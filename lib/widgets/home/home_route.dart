import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import '../widgets.dart';

// ignore: must_be_immutable
class HomeRoute extends StatelessWidget {
  double maxtop;
  double mxwidht;
  double mxheight;
  double size;
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    if (screenSize.height > 800) {
      maxtop = 50;
      size = 35;
      mxwidht = 220;
      mxheight = 220;
    } else {
      maxtop = 50;
      size = 30;
      mxwidht = 150;
      mxheight = 150;
    }
    String _titleH = AppTranslations.of(context).text("welcome");
    return new Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: true,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(top: maxtop),
                  child: Image.asset("assets/icono_casco.png",
                      width: 220, height: 220)),
              Text(
                _titleH,
                style: TextStyle(
                  fontSize: 35,
                  color: Hexcolor('EA6012'),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              TextOption(),
              ButtonSesions(),
              ButtonRegister(),
              TextSecondHome(),
              TextSocialLogin(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset("assets/face.png", height: 70),
                  Image.asset("assets/google.png", height: 70),
                ],
              ),
            ],
          )),
        ],
      ),
    );
  }
}

class TextOption extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(vertical: 25.0),
      margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 20),
      width: double.infinity,
      child: Text(AppTranslations.of(context).text("label_end_sesion"),
          style: TextStyle(
            fontFamily: 'OpenSans-Regular',
            color: Hexcolor('233062'),
            fontSize: 18.0,
          ),
          textAlign: TextAlign.center),
    );
  }
}

class ButtonSesions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
      width: double.infinity,
      child: OutlineButton(
        borderSide: BorderSide(color: Hexcolor('EA6012')),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Login()),
          );
        },
        padding: EdgeInsets.all(17),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        color: Colors.white,
        child: Text(
          AppTranslations.of(context).text("button_sesiom"),
          style: TextStyle(
            color: Hexcolor('EA6012'),
            letterSpacing: 1,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans-Regular',
          ),
        ),
      ),
    );
  }
}

class ButtonRegister extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: EdgeInsets.symmetric(vertical: 25.0),
      margin: EdgeInsets.only(left: 20.0, right: 20.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegisterUser()),
          );
        },
        padding: EdgeInsets.all(18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        color: Hexcolor('EA6012'),
        child: Text(
          AppTranslations.of(context).text("button_register"),
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

class TextSecondHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RecoverPassword()),
        );
      },
      child: Text(AppTranslations.of(context).text("label_recover_passwd"),
          style: TextStyle(
            fontFamily: 'OpenSans-Regular',
            fontWeight: FontWeight.bold,
            color: Hexcolor('233062'),
            fontSize: 18.0,
          )),
    );
  }
}

class TextSocialLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      margin: EdgeInsets.only(left: 20.0, right: 20.0),
      width: double.infinity,
      child: Text(AppTranslations.of(context).text("sesion_social"),
          style: TextStyle(
            fontFamily: 'OpenSans-Regular',
            color: Hexcolor('233062'),
            fontSize: 18.0,
          ),
          textAlign: TextAlign.center),
    );
  }
}
