import 'package:flutter/material.dart';

class Cv extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Padding(
                padding: EdgeInsets.only(top: 50.0),

                child: Image.asset("assets/cv.png", height: 150, width: 150,),
              );
  }
}