import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../widgets.dart';
import '../../providers/auth.dart';

class CodeRecover extends StatefulWidget {
  final String email;

  CodeRecover({@required this.email});

  @override
  _CodeRecoverState createState() => _CodeRecoverState(email);
}

class _CodeRecoverState extends State<CodeRecover> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String _code;
  String email;
  _CodeRecoverState(this.email);

  var _isLoading = false;

  void _showErrorDialog(String message) {
    print(message);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Oops, ha ocurrido un Error!'),
        content: Text(message),
        titleTextStyle: TextStyle(
            color: Hexcolor('373737'),
            fontFamily: 'OpenSansRegular',
            fontWeight: FontWeight.bold,
            fontSize: 20),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            textColor: Hexcolor('EA6012'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Auth>(context, listen: false)
          .verifyCode(_code)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
        var errorMessage = 'Authentication failed';
        errorMessage = 'Por favor verifique el Còdigo.';
        _showErrorDialog(errorMessage);
      });
    } catch (error) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RecoverFinishPassword()),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    String _titleH = AppTranslations.of(context).text("send_code");

    return new Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Image.asset(
                    "assets/email.png",
                    height: 165,
                    width: 180,
                  ),
                ),
                Text(
                  _titleH,
                  style: TextStyle(
                    fontSize: 30,
                    color: Hexcolor('EA6012'),
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                TextOptionRe(),
                SizedBox(height: 5),
                Text(email,
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold,
                      color: Hexcolor('233062'),
                      fontSize: 18.0,
                    )),
                //SizedBox(height:5),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  margin: EdgeInsets.only(left: 20.0, right: 20.0),
                  width: double.infinity,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: AppTranslations.of(context).text("send_code"),
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: Colors.grey,
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    // ignore: missing_return
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Es obligatorio';
                      }
                    },
                    onSaved: (value) {
                      _code = value;
                    },
                  ),
                ),
                SizedBox(height: 10),
                ConfirmRe(),
                Container(
                  margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                  width: double.infinity,
                  child: _isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : RaisedButton(
                          elevation: 5.0,
                          onPressed: _submit,
                          padding: EdgeInsets.all(17),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          color: Hexcolor('009444'),
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
                ButtonReenv(),
                ButtonRegisterR(),
                TextSecondRecoverR(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TextOptionRe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(vertical: 25.0),
      margin: EdgeInsets.only(left: 20.0, right: 20.0),
      width: double.infinity,
      child: Text(AppTranslations.of(context).text("notif_code"),
          style: TextStyle(
            fontFamily: 'OpenSans-Regular',
            color: Hexcolor('9c9c9c'),
            fontSize: 15.0,
          ),
          textAlign: TextAlign.center),
    );
  }
}

class ConfirmRe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(vertical: 25.0),
      margin: EdgeInsets.only(left: 20.0, right: 20.0),
      width: double.infinity,
      child: Text(AppTranslations.of(context).text("text_code"),
          style: TextStyle(
            fontFamily: 'OpenSans-Regular',
            color: Hexcolor('9c9c9c'),
            fontSize: 15.0,
          ),
          textAlign: TextAlign.center),
    );
  }
}

class ButtonSaveRe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: EdgeInsets.symmetric(vertical: 10.0),
      margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RecoverFinishPassword()),
          );
        },
        padding: EdgeInsets.all(15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        color: Hexcolor('009444'),
        child: Text(
          AppTranslations.of(context).text("continue"),
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

class ButtonReenv extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 10),
      width: double.infinity,
      child: OutlineButton(
        borderSide: BorderSide(color: Hexcolor('EA6012')),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RecoverPassword()),
          );
        },
        padding: EdgeInsets.all(15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        color: Colors.white,
        child: Text(
          AppTranslations.of(context).text("reenv_email"),
          style: TextStyle(
            color: Hexcolor('EA6012'),
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

class ButtonRegisterR extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: EdgeInsets.symmetric(vertical: 25.0),
      margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 10),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegisterUser()),
          );
        },
        padding: EdgeInsets.all(15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        color: Hexcolor('233062'),
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

class TextSecondRecoverR extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      },
      child: Text(AppTranslations.of(context).text("label_recover_account"),
          style: TextStyle(
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.bold,
            color: Hexcolor('233062'),
            fontSize: 18.0,
          )),
    );
  }
}
