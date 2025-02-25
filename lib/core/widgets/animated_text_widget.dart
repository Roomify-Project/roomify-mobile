import 'package:flutter/material.dart';
import 'package:rommify_app/core/theming/styles.dart';

class AnimatedText extends StatefulWidget {
  final String text; // النص الذي سيتم تمريره للويدجت

  const AnimatedText({Key? key, required this.text}) : super(key: key);

  @override
  _AnimatedTextState createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<AnimatedText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _charAnimation;

  @override
  void initState() {
    super.initState();

    // AnimationController
    _controller = AnimationController(
      duration: Duration(seconds: 2), // مدة الأنيميشن
      vsync: this,
    );

    // Animation for characters
    _charAnimation = IntTween(begin: 0, end: widget.text.length).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Start the animation
    _controller.forward();
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
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(widget.text.length, (index) {
            // عرض الحرف فقط إذا كان داخل نطاق الأنيميشن
            return Text(
                index < _charAnimation.value
                    ? widget.text[index]
                    : " ", // عرض الحرف أو فراغ
                style: TextStyles.font32WhiteInter);
          }),
        );
      },
    );
  }
}
