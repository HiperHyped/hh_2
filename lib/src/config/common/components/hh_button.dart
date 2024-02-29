import 'package:flutter/material.dart';
import 'package:hh_2/src/config/common/var/hh_colors.dart';

class HHButton extends StatelessWidget {
  final String label;
  final double fontSize;
  final double padding;
  final bool invert;
  final VoidCallback onPressed;

  const HHButton({
    Key? key,
    required this.label,
    this.fontSize =20,
    this.padding = 12.0,
    this.invert=false,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: invert? Colors.white:  HHColors.hhColorFirst,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        side: BorderSide(
          color: invert? HHColors.hhColorFirst : Colors.white,
          width: invert? 1 : 0,
        ),
      ),
      /*style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          invert? Colors.white:  HHColors.hhColorFirst ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),*/
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Text(
          label,
          style: TextStyle(
            color: invert? HHColors.hhColorFirst : Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }
}