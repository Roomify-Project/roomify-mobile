// import 'dart:async';
// import 'dart:ui';
// import 'package:flutter/material.dart';

// class StaticGradientBeam extends StatefulWidget {
//   final Duration duration;

//   const StaticGradientBeam({
//     Key? key,
//     this.duration = const Duration(seconds: 3),
//   }) : super(key: key);

//   @override
//   State<StaticGradientBeam> createState() => _StaticGradientBeamState();
// }

// class _StaticGradientBeamState extends State<StaticGradientBeam>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;
//   bool _beamAnimationComplete = false;
//   int currentColorIndex = 0;
//   int nextColorIndex = 1;
//   double colorTransitionValue = 0.0;
//   Timer? _colorTimer;

//   final List<Color> colors = [
//     Color.fromRGBO(204, 193, 70, 0.43).withOpacity(0.2),
//     Color.fromRGBO(204, 70, 70, 1.0).withOpacity(0.2),
//     Color.fromRGBO(204, 70, 164, 1.0).withOpacity(0.2),
//     Color.fromRGBO(158, 172, 206, 1.0).withOpacity(0.2),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: widget.duration,
//       vsync: this,
//     )..addListener(() {
//         setState(() {});
//       });

//     _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: Curves.easeInOut,
//       ),
//     );

//     Future.delayed(Duration(milliseconds: 500), () {
//       if (mounted) {
//         _controller.forward().then((_) {
//           setState(() {
//             _beamAnimationComplete = true;
//           });
//           startColorTransition();
//         });
//       }
//     });
//   }

//   void startColorTransition() {
//     const transitionDuration =
//         Duration(milliseconds: 3000); // مدة الانتقال بين الألوان
//     const colorShowDuration = Duration(seconds: 1); // مدة ظهور كل لون

//     _colorTimer?.cancel();
//     _colorTimer = Timer.periodic(colorShowDuration, (timer) {
//       if (mounted) {
//         setState(() {
//           currentColorIndex = nextColorIndex;
//           nextColorIndex = (currentColorIndex + 1) % colors.length;
//           colorTransitionValue = 0.0;
//         });

//         // انيميشن انتقالي سلس
//         const fps = 60;
//         const interval = Duration(milliseconds: 1000 ~/ fps);
//         Timer.periodic(interval, (animationTimer) {
//           if (!mounted) {
//             animationTimer.cancel();
//             return;
//           }

//           setState(() {
//             colorTransitionValue += 1 /
//                 (transitionDuration.inMilliseconds / interval.inMilliseconds);
//             if (colorTransitionValue >= 1.0) {
//               animationTimer.cancel();
//             }
//           });
//         });
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     _colorTimer?.cancel();
//     super.dispose();
//   }

//   Color getCurrentColor() {
//     return Color.lerp(colors[currentColorIndex], colors[nextColorIndex],
//             Curves.easeInOut.transform(colorTransitionValue.clamp(0.0, 1.0))) ??
//         colors[currentColorIndex];
//   }

//   @override
//   Widget build(BuildContext context) {
//     final currentColor = getCurrentColor();

//     return Container(
//       decoration: BoxDecoration(
//         gradient: RadialGradient(
//           center: Alignment.bottomRight,
//           radius: _beamAnimationComplete ? 1.2 : _animation.value * 1.2,
//           colors: [
//             currentColor,
//             currentColor.withOpacity(0.0),
//           ],
//           stops: const [0.0, 1.0],
//         ),
//       ),
//       // child: BackdropFilter(
//       //   filter: ImageFilter.blur(
//       //     sigmaX: 0,
//       //     sigmaY: 0,
//       //   ),
//       //   child: Container(
//       //     decoration: BoxDecoration(
//       //       color: Colors.transparent,
//       //     ),
//       //   ),
//       // ),
//     );
//   }
// }

import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';

class StaticGradientBeam extends StatefulWidget {
  final Duration duration;

  const StaticGradientBeam({
    Key? key,
    this.duration = const Duration(seconds: 3),
  }) : super(key: key);

  @override
  State<StaticGradientBeam> createState() => _StaticGradientBeamState();
}

class _StaticGradientBeamState extends State<StaticGradientBeam>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _beamAnimationComplete = false;
  int currentColorIndex = 0;
  int nextColorIndex = 1;
  double colorTransitionValue = 0.0;
  Timer? _colorTimer;
  bool _firstColorShown = false;

  final List<Color> colors = [
    Color.fromRGBO(204, 193, 70, 0.43).withOpacity(0.2),
    Color.fromRGBO(204, 70, 70, 1.0).withOpacity(0.2),
    Color.fromRGBO(204, 70, 164, 1.0).withOpacity(0.2),
    Color.fromRGBO(158, 172, 206, 1.0).withOpacity(0.2),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..addListener(() {
        setState(() {});
      });

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // ظهور سريع للون الأصفر
    Future.delayed(Duration(milliseconds: 200), () {
      if (mounted) {
        _controller.forward().then((_) {
          setState(() {
            _beamAnimationComplete = true;
            _firstColorShown = true;
          });
          // بدء التحول البطيء للألوان بعد ظهور اللون الأصفر
          Future.delayed(Duration(seconds: 1), () {
            startColorTransition();
          });
        });
      }
    });
  }

  void startColorTransition() {
    const transitionDuration = Duration(milliseconds: 5000); // وقت أطول للتحول
    const colorShowDuration = Duration(seconds: 6); // وقت أطول لعرض كل لون

    _colorTimer?.cancel();
    _colorTimer = Timer.periodic(colorShowDuration, (timer) {
      if (mounted) {
        setState(() {
          currentColorIndex = nextColorIndex;
          nextColorIndex = (currentColorIndex + 1) % colors.length;
          colorTransitionValue = 0.0;
        });

        // انيميشن انتقالي بطيء وسلس
        const fps = 60;
        const interval = Duration(milliseconds: 1000 ~/ fps);
        Timer.periodic(interval, (animationTimer) {
          if (!mounted) {
            animationTimer.cancel();
            return;
          }

          setState(() {
            colorTransitionValue += 1 /
                (transitionDuration.inMilliseconds / interval.inMilliseconds);
            if (colorTransitionValue >= 1.0) {
              animationTimer.cancel();
            }
          });
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _colorTimer?.cancel();
    super.dispose();
  }

  Color getCurrentColor() {
    if (!_firstColorShown) {
      return colors[0];
    }
    return Color.lerp(colors[currentColorIndex], colors[nextColorIndex],
            Curves.easeInOut.transform(colorTransitionValue.clamp(0.0, 1.0))) ??
        colors[currentColorIndex];
  }

  @override
  Widget build(BuildContext context) {
    final currentColor = getCurrentColor();

    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.bottomRight,
          radius: _beamAnimationComplete ? 1.2 : _animation.value * 1.2,
          colors: [
            currentColor,
            currentColor.withOpacity(0.0),
          ],
          stops: const [0.0, 1.0],
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 15,
          sigmaY: 15,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
          ),
        ),
      ),
    );
  }
}
