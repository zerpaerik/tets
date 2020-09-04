import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../widgets.dart';
import '../../providers/auth.dart';

class RecoverPassword extends StatefulWidget {
  @override
  _RecoverPasswordState createState() => _RecoverPasswordState();
}

class _RecoverPasswordState extends State<RecoverPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String _email;
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
          .verifyEmail(_email)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
        var errorMessage = 'Authentication failed';
        errorMessage = 'Por favor verifique el Email.';
        _showErrorDialog(errorMessage);
      });
    } catch (error) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CodeRecover(email: _email)),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    String _titleH = AppTranslations.of(context).text("label_recover_passwd");

    return new Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                LogoLogin(),
                Text(
                  _titleH,
                  style: TextStyle(
                    fontSize: 30,
                    color: Hexcolor('EA6012'),
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 5),
                TextOptionRP(),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  margin: EdgeInsets.only(left: 20.0, right: 20.0),
                  width: double.infinity,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: AppTranslations.of(context).text("key_email"),
                      prefixIcon: Icon(
                        Icons.mail_outline,
                        color: Colors.grey,
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    // ignore: missing_return
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Invalid email!';
                      }
                    },
                    onSaved: (value) {
                      _email = value;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 40.0),
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
                            AppTranslations.of(context).text("submit"),
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
                Container(
                  margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 20),
                  width: double.infinity,
                  child: RaisedButton(
                    elevation: 5.0,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeRoute()),
                      );
                    },
                    padding: EdgeInsets.all(17),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    color: Hexcolor('EA6012'),
                    child: Text(
                      AppTranslations.of(context).text("cancel"),
                      style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 1,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TextOptionRP extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(vertical: 25.0),
      margin: EdgeInsets.only(left: 60.0, right: 60.0),
      width: double.infinity,
      child: Text(AppTranslations.of(context).text("text_recover"),
          style: TextStyle(
            fontFamily: 'OpenSans',
            color: Hexcolor('233062'),
            fontSize: 18.0,
          ),
          textAlign: TextAlign.center),
    );
  }
}
