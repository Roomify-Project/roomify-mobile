import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class CircleWidget extends StatefulWidget {
  final Color currentColor;
  final Duration delay;

  const CircleWidget({
    Key? key,
    required this.currentColor,
    this.delay = const Duration(seconds: 2),
  }) : super(key: key);

  @override
  _CircleWidgetState createState() => _CircleWidgetState();
}

class _CircleWidgetState extends State<CircleWidget> with TickerProviderStateMixin {
  late AnimationController _controller;
  Animation<double>? _xAnimation, _yAnimation;
  int _currentStep = 0;

  final double radius = 120;
  final double margin = 10;
  late List<Offset> _path;
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 7),
      vsync: this,
    )..addListener(() {
        if (mounted) setState(() {});
      });

    Future.delayed(widget.delay, () {
      if (!mounted) return;
      final size = MediaQuery.of(context).size;
      final double offset = radius - margin;

      _path = [
        Offset(size.width / 2, size.height - offset),
        Offset(offset, size.height / 2),
        Offset(size.width / 2, offset),
        Offset(size.width - offset, size.height / 2),
      ];

      _setUpAnimations();
      isInitialized = true;
      _controller.forward();
    });
  }

  void _setUpAnimations() {
    _xAnimation = Tween<double>(
      begin: _path[_currentStep].dx,
      end: _path[(_currentStep + 1) % 4].dx,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    _yAnimation = Tween<double>(
      begin: _path[_currentStep].dy,
      end: _path[(_currentStep + 1) % 4].dy,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color getColorForPosition() {
    return widget.currentColor;
  }

  @override
  Widget build(BuildContext context) {
    if (!isInitialized || _xAnimation == null || _yAnimation == null) {
      return SizedBox.expand();
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        if (_controller.isCompleted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _currentStep = (_currentStep + 1) % 4;
            _setUpAnimations();
            _controller.reset();
            _controller.forward();
          });
        }

        return CustomPaint(
          size: Size.infinite,
          painter: MovingShapePainter(
            _xAnimation!.value,
            _yAnimation!.value,
            getColorForPosition(),
            radius,
          ),
        );
      },
    );
  }
}

class MovingShapePainter extends CustomPainter {
  final double x;
  final double y;
  final Color color;
  final double radius;

  MovingShapePainter(this.x, this.y, this.color, this.radius);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.saveLayer(null, Paint()..imageFilter = ui.ImageFilter.blur(sigmaX: 15, sigmaY: 15));

    final Paint paint = Paint()
      ..shader = RadialGradient(
        colors: [
          color.withOpacity(0.5),
          color.withOpacity(0.25),
          Colors.transparent,
        ],
        stops: [0.3, 0.6, 1.0],
      ).createShader(Rect.fromCircle(center: Offset(x, y), radius: radius))
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(x, y), radius, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(MovingShapePainter oldDelegate) {
    return x != oldDelegate.x ||
        y != oldDelegate.y ||
        color != oldDelegate.color ||
        radius != oldDelegate.radius;
  }
}
