import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets.dart';
import '../../providers/auth.dart';
import '../../model/http_exception.dart';
import '../../model/user.dart';

enum AuthMode { Login }

class Login extends StatefulWidget {
  static const routeName = '/auth';
  const Login({
    Key key,
  }) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  // ignore: unused_field
  AuthMode _authMode = AuthMode.Login;
  // ignore: unused_field
  User _user;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  var _authResponse;
  String l;
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

  Future<dynamic> _submit() async {
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
          .login(
        _authData['email'],
        _authData['password'],
      )
          .then((response) {
        setState(() {
          _isLoading = false;
          _authResponse = response;
        });
      });

      //  Navigator.of(context).pushReplacementNamed('/add-profile-picture');
      if (_authResponse['has_city'] == false)
        Navigator.of(context).pushReplacementNamed('/add-profile');
      if (_authResponse['has_city'] == true &&
          _authResponse['has_dependents_number'] == false)
        Navigator.of(context).pushReplacementNamed('/add-profile2');
      if (_authResponse['has_city'] == true &&
          _authResponse['has_dependents_number'] == true &&
          _authResponse['has_profile_image'] == false)
        Navigator.of(context).pushReplacementNamed('/add-profile-picture');
      if (_authResponse['has_city'] == true &&
          _authResponse['has_dependents_number'] == true &&
          _authResponse['has_profile_image'] == true)
        Navigator.of(context).pushReplacementNamed('/dashboard');
    } on HttpException catch (non_field_errors) {
      var errorMessage = 'Authentication failed';
      if (non_field_errors
          .toString()
          .contains('Unable to log in with provided credentials.')) {
        errorMessage = 'Por favor verifique sus credenciales.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      //const errorMessage = 'Intentelo mas tarde!';
      //_showErrorDialog(errorMessage);
      Navigator.of(context).pushReplacementNamed('/add-profile');
    }

    setState(() {
      _isLoading = false;
    });
  }

  getLang() async {
    SharedPreferences lang = await SharedPreferences.getInstance();
    String stringValue = lang.getString('stringValue');
    l = stringValue;
    return stringValue;
  }

  // ignore: unused_element
  void _viewUser() {
    Provider.of<Auth>(context, listen: false).fetchUser().then((value) {
      setState(() {
        _user = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String _titleH = AppTranslations.of(context).text("welcome");
    print(l);
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
                  //margin: EdgeInsets.only(top: 10.0),
                  child: Image.asset(
                    "assets/emplooy.png",
                    width: 280,
                    height: 220,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Text(
                    _titleH,
                    style: TextStyle(
                      fontSize: 30,
                      color: Hexcolor('EA6012'),
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 35,
                ),
                Container(
                  // padding: EdgeInsets.symmetric(vertical: 25.0),
                  margin: EdgeInsets.only(left: 60.0, right: 60.0),
                  width: double.infinity,
                  child:
                      Text(AppTranslations.of(context).text("enter_data_login"),
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                            color: Hexcolor('233062'),
                            fontSize: 18.0,
                          ),
                          textAlign: TextAlign.center),
                ),
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
                      _authData['email'] = value;
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
                      labelText:
                          AppTranslations.of(context).text("key_password"),
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: Colors.grey,
                      ),
                    ),
                    // ignore: missing_return
                    validator: (value) {
                      if (value.isEmpty || value.length < 1) {
                        return 'Password es muy corto!';
                      }
                    },
                    onSaved: (value) {
                      _authData['password'] = value;
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
                TextSecondLogin(),
                TextSecondLoginRegister()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TextOptionL extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(vertical: 25.0),
      margin: EdgeInsets.only(left: 60.0, right: 60.0),
      width: double.infinity,
      child: Text(AppTranslations.of(context).text("enter_data_login"),
          style: TextStyle(
            fontFamily: 'OpenSans',
            color: Hexcolor('233062'),
            fontSize: 18.0,
          ),
          textAlign: TextAlign.center),
    );
  }
}

class TextSecondLogin extends StatelessWidget {
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

class TextSecondLoginRegister extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RegisterUser()),
        );
      },
      child: Text(AppTranslations.of(context).text("register"),
          style: TextStyle(
            fontFamily: 'OpenSans-Regular',
            fontWeight: FontWeight.bold,
            color: Hexcolor('EA6012'),
            fontSize: 18.0,
          )),
    );
  }
}
