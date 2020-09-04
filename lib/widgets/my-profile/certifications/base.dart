import 'dart:io';
import 'package:intl/intl.dart' show DateFormat;
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:worker/model/certification_type.dart';
import '../../widgets.dart';
import '../../../providers/certifications.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../model/certification.dart';
import '../../global.dart';

class BaseCertification extends StatefulWidget {
  @override
  _BaseCertificationState createState() => _BaseCertificationState();
}

class _BaseCertificationState extends State<BaseCertification> {
  final _form = GlobalKey<FormState>();
  List<dynamic> types;

  // ignore: unused_field
  CertificationType _currentUser;

  var _mySelection;
  // ignore: non_constant_identifier_names
  String requires_issuance_date;
  // ignore: non_constant_identifier_names
  String requires_expiration_date;
  // ignore: non_constant_identifier_names
  String requires_file_upload;
  // ignore: non_constant_identifier_names
  String requires_frontal_img;
  // ignore: non_constant_identifier_names
  String requires_rear_img;
  // ignore: non_constant_identifier_names
  String requires_verification_url;
  // ignore: non_constant_identifier_names
  String requires_levels;
  String description;
  var type;
  File _pickedImage;
  File _pickedImage1;
  List _listAdd = ['Agregar Archivo'];
  String _valAdd;
  bool _isLoading = false;
  String nameFile;
  var _createCert = Certification(
    issuance_date: null,
    expiration_date: null,
    file_upload: null,
    frontal_img: null,
    rear_img: null,
    certification_level: '',
    verification_url: '',
  );

  final String url = ApiWebServer.API_GET_CERTIFICATION_TYPE;

  List data = List();

  getToken() async {
    SharedPreferences token = await SharedPreferences.getInstance();
    String stringValue = token.getString('stringValue');
    return stringValue;
  } //edited line

