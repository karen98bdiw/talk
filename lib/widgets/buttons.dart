import 'package:flutter/material.dart';
import 'package:talk/utils/style_helpers.dart';

class CustomBtn extends StatelessWidget {
  final String title;
  final Function onClick;
  final bool fill;
  final bool outlined;
  final Widget icon;
  final Color color;
  final Color outlineColor;
  final Color textColor;

  CustomBtn({
    this.fill = false,
    this.outlined = false,
    this.title,
    this.onClick,
    this.icon,
    this.color,
    this.outlineColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: fill ? double.infinity : null,
      child: FlatButton(
        color: outlined
            ? Colors.transparent
            : color != null
                ? color
                : mainBtnColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: outlined
              ? BorderSide(
                  color: outlineColor != null ? outlineColor : mainBorderColor,
                  width: 2)
              : BorderSide.none,
        ),
        padding: EdgeInsets.all(15),
        onPressed: onClick,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon != null ? icon : Container(),
            icon != null
                ? SizedBox(
                    width: 15,
                  )
                : Container(),
            Text(
              title,
              style: TextStyle(
                color: outlined
                    ? textColor != null
                        ? textColor
                        : mainBorderColor
                    : Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
