import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../widgets.dart';
import '../../providers/auth.dart';

class RecoverFinishPassword extends StatefulWidget {
  @override
  _RecoverFinishPasswordState createState() => _RecoverFinishPasswordState();
}

class _RecoverFinishPasswordState extends State<RecoverFinishPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  Map<String, String> _authData = {
    'passwd1': '',
    'passwd2': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

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
          .changePassword(_authData['passwd1'], _authData['passwd2'])
          .then((_) {
        setState(() {
          _isLoading = false;
        });
        var errorMessage = 'Authentication failed';
        errorMessage = 'Por favor verifique .';
        _showErrorDialog(errorMessage);
      });
    } catch (error) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    String _titleH = 'Recuperar Clave';

    return new Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 20.0, bottom: 10.0),
                  child: Image.asset(
                    "assets/logo.png",
                    width: 180,
                    height: 180,
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
                TextOptionChangeP(),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  margin: EdgeInsets.only(left: 20.0, right: 20.0),
                  width: double.infinity,
                  child: TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Nueva Contraseña',
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Colors.grey,
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    // ignore: missing_return
                    validator: (value) {
                      if (value.isEmpty || value.length < 8) {
                        return 'Invalid Password!';
                      }
                    },
                    onSaved: (value) {
                      _authData['passwd1'] = value;
                    },
                  ),
                ),
                Container(
                  //padding: EdgeInsets.symmetric(vertical: 15.0),
                  margin: EdgeInsets.only(left: 20.0, right: 20.0),
                  width: double.infinity,
                  child: TextFormField(
                    obscureText: true,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Confirme Nueva Contraseña',
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Colors.grey,
                      ),
                    ),
                    // ignore: missing_return
                    validator: (value) {
                      if (value.isEmpty || value.length < 8) {
                        return 'Password debe coincidir!';
                      }
                    },
                    onSaved: (value) {
                      _authData['passwd2'] = value;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 60.0),
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
                            'Enviar',
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
                  margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 10),
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
                      'Cancelar',
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

class TextOptionChangeP extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(vertical: 25.0),
      margin: EdgeInsets.only(left: 60.0, right: 60.0),
      width: double.infinity,
      child: Text('Para continuar debes ingresar una nueva clave.',
          style: TextStyle(
              fontFamily: 'OpenSans',
              color: Hexcolor('233062'),
              fontSize: 15.0,
              fontWeight: FontWeight.bold),
          textAlign: TextAlign.center),
    );
  }
}
