import 'package:flutter/material.dart';

import '../widgets.dart';

class SelectLanguage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String _titleH = 'Seleccionar idioma';
    return new Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: true,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              LogoLogin(),
              TitleLang(_titleH),
              ButtonsLanguage(),
              ButtonsLanguageEs(),
            ],
          ),
        ],
      ),
    );
  }
}
