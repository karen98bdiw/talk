import 'package:flutter/material.dart';
import 'package:talk/utils/style_helpers.dart';

class CustomFormInput extends StatelessWidget {
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;
  final String hint;
  final Widget prefix;
  final Widget sufix;
  final bool obscureText;
  final bool textCentered;
  final TextEditingController controller;
  final FocusNode focuseNode;
  final TextInputAction inputAction;
  final Function onEditingComplate;

  CustomFormInput({
    this.onEditingComplate,
    this.inputAction,
    this.focuseNode,
    this.onSaved,
    this.validator,
    this.hint,
    this.prefix,
    this.obscureText = false,
    this.textCentered = false,
    this.sufix,
    this.controller,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16),
      child: TextFormField(
        onEditingComplete: onEditingComplate,
        textInputAction: inputAction,
        focusNode: focuseNode,
        controller: controller,
        textAlign: textCentered ? TextAlign.center : TextAlign.start,
        obscureText: obscureText,
        validator: validator,
        onSaved: onSaved,
        decoration: InputDecoration(
          prefixIcon: prefix != null
              ? Padding(
                  padding: EdgeInsetsDirectional.only(
                    top: 14,
                    start: 14,
                    end: 14,
                    bottom: 14,
                  ),
                  child: prefix,
                )
              : null,
          suffixIcon: sufix != null
              ? Padding(
                  padding: EdgeInsetsDirectional.only(
                    top: 14,
                    start: 14,
                    end: 14,
                    bottom: 14,
                  ),
                  child: sufix,
                )
              : null,
          isDense: true,
          contentPadding: EdgeInsetsDirectional.only(
            top: 14,
            bottom: 14,
            start: 14,
            end: 14,
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: mainBorderColor,
                width: 1,
              )),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: mainBorderColor,
                width: 1,
              )),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: mainBorderColor,
                width: 1,
              )),
          hintText: hint,
          hintStyle: TextStyle(
            color: Color.fromRGBO(137, 137, 137, 1),
            fontSize: 18,
            fontWeight: FontWeight.w400,
            height: 1,
          ),
        ),
      ),
    );
  }
}
