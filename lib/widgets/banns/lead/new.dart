import 'package:worker/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:signature/signature.dart';
import 'dart:io';
import 'package:percent_indicator/percent_indicator.dart';

import '../../../model/user.dart';
import '../../../model/status.dart';
import '../../../model/rh.dart';
import '../../../model/blodd.dart';
import '../../../providers/auth.dart';
import '../../widgets.dart';

class NewBannsPage extends StatefulWidget {
  static const routeName = '/new-banns';

  final User user;

  NewBannsPage({@required this.user});

  @override
  _NewBannsPageState createState() => _NewBannsPageState(user);
}

class _NewBannsPageState extends State<NewBannsPage> {
  User user;
  _NewBannsPageState(this.user);
  GlobalKey<_NewBannsPageState> signatureKey = GlobalKey();
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
    exportBackgroundColor: Colors.blue,
  );

  var maskTextInputFormatter = MaskTextInputFormatter(
      mask: "+1(###)#######", filter: {"#": RegExp(r'[0-9]')});

  //LIST STATUS MARITALF
  List<StatusM> _status = StatusM.getStatus();
  List<DropdownMenuItem<StatusM>> _dropdownMenuItemsS;
  StatusM _selectedStatus;

  //LIST TYPE BLODD
  List<Blodd> _blodds = Blodd.getBlodds();
  List<DropdownMenuItem<Blodd>> _dropdownMenuItemsB;
  Blodd _selectedBlodds;

  //LIST RH
  List<Rh> _rhs = Rh.getRh();
  List<DropdownMenuItem<Rh>> _dropdownMenuItemsR;
  Rh _selectedRh;

  String _valName;
  String _valFirstName;
  String _valPhone;
  String _valEmail;
  String _valAdd;
  String _valAdd2;
  String success;
  bool signa = false;
  File image;
  List _listAdd = ['Agregar'];
  List _listAdd2 = ['Agregar'];
  double maxtop;
  double maxwidth;

  final _priceFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  final _form1 = GlobalKey<FormState>();

  var _editedUser = User(
    id: null,
    dependents_number: '',
    contact_first_name: '',
    contact_last_name: '',
    contact_email: '',
    contact_phone: '',
    marital_status: null,
    blood_type: null,
    rh_factor: null,
    signature: null,
  );
  var _initValuesU = {
    'dependents_number': '',
    'contact_first_name': '',
    'contact_last_name': '',
    'contact_email': '',
    'contact_phone': '',
    'marital_status': '',
    'blood_type': '',
    'rh_factor': '',
    'signature': '',
  };

  String _myActivityEdo;
  String _myActivityAdd;
  String _myActivityAdd2;
  // ignore: unused_field
  String _myActivityResult;
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

  void _showInputDialog() {
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
                          Text('Ingrese los datos del contacto de Emergencia',
                              style: TextStyle(
                                  fontFamily: 'OpenSans',
                                  color: Hexcolor('EA6012'),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0),
                              textAlign: TextAlign.center),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 40.0, right: 40.0),
                            width: double.infinity,
                            child: TextFormField(
                                initialValue: _valName,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                textAlign: TextAlign.left,
                                decoration:
                                    InputDecoration(labelText: 'Nombre'),
                                // ignore: missing_return
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Es obligatorio!';
                                  }
                                },
                                onSaved: (value) {
                                  setState(() {
                                    _valName =
                                        value; //Untuk memberitahu _valFriends bahwa isi nya akan diubah sesuai dengan value yang kita pilih
                                  });
                                  _editedUser = User(
                                      dependents_number:
                                          _editedUser.dependents_number,
                                      marital_status: _selectedStatus.id,
                                      contact_first_name: _valName,
                                      contact_last_name:
                                          _editedUser.contact_last_name,
                                      contact_email: _editedUser.contact_email,
                                      contact_phone: _editedUser.contact_phone,
                                      blood_type: _selectedBlodds.id,
                                      rh_factor: _selectedRh.id);
                                },
                                onChanged: (value) {
                                  setState(() {
                                    _valName =
                                        value; //Untuk memberitahu _valFriends bahwa isi nya akan diubah sesuai dengan value yang kita pilih
                                  });
                                }),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 40.0, right: 40.0),
                            width: double.infinity,
                            child: TextFormField(
                                initialValue: _valFirstName,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                textAlign: TextAlign.left,
                                decoration:
                                    InputDecoration(labelText: 'Apellido'),
                                // ignore: missing_return
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Es obligatorio!';
                                  }
                                },
                                onSaved: (value) {
                                  setState(() {
                                    _valFirstName =
                                        value; //Untuk memberitahu _valFriends bahwa isi nya akan diubah sesuai dengan value yang kita pilih
                                  });
                                  _editedUser = User(
                                      dependents_number:
                                          _editedUser.dependents_number,
                                      marital_status: _selectedStatus.id,
                                      contact_first_name: _valName,
                                      contact_last_name: _valFirstName,
                                      contact_email: _editedUser.contact_email,
                                      contact_phone: _editedUser.contact_phone,
                                      blood_type: _selectedBlodds.id,
                                      rh_factor: _selectedRh.id);
                                },
                                onChanged: (value) {
                                  setState(() {
                                    _valFirstName =
                                        value; //Untuk memberitahu _valFriends bahwa isi nya akan diubah sesuai dengan value yang kita pilih
                                  });
                                }),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 40.0, right: 40.0),
                            width: double.infinity,
                            child: TextFormField(
                                initialValue: _valPhone,
                                textAlign: TextAlign.left,
                                decoration:
                                    InputDecoration(labelText: 'Telèfono'),
                                inputFormatters: [maskTextInputFormatter],
                                // ignore: missing_return
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Es obligatorio!';
                                  }
                                },
                                onSaved: (value) {
                                  setState(() {
                                    _valPhone =
                                        value; //Untuk memberitahu _valFriends bahwa isi nya akan diubah sesuai dengan value yang kita pilih
                                  });
                                  _editedUser = User(
                                      dependents_number:
                                          _editedUser.dependents_number,
                                      marital_status: _selectedStatus.id,
                                      contact_first_name: _valName,
                                      contact_last_name: _valFirstName,
                                      contact_email: _editedUser.contact_email,
                                      contact_phone: _valPhone,
                                      blood_type: _selectedBlodds.id,
                                      rh_factor: _selectedRh.id);
                                },
                                onChanged: (value) {
                                  setState(() {
                                    _valPhone =
                                        value; //Untuk memberitahu _valFriends bahwa isi nya akan diubah sesuai dengan value yang kita pilih
                                  });
                                }),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 40.0, right: 40.0),
                            width: double.infinity,
                            child: TextFormField(
                                initialValue: _valEmail,
                                textAlign: TextAlign.left,
                                decoration: InputDecoration(labelText: 'Email'),
                                // ignore: missing_return
                                validator: (value) {
                                  if (value.isEmpty || !value.contains('@')) {
                                    return 'Email invalido!';
                                  }
                                },
                                onSaved: (value) {
                                  setState(() {
                                    _valEmail =
                                        value; //Untuk memberitahu _valFriends bahwa isi nya akan diubah sesuai dengan value yang kita pilih
                                  });
                                  _editedUser = User(
                                      dependents_number:
                                          _editedUser.dependents_number,
                                      marital_status: _selectedStatus.id,
                                      contact_first_name: _valName,
                                      contact_last_name: _valFirstName,
                                      contact_email: _valEmail,
                                      contact_phone: _valPhone,
                                      blood_type: _selectedBlodds.id,
                                      rh_factor: _selectedRh.id);
                                },
                                onChanged: (value) {
                                  setState(() {
                                    _valEmail =
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
                            child: RaisedButton(
                              elevation: 5.0,
                              onPressed: () {
                                if (_form1.currentState.validate()) {
                                  setState(() {
                                    _valName = _valName;
                                    _valFirstName = _valFirstName;
                                  });
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
              Container(
                margin: EdgeInsets.only(left: 40.0, right: 40.0),
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Hexcolor('EA6012')),
                    borderRadius: BorderRadius.circular(5)),
                child: Signature(
                  key: signatureKey,
                  controller: _controller,
                  height: 400,
                  width: 600,
                  backgroundColor: Colors.white,
                ),
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
                      _valName = _valName;
                      _valFirstName = _valFirstName;
                      signa = true;
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

  @override
  void initState() {
    _myActivityEdo = '';
    _myActivityAdd = '';
    _myActivityAdd2 = '';
    _myActivityResult = '';
    _controller.addListener(() => print("Value changed"));
    _dropdownMenuItemsS = buildDropdownMenuItemsS(_status);
    _selectedStatus = _dropdownMenuItemsS[0].value;
    _dropdownMenuItemsB = buildDropdownMenuItemsB(_blodds);
    _selectedBlodds = _dropdownMenuItemsB[0].value;
    _dropdownMenuItemsR = buildDropdownMenuItemsR(_rhs);
    _selectedRh = _dropdownMenuItemsR[0].value;
    super.initState();
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

  // LIST DROPDOWN TYPE BLODD

  List<DropdownMenuItem<Blodd>> buildDropdownMenuItemsB(List blodds) {
    List<DropdownMenuItem<Blodd>> items = List();
    for (Blodd blodd in blodds) {
      items.add(
        DropdownMenuItem(
          value: blodd,
          child: Text(blodd.name),
        ),
      );
    }
    return items;
  }

  // LIST DROPDOWN RH

  List<DropdownMenuItem<Rh>> buildDropdownMenuItemsR(List rhs) {
    List<DropdownMenuItem<Rh>> items = List();
    for (Rh rh in rhs) {
      items.add(
        DropdownMenuItem(
          value: rh,
          child: Text(rh.name),
        ),
      );
    }
    return items;
  }

  onChangeDropdownItem() {
    setState(() {
      _myActivityResult = _myActivityEdo;
      _myActivityResult = _myActivityAdd;
      _myActivityResult = _myActivityAdd2;
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
      await Provider.of<Auth>(context, listen: false)
          .updatePart2(_editedUser, _controller)
          .then((response) {
        setState(() {
          _isLoading = false;
        });
        success = '1';
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ImageInputCamera()),
        );
      });
    } catch (error) {
      print(error);
      success = '0';
    }
  }

  @override
  Widget build(BuildContext context) {
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
              Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 5, top: 20),
                        child: Image.asset(
                          'assets/amonestacion.png',
                          width: 50,
                        )),
                    Container(
                      margin: EdgeInsets.only(left: 10, top: 25),
                      child: Text('Crear Amonestación',
                          style: TextStyle(
                              color: Hexcolor('EA6012'),
                              fontFamily: 'OpenSans-Regular',
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    ),
                  ]),
              Container(
                margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                // padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (value) {},
                  //controller: editingController,
                  decoration: InputDecoration(
                      labelText: "Buscar Trabajador",
                      hintText: "Buscar por ID",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(5.0)))),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    width: maxtop,
                    height: 80,
                    child: TextFormField(
                      initialValue: _initValuesU['dependents_number'],
                      decoration: InputDecoration(labelText: 'Nombres'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
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
                  Container(
                    width: maxtop,
                    height: 80,
                    child: TextFormField(
                      initialValue: _initValuesU['dependents_number'],
                      decoration: InputDecoration(labelText: 'Apellidos'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
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
                margin: EdgeInsets.only(left: 20, right: 20),
                child: TextFormField(
                  initialValue: _initValuesU['dependents_number'],
                  decoration: InputDecoration(labelText: 'Dirección'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
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
              Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: TextFormField(
                  initialValue: _initValuesU['dependents_number'],
                  decoration: InputDecoration(labelText: 'ID#'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
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
              Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: TextFormField(
                  initialValue: _initValuesU['dependents_number'],
                  decoration: InputDecoration(labelText: 'Correo electrónico'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
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
              Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 20, top: 10),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Tipo de amonestación',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      left: 20,
                      right: 20,
                    ),
                    child: FormField(
                      builder: (state) {
                        return DropdownButton(
                          isExpanded: true,
                          iconEnabledColor: Hexcolor('EA6012'),
                          //hint: Text('Seleccione Tipo de Sangre'),
                          underline: Container(
                            height: 1,
                            color: Colors.grey,
                          ),
                          items: _dropdownMenuItemsB,
                          value: _selectedBlodds,
                          onChanged: (value) => setState(() {
                            _selectedBlodds = value;
                            state.didChange(value);
                          }),
                        );
                      },
                      onSaved: (value) => _editedUser = User(
                          dependents_number: _editedUser.dependents_number,
                          marital_status: _selectedStatus.id,
                          contact_first_name: _valName,
                          contact_last_name: _valFirstName,
                          contact_email: _valEmail,
                          contact_phone: _valPhone,
                          blood_type: _selectedBlodds.id,
                          rh_factor: _selectedRh.id),
                    ),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 20, top: 10),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Motivo',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      left: 20,
                      right: 20,
                    ),
                    child: FormField(
                      builder: (state) {
                        return DropdownButton(
                          isExpanded: true,
                          iconEnabledColor: Hexcolor('EA6012'),
                          //hint: Text('Seleccione Tipo de Sangre'),
                          underline: Container(
                            height: 1,
                            color: Colors.grey,
                          ),
                          items: _dropdownMenuItemsB,
                          value: _selectedBlodds,
                          onChanged: (value) => setState(() {
                            _selectedBlodds = value;
                            state.didChange(value);
                          }),
                        );
                      },
                      onSaved: (value) => _editedUser = User(
                          dependents_number: _editedUser.dependents_number,
                          marital_status: _selectedStatus.id,
                          contact_first_name: _valName,
                          contact_last_name: _valFirstName,
                          contact_email: _valEmail,
                          contact_phone: _valPhone,
                          blood_type: _selectedBlodds.id,
                          rh_factor: _selectedRh.id),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: TextFormField(
                  initialValue: _initValuesU['dependents_number'],
                  decoration: InputDecoration(
                      labelText: 'Texto explicativo de la amonestación'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
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
              Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: TextFormField(
                  initialValue: _initValuesU['dependents_number'],
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.next,
                  maxLength: 1000,
                  decoration:
                      InputDecoration(labelText: 'Descripción de los hechos'),
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
              Container(
                margin: EdgeInsets.only(left: 20, top: 10),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Firma del Trabajador',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                padding: EdgeInsets.symmetric(vertical: 1.0),
                width: double.infinity,
                child: DropdownButton(
                  // hint: Text("Firma con el dedo"),
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
              Container(
                margin: EdgeInsets.only(left: 20, top: 10),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Firma del Supervisor',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                padding: EdgeInsets.symmetric(vertical: 1.0),
                width: double.infinity,
                child: DropdownButton(
                  // hint: Text("Firma con el dedo"),
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
              if (signa) ...[
                Container(
                  margin: EdgeInsets.only(left: 20.0, right: 20.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Hexcolor('EA6012')),
                      borderRadius: BorderRadius.circular(5)),
                  child: Signature(
                    key: signatureKey,
                    controller: _controller,
                    height: 300,
                    width: 500,
                    backgroundColor: Colors.white,
                  ),
                )
              ],
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    width: 130,
                    height: 50.0,
                    // margin: EdgeInsets.only(left:15),
                    child: RaisedButton(
                      elevation: 5.0,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      // padding: EdgeInsets.only(left: 20, right: 20,top: 15, bottom: 15),
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
                        : RaisedButton(
                            elevation: 5.0,
                            onPressed: _saveForm,
                            // padding: EdgeInsets.only(left: 20, right: 20,top: 10, bottom: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            color: Hexcolor('009444'),
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
