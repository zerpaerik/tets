import 'package:worker/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multiselect/flutter_multiselect.dart';
//import 'package:file_picker/file_picker.dart';
import 'dart:io';

import '../../model/user.dart';
import '../../providers/auth.dart';
import '../widgets.dart';

class ProfileAdicAcade extends StatefulWidget {
  static const routeName = '/add-profile-adic-acad';

  @override
  _ProfileAdicAcadeState createState() => _ProfileAdicAcadeState();
}

class _ProfileAdicAcadeState extends State<ProfileAdicAcade> {
  String _valEdo;
  String _valEdoE;
  String _valEI;
  String _valHI;
  String _valEE;
  String _valHE;
  String _valAdd;
  String _valDe;
  String _valSp;
  List _listEdo = ['Nativo', 'No nativo'];
  List _listLevel = ['Basico', 'Medio', 'Avanzado'];
  List _listAdd = ['Agregar Archivo'];
  File _storageCV;

  final _priceFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  // ignore: unused_field
  String _extension;
  //FileType _pickingType = FileType.any;
  TextEditingController _controller = new TextEditingController();

  var _editedUser = User(
      degree_levels: '',
      speciality_or_degree: '',
      english_mastery: '',
      english_learning_level: '',
      english_learning_method: '',
      spanish_mastery: '',
      spanish_learning_level: '',
      spanish_learning_method: '',
      expertise_area: '',
      cv_file: null);
  var _initValuesU = {
    'degree_levels': '',
    'speciality_or_degree': '',
  };

  // ignore: unused_field
  var _isInit = true;
  // ignore: unused_field
  String _myActivity;
  String _myActivityEdo;
  String _myActivityAdd;
  // ignore: unused_field
  String _myActivityResult;
  String nameFile;

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

  @override
  void initState() {
    _myActivityEdo = '';
    _myActivityAdd = '';
    _myActivityResult = '';
    super.initState();
    _controller.addListener(() => _extension = _controller.text);
  }

  onChangeDropdownItem() {
    setState(() {
      _myActivityResult = _myActivityEdo;
      _myActivityResult = _myActivityAdd;
    });
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    try {
      await Provider.of<Auth>(context, listen: false).updatePartAdic(
        _editedUser, /*_storageCV*/
      );
      Navigator.of(context).pushReplacementNamed('/dashboard');
    } catch (error) {
      Navigator.of(context).pushReplacementNamed('/dashboard');
    }
    Navigator.of(context).pushReplacementNamed('/dashboard');
  }
/*
  void _openFileExplorer() async {
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
/*
  void _showUploadCV() {
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
  }
*/

