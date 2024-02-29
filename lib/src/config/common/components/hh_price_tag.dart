import 'package:flutter/material.dart';
import 'package:hh_2/src/config/common/var/hh_colors.dart';
import 'package:intl/intl.dart';


class HHPriceTag extends StatelessWidget {
  final double price;
  final double fontSize;
  final EdgeInsets padding;
  final double maxWidth;

  HHPriceTag({
      required this.price, 
      this.fontSize = 14, 
      this.padding = const EdgeInsets.fromLTRB(2, 0, 2, 7), 
      required this.maxWidth
    });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      width: maxWidth,
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            width: 2,
            color: HHColors.hhColorFirst,
          ),
          borderRadius: BorderRadius.circular(12),
          //Shadow
          /*boxShadow: [
            BoxShadow(
              color: HHColors.hhColorFirst,
              blurRadius: 8,
              spreadRadius: 3,
            ),
          ],*/
        ),
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(
            NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(price),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
              color: HHColors.hhColorFirst,
            ),
          ),
        ),
      ),
    );
  }
}
