import 'package:worker/widgets/my-profile/tax/w9.dart';
import 'package:worker/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:hexcolor/hexcolor.dart';
import 'package:signature/signature.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../../model/gender.dart';
import '../../../model/user.dart';
import '../../../model/w4.dart';
import '../../../model/country.dart';
import '../../../model/status.dart';
import '../../../model/city.dart';
import '../../../providers/tax_w4.dart';
import '../../widgets.dart';

class Taxw4 extends StatefulWidget {
  static const routeName = '/tax-w4';

  final User user;

  Taxw4({@required this.user});

  @override
  _Taxw4State createState() => new _Taxw4State(user);
}

class _Taxw4State extends State<Taxw4> {
  GlobalKey<_Taxw4State> signatureKey = GlobalKey();
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
    exportBackgroundColor: Colors.blue,
  );
  User user;
  // ignore: unused_field
  bool _isSignature = false;
  _Taxw4State(this.user);
  List<Gender> _genders = Gender.getGenders();
  List<DropdownMenuItem<Gender>> _dropdownMenuItems;
  // ignore: unused_field
  Gender _selectedGender;

  // LIST COUNTRYS
  List<Country> _countrys = Country.getCountrys();
  List<DropdownMenuItem<Country>> _dropdownMenuItemsC;
  // ignore: unused_field
  Country _selectedCountry;

  // LIST CITYS
  List<City> _citys = City.getCitys();
  List<DropdownMenuItem<City>> _dropdownMenuItemsCI;
  City _selectedCity;

  //LIST STATUS MARITALF
  List<StatusM> _status = StatusM.getStatus();
  List<DropdownMenuItem<StatusM>> _dropdownMenuItemsS;
  // ignore: unused_field
  StatusM _selectedStatus;

  List _listEdo = [
    'Soltero o casado declarando individual',
    'Casado declarando en conjunto',
    'Cabeza de hogar'
  ];
  List _listAdd2 = ['Agregar'];

  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedUser =
      // ignore: missing_required_param
      W4(marital_status: null, declaration_date: null, user_id: null);

  // ignore: unused_field
  var _isInit = true;
  // ignore: unused_field
  String _myActivity;
  // ignore: unused_field
  String _value;
  String _valEdo;
  // ignore: unused_field
  String _myActivityResult;
  String name;
  String _valAdd2;
  // ignore: unused_field
  var _isLoading = false;

  // ignore: unused_element
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
    _dropdownMenuItems = buildDropdownMenuItems(_genders);
    _selectedGender = _dropdownMenuItems[0].value;
    _dropdownMenuItemsC = buildDropdownMenuItemsC(_countrys);
    _selectedCountry = _dropdownMenuItemsC[0].value;
    _dropdownMenuItemsCI = buildDropdownMenuItemsCi(_citys);
    _selectedCity = _dropdownMenuItemsCI[0].value;
    _dropdownMenuItemsS = buildDropdownMenuItemsS(_status);
    _selectedStatus = _dropdownMenuItemsS[0].value;
    _myActivity = '';
    _value = '';
    _myActivityResult = '';
    super.initState();
  }

  // ITEMS DROPDOWN COUNTRY

  List<DropdownMenuItem<Country>> buildDropdownMenuItemsC(List countrys) {
    List<DropdownMenuItem<Country>> items = List();
    for (Country country in countrys) {
      items.add(
        DropdownMenuItem(
          value: country,
          child: Text(country.name),
        ),
      );
    }
    return items;
  }

  //ITEMS DROPDOWN STATUS MARITAL
  List<DropdownMenuItem<StatusM>> buildDropdownMenuItemsS(List status) {
    List<DropdownMenuItem<StatusM>> items = List();
    for (StatusM statu in status) {
      items.add(
        DropdownMenuItem(
          value: statu,
          child: Text(statu.name),
        ),
      );
    }
    return items;
  }

  // ITEMS DROPDOWN CITY

  List<DropdownMenuItem<City>> buildDropdownMenuItemsCi(List citys) {
    List<DropdownMenuItem<City>> items = List();
    for (City city in citys) {
      items.add(
        DropdownMenuItem(
          value: city,
          child: Text(city.name),
        ),
      );
    }
    return items;
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

  void _showInputSignature() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return Scaffold(
              body: SingleChildScrollView(
                  child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              Text('Firma con el dedo',
                  style: TextStyle(
                      fontFamily: 'OpenSans',
                      color: Hexcolor('EA6012'),
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0),
                  textAlign: TextAlign.center),
              SizedBox(
                height: 5,
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
                    setState(() {
                      // _valName = _valName;
                      //_valFirstName = _valFirstName;
                      _isSignature = true;
                    });
                    Navigator.of(ctx).pop();
                  },
                  padding:
                      EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
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
              Container(
                margin: EdgeInsets.only(left: 40.0, right: 40.0),
                width: double.infinity,
                child: RaisedButton(
                  elevation: 5.0,
                  onPressed: () {
                    setState(() => _controller.clear());
                  },
                  padding:
                      EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
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
              ),
              SizedBox(
                height: 20,
              ),
            ],
          )));
        });
  }

  // ignore: unused_element
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
      await Provider.of<TaxW4>(context, listen: false)
          .saveForm(_editedUser, user.id)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
        /* Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ViewProfileOblig2(user: this.widget.user,)),
          );*/
      });
    } catch (error) {}
  }

  @override
  Widget build(BuildContext context) {
    DateFormat format = DateFormat("yyyy-MM-dd");
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
      //  endDrawer: EndDrawer(),
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
                margin: EdgeInsets.only(left: 20, top: 5.0),
                child: Text('Declarar Formulario W4',
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
                      width: 130.0,
                      child: TextFormField(
                        initialValue: this.widget.user.first_name,
                        enabled: false,
                        decoration: InputDecoration(labelText: 'Nombre'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please provide a value.';
                          }
                          return null;
                        },
                      )),
                  Container(
                    width: 130.0,
                    child: TextFormField(
                      initialValue: this.widget.user.last_name,
                      enabled: false,
                      decoration: InputDecoration(labelText: 'Apellido'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value.';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              Container(
                  width: 130,
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: TextFormField(
                    initialValue: 'SSN Nº' + ' ' + this.widget.user.id_number,
                    decoration: InputDecoration(labelText: 'Nº SSN'),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_priceFocusNode);
                    },
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Email Invalido!';
                      }
                      return null;
                    },
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                      width: 130.0,
                      height: 72,
                      child: FormField(
                        builder: (state) {
                          return DropdownButton(
                            isExpanded: true,
                            iconEnabledColor: Hexcolor('EA6012'),
                            hint: Text('Seleccione Ciudad'),
                            underline: Container(
                              height: 1,
                              color: Colors.grey,
                            ),
                            items: _dropdownMenuItemsCI,
                            value: _selectedCity,
                            onChanged: (value) => setState(() {
                              _selectedCity = value;
                              state.didChange(value);
                            }),
                          );
                        },
                      )),
                  Container(
                    width: 130.0,
                    child: TextFormField(
                      initialValue: this.widget.user.zip_code,
                      decoration: InputDecoration(labelText: 'Codigo Postal'),
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
                    ),
                  ),
                ],
              ),
              Container(
                width: 130,
                margin: EdgeInsets.only(left: 20),
                child: Text(
                  'Estado Civil',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ),
              Container(
                  width: 130,
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: FormField(
                      builder: (state) {
                        return DropdownButton(
                          isExpanded: true,
                          iconEnabledColor: Hexcolor('EA6012'),
                          hint: Text('Seleccione'),
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
                          onChanged: (value) => setState(() {
                            _valEdo = value;
                            state.didChange(value);
                          }),
                        );
                      },
                      // ignore: missing_required_param
                      onSaved: (value) => _editedUser = W4(
                          marital_status: value,
                          declaration_date: _editedUser.declaration_date))),
              Container(
                  width: 130,
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: DateTimeField(
                    format: format,
                    initialValue: DateTime.now(),
                    decoration:
                        InputDecoration(labelText: 'Fecha de Declaraciòn'),
                    textInputAction: TextInputAction.next,
                    onShowPicker: (context, currentValue) {
                      return showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          initialDate: DateTime.now(),
                          lastDate: DateTime(2100));
                    },
                    onSaved: (value) {
                      // ignore: missing_required_param
                      _editedUser = W4(
                          marital_status: _editedUser.marital_status,
                          declaration_date: value);
                    },
                  )),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                padding: EdgeInsets.symmetric(vertical: 1.0),
                width: double.infinity,
                child: DropdownButton(
                  hint: Text("Firma con el dedo"),
                  underline: Container(
                    height: 1,
                    color: Colors.grey,
                  ),
                  isExpanded: true,
                  iconEnabledColor: Hexcolor('EA6012'),
                  value: _valAdd2,
                  items: _listAdd2.map((value) {
                    return DropdownMenuItem(
                      child: Text(value),
                      value: value,
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _valAdd2 =
                          value; //Untuk memberitahu _valFriends bahwa isi nya akan diubah sesuai dengan value yang kita pilih
                    });
                    _showInputSignature();
                  },
                ),
              ),
              SizedBox(height: 100),
              Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 19, right: 30),
                    width: 130,
                    height: 50.0,
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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Taxw9(user: this.widget.user)),
                        );
                      },
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      color: Hexcolor('009444'),
                      child: Text(
                        'Ir a W9',
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
