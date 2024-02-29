import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hh_2/src/config/common/var/hh_colors.dart';


class HHTextField extends StatefulWidget {
  final IconData icon;
  final String label;
  final String hint;
  final bool isSecret;
  final List<TextInputFormatter>? inputFormatters;
  final String? initialValue;
  final bool readOnly;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final double padding;

  const HHTextField({
    Key? key,
    required this.icon,
    required this.label,
    this.hint = "", 
    this.isSecret = false,
    this.inputFormatters,
    this.initialValue,
    this.readOnly = false,
    this.keyboardType = TextInputType.name,
    this.controller,
    this.padding = 4.0,
  }) : super(key: key);

  @override
  State<HHTextField> createState() => _HHTextFieldState();
}

class _HHTextFieldState extends State<HHTextField> {
  bool isObscure = false;
  
  @override
  void initState(){
    super.initState();
    isObscure= widget.isSecret;
  }

  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(widget.padding),
      child: TextFormField(
        scrollPadding: EdgeInsets.all(0),
        readOnly: widget.readOnly,
        initialValue: widget.initialValue,
        inputFormatters: widget.inputFormatters,
        obscureText: isObscure,
        controller: widget.controller,
        decoration: InputDecoration(
          fillColor: HHColors.hhColorWhite,
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(widget.icon),
          suffixIcon: widget.isSecret 
          ? IconButton(
              onPressed: () {
                setState(() {
                  isObscure = !isObscure;
                });
              }, 
              icon:  Icon(isObscure? Icons.visibility : Icons.visibility_off)
            ) : null,
          labelText: widget.label,
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}



/*class HHTextField extends StatefulWidget {
  final IconData icon;
  final String label;
  final String hint;
  final bool isSecret;
  final List<TextInputFormatter>? inputFormatters;
  final String? initialValue;
  final bool readOnly;
  final TextInputType keyboardType;
  

  const HHTextField({
    Key? key,
    required this.icon,
    required this.label,
    this.hint = "", 
    this.isSecret = false,
    this.inputFormatters,
    this.initialValue,
    this.readOnly = false,
    this.keyboardType = TextInputType.name,
  }) : super(key: key);

  @override
  State<HHTextField> createState() => _HHTextFieldState();
}

class _HHTextFieldState extends State<HHTextField> {
  bool isObscure = false;
  
  @override
  void initState(){
    super.initState();
    isObscure= widget.isSecret;
  }

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        readOnly: widget.readOnly,
        initialValue: widget.initialValue,
        inputFormatters: widget.inputFormatters,
        obscureText: isObscure,
        decoration: InputDecoration(
          prefixIcon: Icon(widget.icon),
          suffixIcon: widget.isSecret 
          ? IconButton(
              onPressed: () {
                setState(() {
                  isObscure = !isObscure;
                });
              }, 
              icon:  Icon(isObscure? Icons.visibility : Icons.visibility_off)
            ) : null,
          labelText: widget.label,
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}*/
