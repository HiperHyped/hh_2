import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hh_2/src/config/common/var/hh_enum.dart';

abstract class HHColors {
  // Cores pré-existentes
  static Color hhColorFirst = Color.fromRGBO(7, 167, 7, 1); 
  static Color hhColorDarkFirst = const Color.fromARGB(255, 7, 167, 7);
  static Color hhColorLightFirst = Color.fromARGB(255, 144, 219, 144);
  static Color hhColorBack = const Color.fromRGBO(192, 0, 0, 1);
  static Color hhColorWhite = Colors.white.withAlpha(200);
  static Color hhColorGreyLight = Colors.grey.shade200;
  static Color hhColorGreyDark = Colors.grey.shade500;
  static Color hhColorGreyMedium = Colors.grey.shade300;
  static MaterialColor hhColorFirstSwatch = MaterialColor(0xFF64D74A, _swatchOpacity);

  // Método para obter a cor baseada na função
  static Color getColor(Functions function) {
    switch (function) {
      case Functions.basket:
        return Color.fromARGB(255, 255, 3, 3); // cor do carrinho
      case Functions.promotion:
        return Color.fromARGB(255, 255, 102, 0); // cor para promoção
      case Functions.image:
        return const Color.fromARGB(255, 255, 111, 159); // cor para imagem
      case Functions.periodic:
        return const Color.fromARGB(255, 136, 134, 0); // cor para periódico
      case Functions.history:
        return Colors.purple; // cor para histórico
      case Functions.hint:
        return HHColors.hhColorDarkFirst; // cor para receitas
      case Functions.book:
        return Colors.blueAccent; // cor para livro
      case Functions.pay:
        return Colors.cyanAccent; // cor para pagamento
      case Functions.delivery:
        return Colors.orangeAccent; // cor para entrega (exemplo)
      default:
        return HHColors.hhColorGreyMedium; // cor padrão
    }
  }

  static final Map<int, Color> _swatchOpacity = {
    50: const Color.fromRGBO(100, 215, 74, 0.1),
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
}
