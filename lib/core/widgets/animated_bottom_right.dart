import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rommify_app/features/create_room_screen/ui/widget/circle_widget.dart';

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
    with TickerProviderStateMixin {
  late AnimationController _beamController;
  late AnimationController _circleFadeController;
  late Animation<double> _beamAnimation;

  bool showCircle = false;
  bool _firstColorShown = false;

  int currentColorIndex = 0;
  int nextColorIndex = 1;
  double colorTransitionValue = 0.0;
  Timer? _colorTimer;

  final List<Color> colors = [
    const Color.fromRGBO(204, 193, 70, 0.18),
    const Color.fromRGBO(204, 70, 70, 0.18),
    const Color.fromRGBO(204, 70, 164, 0.18),
    const Color.fromRGBO(158, 172, 206, 0.18),
  ];

  @override
  void initState() {
    super.initState();

    _beamController = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..forward().then((_) {
        // بعد ما يخلص انميشن الشعاع
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            setState(() {
              showCircle = true;
              _firstColorShown = true;
            });
            _circleFadeController.forward();
            startColorTransition();
          }
        });
      });

    _circleFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _beamAnimation = Tween<double>(begin: 0.0, end: 1.2).animate(
      CurvedAnimation(parent: _beamController, curve: Curves.easeInOut),
    );
  }

  void startColorTransition() {
    const transitionDuration = Duration(milliseconds: 5000);
    const colorShowDuration = Duration(seconds: 6);

    _colorTimer?.cancel();
    _colorTimer = Timer.periodic(colorShowDuration, (timer) {
      if (mounted) {
        setState(() {
          currentColorIndex = nextColorIndex;
          nextColorIndex = (currentColorIndex + 1) % colors.length;
          colorTransitionValue = 0.0;
        });

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
    _beamController.dispose();
    _circleFadeController.dispose();
    _colorTimer?.cancel();
    super.dispose();
  }

  Color getCurrentColor() {
    if (!_firstColorShown) {
      return colors[0];
    }
    return Color.lerp(
          colors[currentColorIndex],
          colors[nextColorIndex],
          Curves.easeInOut.transform(colorTransitionValue.clamp(0.0, 1.0)),
        ) ??
        colors[currentColorIndex];
  }

  @override
  Widget build(BuildContext context) {
    final currentColor = getCurrentColor();

    return Stack(
      children: [
        if (showCircle)
          Positioned.fill(
            child: FadeTransition(
              opacity: _circleFadeController,
              child: CircleWidget(
                currentColor: currentColor,
                delay: const Duration(seconds: 0),
              ),
            ),
          ),
        IgnorePointer(
          child: AnimatedBuilder(
            animation: _beamAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: _beamAnimation.value / 1.2,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.bottomRight,
                      radius: _beamAnimation.value,
                      colors: [
                        currentColor,
                        currentColor.withOpacity(0.0),
                      ],
                      stops: const [0.0, 1.0],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
