// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// import '../theming/colors.dart';
// import '../theming/styles.dart';

// class AppTextFormField extends StatelessWidget {
//   final EdgeInsetsGeometry? contentPadding;
//   final InputBorder? focusedBorder;
//   final InputBorder? enabledBorder;
//   final TextStyle? inputTextStyle;
//   final TextStyle? hintStyle;
//   final String hintText;
//   final bool? isObscureText;
//   final Widget? suffixIcon;
//   final Widget? prefixIcon;
//   final void Function(String)? onChanged;
//   final void Function()? onTap;

//   final Color? backgroundColor;
//   final TextEditingController? controller;
//   final Function(String?) validator;
//   const AppTextFormField({
//     super.key,
//     this.contentPadding,
//     this.focusedBorder,
//     this.enabledBorder,
//     this.inputTextStyle,
//     this.hintStyle,
//     required this.hintText,
//     this.isObscureText,
//     this.suffixIcon,
//     this.backgroundColor,
//     this.controller,
//     required this.validator,
//     this.prefixIcon,
//     this.onChanged,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: controller,
//       decoration: InputDecoration(
//         isDense: true,
//         contentPadding: contentPadding ??
//             EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
//         focusedBorder: focusedBorder ??
//             OutlineInputBorder(
//               borderSide: const BorderSide(
//                 color: ColorsManager.grey,
//                 width: 1.3,
//               ),
//               borderRadius: BorderRadius.circular(24.0),
//             ),
//         enabledBorder: enabledBorder ??
//             OutlineInputBorder(
//               borderSide: const BorderSide(
//                 color: ColorsManager.lightGrey,
//                 width: 1.3,
//               ),
//               borderRadius: BorderRadius.circular(24.0),
//             ),
//         errorBorder: OutlineInputBorder(
//           borderSide: const BorderSide(
//             color: Colors.red,
//             width: 1.3,
//           ),
//           borderRadius: BorderRadius.circular(24.0),
//         ),
//         focusedErrorBorder: OutlineInputBorder(
//           borderSide: const BorderSide(
//             color: Colors.red,
//             width: 1.3,
//           ),
//           borderRadius: BorderRadius.circular(24.0),
//         ),
//         hintStyle: hintStyle ?? TextStyles.font21BlackSemiBold,
//         hintText: hintText,
//         suffixIcon: suffixIcon,
//         fillColor: backgroundColor ?? ColorsManager.white,
//         filled: true,
//         prefixIcon: prefixIcon,
//       ),
//       autocorrect: true,
//       onChanged: onChanged,
//       onTap: onTap,
//       obscureText: isObscureText ?? false,
//       style: TextStyles.font21BlackSemiBold,
//       validator: (value) {
//         return validator(value);
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final String labelText;
  final TextInputType keyboardType;
  final bool obscureText;
  final TextEditingController? controller;

  const CustomTextFormField({
    Key? key,
    required this.labelText,
    this.keyboardType = TextInputType.text,
    required this.obscureText,
    this.controller,
  }) : super(key: key);

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late FocusNode _focusNode;
  bool _isFocused = false;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });

    widget.controller?.addListener(() {
      setState(() {
        _hasText = widget.controller?.text.isNotEmpty ?? false;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AnimatedOpacity(
            opacity: (_isFocused || _hasText) ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 4),
              child: Text(
                widget.labelText,
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 12,
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(71),
              border: Border.all(
                color: Colors.white.withOpacity(0.07),
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(71),
              ),
              child: TextFormField(
                controller: widget.controller,
                focusNode: _focusNode,
                obscureText: widget.obscureText,
                keyboardType: widget.keyboardType,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: !_isFocused && !_hasText ? widget.labelText : null,
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
          ),
        ],
      ),
    );
  }
}
