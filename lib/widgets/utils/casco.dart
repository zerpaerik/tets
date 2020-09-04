import 'package:flutter/material.dart';

class Casco extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Padding(
                padding: EdgeInsets.only(top: 50.0),
                child: Image.asset("assets/casco.png", width: 150,height: 150,),
              );
  }
}