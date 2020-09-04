import 'package:worker/widgets/dashboard/index.dart';
import 'package:worker/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../model/user.dart';
import '../../model/http_exception.dart';
import '../../providers/users.dart';
import '../widgets.dart';

class ProfilePartAdic extends StatefulWidget {
  static const routeName = '/add-profile-adic';

  @override
  _ProfilePartAdicState createState() => _ProfilePartAdicState();
}

class _ProfilePartAdicState extends State<ProfilePartAdic> {
  String _valEdo;
  List _listEdo = ['Soltero(a)', 'Casado(a)', 'Divorciado(a)', 'Viudo(a)'];

  final _priceFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();

  var _editedUser = User(
    id: null,
    first_name: '',
    last_name: '',
    email: '',
    birth_date: null,
    password1: '',
    password2: '',
    gender: null,
  );
  var _initValuesU = {
    'first_name': '',
    'last_name': '',
    'email': '',
    'birth_date': '',
    // ignore: equal_keys_in_map
    'email': '',
    'password1': '',
    'password2': '',
    'gender': '',
    'city': '',
  };
  // ignore: unused_field
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  // ignore: unused_field
  var _isInit = true;
  // ignore: unused_field
  String _myActivity;
  String _myActivityEdo;
  String _myActivityAdd;
  // ignore: unused_field
  String _myActivityResult;

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    _myActivityEdo = '';
    _myActivityAdd = '';
    _myActivityResult = '';
    super.initState();
  }

  onChangeDropdownItem() {
    setState(() {
      _myActivityResult = _myActivityEdo;
      _myActivityResult = _myActivityAdd;
    });
  }

  // ignore: unused_element
  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    var successRegister = 0;
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    if (_editedUser.id != null) {
      Provider.of<User>(context, listen: false);
      //.updateProduct(_editedProduct.id, _editedProduct);
    } else {
      //Provider.of<Users>(context, listen: false).addUser(_editedUser);
      try {
        await Provider.of<Users>(context, listen: false).addUser(_editedUser);
        successRegister = 1;
      } on HttpException catch (email) {
        successRegister = 2;
        var errorMessage = '';
        if (email
            .toString()
            .contains('A user with that email address already exists')) {
          errorMessage = 'This email address is already in use.';
        } else if (email.toString().contains('INVALID_EMAIL')) {
          errorMessage = 'This is not a valid email address';
        } else if (email.toString().contains('WEAK_PASSWORD')) {
          errorMessage = 'This password is too weak.';
        } else if (email.toString().contains('EMAIL_NOT_FOUND')) {
          errorMessage = 'Could not find a user with that email.';
        } else if (email.toString().contains('INVALID_PASSWORD')) {
          errorMessage = 'Invalid password.';
        }
        _showErrorDialog(errorMessage);
      } catch (email) {
        successRegister = 2;
        const errorMessage = 'Could not register you. Please try again later.';
        _showErrorDialog(errorMessage);
      }
    }
    //Navigator.of(context).pop();
    print(successRegister);
    if (successRegister == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ConfirmRegister(_editedUser.email)),
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    String _titleReg = 'Datos adicionales';
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              TitleProfile(_titleReg),
              Text(
                'Declaración de formulario W4',
                style: TextStyle(
                    fontSize: 17,
                    fontFamily: 'OpenSans-Regular',
                    color: Hexcolor('9c9c9c'),
                    fontWeight: FontWeight.bold),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: SizedBox(
                      height: 56.0,
                      child: TextFormField(
                        initialValue: _initValuesU['email'],
                        decoration: InputDecoration(labelText: 'Nombre'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty || !value.contains('@')) {
                            return 'Invalid email!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedUser = User(
                            first_name: _editedUser.first_name,
                            last_name: _editedUser.last_name,
                            email: value,
                            birth_date: _editedUser.birth_date,
                            password1: _editedUser.password1,
                            password2: _editedUser.password2,
                            gender: _editedUser.gender,
                            id: _editedUser.id,
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 56.0,
                      child: TextFormField(
                        initialValue: _initValuesU['email'],
                        decoration: InputDecoration(labelText: 'Apellido'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty || !value.contains('@')) {
                            return 'Invalid email!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedUser = User(
                            first_name: _editedUser.first_name,
                            last_name: _editedUser.last_name,
                            email: value,
                            birth_date: _editedUser.birth_date,
                            password1: _editedUser.password1,
                            password2: _editedUser.password2,
                            gender: _editedUser.gender,
                            id: _editedUser.id,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              TextFormField(
                initialValue: _initValuesU['email'],
                decoration: InputDecoration(labelText: 'SSN'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                validator: (value) {
                  if (value.isEmpty || !value.contains('@')) {
                    return 'Invalid email!';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedUser = User(
                    first_name: _editedUser.first_name,
                    last_name: _editedUser.last_name,
                    email: value,
                    birth_date: _editedUser.birth_date,
                    password1: _editedUser.password1,
                    password2: _editedUser.password2,
                    gender: _editedUser.gender,
                    id: _editedUser.id,
                  );
                },
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: SizedBox(
                      height: 56.0,
                      child: TextFormField(
                        initialValue: _initValuesU['email'],
                        decoration: InputDecoration(labelText: 'Estado'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty || !value.contains('@')) {
                            return 'Invalid email!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedUser = User(
                            first_name: _editedUser.first_name,
                            last_name: _editedUser.last_name,
                            email: value,
                            birth_date: _editedUser.birth_date,
                            password1: _editedUser.password1,
                            password2: _editedUser.password2,
                            gender: _editedUser.gender,
                            id: _editedUser.id,
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 56.0,
                      child: TextFormField(
                        initialValue: _initValuesU['email'],
                        decoration: InputDecoration(labelText: 'Ciudad'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty || !value.contains('@')) {
                            return 'Invalid email!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedUser = User(
                            first_name: _editedUser.first_name,
                            last_name: _editedUser.last_name,
                            email: value,
                            birth_date: _editedUser.birth_date,
                            password1: _editedUser.password1,
                            password2: _editedUser.password2,
                            gender: _editedUser.gender,
                            id: _editedUser.id,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: SizedBox(
                      height: 55.0,
                      width: 50.0,
                      child: TextFormField(
                        initialValue: _initValuesU['email'],
                        decoration: InputDecoration(labelText: 'Codigo Postal'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty || !value.contains('@')) {
                            return 'Invalid email!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedUser = User(
                            first_name: _editedUser.first_name,
                            last_name: _editedUser.last_name,
                            email: value,
                            birth_date: _editedUser.birth_date,
                            password1: _editedUser.password1,
                            password2: _editedUser.password2,
                            gender: _editedUser.gender,
                            id: _editedUser.id,
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 69.0,
                      width: 50.0,
                      child: DropdownButton(
                        isExpanded: true,
                        iconEnabledColor: Hexcolor('EA6012'),
                        hint: Text("Estado Civil"),
                        underline: Container(
                          height: 1,
                          color: Colors.grey,
                        ),
                        value: _valEdo,
                        items: _listEdo.map((value) {
                          return DropdownMenuItem(
                            child: Text(value),
                            value: value,
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _valEdo =
                                value; //Untuk memberitahu _valFriends bahwa isi nya akan diubah sesuai dengan value yang kita pilih
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              TextFormField(
                initialValue: _initValuesU['email'],
                decoration: InputDecoration(labelText: 'Firma con el dedo'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                validator: (value) {
                  if (value.isEmpty || !value.contains('@')) {
                    return 'Invalid email!';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedUser = User(
                    first_name: _editedUser.first_name,
                    last_name: _editedUser.last_name,
                    email: value,
                    birth_date: _editedUser.birth_date,
                    password1: _editedUser.password1,
                    password2: _editedUser.password2,
                    gender: _editedUser.gender,
                    id: _editedUser.id,
                  );
                },
              ),
              SizedBox(
                height: 230,
              ),
              Row(
                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: SizedBox(
                      height: 50.0,
                      child: RaisedButton(
                        elevation: 5.0,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        padding: EdgeInsets.only(
                            left: 20, right: 20, top: 15, bottom: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        color: Hexcolor('EA6012'),
                        child: Text(
                          'Anterior',
                          style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 1,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'OpenSans',
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 50.0,
                      child: RaisedButton(
                        elevation: 5.0,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DashboardHome()),
                          );
                        },
                        padding: EdgeInsets.only(
                            left: 20, right: 20, top: 10, bottom: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        color: Hexcolor('009444'),
                        child: Text(
                          'Siguiente',
                          style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 1,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'OpenSans',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
