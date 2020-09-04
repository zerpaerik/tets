import 'package:worker/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:hexcolor/hexcolor.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'dart:io';
import 'package:percent_indicator/percent_indicator.dart';

import '../../../model/gender.dart';
import '../../../model/user.dart';
import '../../../providers/users.dart';
import '../../widgets.dart';

class ViewProfileOblig2 extends StatefulWidget {
  static const routeName = '/view-my-profile2';

  final User user;

  ViewProfileOblig2({@required this.user});

  @override
  _ViewProfileOblig2State createState() => new _ViewProfileOblig2State(user);
}

class _ViewProfileOblig2State extends State<ViewProfileOblig2> {
  User user;
  _ViewProfileOblig2State(this.user);

  String _valDoc;
  String _valEdo;
  String _valDocsSheet;
  String _valDociSheet;
  String _valDocI;
  // ignore: unused_field
  String _valDocN;
  // ignore: unused_field
  File _pickedImage;
  String _valBlood;
  String _valRh;
  DateTime _valExpire;
  List _listDoc = ['SSN', 'ITIN'];
  List _listDocI = ['Licencia de Conducir', 'StateId', 'Pasaporte'];
  List _listEdo = ['Soltero(a)', 'Casado(a)', 'Divorciado(a)', 'Viudo(a)'];
  List _listBlodd = ['A', 'B', 'AB', 'O'];
  List _listRH = ['Positivo (+)', 'Negativo (-)', 'No lo se'];

  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  final _form1 = GlobalKey<FormState>();
  final _form2 = GlobalKey<FormState>();
  var _editedUser = User(
    id: null,
    first_name: '',
    last_name: '',
    email: '',
    birth_date: null,
    country: null,
    state: null,
    city: null,
    gender: '',
  );

  // ignore: unused_field
  String _myActivity;
  // ignore: unused_field
  String _value;
  // ignore: unused_field
  String _myActivityResult;
  String name;

  // MASK SSN - ITIN
  var maskTextInputFormatter = MaskTextInputFormatter(
      mask: "###-##-####", filter: {"#": RegExp(r'[0-9]')});
  var maskTextInputFormatterItin = MaskTextInputFormatter(
      mask: "9##-##-####", filter: {"#": RegExp(r'[0-9]')});
  var maskTextInputFormatterID = MaskTextInputFormatter(
      mask: "#########", filter: {"#": RegExp(r'[0-9]')});
  // ignore: unused_field
  var _isLoading = false;

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

  String capitalize(String string) {
    if (string == null) {
      throw ArgumentError("string: $string");
    }

    if (string.isEmpty) {
      return string;
    }

    return string[0].toUpperCase() + string.substring(1);
  }

  @override
  void initState() {
    _myActivity = '';
    _value = '';
    _myActivityResult = '';
    super.initState();
  }

