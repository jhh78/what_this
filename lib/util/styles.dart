import 'package:flutter/material.dart';

TextStyle getTextStyle(BuildContext context, Color color, double scale) {
  const fontFamily = 'NotoSerifJP';
  const fontWeight = FontWeight.w400;
  double screenWidth = MediaQuery.of(context).size.width;
  return TextStyle(
    fontFamily: fontFamily,
    fontWeight: fontWeight,
    color: color,
    fontSize: screenWidth * scale,
  );
}

TextTheme getTextTheme(BuildContext context, Color color) {
  return TextTheme(
    labelSmall: getTextStyle(context, color, 0.04),
    labelMedium: getTextStyle(context, color, 0.05),
    labelLarge: getTextStyle(context, color, 0.06),
    bodySmall: getTextStyle(context, color, 0.04),
    bodyMedium: getTextStyle(context, color, 0.05),
    bodyLarge: getTextStyle(context, color, 0.06),
    headlineSmall: getTextStyle(context, color, 0.05),
    headlineMedium: getTextStyle(context, color, 0.06),
    headlineLarge: getTextStyle(context, color, 0.07),
    titleSmall: getTextStyle(context, color, 0.05),
    titleMedium: getTextStyle(context, color, 0.06),
    titleLarge: getTextStyle(context, color, 0.07),
    displaySmall: getTextStyle(context, color, 0.06),
    displayMedium: getTextStyle(context, color, 0.07),
    displayLarge: getTextStyle(context, color, 0.08),
  );
}

TextTheme getLightTextTheme(BuildContext context) => getTextTheme(context, const Color.fromARGB(255, 0, 0, 0));
TextTheme getDarkTextTheme(BuildContext context) => getTextTheme(context, const Color.fromARGB(255, 255, 255, 255));

const double ICON_SIZE_BIG = 40;
const double ICON_SIZE = 32;
const double ICON_SIZE_SMALL = 24;
