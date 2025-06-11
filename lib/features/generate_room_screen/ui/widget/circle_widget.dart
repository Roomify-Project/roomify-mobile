// import 'package:flutter/material.dart';
// import 'dart:ui' as ui;

// class CircleWidget extends StatefulWidget {
//   @override
//   _CircleWidgetState createState() => _CircleWidgetState();
// }

// class _CircleWidgetState extends State<CircleWidget> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _xAnimation, _yAnimation;
//   late int _currentStep;

//   // Define colors with opacity
//   final List<Color> colors = [
//     Color(0xFFCC46A4),  // CC46A4
//     Color(0xFFCCC146),  // CCC146
//     Color(0xFFCC4646),  // CC4646
//     Color(0xFF9EACCE),  // 9EACCE
//   ];

//   final List<Offset> _path = [
//     Offset(0.5, 1.0),  // Bottom
//     Offset(0.0, 0.5),  // Left
//     Offset(0.5, 0.0),  // Top
//     Offset(1.0, 0.5),  // Right
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _currentStep = 0;
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     final size = MediaQuery.of(context).size;

//     _controller = AnimationController(
//       duration: Duration(seconds: 7),  // Duration of the animation
//       vsync: this,
//     )..addListener(() {
//       if (mounted) {
//         setState(() {});
//       }
//     });

//     _xAnimation = Tween<double>(
//       begin: _path[_currentStep].dx * size.width,
//       end: _path[(_currentStep + 1) % 4].dx * size.width,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

//     _yAnimation = Tween<double>(
//       begin: _path[_currentStep].dy * size.height,
//       end: _path[(_currentStep + 1) % 4].dy * size.height,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

//     _controller.forward();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   Color getColorForPosition() {
//     final currentColor = colors[_currentStep];
//     final nextColor = colors[(_currentStep + 1) % 4];
//     return Color.lerp(currentColor, nextColor, _controller.value) ?? currentColor;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _controller,
//       builder: (context, child) {
//         if (_controller.isCompleted) {
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             setState(() {
//               _currentStep = (_currentStep + 1) % 4;
//               final size = MediaQuery.of(context).size;

//               _xAnimation = Tween<double>(
//                 begin: _path[_currentStep].dx * size.width,
//                 end: _path[(_currentStep + 1) % 4].dx * size.width,
//               ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

//               _yAnimation = Tween<double>(
//                 begin: _path[_currentStep].dy * size.height,
//                 end: _path[(_currentStep + 1) % 4].dy * size.height,
//               ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

//               _controller.reset();
//               _controller.forward();
//             });
//           });
//         }

//         return CustomPaint(
//           size: Size.infinite,
//           painter: MovingShapePainter(
//             _xAnimation.value,
//             _yAnimation.value,
//             getColorForPosition(),
//           ),
//         );
//       },
//     );
//   }
// }

// class MovingShapePainter extends CustomPainter {
//   final double x;
//   final double y;
//   final Color color;

//   MovingShapePainter(this.x, this.y, this.color);

//   @override
//   void paint(Canvas canvas, Size size) {
//     // Apply blur effect
//     canvas.saveLayer(null, Paint()..imageFilter = ui.ImageFilter.blur(sigmaX: 15, sigmaY: 15));

//     final Paint paint = Paint()
//       ..shader = RadialGradient(
//         colors: [
//           color.withOpacity(0.5),  // 50% opacity
//           color.withOpacity(0.25),
//           Colors.transparent,
//         ],
//         stops: [0.3, 0.6, 1.0],
//       ).createShader(Rect.fromCircle(center: Offset(x, y), radius: 120))  // Increased radius to 120
//       ..style = PaintingStyle.fill;

//     canvas.drawCircle(Offset(x, y), 120, paint);  // Increased radius to 120
//     canvas.restore();
//   }

//   @override
//   bool shouldRepaint(MovingShapePainter oldDelegate) {
//     return x != oldDelegate.x ||
//         y != oldDelegate.y ||
//         color != oldDelegate.color;
//   }
// }
