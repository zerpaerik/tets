import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class TitleGeneral extends StatelessWidget {
  final String titleGral;

  TitleGeneral(this.titleGral);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10.0, bottom: 20.0),
      child: Text(
        titleGral,
        style: TextStyle(
          fontSize: 25,
          color: Hexcolor('EA6012'),
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
