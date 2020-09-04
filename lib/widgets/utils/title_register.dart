import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class TitleRegister extends StatelessWidget {
  final String titleGral;

  TitleRegister(this.titleGral);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 1.0, bottom: 10.0),
      child: Text(
        titleGral,
        style: TextStyle(
          fontSize: 28,
          color: Hexcolor('EA6012'),
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
