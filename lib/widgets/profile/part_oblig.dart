import 'dart:io';
import 'package:worker/widgets/profile/verify_address.dart';
import 'package:worker/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:percent_indicator/percent_indicator.dart';

import '../../model/user.dart';
import '../../model/country.dart';
import '../../model/states.dart';
import '../../model/city.dart';
import '../../providers/auth.dart';
import '../widgets.dart';

class ProfilePartOblig extends StatefulWidget {
  static const routeName = '/add-profile';

  @override
  _ProfilePartObligState createState() => _ProfilePartObligState();
}

abstract class ListItem {}

class HeadingItem implements ListItem {
  final String heading;

  HeadingItem(this.heading);
}

// Un ListItem que contiene datos para mostrar un mensaje
class MessageItem implements ListItem {
  final String sender;
  final String body;

  MessageItem(this.sender, this.body);
}

class _ProfilePartObligState extends State<ProfilePartOblig> {
  // LIST COUNTRYS
  List<Country> _countrys = Country.getCountrys();
  List<DropdownMenuItem<Country>> _dropdownMenuItemsC;
  Country _selectedCountry;

  // LIST STATES
  List<States> _states = States.getStates();
  List<DropdownMenuItem<States>> _dropdownMenuItemsS;
  States _selectedState;

  // LIST CITYS
  List<City> _citys = City.getCitys();
  List<DropdownMenuItem<City>> _dropdownMenuItemsCI;
  City _selectedCity;

  // MASK SSN - ITIN
  var maskTextInputFormatter = MaskTextInputFormatter(
      mask: "###-##-####", filter: {"#": RegExp(r'[0-9]')});
  var maskTextInputFormatterItin = MaskTextInputFormatter(
      mask: "9##-##-####", filter: {"#": RegExp(r'[0-9]')});
  var maskTextInputFormatterID = MaskTextInputFormatter(
      mask: "#########", filter: {"#": RegExp(r'[0-9]')});
  var _isLoading = false;

  // ignore: unused_field
  String _valCountry;
  // ignore: unused_field
  String _valState;
  // ignore: unused_field
  String _valCity;
  String success;
  String _valAmerican;
  String _valDoc;
  String _valDocsSheet;
  String _valDociSheet;
  String _valDocnSheet;
  String _valDocI;
  String _valDocN;
  DateTime _valExpire;
  DateTime _valExpireN;
  String add1;
  String add2;
  double maxtop;
  double maxwidth;
  // ignore: unused_field
  List _listCountry = ["EEUU", 'Mexico'];
  // ignore: unused_field
  List _listState = ['Florida', 'Houston'];
  // ignore: unused_field
  List _listCity = ['Manhattan', 'BeverlyHills'];
  List _listAmerican = ['Si', 'No'];
  // ignore: unused_field
  List _listDocs = ['SSN'];
  List _listDoc = ['SSN', 'ITIN'];
  List _listDocI = ['Licencia de Conducir', 'State ID', 'Pasaporte'];
  List _listDocN = [
    'Permiso de Trabajo',
    'Tarjeta de Residencia',
    'Comprobante de Solicitud de documento'
  ];

  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  final _form1 = GlobalKey<FormState>();
  final _form2 = GlobalKey<FormState>();
  final _form3 = GlobalKey<FormState>();
  File _pickedImage;
  File _pickedImageF;
  File _pickedImageR;

  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  void _selectImageF(File pickedImageF) {
    _pickedImageF = pickedImageF;
  }

  void _selectImageR(File pickedImageR) {
    _pickedImageR = pickedImageR;
  }

  var _editedUser1 = User(
      country: null,
      city: null,
      state: null,
      address_1: '',
      address_2: '',
      is_us_citizen: null,
      id_type: '',
      doc_type: '',
      id_number: '',
      doc_number: '',
      doc_expire_date: null,
      doc_image: null,
      dependents_number: null,
      marital_status: null,
      contact_first_name: '',
      contact_last_name: '',
      contact_phone: '',
      contact_email: '',
      signature: null,
      phone_number: '',
      blood_type: null,
      rh_factor: null,
      zip_code: '',
      uscis_number: '',
      doc_type_no: '',
      front_image_no: null,
      rear_image_no: null,
      i94_form_image: null,
      expiration_date_no: null);
  var _initValuesU = {
    'country': '',
    'state': '',
    'city': '',
    'address_1': '',
    'address_2': '',
    'is_us_citizen': '',
    'id_type': '',
    'doc_type': '',
    'id_number': '',
    'doc_number': '',
    'doc_image': '',
    'doc_expire_date': '',
    'dependents_number': '',
    'marital_status': '',
    'contact_first_name': '',
    'contact_last_name': '',
    'contact_phone': '',
    'contact_email': '',
    'signature': '',
    'phone_number': '',
    'blod_type': '',
    'rh_factor': '',
    'zip_code': ''
  };

  // ignore: unused_field
  var _isInit = true;
  // ignore: unused_field
  String _myActivity;
  String _myActivityCountry;
  String _myActivityState;
  String _myActivityCity;
  String _myActivityAmerican;
  String _myActivityDoc;
  String _myActivityDocI;
  // ignore: unused_field
  String _myActivityResult;
  // ignore: unused_field
  bool _isButtonDisabled;
  // ignore: non_constant_identifier_names
  bool addres1_verify = false;
  // ignore: non_constant_identifier_names
  bool addres2_verify = false;

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

