import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class TitleLang extends StatelessWidget {
  final String titleGral;

  TitleLang(this.titleGral);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 20.0, bottom: 80.0),
      child: Text(
        titleGral,
        style: TextStyle(
            fontSize: 30,
            color: Hexcolor('EA6012'),
            fontFamily: 'OpenSans-Regular'),
        textAlign: TextAlign.center,
      ),
    );
  }
}
