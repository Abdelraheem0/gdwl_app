// ignore_for_file: use_key_in_widget_constructors, sized_box_for_whitespace, prefer_const_constructors

import 'package:flutter/material.dart';


// ignore: must_be_immutable
class DefaultTextField extends StatelessWidget {


  String hintText ;
  double width ;
  TextInputType inputType ;
  double borderRadius;
  Color backgroundColor;
  String? Function(String?)? validator;
  String? Function(String?)? onSaved;
  Function? onTap;
  TextEditingController controller;
  IconData? prefixIcon;
  IconData? suffixIcon;
  Color borderColor;
  Color iconColor;
  DefaultTextField({
    required this.hintText,
    this.width = double.infinity,
    this.inputType = TextInputType.text,
    this.borderRadius = 5,
    this.backgroundColor = Colors.white,
    this.validator,
    this.onSaved,
    this.onTap,
    required this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.borderColor = Colors.grey,
    this.iconColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Container(
        width: width,
        child: TextFormField(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(10.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: borderColor),
            ),

            fillColor: backgroundColor,
            filled: true,
            hintText: hintText,
            prefixIcon: prefixIcon != null
                ?  Icon(prefixIcon , color:iconColor,)
                : null ,
            suffixIcon: suffixIcon != null ? Icon(suffixIcon,) : null,
          ),
          keyboardType: inputType,
          controller: controller,
          validator:validator,
          onTap: (){onTap!();},
          // onSaved: onSaved,
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
      ),
    );
  }
}
