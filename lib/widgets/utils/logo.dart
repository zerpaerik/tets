import 'package:flutter/material.dart';

class Logo extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
                margin: EdgeInsets.only(top: 25.0, bottom: 1.0),
                child: Image.asset("assets/icono_casco.png", width: 180,height: 180,),
              );
  }
}