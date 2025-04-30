import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class CircleWidget extends StatefulWidget {
  @override
  _CircleWidgetState createState() => _CircleWidgetState();
}

class _CircleWidgetState extends State<CircleWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _xAnimation, _yAnimation;
  late Animation<Color?> _colorAnimation;
  late int _currentStep;

  final List<Color> colors = [
    Color(0xFFCC46A4), // موف غامق
    Color(0xFFCCC146), // أصفر
    Color(0xFFCC4646), // برتقالي
    Color(0xFFD48ACF), // موف فاتح
  ];

  final List<Offset> _path = [
    Offset(0.5, 1.0),
    Offset(0.0, 0.5),
    Offset(0.5, 0.0),
    Offset(1.0, 0.5),
  ];

  @override
  void initState() {
    super.initState();
    _currentStep = 0;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final size = MediaQuery.of(context).size;

    _controller = AnimationController(
      duration: Duration(seconds: 7),
      vsync: this,
    )..addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    _updateAnimations(size);

    _controller.forward();
  }

  void _updateAnimations(Size size) {
    _xAnimation = Tween<double>(
      begin: _path[_currentStep].dx * size.width,
      end: _path[(_currentStep + 1) % 4].dx * size.width,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    _yAnimation = Tween<double>(
      begin: _path[_currentStep].dy * size.height,
      end: _path[(_currentStep + 1) % 4].dy * size.height,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    _colorAnimation = ColorTween(
      begin: colors[_currentStep],
      end: colors[(_currentStep + 1) % 4],
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        if (_controller.isCompleted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              _currentStep = (_currentStep + 1) % 4;
              final size = MediaQuery.of(context).size;
              _updateAnimations(size);
              _controller.reset();
              _controller.forward();
            });
          });
        }

        return CustomPaint(
          size: Size.infinite,
          painter: MovingShapePainter(
            _xAnimation.value,
            _yAnimation.value,
            _colorAnimation.value ?? colors[_currentStep],
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

  MovingShapePainter(this.x, this.y, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.saveLayer(null, Paint()..imageFilter = ui.ImageFilter.blur(sigmaX: 30, sigmaY: 30));

    final Paint paint = Paint()
      ..shader = RadialGradient(
        colors: [
          color.withOpacity(0.8),
          color.withOpacity(0.4),
          Colors.transparent,
        ],
        stops: [0.3, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: Offset(x, y), radius: 150))
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(x, y), 150, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(MovingShapePainter oldDelegate) {
    return x != oldDelegate.x ||
        y != oldDelegate.y ||
        color != oldDelegate.color;
  }
}