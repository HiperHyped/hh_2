import 'package:flutter/material.dart';
import 'package:hh_2/src/config/common/var/hh_globals.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class Utils{


  //R$ VALOR
  String priceToCurrency(double price){

    NumberFormat numberFormat = NumberFormat.simpleCurrency(locale: 'pt_BR');

    return numberFormat.format(price);
  }

  String formatDateTime(DateTime dateTime){
    initializeDateFormatting();

    DateFormat dateFormat = DateFormat.yMd('pt_BR').add_Hm();
    return dateFormat.format(dateTime);
  }

  static String capitalizeInitials(String text) {
    return text.split(' ').map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase()).join(" ");
  }

  
  static bool isEmail(String email) {
    // Regex for email validation
    String emailRegex = r'^[^@]+@[^@]+\.[^@]+$';
    RegExp regExp = RegExp(emailRegex);
    
    return regExp.hasMatch(email);
  }

  static String getUserInitials(String name) {
    List<String> names = name.split(" ");
    String initials = "";
    int numWords = 2;
    if (numWords < names.length) {
      numWords = names.length;
    }
    for (var i = 0; i < numWords; i++) {
      initials += '${names[i][0]}';
    }
    return initials;
  }

  /*static Color getColorFromCat(String sig) {
    print("SIG: $sig");
    for (var cat in HHGlobals.listCat) {
      print(cat.sigla);
      if (cat.sig == sig && cat.level == 2) {
        print(cat.color);
        return cat.color;
      }
    }
    return Colors.brown; // Cor padrão caso a sigla não seja encontrada
  }*/

  static Color getColorFromCat1(String sig) {
    //print("SIG: $sig");
    for (var cat in HHGlobals.listCat) { // iterando sobre as categorias de nível 0
      //print("SIG0: ${cat.sig}");
      for (var subCat in cat.subCats) { // iterando sobre as subcategorias de nível 1
        //print("SIG1: ${subCat.sig}");
        if (cat.sig + subCat.sig == sig) {
          return subCat.color; // se encontramos a sigla correta, retorna a cor correspondente
        }
      }
    }
    return Colors.brown; // se a sigla não for encontrada, retorna a cor padrão
  }

  static Color getColorFromCat0(String sig) {
    //print("SIG: $sig");
    for (var cat in HHGlobals.listCat) { // iterando sobre as categorias de nível 0
      //print("SIG0: ${cat.sig}");
      if (cat.sig == sig) {
        return cat.color; // se encontramos a sigla correta, retorna a cor correspondente
      }
    }
    return Colors.brown; // se a sigla não for encontrada, retorna a cor padrão
  }

}
/*
  static bool isPasswordStrong(String password, {int minLength = 8, int minUppercase = 1, int minLowercase = 1, int minDigits = 1, int minSpecialChars = 1}) {
    // Regex for password strength
    String passwordPattern = r'^'
        // Lookahead assertion for lower case letters
        '(?=(.*[a-z]){' + minLowercase.toString() + ',})'
        // Lookahead assertion for upper case letters
        '(?=(.*[A-Z]){' + minUppercase.toString() + ',})'
        // Lookahead assertion for digits
        '(?=(.*\d){' + minDigits.toString() + ',})'
        // Lookahead assertion for special characters
        '(?=(.*[@$!%*?&]){' + minSpecialChars.toString() + ',})'
        // Any character of the set, {minLength} or more times
        '[A-Za-z\d@$!%*?&]{' + minLength.toString() + ',}'
        r'$';
    RegExp regExp = RegExp(passwordPattern);
    
    return regExp.hasMatch(password);
  }

  Utils.isPasswordStrong(user.password, minLength: 10, minUppercase: 2, minDigits: 3, minSpecialChars: 2);

 */

