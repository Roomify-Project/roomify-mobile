import 'package:flutter/material.dart';

class CustomTextFieldProfile extends StatefulWidget {
  final String hint;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final bool obscureText;

  const CustomTextFieldProfile({
    Key? key,
    required this.hint,
    this.keyboardType,
    this.controller,
    this.obscureText = false, required String? Function(dynamic value) validator,
  }) : super(key: key);

  @override
  State<CustomTextFieldProfile> createState() => _CustomTextFieldProfileState();
}

class _CustomTextFieldProfileState extends State<CustomTextFieldProfile> {
  late FocusNode _focusNode;
  bool _isFocused = false;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);

    widget.controller?.addListener(_handleTextChange);
  }

  void _handleFocusChange() {
    if (mounted) {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    }
  }

  void _handleTextChange() {
    if (mounted) {
      setState(() {
        _hasText = widget.controller?.text.isNotEmpty ?? false;
      });
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    widget.controller?.removeListener(_handleTextChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 281,
        height: 47,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.white.withOpacity(0.0),
          ),
          color: const Color(0x75320C39),
        ),
        child: TextField(
          controller: widget.controller,
          // focusNode: _focusNode,
          keyboardType: widget.keyboardType,
          obscureText: widget.obscureText,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
          ),
        ),
      ),
    );
  }
}