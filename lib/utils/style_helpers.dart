import 'dart:ui';

import 'package:flutter/material.dart';

const mainWhiteBackgroundColor = Colors.white;
const backgroundGray = Color.fromRGBO(240, 240, 240, 1);

const mainBtnColor = Color.fromRGBO(137, 41, 67, 1);
const blueShape = Color.fromRGBO(1, 97, 137, 1);
const lightBlue = Color.fromRGBO(31, 163, 251, 1);
const mainBorderColor = Color.fromRGBO(1, 97, 137, 1);
const trasnparentBlueShape = Color.fromRGBO(1, 97, 137, 0.5);
const titleColor = Color.fromRGBO(0, 40, 57, 1);
const greyShape = Color.fromRGBO(203, 203, 203, 1);
const darkBackground = Color.fromRGBO(3, 21, 56, 1);
const lightBackground = Color.fromRGBO(245, 245, 252, 1);

const formScaffoldPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 30);

TextStyle titleStyle({isLight = false}) => TextStyle(
      color: !isLight ? Colors.white : darkBackground,
      fontSize: 50,
      fontWeight: FontWeight.w600,
    );
