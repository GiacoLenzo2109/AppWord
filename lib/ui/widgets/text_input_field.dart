import 'package:app_word/res/custom_colors.dart';
import 'package:app_word/viewmodel/sign_in_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TextFieldWidget extends StatelessWidget {
  final String? hintText;
  final IconData? prefixIconData;
  final IconData? suffixIconData;
  final bool obscureText;
  final String? error;
  final void Function(String)? onChanged;

  // ignore: use_key_in_widget_constructors
  const TextFieldWidget(
      {this.hintText,
      this.prefixIconData,
      this.suffixIconData,
      required this.obscureText,
      this.error,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<SignInModel>(context);

    return TextField(
      onChanged: onChanged,
      obscureText: obscureText,
      cursorColor: CustomColors.mediumBlue,
      style: const TextStyle(
        color: CustomColors.mediumBlue,
        fontSize: 14.0,
      ),
      decoration: InputDecoration(
        labelStyle: const TextStyle(color: CustomColors.mediumBlue),
        focusColor: CustomColors.mediumBlue,
        filled: true,
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: CustomColors.mediumBlue),
        ),
        labelText: hintText,
        prefixIcon: Icon(
          prefixIconData,
          size: 18,
          color: CustomColors.mediumBlue,
        ),
        errorText: error,
        suffixIcon: GestureDetector(
          onTap: () {
            model.isVisible = !model.isVisible;
          },
          child: Icon(
            suffixIconData,
            size: 18,
            color: CustomColors.mediumBlue,
          ),
        ),
      ),
    );
  }
}
