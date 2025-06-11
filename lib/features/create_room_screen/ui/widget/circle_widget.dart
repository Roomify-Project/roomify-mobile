import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class CircleWidget extends StatefulWidget {
  @override
  _CircleWidgetState createState() => _CircleWidgetState();
}

class _CircleWidgetState extends State<CircleWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _xAnimation, _yAnimation;
  late int _currentStep;

  final double radius = 120;
  final double margin = 10; // المسافة اللي يدخلها داخل الشاشة
  late List<Offset> _path;

  final List<Color> colors = [
    Color(0xFFCC46A4),
    Color(0xFFCCC146),
    Color(0xFFCC4646),
    Color(0xFF9EACCE),
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

    final double offset = radius - margin;

    _path = [
      Offset(size.width / 2, size.height - offset), // أسفل
      Offset(offset, size.height / 2), // يسار
      Offset(size.width / 2, offset), // أعلى
      Offset(size.width - offset, size.height / 2), // يمين
    ];

    _controller = AnimationController(
      duration: Duration(seconds: 7),
      vsync: this,
    )..addListener(() {
        if (mounted) setState(() {});
      });

    _setUpAnimations();
    _controller.forward();
  }

  void _setUpAnimations() {
    final size = MediaQuery.of(context).size;

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
    final currentColor = colors[_currentStep];
    final nextColor = colors[(_currentStep + 1) % 4];
    return Color.lerp(currentColor, nextColor, _controller.value) ??
        currentColor;
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
              _setUpAnimations();
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
    canvas.saveLayer(null,
        Paint()..imageFilter = ui.ImageFilter.blur(sigmaX: 15, sigmaY: 15));

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
