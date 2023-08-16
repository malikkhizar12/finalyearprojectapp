import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupFormField extends StatelessWidget {
  SignupFormField(
      {Key? key,
        required this.controller,
        required this.hintText,
        required this.labelText,
        this.prefixIcon,
        required this.keyBoardType,
        this.textInputAction = TextInputAction.next,
        this.obscure = false,
        required this.validator,
        this.onTap,
        this.readOnly = false,
        this.suffix})
      : super(key: key);

  final TextEditingController controller;
  final String hintText, labelText;
  final IconData? prefixIcon;
  final TextInputType keyBoardType;
  final TextInputAction textInputAction;
  final bool? obscure;
  final VoidCallback? onTap;
  var validator;
  bool readOnly;
  Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: TextFormField(
        readOnly: readOnly,
        validator: validator,
        obscureText: obscure ?? false,
        cursorColor: const Color(0xff117EFF),
        controller: controller,
        keyboardType: keyBoardType,
        textInputAction: textInputAction,
        onTap: onTap,
        cursorWidth: 1,
        obscuringCharacter: '*',
        style:context.textTheme.bodySmall!.copyWith(fontSize: 16),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(20),
          suffix: suffix,
          labelText: labelText,
          filled: true,
          fillColor: context.theme.cardColor,
          labelStyle: context.textTheme.bodySmall!.copyWith(fontSize: 16, color: context.iconColor),
          hintText: hintText,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: context.theme.colorScheme.outline),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: context.theme.colorScheme.secondary),
            borderRadius: BorderRadius.circular(10.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: context.theme.cardColor),
            borderRadius: BorderRadius.circular(10.0),
          ),
          prefixIcon: prefixIcon == null ? null : Icon(prefixIcon),
        ),
      ),
    );
  }
}
