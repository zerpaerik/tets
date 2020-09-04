import 'package:worker/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:percent_indicator/percent_indicator.dart';
//import 'package:file_picker/file_picker.dart';

import '../../../model/user.dart';
import '../../../providers/auth.dart';
import '../../widgets.dart';

class ViewProfileAcad extends StatefulWidget {
  static const routeName = '/view-my-profile-acad';

  final User user;

  ViewProfileAcad({@required this.user});

  @override
  _ViewProfileAcadState createState() => new _ViewProfileAcadState(user);
}

class _ViewProfileAcadState extends State<ViewProfileAcad> {
  User user;
  _ViewProfileAcadState(this.user);
  String _valEdo;
  String _valEdoE;
  String _valEI;
  String _valHI;
  String _valEE;
  String _valHE;
  String _valDe;
  String _valSp;
  List _listEdo = ['Nativo', 'No nativo'];
  List _listLevel = ['Basico', 'Medio', 'Avanzado'];

  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
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

  String name;
  String nameFile;

  @override
  void initState() {
    super.initState();
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
    try {
      await Provider.of<Auth>(context, listen: false)
          .updatePartAdic(_editedUser);
      // Navigator.of(context).pushReplacementNamed('/my-profile');

    } catch (error) {
      // _showErrorDialog(errorMessage);
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
  
  }

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
    if (this.widget.user.english_mastery == '1')
      _valEdo = 'No nativo';
    else
      _valEdo = 'Nativo';

    if (this.widget.user.spanish_mastery == '1')
      _valEdoE = 'No nativo';
    else
      _valEdoE = 'Nativo';

    if (this.widget.user.english_learning_level == '1') _valEI = 'Basico';
    if (this.widget.user.english_learning_level == '2') _valEI = 'Medio';
    if (this.widget.user.english_learning_level == '3') _valEI = 'Avanzado';

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
                margin: EdgeInsets.only(left: 20, top: 5.0),
                child: Text('Editar datos academicos/profesionales',
                    style: TextStyle(
                        color: Hexcolor('9c9c9c'),
                        fontFamily: 'OpenSans-Regular',
                        fontSize: 19,
                        fontWeight: FontWeight.bold)),
              ),
              Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  width: 130,
                  child: TextFormField(
                    initialValue: this.widget.user.degree_levels,
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
                        degree_levels: value,
                        speciality_or_degree: _valSp,
                      );
                    },
                  )),
              Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: TextFormField(
                    initialValue: this.widget.user.speciality_or_degree,
                    decoration:
                        InputDecoration(labelText: 'Especialidad o titulo'),
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
                        speciality_or_degree: value,
                      );
                    },
                  )),
              SizedBox(height: 5),
              Container(
                margin: EdgeInsets.only(left: 20),
                child: Text(
                  'Dominio del Ingles',
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
                        hint: Text('Dominio del Ingles'),
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
                    onSaved: (value) => _editedUser = User(
                      degree_levels: _valDe,
                      speciality_or_degree: _valSp,
                      english_mastery: value,
                      english_learning_level: _valEI,
                      english_learning_method: _valEE,
                      spanish_mastery: _valEdoE,
                      spanish_learning_level: _valHE,
                      spanish_learning_method: _valEE,
                    ),
                  )),
              if (_valEdo == 'Nativo') ...[
                Container(
                    width: 130,
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: FormField(
                      builder: (state) {
                        return DropdownButton(
                          isExpanded: true,
                          iconEnabledColor: Hexcolor('EA6012'),
                          hint: Text('Escrito'),
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
                          onChanged: (value) => setState(() {
                            _valEI = value;
                            state.didChange(value);
                          }),
                        );
                      },
                      onSaved: (value) => _editedUser = User(
                        degree_levels: _valDe,
                        speciality_or_degree: _valSp,
                        english_mastery: _valEdo,
                        english_learning_level: value,
                        english_learning_method: _valEE,
                        spanish_mastery: _valEdoE,
                        spanish_learning_level: _valHE,
                        spanish_learning_method: _valEE,
                      ),
                    )),
                Container(
                    width: 130,
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: FormField(
                      builder: (state) {
                        return DropdownButton(
                          isExpanded: true,
                          iconEnabledColor: Hexcolor('EA6012'),
                          hint: Text('Hablado'),
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
                          onChanged: (value) => setState(() {
                            _valHI = value;
                            state.didChange(value);
                          }),
                        );
                      },
                      onSaved: (value) => _editedUser = User(
                        degree_levels: _valDe,
                        speciality_or_degree: _valSp,
                        english_mastery: _valEdo,
                        english_learning_level: _valEI,
                        english_learning_method: value,
                        spanish_mastery: _valEdoE,
                        spanish_learning_level: _valHE,
                        spanish_learning_method: _valEE,
                      ),
                    )),
              ],
              Container(
                margin: EdgeInsets.only(left: 20),
                child: Text(
                  'Dominio del Español',
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
                        hint: Text('Dominio del Español'),
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
                        onChanged: (value) => setState(() {
                          _valEdoE = value;
                          state.didChange(value);
                        }),
                      );
                    },
                    onSaved: (value) => _editedUser = User(
                      degree_levels: _valDe,
                      speciality_or_degree: _valSp,
                      english_mastery: _valEdo,
                      english_learning_level: _valEI,
                      english_learning_method: _valHI,
                      spanish_mastery: value,
                      spanish_learning_level: _valHE,
                      spanish_learning_method: _valEE,
                    ),
                  )),
              if (_valEdoE == 'Nativo') ...[
                Container(
                    width: 130,
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: DropdownButton(
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
                          spanish_learning_level: value,
                          spanish_learning_method: _valHE,
                        );
                      },
                    )),
                Container(
                    width: 130,
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: DropdownButton(
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
                    )),
              ],
              /*   DropdownButton(
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
                        _valAdd = value;  //Untuk memberitahu _valFriends bahwa isi nya akan diubah sesuai dengan value yang kita pilih
                      });
                       _editedUser = User(
                          degree_levels: '1',
                          speciality_or_degree: '1',
                          english_mastery: '1',
                          english_learning_level: '1',
                          english_learning_method: '1',
                          spanish_mastery: '1',
                          spanish_learning_level: '1',
                          spanish_learning_method: '1',
                          );
                      //_showUploadCV();
                    },
                  ),*/
              SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Container(
                    width: 130.0,
                    height: 50,
                    margin: EdgeInsets.only(left: 18, right: 30),
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
                    width: 130.0,
                    height: 50,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