  List<DropdownMenuItem<Gender>> buildDropdownMenuItems(List genders) {
    List<DropdownMenuItem<Gender>> items = List();
    for (Gender gender in genders) {
      items.add(
        DropdownMenuItem(
          value: gender,
          child: Text(gender.name),
        ),
      );
    }
    return items;
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Users>(context, listen: false)
          .updateProfile2(_editedUser)
          .then((_) {
        setState(() {
          _isLoading = false;
        });

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MyProfile(user: this.widget.user)),
        );
      });
    } catch (error) {}
  }

  // ignore: unused_element
  void _showInputDialog(String title) {
    if (title == 'SSN') {
      showModalBottomSheet(
          context: context,
          builder: (ctx) {
            return Scaffold(
                body: SingleChildScrollView(
              child: Form(
                  key: _form1,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(
                        height: 50,
                      ),
                      Text('Ingrese la numeración de su $title',
                          style: TextStyle(
                              fontFamily: 'OpenSans',
                              color: Hexcolor('EA6012'),
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0),
                          textAlign: TextAlign.center),
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 40.0, right: 40.0),
                        width: double.infinity,
                        child: TextFormField(
                            initialValue: _valDocsSheet,
                            inputFormatters: [maskTextInputFormatter],
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              hintText: '###-##-####',
                              alignLabelWithHint: true,
                            ),
                            // ignore: missing_return
                            validator: (value) {
                              if (value.isEmpty || value.length < 9) {
                                return 'Valor es muy corto!';
                              }
                            },
                            onSaved: (value) {
                              setState(() {
                                _valDocsSheet =
                                    value; //Untuk memberitahu _valFriends bahwa isi nya akan diubah sesuai dengan value yang kita pilih
                              });
                              _editedUser = User();
                            },
                            onChanged: (value) {
                              setState(() {
                                _valDocsSheet =
                                    value; //Untuk memberitahu _valFriends bahwa isi nya akan diubah sesuai dengan value yang kita pilih
                              });
                            }),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 40.0, right: 40.0),
                        width: double.infinity,
                        child: RaisedButton(
                          elevation: 5.0,
                          /*onPressed: () {
                    Navigator.of(ctx).pop();
                    },*/
                          onPressed: () {
                            if (_form1.currentState.validate()) {
                              Navigator.of(ctx).pop();
                            } else {
                              String error = 'El valor de SSN es Obligatorio';
                              _showErrorDialog(error);
                            }
                          },
                          padding: EdgeInsets.only(
                              left: 25, right: 25, top: 10, bottom: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          color: Colors.green[700],
                          child: Text(
                            'Aceptar',
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
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  )),
            ));
          });
    } else {
      showModalBottomSheet(
          context: context,
          builder: (ctx) {
            return Scaffold(
                body: SingleChildScrollView(
              child: Form(
                  key: _form1,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(
                        height: 50,
                      ),
                      Text('Ingrese la numeración de su $title',
                          style: TextStyle(
                              fontFamily: 'OpenSans',
                              color: Hexcolor('EA6012'),
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0),
                          textAlign: TextAlign.center),
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 40.0, right: 40.0),
                        width: double.infinity,
                        child: TextFormField(
                            initialValue: _valDocsSheet,
                            inputFormatters: [maskTextInputFormatterItin],
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              hintText: '9##-##-####',
                              alignLabelWithHint: true,
                            ),
                            // ignore: missing_return
                            validator: (value) {
                              if (value.isEmpty || value.length < 9) {
                                return 'Valor es muy corto!';
                              }
                            },
                            onSaved: (value) {
                              setState(() {
                                _valDocsSheet =
                                    value; //Untuk memberitahu _valFriends bahwa isi nya akan diubah sesuai dengan value yang kita pilih
                              });
                              _editedUser = User();
                            },
                            onChanged: (value) {
                              setState(() {});
                            }),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 40.0, right: 40.0),
                        width: double.infinity,
                        child: RaisedButton(
                          elevation: 5.0,
                          onPressed: () {
                            if (_form1.currentState.validate()) {
                              Navigator.of(ctx).pop();
                            } else {
                              String error = 'El valor de ITIN es Obligatorio';
                              _showErrorDialog(error);
                            }
                          },
                          padding: EdgeInsets.only(
                              left: 25, right: 25, top: 10, bottom: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          color: Colors.green[700],
                          child: Text(
                            'Aceptar',
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
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  )),
            ));
          });
    }
  }

  // ignore: unused_element
  void _showInputDialogIdentify(String title) {
    DateFormat format = DateFormat("yyyy-MM-dd");
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return Scaffold(
              body: SingleChildScrollView(
                  child: Form(
                      key: _form2,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          SizedBox(
                            height: 50,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 40.0, right: 40.0),
                            width: double.infinity,
                            child: Text('Ingrese la numeración de su $title',
                                style: TextStyle(
                                    fontFamily: 'OpenSans',
                                    color: Hexcolor('EA6012'),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17.0),
                                textAlign: TextAlign.center),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 40.0, right: 40.0),
                            width: double.infinity,
                            child: TextFormField(
                                initialValue: _valDociSheet,
                                inputFormatters: [maskTextInputFormatterID],
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  hintText: '#########',
                                  alignLabelWithHint: true,
                                ),
                                // ignore: missing_return
                                validator: (value) {
                                  if (value.isEmpty || value.length < 9) {
                                    return 'Valor es muy corto!';
                                  }
                                },
                                onSaved: (value) {
                                  setState(() {
                                    _valDociSheet =
                                        value; //Untuk memberitahu _valFriends bahwa isi nya akan diubah sesuai dengan value yang kita pilih
                                  });
                                  _editedUser = User(
                                    is_us_citizen: true,
                                    id_type: _valDoc,
                                    id_number: _valDocsSheet,
                                    doc_type: _valDocI,
                                    doc_number: _valDociSheet,
                                  );
                                },
                                onChanged: (value) {
                                  setState(() {
                                    _valDociSheet =
                                        value; //Untuk memberitahu _valFriends bahwa isi nya akan diubah sesuai dengan value yang kita pilih
                                  });
                                }),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 40.0, right: 40.0),
                            width: double.infinity,
                            child: DateTimeField(
                                format: format,
                                initialValue: DateTime.now(),
                                decoration: InputDecoration(
                                    labelText: 'Fecha de Vencimiento'),
                                textInputAction: TextInputAction.next,
                                onShowPicker: (context, currentValue) {
                                  return showDatePicker(
                                      context: context,
                                      firstDate: DateTime(1900),
                                      initialDate:
                                          currentValue ?? DateTime.now(),
                                      lastDate: DateTime(2100));
                                },
                                onSaved: (value) {
                                  setState(() {
                                    _valExpire = DateTime
                                        .now(); //Untuk memberitahu _valFriends bahwa isi nya akan diubah sesuai dengan value yang kita pilih
                                  });
                                  _editedUser = User(
                                      is_us_citizen: true,
                                      id_type: _valDoc,
                                      id_number: _valDocsSheet,
                                      doc_type: _valDocI,
                                      doc_number: _valDociSheet,
                                      doc_expire_date: _valExpire);
                                },
                                onChanged: (value) {
                                  setState(() {
                                    _valExpire =
                                        value; //Untuk memberitahu _valFriends bahwa isi nya akan diubah sesuai dengan value yang kita pilih
                                  });
                                }),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 40.0, right: 40.0),
                            width: double.infinity,
                            child: ImageInputGallery(_selectImage),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 40.0, right: 40.0),
                            width: double.infinity,
                            child: RaisedButton(
                              elevation: 5.0,
                              onPressed: () {
                                if (_form2.currentState.validate()) {
                                  Navigator.of(ctx).pop();
                                } else {
                                  String error =
                                      'Todos los Valores son obligatorios';
                                  _showErrorDialog(error);
                                }
                              },
                              padding: EdgeInsets.only(
                                  left: 25, right: 25, top: 10, bottom: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              color: Colors.green[700],
                              child: Text(
                                'Aceptar',
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
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ))));
        });
  }

  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  @override
  Widget build(BuildContext context) {
    if (this.widget.user.id_type == '1') {
      _valDoc = 'SSN';
    } else {
      _valDoc = 'ITIN';
    }

    if (this.widget.user.doc_type == '1') {
      _valDocI = 'Licencia de Conducir';
    }
    if (this.widget.user.doc_type == '2') {
      _valDocI = 'StateId';
    }
    if (this.widget.user.doc_type == '3') {
      _valDocI = 'Pasaporte';
    }
    _valEdo = 'Soltero(a)';
    _valBlood = 'A';
    _valRh = 'Positivo (+)';
    _valDocsSheet = user.id_number;

    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        backgroundColor: Colors.white,
        //centerTitle: true,
        iconTheme: IconThemeData(
          color: Hexcolor('EA6012'),
        ),
        title: Image.asset(
          "assets/homelogo.png",
          width: 120,
          alignment: Alignment.topLeft,
        ),
      ),
      // endDrawer: EndDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 20),
                child: Text('Completitud de Perfil',
                    style: TextStyle(
                        color: Hexcolor('EA6012'),
                        fontFamily: 'OpenSans-Regular',
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
              ),
              Container(
                  margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: new LinearPercentIndicator(
                        width: 300.0,
                        animation: true,
                        animationDuration: 1000,
                        lineHeight: 10.0,
                        percent: 0.8,
                        //center: Text("20.0%"),
                        linearStrokeCap: LinearStrokeCap.butt,
                        progressColor: Hexcolor('233062')),
                  )),
              Container(
                margin: EdgeInsets.only(left: 20, top: 10.0),
                child: Text('Ciudadania estadounidense',
                    style: TextStyle(
                        color: Hexcolor('9c9c9c'),
                        fontFamily: 'OpenSans-Regular',
                        fontSize: 19,
                        fontWeight: FontWeight.bold)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                      width: 168.0,
                      height: 74,
                      child: DropdownButton(
                        // disabledHint: ,
                        disabledHint: Text(_valDoc),
                        isExpanded: true,
                        iconEnabledColor: Hexcolor('EA6012'),
                        hint: Text("¿Tienes SSN o ITIN?"),
                        underline: Container(
                          height: 1,
                          color: Colors.grey,
                        ),
                        value: _valDoc,
                        items: _listDoc.map((value) {
                          return DropdownMenuItem(
                            child: Text(value),
                            value: value,
                          );
                        }).toList(),
                        onChanged: null,
                      )),
                  Container(
                    width: 168.0,
                    height: 60,
                    child: TextFormField(
                      initialValue: _valDocsSheet,
                      enabled: false,
                      decoration:
                          InputDecoration(labelText: 'ID de' + ' ' + _valDoc),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Es obligatorio!';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedUser = User(
                          zip_code: value,
                          phone_number: _editedUser.phone_number,
                          address_1: _editedUser.address_1,
                          address_2: _editedUser.address_2,
                        );
                      },
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                      width: 168.0,
                      height: 74,
                      child: DropdownButton(
                        isExpanded: true,
                        disabledHint: Text(_valDocI),
                        iconEnabledColor: Hexcolor('EA6012'),
                        hint:
                            Text("¿Tienes algun documento de Identificaciòn?"),
                        underline: Container(
                          height: 1,
                          color: Colors.grey,
                        ),
                        value: _valDocI,
                        items: _listDocI.map((value) {
                          return DropdownMenuItem(
                            child: Text(value),
                            value: value,
                          );
                        }).toList(),
                        onChanged: null,
                      )),
                  Container(
                    width: 168,
                    height: 60.0,
                    child: TextFormField(
                      initialValue: this.widget.user.doc_number,
                      enabled: true,
                      decoration:
                          InputDecoration(labelText: 'ID de' + ' ' + _valDocI),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Es obligatorio!';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedUser = User(
                          zip_code: value,
                          phone_number: _editedUser.phone_number,
                          address_1: _editedUser.address_1,
                          address_2: _editedUser.address_2,
                        );
                      },
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                      width: 168.0,
                      height: 74,
                      child: TextFormField(
                        initialValue: '1',
                        decoration:
                            InputDecoration(labelText: 'Nº Dependientes'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Es obligatorio!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedUser = User(
                              contact_first_name:
                                  _editedUser.contact_first_name,
                              contact_last_name: _editedUser.contact_last_name,
                              contact_phone: _editedUser.contact_phone,
                              contact_email: _editedUser.contact_email,
                              dependents_number: value);
                        },
                      )),
                  Container(
                    width: 168.0,
                    height: 60.0,
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
                        _editedUser = User(
                            contact_first_name: _editedUser.contact_first_name,
                            contact_last_name: _editedUser.contact_last_name,
                            contact_phone: _editedUser.contact_phone,
                            contact_email: _editedUser.contact_email,
                            dependents_number: _editedUser.dependents_number);
                      },
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(left: 20, top: 10.0),
                child: Text('Contacto de emergencia',
                    style: TextStyle(
                        color: Hexcolor('9c9c9c'),
                        fontFamily: 'OpenSans-Regular',
                        fontSize: 19,
                        fontWeight: FontWeight.bold)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                      width: 168.0,
                      child: TextFormField(
                        initialValue: this.widget.user.contact_first_name,
                        decoration: InputDecoration(labelText: 'Nombre'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Es obligatorio!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedUser = User(
                              contact_first_name: value,
                              contact_last_name: _editedUser.contact_last_name,
                              contact_phone: _editedUser.contact_phone,
                              contact_email: _editedUser.contact_email,
                              dependents_number: _editedUser.dependents_number);
                        },
                      )),
                  Container(
                    width: 168.0,
                    child: TextFormField(
                      initialValue: this.widget.user.contact_last_name,
                      decoration: InputDecoration(labelText: 'Apellido'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Es obligatorio!';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedUser = User(
                            contact_first_name: _editedUser.contact_first_name,
                            contact_last_name: value,
                            contact_phone: _editedUser.contact_phone,
                            contact_email: _editedUser.contact_email,
                            dependents_number: _editedUser.dependents_number);
                      },
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                      width: 168.0,
                      child: TextFormField(
                        initialValue: this.widget.user.contact_phone,
                        decoration: InputDecoration(labelText: 'Telefono'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Es obligatorio!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedUser = User(
                              contact_first_name:
                                  _editedUser.contact_first_name,
                              contact_last_name: _editedUser.contact_last_name,
                              contact_phone: value,
                              contact_email: _editedUser.contact_email,
                              dependents_number: _editedUser.dependents_number);
                        },
                      )),
                  Container(
                    width: 168.0,
                    child: TextFormField(
                      initialValue: this.widget.user.contact_email,
                      decoration: InputDecoration(labelText: 'Email'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Es obligatorio!';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedUser = User(
                            contact_first_name: _editedUser.contact_first_name,
                            contact_last_name: _editedUser.contact_last_name,
                            contact_phone: _editedUser.contact_phone,
                            contact_email: value,
                            dependents_number: _editedUser.dependents_number);
                      },
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                      width: 168.0,
                      height: 74,
                      child: DropdownButton(
                        isExpanded: true,
                        iconEnabledColor: Hexcolor('EA6012'),
                        hint: Text("Tipo Sangre"),
                        underline: Container(
                          height: 1,
                          color: Colors.grey,
                        ),
                        value: _valBlood,
                        items: _listBlodd.map((value) {
                          return DropdownMenuItem(
                            child: Text(value),
                            value: value,
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _valDoc =
                                value; //Untuk memberitahu _valFriends bahwa isi nya akan diubah sesuai dengan value yang kita pilih
                          });
                          _editedUser = User(
                              contact_first_name:
                                  _editedUser.contact_first_name,
                              contact_last_name: _editedUser.contact_last_name,
                              contact_phone: _editedUser.contact_phone,
                              contact_email: value,
                              dependents_number: _editedUser.dependents_number);
                        },
                      )),
                  Container(
                    width: 168.0,
                    height: 60.0,
                    child: DropdownButton(
                      isExpanded: true,
                      iconEnabledColor: Hexcolor('EA6012'),
                      hint: Text("Factor RH"),
                      underline: Container(
                        height: 1,
                        color: Colors.grey,
                      ),
                      value: _valRh,
                      items: _listRH.map((value) {
                        return DropdownMenuItem(
                          child: Text(value),
                          value: value,
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _valDoc =
                              value; //Untuk memberitahu _valFriends bahwa isi nya akan diubah sesuai dengan value yang kita pilih
                        });
                        _editedUser = User(
                            contact_first_name: _editedUser.contact_first_name,
                            contact_last_name: _editedUser.contact_last_name,
                            contact_phone: _editedUser.contact_phone,
                            contact_email: value,
                            dependents_number: _editedUser.dependents_number);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    width: 130,
                    height: 50.0,
                    margin: EdgeInsets.only(left: 20, right: 30),
                    child: RaisedButton(
                      elevation: 5.0,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MyProfile(user: this.widget.user)),
                        );
                      },
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 15, bottom: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      color: Hexcolor('EA6012'),
                      child: Text(
                        'Ir a Perfil',
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
                  Container(
                    width: 130,
                    height: 50.0,
                    child: RaisedButton(
                      elevation: 5.0,
                      onPressed: _saveForm,
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      color: Hexcolor('009444'),
                      child: Text(
                        'Actualizar',
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
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
