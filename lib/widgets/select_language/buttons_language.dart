import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import '../lang/signupscreen.dart';

import '../widgets.dart';

class ButtonsLanguage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 1.0),
      width: double.infinity,
      child: OutlineButton.icon(
        padding: EdgeInsets.all(15),
        borderSide: BorderSide(color: Hexcolor('EA6012')),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SignUpUI()),
          );
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        label: Text(
          'English',
          style: TextStyle(
            color: Hexcolor('EA6012'),
            letterSpacing: 1.5,
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans-Regular',
          ),
        ),
        icon: Image.asset("assets/en.png", alignment: Alignment.centerRight),
      ),
    );
  }
}
