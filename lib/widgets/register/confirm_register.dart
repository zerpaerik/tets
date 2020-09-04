import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import '../widgets.dart';

class ConfirmRegister extends StatelessWidget {
  final String email;

  ConfirmRegister(this.email);

  @override
  Widget build(BuildContext context) {
    String _titleH = '¡Ya casi has terminado!';
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: true,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Email(),
              TitleGeneral(_titleH),
              TextReviewEmail(),
              TextEmail(email),
              ValidCuenta(),
              ValidCuentaR(),
              Notif(),
              Container(
                // padding: EdgeInsets.symmetric(vertical: 25.0),
                margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 50.0),
                width: double.infinity,
                child: RaisedButton(
                  elevation: 5.0,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  },
                  padding: EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  color: Hexcolor('EA6012'),
                  child: Text(
                    'Continuar',
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 1,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                ),
              ),
              ButtonReen()
            ],
          ),
        ],
      ),
    );
  }
}

class TextReviewEmail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(vertical: 25.0),
      margin: EdgeInsets.only(left: 20.0, right: 20.0),
      width: double.infinity,
      child: Text('Revisa tu Email',
          style: TextStyle(
            fontFamily: 'OpenSans-Regular',
            color: Hexcolor('9c9c9c'),
            fontSize: 15.0,
          ),
          textAlign: TextAlign.center),
    );
  }
}

class TextEmail extends StatelessWidget {
  final String emailView;
  TextEmail(this.emailView);

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(vertical: 25.0),
      margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
      width: double.infinity,
      child: Text(emailView,
          style: TextStyle(
            fontFamily: 'OpenSans-Regular',
            fontWeight: FontWeight.bold,
            color: Hexcolor('233062'),
            fontSize: 25.0,
          ),
          textAlign: TextAlign.center),
    );
  }
}

class ValidCuenta extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(vertical: 25.0),
      margin: EdgeInsets.only(left: 40.0, right: 40.0, top: 30.0),
      width: double.infinity,
      child: Text(
          'Para validar tu cuenta, ve a tu correo electrónico y pulsa en el boton validar',
          style: TextStyle(
            fontFamily: 'OpenSans-Regular',
            color: Hexcolor('9c9c9c'),
            fontSize: 15.0,
          ),
          textAlign: TextAlign.center),
    );
  }
}

class ValidCuentaR extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(vertical: 25.0),
      margin: EdgeInsets.only(left: 40.0, right: 40.0, top: 30.0),
      width: double.infinity,
      child: Text('Recuerda tambien revisar tu bandeja de SPAM',
          style: TextStyle(
            fontFamily: 'OpenSans-Regular',
            color: Hexcolor('9c9c9c'),
            fontSize: 15.0,
          ),
          textAlign: TextAlign.center),
    );
  }
}

class Notif extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(vertical: 25.0),
      margin: EdgeInsets.only(left: 60.0, right: 60.0, top: 30.0),
      width: double.infinity,
      child: Text('SI NO RECIBES EL CORREO, HAZ CLIC EN EL BOTON',
          style: TextStyle(
            fontFamily: 'OpenSans-Regular',
            fontWeight: FontWeight.bold,
            color: Hexcolor('233062'),
            fontSize: 20.0,
          ),
          textAlign: TextAlign.center),
    );
  }
}

class ButtonReen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(vertical: 25.0),
      margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Login()),
          );
        },
        padding: EdgeInsets.all(15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        color: Hexcolor('009444'),
        child: Text(
          'Reenviar Correo',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }
}