  // ignore: unused_element
  void _showVerifyAddress(add1, add2) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Encontramos estas direcciones según la información que colocaste. Por favor, escoge tu dirección:',
          textAlign: TextAlign.justify,
        ),
        content: VerifyAddress(
          add1: add1,
          add2: add2,
        ),
        titleTextStyle: TextStyle(
            color: Hexcolor('373737'),
            fontFamily: 'OpenSansRegular',
            fontWeight: FontWeight.bold,
            fontSize: 20),
        /*
            
             */
        actions: <Widget>[
          FlatButton(
            child: Text('Actualizar y Seguir'),
            textColor: Hexcolor('EA6012'),
            onPressed: () {
              Provider.of<Auth>(context, listen: false).updateAddress(add1);
              Navigator.of(context, rootNavigator: true).pop('/add-profile2');
              Navigator.of(context).pushReplacementNamed('/add-profile2');
            },
          ),
          FlatButton(
            child: Text('Seguir'),
            textColor: Hexcolor('EA6012'),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop('/add-profile2');
              Navigator.of(context).pushReplacementNamed('/add-profile2');
            },
          )
        ],
      ),
    );
  }

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
                              _editedUser1 = User(
                                  country: _selectedCountry.id,
                                  state: _selectedState.id,
                                  city: _selectedCity.id,
                                  zip_code: _editedUser1.zip_code,
                                  phone_number: _editedUser1.phone_number,
                                  address_1: _editedUser1.address_1,
                                  address_2: _editedUser1.address_2,
                                  is_us_citizen: true,
                                  id_type: _valDoc,
                                  id_number: _valDocsSheet,
                                  doc_type: _valDocI,
                                  doc_number: _valDociSheet,
                                  doc_expire_date:
                                      _editedUser1.doc_expire_date);
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
                              _editedUser1 = User(
                                  country: _selectedCountry.id,
                                  state: _selectedState.id,
                                  city: _selectedCity.id,
                                  zip_code: _editedUser1.zip_code,
                                  phone_number: _editedUser1.phone_number,
                                  address_1: _editedUser1.address_1,
                                  address_2: _editedUser1.address_2,
                                  is_us_citizen: true,
                                  id_type: _valDoc,
                                  id_number: _valDocsSheet,
                                  doc_type: _valDocI,
                                  doc_number: _valDociSheet,
                                  doc_expire_date:
                                      _editedUser1.doc_expire_date);
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
                            child: Text('Numero de $title',
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
                                  if (value.isEmpty ||
                                      value.length < 8 ||
                                      value.length > 9) {
                                    return 'Verifique la longitud del valor!';
                                  }
                                },
                                onSaved: (value) {
                                  setState(() {
                                    _valDociSheet =
                                        value; //Untuk memberitahu _valFriends bahwa isi nya akan diubah sesuai dengan value yang kita pilih
                                  });
                                  _editedUser1 = User(
                                      country: _selectedCountry.id,
                                      state: _selectedState.id,
                                      city: _selectedCity.id,
                                      zip_code: _editedUser1.zip_code,
                                      phone_number: _editedUser1.phone_number,
                                      address_1: _editedUser1.address_1,
                                      address_2: _editedUser1.address_2,
                                      is_us_citizen: true,
                                      id_type: _valDoc,
                                      id_number: _valDocsSheet,
                                      doc_type: _valDocI,
                                      doc_number: _valDociSheet,
                                      doc_expire_date:
                                          _editedUser1.doc_expire_date);
                                },
                                onChanged: (value) {
                                  setState(() {
                                    _valDociSheet =
                                        value; //Untuk memberitahu _valFriends bahwa isi nya akan diubah sesuai dengan value yang kita pilih
                                  });
                                }),
                          ),
                          SizedBox(height: 10),
                          Text('Fecha de Vencimiento',
                              style: TextStyle(
                                  fontFamily: 'OpenSans',
                                  color: Hexcolor('EA6012'),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17.0),
                              textAlign: TextAlign.center),
                          Container(
                            margin: EdgeInsets.only(left: 40.0, right: 40.0),
                            width: double.infinity,
                            child: DateTimeField(
                                format: format,
                                //initialValue: DateTime.now(),
                                decoration: InputDecoration(
                                    hintText: 'XXXX/XX/XX',
                                    alignLabelWithHint: false),
                                textInputAction: TextInputAction.next,
                                onShowPicker: (context, currentValue) {
                                  return showDatePicker(
                                      context: context,
                                      firstDate: DateTime(2020),
                                      initialDate:
                                          currentValue ?? DateTime.now(),
                                      lastDate: DateTime(2100));
                                },
                                onSaved: (value) {
                                  setState(() {
                                    _valExpire = DateTime
                                        .now(); //Untuk memberitahu _valFriends bahwa isi nya akan diubah sesuai dengan value yang kita pilih
                                  });
                                  _editedUser1 = User(
                                      country: _selectedCountry.id,
                                      state: _selectedState.id,
                                      city: _selectedCity.id,
                                      zip_code: _editedUser1.zip_code,
                                      phone_number: _editedUser1.phone_number,
                                      address_1: _editedUser1.address_1,
                                      address_2: _editedUser1.address_2,
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
                            height: 10,
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
                                if (_form2.currentState.validate() &&
                                    _pickedImage != null) {
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

  void _showInputDialogIdentifyNo(String title) {
    DateFormat format = DateFormat("yyyy-MM-dd");
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return Form(
              key: _form3,
              child: SingleChildScrollView(
                  child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  SizedBox(
                    height: 60,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 40.0, right: 40.0),
                    width: double.infinity,
                    child: Text('Numero de $title',
                        style: TextStyle(
                            fontFamily: 'OpenSans',
                            color: Hexcolor('EA6012'),
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0),
                        textAlign: TextAlign.left),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 40.0, right: 40.0),
                    width: double.infinity,
                    child: TextFormField(
                        initialValue: _valDocnSheet,
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
                            _valDocnSheet =
                                value; //Untuk memberitahu _valFriends bahwa isi nya akan diubah sesuai dengan value yang kita pilih
                          });
                        },
                        onChanged: (value) {
                          setState(() {
                            _valDocnSheet =
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
                    child: DateTimeField(
                      initialValue: DateTime.now(),
                      format: format,
                      decoration: InputDecoration(
                          labelText: 'Fecha de Vencimiento',
                          labelStyle: TextStyle(
                            fontFamily: 'OpenSans',
                            color: Hexcolor('EA6012'),
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0,
                          ),
                          alignLabelWithHint: true),
                      textInputAction: TextInputAction.next,
                      textAlign: TextAlign.center,
                      onShowPicker: (context, currentValue) {
                        return showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            initialDate: currentValue ?? DateTime.now(),
                            lastDate: DateTime(2100));
                      },
                      onSaved: (value) {
                        setState(() {
                          _valExpireN =
                              value; //Untuk memberitahu _valFriends bahwa isi nya akan diubah sesuai dengan value yang kita pilih
                        });
                      },
                      onChanged: (value) {
                        setState(() {
                          _valExpireN =
                              value; //Untuk memberitahu _valFriends bahwa isi nya akan diubah sesuai dengan value yang kita pilih
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    margin:
                        EdgeInsets.only(left: 40.0, right: 40.0, bottom: 20),
                    width: double.infinity,
                    child: Text('Imagen Frontal',
                        style: TextStyle(
                            fontFamily: 'OpenSans',
                            color: Hexcolor('EA6012'),
                            fontWeight: FontWeight.bold,
                            fontSize: 13.0),
                        textAlign: TextAlign.left),
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(
                          left: 40.0,
                          right: 10.0,
                        ),
                        width: 250,
                        height: 100,
                        decoration: BoxDecoration(
                            border:
                                Border.all(width: 1, color: Hexcolor('EA6012')),
                            borderRadius: BorderRadius.circular(5)),
                        child: _pickedImageF != null
                            ? Image.file(
                                _pickedImageF,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              )
                            : Text(
                                'No hay Imagen',
                                textAlign: TextAlign.center,
                              ),
                        alignment: Alignment.center,
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            width: 95,
                            child: ImageInputFrontCamera(_selectImageF),
                          ),
                          Container(
                            width: 95,
                            child: ImageInputFrontGallery(_selectImageF),
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 40.0, right: 40.0),
                    width: double.infinity,
                    child: Text('Imagen Trasera',
                        style: TextStyle(
                            fontFamily: 'OpenSans',
                            color: Hexcolor('EA6012'),
                            fontWeight: FontWeight.bold,
                            fontSize: 13.0),
                        textAlign: TextAlign.left),
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(
                          left: 40.0,
                          right: 10.0,
                        ),
                        width: 250,
                        height: 100,
                        decoration: BoxDecoration(
                            border:
                                Border.all(width: 1, color: Hexcolor('EA6012')),
                            borderRadius: BorderRadius.circular(5)),
                        child: _pickedImageR != null
                            ? Image.file(
                                _pickedImageR,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              )
                            : Text(
                                'No hay Imagen',
                                textAlign: TextAlign.center,
                              ),
                        alignment: Alignment.center,
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            width: 95,
                            child: ImageInputRierCamera(_selectImageR),
                          ),
                          Container(
                            width: 95,
                            child: ImageInputRierGallery(_selectImageR),
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 40.0, right: 40.0),
                    width: double.infinity,
                    child: RaisedButton(
                      elevation: 5.0,
                      onPressed: () {
                        Navigator.of(ctx).pop();
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
              )));
        });
  }

  void _showInputDialogI94(String title) {
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: 60,
              ),
              Container(
                margin: EdgeInsets.only(left: 40.0, right: 40.0),
                width: double.infinity,
                child: OutlineButton.icon(
                  padding: EdgeInsets.all(20),
                  borderSide: BorderSide(color: Hexcolor('EA6012')),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpUI()),
                    );
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  label: Text(
                    'Foto del Formulario I94',
                    style: TextStyle(
                      color: Hexcolor('EA6012'),
                      letterSpacing: 1.5,
                      fontSize: 17.0,
                      fontFamily: 'OpenSans-Regular',
                    ),
                  ),
                  icon: Icon(Icons.image, color: Hexcolor('EA6012')),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                margin: EdgeInsets.only(left: 40.0, right: 40.0),
                width: double.infinity,
                child: RaisedButton(
                  elevation: 5.0,
                  onPressed: () {
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
              SizedBox(
                height: 20,
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    _myActivityCountry = '';
    _myActivityState = '';
    _myActivityCity = '';
    _myActivityAmerican = '';
    _myActivityDoc = '';
    _myActivityDocI = '';
    _myActivityResult = '';
    _dropdownMenuItemsC = buildDropdownMenuItems(_countrys);
    _selectedCountry = _dropdownMenuItemsC[0].value;
    _dropdownMenuItemsS = buildDropdownMenuItemsS(_states);
    _selectedState = _dropdownMenuItemsS[0].value;
    _dropdownMenuItemsCI = buildDropdownMenuItemsC(_citys);
    _selectedCity = _dropdownMenuItemsCI[0].value;
    addres1_verify = false;
    super.initState();
  }

  // ITEMS DROPDOWN COUNTRY

  List<DropdownMenuItem<Country>> buildDropdownMenuItems(List countrys) {
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

  // ITEMS DROPDOWN STATE

  List<DropdownMenuItem<States>> buildDropdownMenuItemsS(List states) {
    List<DropdownMenuItem<States>> items = List();
    for (States state in states) {
      items.add(
        DropdownMenuItem(
          value: state,
          child: Text(state.name),
        ),
      );
    }
    return items;
  }

  // ITEMS DROPDOWN CITY

  List<DropdownMenuItem<City>> buildDropdownMenuItemsC(List citys) {
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

  onChangeDropdownItem() {
    setState(() {
      _myActivityResult = _myActivityCountry;
      _myActivityResult = _myActivityState;
      _myActivityResult = _myActivityCity;
      _myActivityResult = _myActivityAmerican;
      _myActivityResult = _myActivityDoc;
      _myActivityResult = _myActivityDocI;
    });
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
    // ignore: unused_local_variable
    var _responsePost;
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      Provider.of<Auth>(context, listen: false)
          .uploadFile(_editedUser1, _pickedImage, _pickedImageF, _pickedImageR)
          .then((response) {
        setState(() {
          _isLoading = false;
          // _responsePost = response;
        });
        //print(_responsePost['data'][0]['components']);
        Navigator.of(context).pushReplacementNamed('/add-profile2');

        /* if (_responsePost['data'][0]['components']['city_name'] != null) {
          if (_responsePost['data'].length > 1) {
            add1 = _responsePost['data'][0]['last_line'];
            add2 = _responsePost['data'][1]['last_line'];
            _showVerifyAddress(add1, add2);
          } else {
            add1 = _responsePost['data'][0]['last_line'];
            add2 = 'no-data';
            _showVerifyAddress(add1, add2);
          }
        } else {
          Navigator.of(context).pushReplacementNamed('/add-profile2');
        }*/
      });
      success = '1';
    } catch (error) {
      success = '0';
    }
    if (success == '1') {
      /* Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfilePartOblig2()),
          );*/
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfilePartOblig()),
      );
      String error = 'Favor valide sus datos';
      _showErrorDialog(error);
    }
  }

  // ignore: unused_element
  Future<void> _updateAddress() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      // _isLoading = true;
    });
    try {
      Provider.of<Auth>(context, listen: false)
          .updateAddress(add1)
          .then((response) {
        Navigator.of(context).pushReplacementNamed('/add-profile2');
      });
    } catch (error) {
      success = '0';
    }
    if (success == '1') {
      /* Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfilePartOblig2()),
          );*/
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    String _titleReg = 'Datos básicos obligatorios';
    SizeConfig().init(context);
    var screenSize = MediaQuery.of(context).size;
    if (screenSize.height > 800) {
      maxtop = 168;
      maxwidth = 380;
    } else {
      maxwidth = 300;
      maxtop = 130;
    }
    return Scaffold(
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
                        width: maxwidth,
                        animation: true,
                        animationDuration: 1000,
                        lineHeight: 10.0,
                        percent: 0.1,
                        //center: Text("20.0%"),
                        linearStrokeCap: LinearStrokeCap.butt,
                        progressColor: Hexcolor('233062')),
                  )),
              Container(
                margin: EdgeInsets.only(left: 20, top: 20.0),
                child: Text(_titleReg,
                    style: TextStyle(
                        color: Hexcolor('9c9c9c'),
                        fontFamily: 'OpenSans-Regular',
                        fontSize: 19,
                        fontWeight: FontWeight.bold)),
              ),
              Container(
                margin: EdgeInsets.only(left: 20.0, right: 20),
                child: TextFormField(
                  initialValue: _initValuesU['address_1'],
                  decoration: InputDecoration(labelText: 'Dirección'),
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
                    _editedUser1 = User(
                        country: _selectedCountry.id,
                        state: _selectedState.id,
                        city: _selectedCity.id,
                        zip_code: _editedUser1.zip_code,
                        phone_number: _editedUser1.phone_number,
                        address_1: value,
                        address_2: _editedUser1.address_2,
                        is_us_citizen: true,
                        id_type: _valDoc,
                        id_number: _valDocsSheet,
                        doc_type: _valDocI,
                        doc_number: _valDociSheet,
                        doc_expire_date: _valExpire,
                        doc_image: _pickedImage,
                        front_image_no: _pickedImageF,
                        rear_image_no: _pickedImageR,
                        doc_type_no: _valDocN,
                        expiration_date_no: _valExpireN,
                        uscis_number: _valDocnSheet);
                  },
                ),
              ),
              Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: TextFormField(
                    initialValue: _initValuesU['address_2'],
                    decoration:
                        InputDecoration(labelText: 'Casa o Apartamento'),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_priceFocusNode);
                    },
                    onSaved: (value) {
                      _editedUser1 = User(
                          country: _selectedCountry.id,
                          state: _selectedState.id,
                          city: _selectedCity.id,
                          zip_code: _editedUser1.zip_code,
                          phone_number: _editedUser1.phone_number,
                          address_1: _editedUser1.address_1,
                          address_2: value,
                          is_us_citizen: true,
                          id_type: _valDoc,
                          id_number: _valDocsSheet,
                          doc_type: _valDocI,
                          doc_number: _valDociSheet,
                          doc_expire_date: _valExpire,
                          doc_image: _pickedImage,
                          front_image_no: _pickedImageF,
                          rear_image_no: _pickedImageR,
                          doc_type_no: _valDocN,
                          expiration_date_no: _valExpireN,
                          uscis_number: _valDocnSheet);
                    },
                  )),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    width: maxtop,
                    child: Column(
                      children: <Widget>[
                        Container(
                          /* margin: EdgeInsets.only(
                            left: 10,
                          ),*/
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Seleccione Pais',
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 12),
                            ),
                          ),
                        ),
                        FormField(
                          builder: (state) {
                            return DropdownButton(
                              isExpanded: true,
                              iconEnabledColor: Hexcolor('EA6012'),
                              hint: Text('Seleccione'),
                              underline: Container(
                                height: 1,
                                color: Colors.grey,
                              ),
                              items: _dropdownMenuItemsC,
                              value: _selectedCountry,
                              onChanged: (value) => setState(() {
                                _selectedCountry = value;
                                state.didChange(value);
                              }),
                            );
                          },
                          onSaved: (value) => _editedUser1 = User(
                              country: _selectedCountry.id,
                              state: _selectedState.id,
                              city: _selectedCity.id,
                              zip_code: _editedUser1.zip_code,
                              phone_number: _editedUser1.phone_number,
                              address_1: _editedUser1.address_1,
                              address_2: _editedUser1.address_2,
                              is_us_citizen: true,
                              id_type: _valDoc,
                              id_number: _valDocsSheet,
                              doc_type: _valDocI,
                              doc_number: _valDociSheet,
                              doc_expire_date: _valExpire,
                              doc_image: _pickedImage,
                              front_image_no: _pickedImageF,
                              rear_image_no: _pickedImageR,
                              doc_type_no: _valDocN,
                              expiration_date_no: _valExpireN,
                              uscis_number: _valDocnSheet),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: maxtop,
                    child: Column(
                      children: <Widget>[
                        Container(
                          /* margin: EdgeInsets.only(
                            left: 10,
                          ),*/
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Seleccione Estado',
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 12),
                            ),
                          ),
                        ),
                        FormField(
                          builder: (state) {
                            return DropdownButton(
                              isExpanded: true,
                              iconEnabledColor: Hexcolor('EA6012'),
                              hint: Text('Seleccione'),
                              underline: Container(
                                height: 1,
                                color: Colors.grey,
                              ),
                              items: _dropdownMenuItemsS,
                              value: _selectedState,
                              onChanged: (value) => setState(() {
                                _selectedState = value;
                                state.didChange(value);
                              }),
                            );
                          },
                          onSaved: (value) => _editedUser1 = User(
                              country: _selectedCountry.id,
                              state: _selectedState.id,
                              city: _selectedCity.id,
                              zip_code: _editedUser1.zip_code,
                              phone_number: _editedUser1.phone_number,
                              address_1: _editedUser1.address_1,
                              address_2: _editedUser1.address_2,
                              is_us_citizen: true,
                              id_type: _valDoc,
                              id_number: _valDocsSheet,
                              doc_type: _valDocI,
                              doc_number: _valDociSheet,
                              doc_expire_date: _valExpire,
                              doc_image: _pickedImage,
                              front_image_no: _pickedImageF,
                              rear_image_no: _pickedImageR,
                              doc_type_no: _valDocN,
                              expiration_date_no: _valExpireN,
                              uscis_number: _valDocnSheet),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                      width: maxtop,
                      child: Column(
                        children: <Widget>[
                          Container(
                            /* margin: EdgeInsets.only(
                            left: 10,
                          ),*/
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Seleccione Ciudad',
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 12),
                              ),
                            ),
                          ),
                          FormField(
                            builder: (state) {
                              return DropdownButton(
                                isExpanded: true,
                                iconEnabledColor: Hexcolor('EA6012'),
                                hint: Text('Seleccione'),
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
                            onSaved: (value) => _editedUser1 = User(
                                country: _selectedCountry.id,
                                state: _selectedState.id,
                                city: _selectedCity.id,
                                zip_code: _editedUser1.zip_code,
                                phone_number: _editedUser1.phone_number,
                                address_1: _editedUser1.address_1,
                                address_2: _editedUser1.address_2,
                                is_us_citizen: true,
                                id_type: _valDoc,
                                id_number: _valDocsSheet,
                                doc_type: _valDocI,
                                doc_number: _valDociSheet,
                                doc_expire_date: _editedUser1.doc_expire_date,
                                doc_image: _pickedImage,
                                front_image_no: _pickedImageF,
                                rear_image_no: _pickedImageR,
                                doc_type_no: _valDocN,
                                expiration_date_no: _valExpireN,
                                uscis_number: _valDocnSheet),
                          ),
                        ],
                      )),
                  Container(
                    width: maxtop,
                    height: 75,
                    child: TextFormField(
                      initialValue: _initValuesU['zip_code'],
                      decoration: InputDecoration(labelText: 'Código Postal'),
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
                        _editedUser1 = User(
                            country: _selectedCountry.id,
                            state: _selectedState.id,
                            city: _selectedCity.id,
                            zip_code: value,
                            phone_number: _editedUser1.phone_number,
                            address_1: _editedUser1.address_1,
                            address_2: _editedUser1.address_2,
                            is_us_citizen: true,
                            id_type: _valDoc,
                            id_number: _valDocsSheet,
                            doc_type: _valDocI,
                            doc_number: _valDociSheet,
                            doc_expire_date: _valExpire,
                            doc_image: _pickedImage,
                            front_image_no: _pickedImageF,
                            rear_image_no: _pickedImageR,
                            doc_type_no: _valDocN,
                            expiration_date_no: _valExpireN,
                            uscis_number: _valDocnSheet);
                      },
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(left: 20.0, right: 20),
                padding: EdgeInsets.symmetric(vertical: 1.0),
                width: double.infinity,
                child: TextFormField(
                  initialValue: _initValuesU['phone_number'],
                  decoration: InputDecoration(labelText: 'Teléfono'),
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
                    _editedUser1 = User(
                        country: _selectedCountry.id,
                        state: _selectedState.id,
                        city: _selectedCity.id,
                        zip_code: _editedUser1.zip_code,
                        phone_number: value,
                        address_1: _editedUser1.address_1,
                        address_2: _editedUser1.address_2,
                        is_us_citizen: true,
                        id_type: _valDoc,
                        id_number: _valDocsSheet,
                        doc_type: _valDocI,
                        doc_number: _valDociSheet,
                        doc_expire_date: _valExpire,
                        doc_image: _pickedImage,
                        front_image_no: _pickedImageF,
                        rear_image_no: _pickedImageR,
                        doc_type_no: _valDocN,
                        expiration_date_no: _valExpireN,
                        uscis_number: _valDocnSheet);
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                child: Text(
                  'Eres ciudadano/a Estadounidense?',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 5.0),
                width: double.infinity,
                child: DropdownButton(
                  hint: Text("Seleccione"),
                  underline: Container(
                    height: 1,
                    color: Colors.grey,
                  ),
                  isExpanded: true,
                  iconEnabledColor: Hexcolor('EA6012'),
                  value: _valAmerican,
                  items: _listAmerican.map((value) {
                    return DropdownMenuItem(
                      child: Text(value),
                      value: value,
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _valAmerican =
                          value; //Untuk memberitahu _valFriends bahwa isi nya akan diubah sesuai dengan value yang kita pilih
                    });
                    _editedUser1 = User(
                        country: _selectedCountry.id,
                        state: _selectedState.id,
                        city: _selectedCity.id,
                        zip_code: _editedUser1.zip_code,
                        phone_number: _editedUser1.phone_number,
                        address_1: _editedUser1.address_1,
                        address_2: _editedUser1.address_2,
                        is_us_citizen: true,
                        id_type: _valDoc,
                        id_number: _valDocsSheet,
                        doc_type: _valDocI,
                        doc_number: _valDociSheet,
                        doc_expire_date: _valExpire,
                        doc_image: _pickedImage,
                        front_image_no: _pickedImageF,
                        rear_image_no: _pickedImageR,
                        doc_type_no: _valDocN,
                        expiration_date_no: _valExpireN,
                        uscis_number: _valDocnSheet);
                  },
                ),
              ),
              if (_valAmerican == 'Si') ...[
                Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: Text('¿Posee alguno de los siguientes documentos?',
                        style: TextStyle(
                            fontFamily: 'OpenSans',
                            color: Hexcolor('233062'),
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0),
                        textAlign: TextAlign.center)),
                Container(
                  margin: EdgeInsets.only(left: 20.0, right: 20),
                  child: TextFormField(
                      initialValue: _valDocsSheet,
                      inputFormatters: [maskTextInputFormatter],
                      decoration: InputDecoration(labelText: 'SSN'),
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
                        _editedUser1 = User(
                            country: _selectedCountry.id,
                            state: _selectedState.id,
                            city: _selectedCity.id,
                            zip_code: _editedUser1.zip_code,
                            phone_number: _editedUser1.phone_number,
                            address_1: value,
                            address_2: _editedUser1.address_2,
                            is_us_citizen: true,
                            id_type: _valDoc,
                            id_number: value,
                            doc_type: _valDocI,
                            doc_number: _valDociSheet,
                            doc_expire_date: _valExpire,
                            doc_image: _pickedImage,
                            front_image_no: _pickedImageF,
                            rear_image_no: _pickedImageR,
                            doc_type_no: _valDocN,
                            expiration_date_no: _valExpireN,
                            uscis_number: _valDocnSheet);
                      },
                      onChanged: (value) {
                        setState(() {
                          _valDocsSheet =
                              value; //Untuk memberitahu _valFriends bahwa isi nya akan diubah sesuai dengan value yang kita pilih
                        });
                      }),
                )
                /*Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: DropdownButton(
                        isExpanded: true,
                        iconEnabledColor: Hexcolor('EA6012'),
                        hint: Text("¿Tienes SSN o ITIN?"),
                        underline: Container(
                          height: 1,
                          color: Colors.grey,
                        ),
                        value: _valDoc,
                        items: _listDocs.map((value) {
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
                          _showInputDialog(_valDoc);
                          _editedUser1 = User(
                              country: _selectedCountry.id,
                              state: _selectedState.id,
                              city: _selectedCity.id,
                              zip_code: _editedUser1.zip_code,
                              phone_number: _editedUser1.phone_number,
                              address_1: _editedUser1.address_1,
                              address_2: _editedUser1.address_2,
                              is_us_citizen: true,
                              id_type: _valDoc,
                              id_number: _valDocsSheet,
                              doc_type: _valDocI,
                              doc_number: _valDociSheet,
                              doc_expire_date: _valExpire,
                              doc_image: _pickedImage);
                        },
                      ))*/
                ,
                /*  if (_valDocsSheet != null) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                          width: 130.0,
                          child: DropdownButton(
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
                            onChanged: (value) {
                              setState(() {
                                _valDoc = value;
                              });
                              _showInputDialog(_valDoc);
                              _editedUser1 = User(
                                  country: _selectedCountry.id,
                                  state: _selectedState.id,
                                  city: _selectedCity.id,
                                  zip_code: _editedUser1.zip_code,
                                  phone_number: _editedUser1.phone_number,
                                  address_1: _editedUser1.address_1,
                                  address_2: _editedUser1.address_2,
                                  is_us_citizen: true,
                                  id_type: _valDoc,
                                  id_number: _valDocsSheet,
                                  doc_type: _valDocI,
                                  doc_number: _valDociSheet,
                                  doc_expire_date: _valExpire,
                                  doc_image: _pickedImage);
                            },
                          )),
                      Container(
                        height: 67.0,
                        width: 130.0,
                        child: TextFormField(
                          // va: _valDocsSheet,
                          textAlign: TextAlign.left,
                          decoration: InputDecoration(
                              hintText: _valDocsSheet,
                              alignLabelWithHint: true,
                              hintStyle: TextStyle()),
                        ),
                      ),
                    ],
                  )
                ],*/
                if (_valDociSheet == null) ...[
                  Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: DropdownButton(
                        isExpanded: true,
                        iconEnabledColor: Hexcolor('EA6012'),
                        hint: Text("Seleccione documento de Identificación"),
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
                        onChanged: (value) {
                          setState(() {
                            _valDocI = value;
                            print(
                                _valDocI); //Untuk memberitahu _valFriends bahwa isi nya akan diubah sesuai dengan value yang kita pilih
                          });
                          _editedUser1 = User(
                              country: _selectedCountry.id,
                              state: _selectedState.id,
                              city: _selectedCity.id,
                              zip_code: _editedUser1.zip_code,
                              phone_number: _editedUser1.phone_number,
                              address_1: _editedUser1.address_1,
                              address_2: _editedUser1.address_2,
                              is_us_citizen: true,
                              id_type: _valDoc,
                              id_number: _valDocsSheet,
                              doc_type: _valDocI,
                              doc_number: _valDociSheet,
                              doc_expire_date: _valExpire,
                              doc_image: _pickedImage,
                              front_image_no: _pickedImageF,
                              rear_image_no: _pickedImageR,
                              doc_type_no: _valDocN,
                              expiration_date_no: _valExpireN,
                              uscis_number: _valDocnSheet);
                          _showInputDialogIdentify(_valDocI);
                        },
                      )),
                ],
                if (_valDociSheet != null) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                          width: 130.0,
                          child: DropdownButton(
                            isExpanded: true,
                            iconEnabledColor: Hexcolor('EA6012'),
                            hint:
                                Text("Seleccione documento de Identificación"),
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
                            onChanged: (value) {
                              setState(() {
                                _valDocI =
                                    value; //Untuk memberitahu _valFriends bahwa isi nya akan diubah sesuai dengan value yang kita pilih
                              });
                              _editedUser1 = User(
                                  country: _selectedCountry.id,
                                  state: _selectedState.id,
                                  city: _selectedCity.id,
                                  zip_code: _editedUser1.zip_code,
                                  phone_number: _editedUser1.phone_number,
                                  address_1: _editedUser1.address_1,
                                  address_2: _editedUser1.address_2,
                                  is_us_citizen: true,
                                  id_type: _valDoc,
                                  id_number: _valDocsSheet,
                                  doc_type: _valDocI,
                                  doc_number: _valDociSheet,
                                  doc_expire_date: _valExpire,
                                  doc_image: _pickedImage,
                                  front_image_no: _pickedImageF,
                                  rear_image_no: _pickedImageR,
                                  doc_type_no: _valDocN,
                                  expiration_date_no: _valExpireN,
                                  uscis_number: _valDocnSheet);
                              _showInputDialogIdentify(_valDocI);
                            },
                          )),
                      Container(
                        height: 67.0,
                        width: 130.0,
                        child: TextFormField(
                          // va: _valDocsSheet,
                          textAlign: TextAlign.left,
                          decoration: InputDecoration(
                              hintText: _valDociSheet,
                              alignLabelWithHint: true,
                              hintStyle: TextStyle()),
                        ),
                      ),
                    ],
                  )
                ],
              ],
              if (_valAmerican == 'No') ...[
                Text('¿Posee alguno de los siguientes documentos?',
                    style: TextStyle(
                        fontFamily: 'OpenSans',
                        color: Hexcolor('233062'),
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0),
                    textAlign: TextAlign.center),
                if (_valDoc == null) ...[
                  Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: DropdownButton(
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
                        onChanged: (value) {
                          setState(() {
                            _valDoc =
                                value; //Untuk memberitahu _valFriends bahwa isi nya akan diubah sesuai dengan value yang kita pilih
                          });
                          _showInputDialog(_valDoc);
                          _editedUser1 = User(
                              country: _selectedCountry.id,
                              state: _selectedState.id,
                              city: _selectedCity.id,
                              zip_code: _editedUser1.zip_code,
                              phone_number: _editedUser1.phone_number,
                              address_1: _editedUser1.address_1,
                              address_2: _editedUser1.address_2,
                              is_us_citizen: true,
                              id_type: _valDoc,
                              id_number: _valDocsSheet,
                              doc_type: _valDocI,
                              doc_number: _valDociSheet,
                              doc_expire_date: _valExpire,
                              doc_image: _pickedImage,
                              front_image_no: _pickedImageF,
                              rear_image_no: _pickedImageR,
                              doc_type_no: _valDocN,
                              expiration_date_no: _valExpireN,
                              uscis_number: _valDocnSheet);
                        },
                      ))
                ],
                if (_valDocsSheet != null) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                          width: maxtop,
                          child: DropdownButton(
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
                            onChanged: (value) {
                              setState(() {
                                _valDoc = value;
                              });
                              _showInputDialog(_valDoc);
                              _editedUser1 = User(
                                  country: _selectedCountry.id,
                                  state: _selectedState.id,
                                  city: _selectedCity.id,
                                  zip_code: _editedUser1.zip_code,
                                  phone_number: _editedUser1.phone_number,
                                  address_1: _editedUser1.address_1,
                                  address_2: _editedUser1.address_2,
                                  is_us_citizen: true,
                                  id_type: _valDoc,
                                  id_number: _valDocsSheet,
                                  doc_type: _valDocI,
                                  doc_number: _valDociSheet,
                                  doc_expire_date: _valExpire,
                                  doc_image: _pickedImage,
                                  front_image_no: _pickedImageF,
                                  rear_image_no: _pickedImageR,
                                  doc_type_no: _valDocN,
                                  expiration_date_no: _valExpireN,
                                  uscis_number: _valDocnSheet);
                            },
                          )),
                      Container(
                        height: 67.0,
                        width: maxtop,
                        child: TextFormField(
                          // va: _valDocsSheet,
                          textAlign: TextAlign.left,
                          decoration: InputDecoration(
                              hintText: _valDocsSheet,
                              alignLabelWithHint: true,
                              hintStyle: TextStyle()),
                        ),
                      ),
                    ],
                  )
                ],
                if (_valDocnSheet == null) ...[
                  if (_valDoc == 'SSN') ...[
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: DropdownButton(
                        isExpanded: true,
                        iconEnabledColor: Hexcolor('EA6012'),
                        hint: Text("Seleccione documento de Identificación"),
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
                        onChanged: (value) {
                          setState(() {
                            _valDocN =
                                value; //Untuk memberitahu _valFriends bahwa isi nya akan diubah sesuai dengan value yang kita pilih
                          });
                          if (_valDocN ==
                              'Comprobante de Solicitud de documento') {
                            _showInputDialogI94(_valDocN);
                          } else {
                            _showInputDialogIdentifyNo(_valDocN);
                          }
                        },
                      ),
                    )
                  ],
                  if (_valDoc == 'ITIN') ...[
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: DropdownButton(
                        isExpanded: true,
                        iconEnabledColor: Hexcolor('EA6012'),
                        hint: Text("Seleccione documento de Identificación"),
                        underline: Container(
                          height: 1,
                          color: Colors.grey,
                        ),
                        value: _valDocN,
                        items: _listDocN.map((value) {
                          return DropdownMenuItem(
                            child: Text(value),
                            value: value,
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _valDocN =
                                value; //Untuk memberitahu _valFriends bahwa isi nya akan diubah sesuai dengan value yang kita pilih
                          });
                          if (_valDocN ==
                              'Comprobante de Solicitud de documento') {
                            _showInputDialogI94(_valDocN);
                          } else {
                            _showInputDialogIdentifyNo(_valDocN);
                          }
                        },
                      ),
                    )
                  ]
                ],
                if (_valDocnSheet != null) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        height: 67.0,
                        width: 130.0,
                        child: TextFormField(
                          // va: _valDocsSheet,
                          textAlign: TextAlign.left,
                          decoration: InputDecoration(
                              hintText: _valDocI != null ? _valDocI : _valDocN,
                              alignLabelWithHint: true,
                              hintStyle: TextStyle()),
                        ),
                      ),
                      Container(
                        height: 67.0,
                        width: 130.0,
                        child: TextFormField(
                          // va: _valDocsSheet,
                          textAlign: TextAlign.left,
                          decoration: InputDecoration(
                              hintText: _valDocnSheet,
                              alignLabelWithHint: true,
                              hintStyle: TextStyle()),
                        ),
                      ),
                    ],
                  )
                  /* TextFormField(
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                        hintText: _valDocnSheet,
                        alignLabelWithHint: true,
                        hintStyle: TextStyle()),
                  )*/
                ]
              ],
              _isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container(
                      margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                      child: RaisedButton(
                        elevation: 5.0,
                        onPressed: () {
                          if (_form.currentState.validate()) {
                            _saveForm();
                          } else {
                            String error =
                                'Todos los campos en esta sección son obligatorios!';
                            _showErrorDialog(error);
                          }
                        },
                        padding: EdgeInsets.only(
                            left: 25, right: 25, top: 15, bottom: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        color: Colors.green[700],
                        child: Text(
                          'Siguiente',
                          style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 1,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'OpenSans',
                          ),
                        ),
                      )),
            ],
          ),
        ),
      ),
    );
  }
}
