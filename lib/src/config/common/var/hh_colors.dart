import 'package:flutter/material.dart';


Map<int, Color> _swatchOpacity = {


  50:  const Color.fromRGBO(100, 215, 74, 0.1),
  100: const Color.fromRGBO(100, 215, 74, 0.2),
  200: const Color.fromRGBO(100, 215, 74, 0.3),
  300: const Color.fromRGBO(100, 215, 74, 0.4),
  400: const Color.fromRGBO(100, 215, 74, 0.5),
  500: const Color.fromRGBO(100, 215, 74, 0.6),
  600: const Color.fromRGBO(100, 215, 74, 0.7),
  700: const Color.fromRGBO(100, 215, 74, 0.8),
  800: const Color.fromRGBO(100, 215, 74, 0.9),
  900: const Color.fromRGBO(100, 215, 74, 1),
};

abstract class HHColors{

  //static Color hhColorBack = Colors.deepOrange;
  static Color hhColorFirst = Color.fromRGBO(7, 167, 7, 1); //Color.fromARGB(255, 81, 214, 47);
  
  static Color hhColorDarkFirst = const Color.fromARGB(255, 7, 167, 7);

  static Color hhColorLightFirst = Color.fromARGB(255, 144, 219, 144);

  static Color hhColorBack =   const Color.fromRGBO(192, 0, 0, 1);

  static Color hhColorWhite = Colors.white.withAlpha(200);

  static Color hhColorGreyLight = Colors.grey.shade200;

  static Color hhColorGreyDark = Colors.grey.shade500;

  static Color hhColorGreyMedium = Colors.grey.shade300;

  static MaterialColor hhColorFirstSwatch = MaterialColor(0xFF64D74A, _swatchOpacity);


}
