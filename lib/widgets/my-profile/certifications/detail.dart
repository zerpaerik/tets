import 'dart:io';
import 'package:intl/intl.dart' show DateFormat;
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../widgets.dart';
import '../../../providers/certifications.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../../../model/certification.dart';

class DetailCertification extends StatefulWidget {
  final Certification cert;

  DetailCertification({this.cert});

  @override
  _DetailCertificationState createState() => _DetailCertificationState(cert);
}

class _DetailCertificationState extends State<DetailCertification> {
  Certification cert;
  _DetailCertificationState(this.cert);

  final _form = GlobalKey<FormState>();
  List<dynamic> types;

  var type;
  File _pickedImage;
  File _pickedImage1;
  bool _isLoading = false;
  String nameFile;
  var _editedCert = Certification(
    issuance_date: null,
    expiration_date: null,
    file_upload: null,
    frontal_img: null,
    rear_img: null,
    certification_level: '',
    verification_url: '',
  );

  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  void _selectImage1(File pickedImage) {
    _pickedImage1 = pickedImage;
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

  /* void _openFileExplorer() async {
   File file = await FilePicker.getFile();
   if (file == null) {
      return;
    }
    
   final appDir = await syspaths.getApplicationDocumentsDirectory();
   final fileName = path.basename(file.path);
   final savedImage = await file.copy('${appDir.path}/$fileName');
   setState(() {
      _storageCV = savedImage;
      nameFile = fileName;
    });
  
  }*/

  /* void _showUploadCV() {
    showModalBottomSheet(
      context: context, 
      builder: (ctx){
        return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height:60,),
              Container(
              margin: EdgeInsets.only(left:40.0, right: 40.0),
              width: double.infinity,
              child: OutlineButton.icon(
              padding: EdgeInsets.all(20),
              borderSide: BorderSide(color: Hexcolor('EA6012')),
              onPressed: _openFileExplorer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),        
              label: Text(
                'Adjunte el Archivo',
                  style: TextStyle(
                  color: Hexcolor('EA6012'),
                  letterSpacing: 1.5,
                  fontSize: 17.0,
                  fontFamily: 'OpenSans-Regular',
                ),
                
              ),
              icon: Icon(Icons.file_upload, color: Hexcolor('EA6012')), 
        ),
              ),
              SizedBox(height: 30,),
                Container(
              margin: EdgeInsets.only(left:40.0, right: 40.0),
              width: double.infinity,
              child: RaisedButton(
                  elevation: 5.0,
                  onPressed: () {
                    print(_storageCV);
                    Navigator.of(ctx).pop();
                    },
                  padding: EdgeInsets.only(left: 25, right: 25,top: 10, bottom: 10),
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
                SizedBox(height:20,),

            ],
         );
      });
  }*/

  /* Future<List<CertificationType>> _fetchType() async {
    var response = await http.get(url);

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<CertificationType> listOfUsers = items.map<CertificationType>((json) {
        return CertificationType.fromJson(json);
      }).toList();

      return listOfUsers;
    } else {
      throw Exception('Failed to load internet');
    }
  }*/
/*
  void _viewTypes(){
    Provider.of<Certifications>(context, listen: false).fetchType().then((value) {
       setState(() {
        types = value; 
        });
        print(types[0]);
     });
  }*/

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
      Provider.of<Certifications>(context, listen: false)
          .createCertification(_editedCert, _pickedImage, _pickedImage1, type)
          .then((response) {
        setState(() {
          _isLoading = false;
        });
      });
    } catch (error) {}
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(this.widget.cert.certification_type.requires_rear_img);
    DateFormat format = DateFormat("yyyy-MM-dd");
    String _titleReg =
        'Detalle de' + ' ' + this.widget.cert.certification_type.name;
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
                child: TextFormField(
                  initialValue: this.widget.cert.certification_type.name,
                  textCapitalization: TextCapitalization.sentences,
                  enabled: false,
                  decoration:
                      InputDecoration(labelText: 'Tipo de certificación'),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please provide a value.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _editedCert = Certification(
                        issuance_date: _editedCert.issuance_date,
                        expiration_date: _editedCert.expiration_date,
                        file_upload: null,
                        frontal_img: _pickedImage,
                        rear_img: _pickedImage1,
                        verification_url: value);
                  },
                ),
              ),
              if (this.widget.cert.issuance_date != null) ...[
                Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: DateTimeField(
                      format: format,
                      decoration:
                          InputDecoration(labelText: 'Fecha de Emisión'),
                      initialValue: this.widget.cert.issuance_date,
                      onShowPicker: (context, currentValue) {
                        return showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            initialDate: currentValue ?? DateTime(2002),
                            lastDate: DateTime(2020));
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Es obligatorio!';
                        }
                        return null;
                      },
                    ))
              ],
              if (this.widget.cert.expiration_date != null) ...[
                Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: DateTimeField(
                      format: format,
                      decoration:
                          InputDecoration(labelText: 'Fecha de Expiración'),
                      initialValue: this.widget.cert.expiration_date,
                      onShowPicker: (context, currentValue) {
                        return showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            initialDate: currentValue ?? DateTime(2002),
                            lastDate: DateTime(2020));
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Es obligatorio!';
                        }
                        return null;
                      },
                    ))
              ],
              if (this.widget.cert.frontal_img != null) ...[
                SizedBox(height: 10),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                          child: FlatButton(
                        onPressed: () {
                          {}
                        },
                        child: Text('Foto Frontal',
                            style: TextStyle(
                              fontFamily: 'OpenSans-Regular',
                              fontWeight: FontWeight.bold,
                              color: Hexcolor('EA6012'),
                              fontSize: 18.0,
                            )),
                      )),
                      Container(
                        width: 160,
                        height: 70,
                        decoration: BoxDecoration(
                            border:
                                Border.all(width: 1, color: Hexcolor('EA6012')),
                            borderRadius: BorderRadius.circular(5)),
                        child: this.widget.cert.frontal_img != null
                            ? Image.network(
                                this.widget.cert.frontal_img.path,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              )
                            : Text(
                                'No hay Imagen',
                                textAlign: TextAlign.center,
                              ),
                        alignment: Alignment.center,
                      )
                    ])
              ],
              if (this.widget.cert.rear_img != null) ...[
                SizedBox(height: 10),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                          child: FlatButton(
                        onPressed: () {
                          {}
                        },
                        child: Text('Foto Trasera',
                            style: TextStyle(
                              fontFamily: 'OpenSans-Regular',
                              fontWeight: FontWeight.bold,
                              color: Hexcolor('EA6012'),
                              fontSize: 18.0,
                            )),
                      )),
                      Container(
                        width: 160,
                        height: 70,
                        decoration: BoxDecoration(
                            border:
                                Border.all(width: 1, color: Hexcolor('EA6012')),
                            borderRadius: BorderRadius.circular(5)),
                        child: this.widget.cert.rear_img != null
                            ? Image.network(
                                this.widget.cert.rear_img.path,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              )
                            : Text(
                                'No hay Imagen',
                                textAlign: TextAlign.center,
                              ),
                        alignment: Alignment.center,
                      )
                    ])
              ],
              if (this.widget.cert.verification_url != '') ...[
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: TextFormField(
                    initialValue: this.widget.cert.verification_url,
                    textCapitalization: TextCapitalization.sentences,
                    decoration:
                        InputDecoration(labelText: 'Url de verificación'),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please provide a value.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _editedCert = Certification(
                          issuance_date: _editedCert.issuance_date,
                          expiration_date: _editedCert.expiration_date,
                          file_upload: null,
                          frontal_img: _pickedImage,
                          rear_img: _pickedImage1,
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
                            onPressed: null,
                            //padding: EdgeInsets.only(left: 25, right: 25,top: 15, bottom: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            color: Colors.green[700],
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