  @override
  Widget build(BuildContext context) {
    String _titleReg = 'Datos academicos';
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              TitleProfile(_titleReg),
              TextFormField(
                initialValue: _initValuesU['degree_levels'],
                decoration: InputDecoration(labelText: 'Nivel de estudio'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                validator: (value) {
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _valDe =
                        value; //Untuk memberitahu _valFriends bahwa isi nya akan diubah sesuai dengan value yang kita pilih
                  });
                },
                onSaved: (value) {
                  _editedUser = User(
                    degree_levels: _valDe,
                    speciality_or_degree: _valSp,
                    english_mastery: _valEdo,
                    english_learning_level: _valEI,
                    english_learning_method: _valEE,
                    spanish_mastery: _valEdoE,
                    spanish_learning_level: _valHE,
                    spanish_learning_method: _valEE,
                  );
                },
              ),
              TextFormField(
                initialValue: _initValuesU['email'],
                decoration: InputDecoration(labelText: 'Especialidad o titulo'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                validator: (value) {
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _valSp =
                        value; //Untuk memberitahu _valFriends bahwa isi nya akan diubah sesuai dengan value yang kita pilih
                  });
                },
                onSaved: (value) {
                  _editedUser = User(
                    degree_levels: _valDe,
                    speciality_or_degree: _valSp,
                    english_mastery: _valEdo,
                    english_learning_level: _valEI,
                    english_learning_method: _valEE,
                    spanish_mastery: _valEdoE,
                    spanish_learning_level: _valHE,
                    spanish_learning_method: _valEE,
                  );
                },
              ),
              DropdownButton(
                isExpanded: true,
                iconEnabledColor: Hexcolor('EA6012'),
                hint: Text("Dominio del Ingles"),
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
                    degree_levels: _valDe,
                    speciality_or_degree: _valSp,
                    english_mastery: _valEdo,
                    english_learning_level: _valEI,
                    english_learning_method: _valEE,
                    spanish_mastery: _valEdoE,
                    spanish_learning_level: _valHE,
                    spanish_learning_method: _valEE,
                  );
                },
              ),
              if (_valEdo == 'Nativo') ...[
                DropdownButton(
                  isExpanded: true,
                  iconEnabledColor: Hexcolor('EA6012'),
                  hint: Text("Escrito"),
                  underline: Container(
                    height: 1,
                    color: Colors.grey,
                  ),
                  value: _valEI,
                  items: _listLevel.map((value) {
                    return DropdownMenuItem(
                      child: Text(value),
                      value: value,
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _valEI =
                          value; //Untuk memberitahu _valFriends bahwa isi nya akan diubah sesuai dengan value yang kita pilih
                    });
                    _editedUser = User(
                      degree_levels: _valDe,
                      speciality_or_degree: _valSp,
                      english_mastery: _valEdo,
                      english_learning_level: _valEI,
                      english_learning_method: _valEE,
                      spanish_mastery: _valEdoE,
                      spanish_learning_level: _valHE,
                      spanish_learning_method: _valEE,
                    );
                  },
                ),
                DropdownButton(
                  isExpanded: true,
                  iconEnabledColor: Hexcolor('EA6012'),
                  hint: Text("Hablado"),
                  underline: Container(
                    height: 1,
                    color: Colors.grey,
                  ),
                  value: _valHI,
                  items: _listLevel.map((value) {
                    return DropdownMenuItem(
                      child: Text(value),
                      value: value,
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _valHI =
                          value; //Untuk memberitahu _valFriends bahwa isi nya akan diubah sesuai dengan value yang kita pilih
                    });
                    _editedUser = User(
                      degree_levels: _valDe,
                      speciality_or_degree: _valSp,
                      english_mastery: _valEdo,
                      english_learning_level: _valEI,
                      english_learning_method: _valHI,
                      spanish_mastery: _valEdoE,
                      spanish_learning_level: _valHE,
                      spanish_learning_method: _valEE,
                    );
                  },
                )
              ],
              DropdownButton(
                isExpanded: true,
                iconEnabledColor: Hexcolor('EA6012'),
                hint: Text("Dominio del Español"),
                underline: Container(
                  height: 1,
                  color: Colors.grey,
                ),
                value: _valEdoE,
                items: _listEdo.map((value) {
                  return DropdownMenuItem(
                    child: Text(value),
                    value: value,
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _valEdoE =
                        value; //Untuk memberitahu _valFriends bahwa isi nya akan diubah sesuai dengan value yang kita pilih
                  });
                  _editedUser = User(
                    degree_levels: _valDe,
                    speciality_or_degree: _valSp,
                    english_mastery: _valEdo,
                    english_learning_level: _valEI,
                    english_learning_method: _valHI,
                    spanish_mastery: _valEdoE,
                    spanish_learning_level: _valHE,
                    spanish_learning_method: _valEE,
                  );
                },
              ),
              if (_valEdoE == 'Nativo') ...[
                DropdownButton(
                  isExpanded: true,
                  iconEnabledColor: Hexcolor('EA6012'),
                  hint: Text("Escrito"),
                  underline: Container(
                    height: 1,
                    color: Colors.grey,
                  ),
                  value: _valEE,
                  items: _listLevel.map((value) {
                    return DropdownMenuItem(
                      child: Text(value),
                      value: value,
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _valEE =
                          value; //Untuk memberitahu _valFriends bahwa isi nya akan diubah sesuai dengan value yang kita pilih
                    });
                    _editedUser = User(
                      degree_levels: _valDe,
                      speciality_or_degree: _valSp,
                      english_mastery: _valEdo,
                      english_learning_level: _valEI,
                      english_learning_method: _valHI,
                      spanish_mastery: _valEdoE,
                      spanish_learning_level: _valEE,
                      spanish_learning_method: _valHE,
                    );
                  },
                ),
                DropdownButton(
                  isExpanded: true,
                  iconEnabledColor: Hexcolor('EA6012'),
                  hint: Text("Hablado"),
                  underline: Container(
                    height: 1,
                    color: Colors.grey,
                  ),
                  value: _valHE,
                  items: _listLevel.map((value) {
                    return DropdownMenuItem(
                      child: Text(value),
                      value: value,
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _valHE =
                          value; //Untuk memberitahu _valFriends bahwa isi nya akan diubah sesuai dengan value yang kita pilih
                    });
                    _editedUser = User(
                      degree_levels: _valDe,
                      speciality_or_degree: _valSp,
                      english_mastery: _valEdo,
                      english_learning_level: _valEI,
                      english_learning_method: _valHI,
                      spanish_mastery: _valEdoE,
                      spanish_learning_level: _valEE,
                      spanish_learning_method: _valHE,
                    );
                  },
                )
              ],
              DropdownButton(
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
              ),
              SizedBox(
                height: 10,
              ),
              if (_storageCV != null) ...[
                Text(nameFile),
              ],
              MultiSelect(
                  autovalidate: false,
                  titleTextColor: Colors.grey,
                  titleText:
                      'Tiene conocimientos o ha realizado alguno de estos trabajos?',
                  dataSource: [
                    {
                      "display": "Australia",
                      "value": 1,
                    },
                    {
                      "display": "Canada",
                      "value": 2,
                    },
                    {
                      "display": "India",
                      "value": 3,
                    },
                    {
                      "display": "United States",
                      "value": 4,
                    }
                  ],
                  textField: 'display',
                  valueField: 'value',
                  filterable: true,
                  required: false,
                  value: null,
                  onSaved: (value) {
                    _editedUser = User(
                      degree_levels: _valDe,
                      speciality_or_degree: _valSp,
                      english_mastery: _valEdo,
                      english_learning_level: _valEI,
                      english_learning_method: _valHI,
                      spanish_mastery: _valEdoE,
                      spanish_learning_level: _valEE,
                      spanish_learning_method: _valHE,
                    );
                  }),
              SizedBox(
                height: 190,
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
                        onPressed: _saveForm,
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