  Future<String> getSWData() async {
    String token = await getToken();
    var res = await http
        .get(Uri.encodeFull(url), headers: {"Authorization": "Token $token"});
    var resBody = json.decode(res.body);

    setState(() {
      data = resBody;
    });

    return "Sucess";
  }

  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  void _selectImage1(File pickedImage) {
    _pickedImage1 = pickedImage;
  }

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
  void _showInputImageFront() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return Scaffold(
              body: SingleChildScrollView(
                  child: Form(
                      child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              Container(
                margin: EdgeInsets.only(left: 40.0, right: 40.0),
                width: double.infinity,
                child: ImageInputFront(_selectImage),
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
          ))));
        });
  }

  // ignore: unused_element
  void _showInputImageRear() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return Scaffold(
              body: SingleChildScrollView(
                  child: Form(
                      child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              Container(
                margin: EdgeInsets.only(left: 40.0, right: 40.0),
                width: double.infinity,
                child: ImageInputRier(_selectImage1),
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
          ))));
        });
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
      Provider.of<Certifications>(context, listen: false)
          .createCertification(_createCert, _pickedImage, _pickedImage1, type)
          .then((response) {
        setState(() {
          _isLoading = false;
        });
        if (response == 201) {
          Navigator.push(
            context,
            // ignore: missing_required_param
            MaterialPageRoute(builder: (context) => CertifactionsPage()),
          );
        } else {
          _showErrorDialog(response.toString());
        }
      });
    } catch (error) {}
  }

  @override
  void initState() {
    this.getSWData();
    super.initState();
  }

  String validateUrl(String value) {
    Pattern pattern =
        r'^((?:.|\n)*?)((http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?)';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Valide el formato del url';
    else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    DateFormat format = DateFormat("yyyy-MM-dd");
    String _titleReg = 'Nueva certificación';
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                    top: 1.0, bottom: 10.0, right: 20.0, left: 20),
                child: Text(
                  _titleReg,
                  style: TextStyle(
                    fontSize: 23,
                    color: Hexcolor('EA6012'),
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: DropdownButton(
                    iconEnabledColor: Hexcolor('EA6012'),
                    isExpanded: true,
                    items: data.map((item) {
                      return new DropdownMenuItem(
                          child: new Text(item['name']), value: item);
                    }).toList(),
                    onChanged: (newVal) {
                      setState(() {
                        _mySelection = newVal;
                        Map<String, dynamic> dataType = newVal;
                        requires_issuance_date =
                            dataType['requires_issuance_date'];
                        requires_expiration_date =
                            dataType['requires_expiration_date'];
                        requires_file_upload = dataType['requires_file_upload'];
                        requires_frontal_img = dataType['requires_frontal_img'];
                        requires_rear_img = dataType['requires_rear_img'];
                        requires_verification_url =
                            dataType['requires_verification_url'];
                        requires_levels = dataType['requires_levels'];
                        description = dataType['description'];
                        type = dataType['id'];
                      });
                    },
                    hint: Text('Tipo de certificaciòn'),
                    value: _mySelection,
                  )),
              if (description != null) ...[
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: Text(description),
                )
              ],
              if (requires_issuance_date == 'RE') ...[
                Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: DateTimeField(
                      format: format,
                      decoration:
                          InputDecoration(labelText: 'Fecha de Emisiòn'),
                      onShowPicker: (context, currentValue) {
                        return showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            initialDate: currentValue ?? DateTime(2002),
                            lastDate: DateTime(2002));
                      },
                      onSaved: (value) {
                        _createCert = Certification(
                          issuance_date: value,
                          expiration_date: _createCert.expiration_date,
                          file_upload: null,
                          frontal_img:
                              _pickedImage != null ? _pickedImage : null,
                          rear_img:
                              _pickedImage1 != null ? _pickedImage1 : null,
                        );
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Es obligatorio!';
                        }
                        return null;
                      },
                    ))
              ],
              if (requires_issuance_date == 'OP') ...[
                Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: DateTimeField(
                      format: format,
                      decoration:
                          InputDecoration(labelText: 'Fecha de Emisiòn'),
                      onShowPicker: (context, currentValue) {
                        return showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            initialDate: currentValue ?? DateTime(2002),
                            lastDate: DateTime(2002));
                      },
                      onSaved: (value) {
                        _createCert = Certification(
                          issuance_date: value,
                          expiration_date: _createCert.expiration_date,
                          file_upload: null,
                          frontal_img:
                              _pickedImage != null ? _pickedImage : null,
                          rear_img:
                              _pickedImage1 != null ? _pickedImage1 : null,
                        );
                      },
                    ))
              ],
              if (requires_expiration_date == 'RE') ...[
                Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: DateTimeField(
                        format: format,
                        decoration:
                            InputDecoration(labelText: 'Fecha de Expiraciòn'),
                        onShowPicker: (context, currentValue) {
                          return showDatePicker(
                              context: context,
                              firstDate: DateTime(1900),
                              initialDate: currentValue ?? DateTime(2002),
                              lastDate: DateTime(2002));
                        },
                        onSaved: (value) {
                          _createCert = Certification(
                            issuance_date: _createCert.issuance_date,
                            expiration_date: value,
                            file_upload: null,
                            frontal_img:
                                _pickedImage != null ? _pickedImage : null,
                            rear_img:
                                _pickedImage1 != null ? _pickedImage1 : null,
                          );
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Es obligatorio!';
                          }
                          return null;
                        }))
              ],
              if (requires_expiration_date == 'OP') ...[
                Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: DateTimeField(
                      format: format,
                      decoration:
                          InputDecoration(labelText: 'Fecha de Expiraciòn'),
                      onShowPicker: (context, currentValue) {
                        return showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            initialDate: currentValue ?? DateTime(2002),
                            lastDate: DateTime(2002));
                      },
                      onSaved: (value) {
                        _createCert = Certification(
                          issuance_date: _createCert.issuance_date,
                          expiration_date: value,
                          file_upload: null,
                          frontal_img:
                              _pickedImage != null ? _pickedImage : null,
                          rear_img:
                              _pickedImage1 != null ? _pickedImage1 : null,
                        );
                      },
                    ))
              ],
              if (requires_frontal_img == 'RE') ...[
                Container(
                  margin: EdgeInsets.only(left: 20.0, right: 20.0),
                  width: double.infinity,
                  child: ImageInputFront(_selectImage),
                ),
              ],
              if (requires_frontal_img == 'OP') ...[
                Container(
                  margin: EdgeInsets.only(left: 20.0, right: 20.0),
                  width: double.infinity,
                  child: ImageInputFront(_selectImage),
                ),
              ],
              if (requires_rear_img == 'RE') ...[
                Container(
                  margin: EdgeInsets.only(left: 20.0, right: 20.0),
                  width: double.infinity,
                  child: ImageInputRier(_selectImage1),
                ),
              ],
              if (requires_rear_img == 'OP') ...[
                Container(
                  margin: EdgeInsets.only(left: 20.0, right: 20.0),
                  width: double.infinity,
                  child: ImageInputRier(_selectImage1),
                ),
              ],
              if (requires_file_upload == 'RE') ...[
                Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: DropdownButton(
                      hint: Text("Archivo de CV"),
                      underline: Container(
                        height: 1,
                        color: Colors.grey,
                      ),
                      isExpanded: true,
                      iconEnabledColor: Hexcolor('EA6012'),
                      value: _valAdd,
                      items: _listAdd.map((value) {
                        return DropdownMenuItem(
                          child: Text(value),
                          value: value,
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _valAdd =
                              value; //Untuk memberitahu _valFriends bahwa isi nya akan diubah sesuai dengan value yang kita pilih
                        });
                        // _showUploadCV();
                      },
                    ))
              ],
              if (requires_file_upload == 'OP') ...[
                Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: DropdownButton(
                      hint: Text("Archivo de CV"),
                      underline: Container(
                        height: 1,
                        color: Colors.grey,
                      ),
                      isExpanded: true,
                      iconEnabledColor: Hexcolor('EA6012'),
                      value: _valAdd,
                      items: _listAdd.map((value) {
                        return DropdownMenuItem(
                          child: Text(value),
                          value: value,
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _valAdd =
                              value; //Untuk memberitahu _valFriends bahwa isi nya akan diubah sesuai dengan value yang kita pilih
                        });
                        // _showUploadCV();
                      },
                    ))
              ],
              if (requires_verification_url == 'RE') ...[
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: TextFormField(
                    initialValue: '',
                    textCapitalization: TextCapitalization.sentences,
                    decoration:
                        InputDecoration(labelText: 'Url de verificación'),
                    textInputAction: TextInputAction.next,
                    // validator: validateUrl,
                    onSaved: (value) {
                      _createCert = Certification(
                          issuance_date: _createCert.issuance_date,
                          expiration_date: _createCert.expiration_date,
                          file_upload: null,
                          frontal_img:
                              _pickedImage != null ? _pickedImage : null,
                          rear_img:
                              _pickedImage1 != null ? _pickedImage1 : null,
                          verification_url: value);
                    },
                  ),
                )
              ],
              if (requires_verification_url == 'OP') ...[
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: TextFormField(
                    initialValue: '',
                    textCapitalization: TextCapitalization.sentences,
                    decoration:
                        InputDecoration(labelText: 'Url de verificación'),
                    textInputAction: TextInputAction.next,
                    //validator: validateUrl,
                    onSaved: (value) {
                      _createCert = Certification(
                          issuance_date: _createCert.issuance_date,
                          expiration_date: _createCert.expiration_date,
                          file_upload: null,
                          frontal_img:
                              _pickedImage != null ? _pickedImage : null,
                          rear_img:
                              _pickedImage1 != null ? _pickedImage1 : null,
                          verification_url: value);
                    },
                  ),
                )
              ],
              SizedBox(
                height: 130,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    width: 130,
                    height: 50.0,
                    child: RaisedButton(
                      elevation: 5.0,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              // ignore: missing_required_param
                              builder: (context) => CertifactionsPage()),
                        );
                      },
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 15, bottom: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      color: Hexcolor('EA6012'),
                      child: Text(
                        'Ir Atras',
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
                    child: _isLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Container(
                            child: RaisedButton(
                            elevation: 5.0,
                            onPressed: _saveForm,
                            //padding: EdgeInsets.only(left: 25, right: 25,top: 15, bottom: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            color: Colors.green[700],
                            child: Text(
                              'Guardar',
                              style: TextStyle(
                                color: Colors.white,
                                letterSpacing: 1,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'OpenSans',
                              ),
                            ),
                          )),
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
