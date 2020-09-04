import 'package:worker/widgets/dashboard/index.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../widgets.dart';

class PreviewComplete extends StatelessWidget {
  static const routeName = '/preview-complete';

  @override
  Widget build(BuildContext context) {
    String _titleH = '¡No lo dejes a medias!';
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
              Cv(),
              TitleGeneral(_titleH),
              SizedBox(
                height: 20,
              ),
              ValidCuentaP(),
              SizedBox(
                height: 20,
              ),
              ValidCuentaRP(),
              SizedBox(
                height: 20,
              ),
              ButtonReenP(),
              Container(
                margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                width: double.infinity,
                child: OutlineButton(
                  borderSide: BorderSide(color: Hexcolor('EA6012')),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DashboardHome()),
                    );
                  },
                  padding: EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  color: Colors.white,
                  child: Text(
                    'No, prefiero hacerlo más tarde',
                    style: TextStyle(
                      color: Hexcolor('EA6012'),
                      letterSpacing: 1,
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans-Regular',
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TextEmailP extends StatelessWidget {
  final String emailView;
  TextEmailP(this.emailView);

  @override
  Widget build(BuildContext context) {
    return Container(
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

class ValidCuentaP extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(vertical: 25.0),
      margin: EdgeInsets.only(left: 40.0, right: 40.0, top: 30.0),
      width: double.infinity,
      child: Text(
          'Completa la información para recibir ofertas de trabajo mas atractivas',
          style: TextStyle(
            fontFamily: 'OpenSans-Regular',
            color: Hexcolor('9c9c9c'),
            fontSize: 15.0,
          ),
          textAlign: TextAlign.center),
    );
  }
}

class ValidCuentaRP extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 40.0, right: 40.0, top: 30.0),
      width: double.infinity,
      child: Text(
          'Deseas completar el perfil ahora y comenzar a recibir ofertas en este momento?',
          style: TextStyle(
            fontFamily: 'OpenSans-Regular',
            color: Hexcolor('9c9c9c'),
            fontSize: 15.0,
          ),
          textAlign: TextAlign.center),
    );
  }
}

class ButtonReenP extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(vertical: 25.0),
      margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfileAdicAcade()),
          );
        },
        padding: EdgeInsets.all(15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        color: Hexcolor('009444'),
        child: Text(
          '¡Si! Completemos esos datos',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1,
            fontSize: 17.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }
}

class ButtonNeg extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(vertical: 25.0),
      margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 50.0),
      width: double.infinity,
      child: OutlineButton(
        borderSide: BorderSide(color: Hexcolor('EA6012')),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DashboardHome()),
          );
        },
        padding: EdgeInsets.all(15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        color: Colors.white,
        child: Text(
          'No, prefiero hacerlo más tarde',
          style: TextStyle(
            color: Hexcolor('EA6012'),
            letterSpacing: 1,
            fontSize: 17.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans-Regular',
          ),
        ),
      ),
    );
  }
}
