import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:worker/providers/workday.dart';
import 'package:worker/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../model/user.dart';
import '../widgets.dart';
import 'package:intl/intl.dart' show DateFormat;

class NewWorkdayReport extends StatefulWidget {
  static const routeName = '/new-workday';
  final User user;
  final int workday;

  NewWorkdayReport({@required this.user, @required this.workday});

  @override
  _NewWorkdayReportState createState() => _NewWorkdayReportState(user, workday);
}

class _NewWorkdayReportState extends State<NewWorkdayReport> {
  User user;
  int workday;
  _NewWorkdayReportState(this.user, this.workday);

  // ignore: unused_field
  int _selectedIndex = 4;
  bool yes_offer = false;
  int selectedRadio;
  int selectedRadio1;
  int selectedRadio2;
  int selectedRadio3;
  int selectedRadio4;
  int selectedRadio5;
  int selectedRadio6;
  int selectedRadio7;
  int selectedRadio8;
  int selectedRadio9;
  int selectedRadio10;

  String _time = "S/H";
  String _time1 = "S/H";
  String _time2 = "S/H";
  String _time3 = "S/H";
  String _time4 = "S/H";
  String _time5 = "S/H";
  String _time6 = "S/H";
  String _time7 = "S/H";
  String _time8 = "S/H";
  String _time9 = "S/H";

  DateTime hourClock; // init workday
  DateTime hourClock1; // fin workday
  DateTime hourClock2; // init lunch
  DateTime hourClock3; // fin lunch
  DateTime hourClock4; // init standby
  DateTime hourClock5; // fin standby
  DateTime hourClock6; // init travel
  DateTime hourClock7; // fin travel
  DateTime hourClock8; // init return
  DateTime hourClock9; // fin return
  String durationLunch;
  String durationStandBy;
  String durationTravel;
  String durationReturn;
  String comments;
  var drivers;
  final _form = GlobalKey<FormState>();
  List data = List();
  List _workers = List();
  List _workersForDisplay = List();
  List _driversWork;
  var image;
  List imageArray = [];
  bool isLoading = false;

  _openGallery() async {
    image = await ImagePicker.pickImage(source: ImageSource.gallery);
    imageArray.add(image);
    setState(() {
      imageArray;
    });
    print('desde galer');
  }

  _openCamera() async {
    image = await ImagePicker.pickImage(source: ImageSource.camera);
    imageArray.add(image);
    setState(() {
      imageArray;
    });
    print('desde cam');
  }

  getToken() async {
    SharedPreferences token = await SharedPreferences.getInstance();
    String stringValue = token.getString('stringValue');
    return stringValue;
  }

  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  setSelectedRadio1(int val) {
    setState(() {
      selectedRadio1 = val;
    });
  }

  setSelectedRadio2(int val) {
    setState(() {
      selectedRadio2 = val;
    });
  }

  setSelectedRadio3(int val) {
    setState(() {
      selectedRadio3 = val;
    });
  }

  setSelectedRadio4(int val) {
    setState(() {
      selectedRadio4 = val;
    });
  }

  setSelectedRadio5(int val) {
    setState(() {
      selectedRadio5 = val;
    });
  }

  setSelectedRadio6(int val) {
    setState(() {
      selectedRadio6 = val;
    });
  }

  setSelectedRadio7(int val) {
    setState(() {
      selectedRadio7 = val;
    });
  }

  setSelectedRadio8(int val) {
    setState(() {
      selectedRadio8 = val;
    });
  }

  setSelectedRadio9(int val) {
    setState(() {
      selectedRadio9 = val;
    });
  }

  setSelectedRadio10(int val) {
    setState(() {
      selectedRadio10 = val;
    });
  }

  Future<dynamic> getSWData() async {
    String token = await getToken();
    var res = await http.get(
        Uri.encodeFull(
            'http://emplooy.turpialdev.webfactional.com/api/v-1/contract/1/list-workers-accepted'),
        headers: {
          "Authorization": "Token 4ead92aa67e22337c35db38e019437eba1fe4ab5"
        });
    var resBody = json.decode(res.body);

    setState(() {
      _workers = resBody;
    });

    return _workers;
  }

  Future<void> _submit() async {
    setState(() {
      isLoading = true;
    });
    print('se fue');
    print(_driversWork);
    print(comments);
    try {
      Provider.of<WorkDay>(context, listen: false)
          .addWorkdayReport(
              this.widget.workday,
              hourClock,
              hourClock1,
              hourClock2,
              hourClock3,
              durationLunch,
              _driversWork,
              hourClock4,
              hourClock4,
              durationStandBy,
              hourClock4,
              hourClock5,
              durationTravel,
              hourClock6,
              hourClock7,
              durationReturn,
              comments,
              imageArray)
          .then((response) {
        setState(() {
          // isLoading = false;
        });
        if (response == '201') {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WorkDayPage(
                      user: user,
                      workday: this.widget.workday,
                    )),
          );
        } else {
          //_showErrorDialog('Verifique la información');
        }
      });
    } catch (error) {}
    /* Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfilePartOblig2()),
          );*/
  }

  void _onWorkerSelected(bool selected, worker_id) {
    if (selected == true) {
      setState(() {
        _driversWork.add(worker_id);
        print(_driversWork);
      });
    } else {
      setState(() {
        _driversWork.remove(worker_id);
        print(_driversWork);
      });
    }
  }

  @override
  void initState() {
    _driversWork = [];
    selectedRadio = 0;
    selectedRadio1 = 0;
    selectedRadio2 = 0;
    selectedRadio3 = 0;
    selectedRadio4 = 0;
    selectedRadio5 = 0;
    selectedRadio6 = 0;
    selectedRadio7 = 0;
    selectedRadio8 = 0;
    selectedRadio9 = 0;
    selectedRadio10 = 0;
    this.getSWData();
    /*getSWData().then((value) {
      setState(() {
        _workers.addAll(value);
        _workersForDisplay = _workers;
      });
    });*/
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(data);
    return new Scaffold(
        appBar: AppBar(
          elevation: 2.0,
          backgroundColor: Colors.white,
          centerTitle: true,
          automaticallyImplyLeading: false,
          iconTheme: IconThemeData(
            color: Hexcolor('EA6012'),
          ),
          title: Image.asset(
            "assets/homelogo.png",
            width: 120,
          ),
        ),
        // ignore: missing_required_param
        endDrawer: MenuLateral(
          user: user,
        ),
        body: SingleChildScrollView(
            child: Form(
                key: _form,
                child: Container(
                    margin: EdgeInsets.only(top: 30),
                    child: Column(children: <Widget>[
                      Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                                margin: EdgeInsets.only(left: 20),
                                child: Image.asset(
                                  'assets/gastos_icon.png',
                                  width: 50,
                                )),
                            Container(
                              margin: EdgeInsets.only(left: 10, top: 15),
                              child: Text('Nombre de Proyecto',
                                  style: TextStyle(
                                      color: Hexcolor('EA6012'),
                                      fontFamily: 'OpenSans-Regular',
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ]),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              '¿Hubo jornada laboral?',
                              style: TextStyle(
                                  color: Hexcolor('EA6012'),
                                  fontFamily: 'OpenSans-Regular',
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
                            ),
                          )),
                      Row(children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Text(
                            'Si',
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Radio(
                          value: 1,
                          groupValue: selectedRadio,
                          activeColor: Colors.green,
                          onChanged: (val) {
                            print("$val");
                            setSelectedRadio(val);
                          },
                        ),
                        Text('No',
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold)),
                        Radio(
                          value: 2,
                          groupValue: selectedRadio,
                          activeColor: Colors.green,
                          onChanged: (val) {
                            print("$val");
                            setSelectedRadio(val);
                          },
                        ),
                      ]),
                      if (selectedRadio == 1) ...[
                        Row(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Container(
                                    margin: EdgeInsets.only(left: 20),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'Hora Entrada',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 17),
                                      ),
                                    )),
                                Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        _time,
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 17),
                                      ),
                                    )),
                              ],
                            ),
                            IconButton(
                              icon: Icon(Icons.timer),
                              color: Hexcolor('EA6012'),
                              onPressed: () {
                                DatePicker.showTimePicker(context,
                                    theme: DatePickerTheme(
                                        containerHeight: 210.0,
                                        doneStyle: TextStyle(
                                            color: Hexcolor('EA6012'))),
                                    showTitleActions: true, onConfirm: (time) {
                                  print('confirm $time');
                                  hourClock = time;
                                  String formattedTime =
                                      DateFormat('hh:mm:aa').format(time);
                                  _time = formattedTime;
                                  setState(() {});
                                },
                                    currentTime: DateTime.now(),
                                    locale: LocaleType.en);
                                setState(() {});
                              },
                            ),
                            Column(
                              children: <Widget>[
                                Container(
                                    margin: EdgeInsets.only(left: 30),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'Hora Salida',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 17),
                                      ),
                                    )),
                                Container(
                                    margin: EdgeInsets.only(left: 30),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        _time1,
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 17),
                                      ),
                                    )),
                              ],
                            ),
                            IconButton(
                              icon: Icon(Icons.timer_off),
                              color: Hexcolor('EA6012'),
                              onPressed: () {
                                DatePicker.showTimePicker(context,
                                    theme: DatePickerTheme(
                                        containerHeight: 210.0,
                                        doneStyle: TextStyle(
                                            color: Hexcolor('EA6012'))),
                                    showTitleActions: true, onConfirm: (time1) {
                                  print('confirm $time1');
                                  hourClock1 = time1;
                                  String formattedTime1 =
                                      DateFormat('hh:mm:aa').format(time1);
                                  _time1 = formattedTime1;
                                  setState(() {});
                                },
                                    currentTime: DateTime.now(),
                                    locale: LocaleType.en);
                                setState(() {});
                              },
                            ),
                          ],
                        )
                      ],
                      if (selectedRadio == 1) ...[
                        Container(
                            margin: EdgeInsets.only(left: 20),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                '¿Hubo tiempo de almuerzo?',
                                style: TextStyle(
                                    color: Hexcolor('EA6012'),
                                    fontFamily: 'OpenSans-Regular',
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                        Row(children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 20),
                            child: Text(
                              'Si',
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Radio(
                            value: 1,
                            groupValue: selectedRadio1,
                            activeColor: Colors.green,
                            onChanged: (val) {
                              print("$val");
                              setSelectedRadio1(val);
                            },
                          ),
                          Text('No',
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold)),
                          Radio(
                            value: 2,
                            groupValue: selectedRadio1,
                            activeColor: Colors.green,
                            onChanged: (val) {
                              print("$val");
                              setSelectedRadio1(val);
                            },
                          ),
                        ]),
                        if (selectedRadio1 == 1) ...[
                          Container(
                              margin: EdgeInsets.only(left: 20),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  '¿Deseas indicar la hora de inicio/fin o la duración?',
                                  style: TextStyle(
                                      color: Hexcolor('EA6012'),
                                      fontFamily: 'OpenSans-Regular',
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                          Row(children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(left: 20),
                              child: Text(
                                'Inicio/Fin',
                                style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Radio(
                              value: 1,
                              groupValue: selectedRadio2,
                              activeColor: Colors.green,
                              onChanged: (val) {
                                print("sr2 $val");
                                setSelectedRadio2(val);
                              },
                            ),
                            Text('Duración',
                                style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold)),
                            Radio(
                              value: 2,
                              groupValue: selectedRadio2,
                              activeColor: Colors.green,
                              onChanged: (val) {
                                print("sr2 $val");
                                setSelectedRadio2(val);
                              },
                            ),
                          ])
                        ],
                        if (selectedRadio2 == 1) ...[
                          Row(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Container(
                                      margin: EdgeInsets.only(left: 20),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          'Hora Inicio',
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 17),
                                        ),
                                      )),
                                  Container(
                                      margin: EdgeInsets.only(left: 10),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          _time2,
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 17),
                                        ),
                                      )),
                                ],
                              ),
                              IconButton(
                                icon: Icon(Icons.timer),
                                color: Hexcolor('EA6012'),
                                onPressed: () {
                                  DatePicker.showTimePicker(context,
                                      theme: DatePickerTheme(
                                          containerHeight: 210.0,
                                          doneStyle: TextStyle(
                                              color: Hexcolor('EA6012'))),
                                      showTitleActions: true,
                                      onConfirm: (time2) {
                                    print('confirm $time2');
                                    hourClock2 = time2;
                                    String formattedTime2 =
                                        DateFormat('hh:mm:aa').format(time2);
                                    _time2 = formattedTime2;
                                    setState(() {});
                                  },
                                      currentTime: DateTime.now(),
                                      locale: LocaleType.en);
                                  setState(() {});
                                },
                              ),
                              Column(
                                children: <Widget>[
                                  Container(
                                      margin: EdgeInsets.only(left: 30),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          'Hora Fin',
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 17),
                                        ),
                                      )),
                                  Container(
                                      margin: EdgeInsets.only(left: 30),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          _time3,
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 17),
                                        ),
                                      )),
                                ],
                              ),
                              IconButton(
                                icon: Icon(Icons.timer_off),
                                color: Hexcolor('EA6012'),
                                onPressed: () {
                                  DatePicker.showTimePicker(context,
                                      theme: DatePickerTheme(
                                          containerHeight: 210.0,
                                          doneStyle: TextStyle(
                                              color: Hexcolor('EA6012'))),
                                      showTitleActions: true,
                                      onConfirm: (time3) {
                                    print('confirm $time3');
                                    hourClock3 = time3;
                                    String formattedTime3 =
                                        DateFormat('hh:mm:aa').format(time3);
                                    _time3 = formattedTime3;
                                    setState(() {});
                                  },
                                      currentTime: DateTime.now(),
                                      locale: LocaleType.en);
                                  setState(() {});
                                },
                              ),
                            ],
                          )
                        ],
                        if (selectedRadio2 == 2) ...[
                          Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: TextFormField(
                              // initialValue: _initValuesU['dependents_number'],
                              decoration: InputDecoration(
                                  labelText: 'Duración en minutos'),
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Es obligatorio!';
                                }
                                return null;
                              },
                              onChanged: (value) => setState(() {
                                durationLunch = value;
                              }),
                            ),
                          ),
                        ],
                      ],
                      Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Ubique los conductores por su nombre o número' +
                                  '\n' 'de id.',
                              style: TextStyle(
                                  color: Hexcolor('EA6012'),
                                  fontFamily: 'OpenSans-Regular',
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
                            ),
                          )),
                      /* Container(
                        padding: EdgeInsets.all(16),
                        child: MultiSelectFormField(
                          autovalidate: false,
                          fillColor: Hexcolor('EA6012'),
                          titleText: 'Lista de Trabajadores',
                          validator: (value) {
                            if (value == null || value.length == 0) {
                              return 'Seleccione los drivers';
                            }
                            return null;
                          },
                          dataSource: _workers != null
                              ? _workers
                              : [
                                  {
                                    "first_name": "Cargando",
                                    "id": "0",
                                  }
                                ],
                          textField:
                              _workers != null ? 'first_name' : 'first_name',
                          valueField: _workers != null ? 'id' : 'id',
                          okButtonLabel: 'OK',
                          cancelButtonLabel: 'Cancelar',
                          // required: true,
                          hintText: 'Drivers disponibles',
                          initialValue: _driversWork,
                          onSaved: (value) {
                            if (value == null) return;
                            setState(() {
                              _driversWork = value;
                              print(_driversWork);
                            });
                          },
                        ),
                      )*/
                      Container(
                        // margin: EdgeInsets.only(left: 10),
                        height: 120,
                        child: ListView.builder(
                            // padding: const EdgeInsets.all(8),
                            itemCount: _workers.length,
                            itemBuilder: (BuildContext context, int index) {
                              /*   return Container(
                                    height: 50,
                                    child: Text(
                                      'Datos: ${workerDescription[index]}',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 18),
                                    ),
                                  );*/
                              return Row(
                                children: <Widget>[
                                  Expanded(
                                    child: ListTile(
                                        title: Container(
                                      margin: EdgeInsets.only(left: 10),
                                      child: Text(
                                        'Datos: ${_workers[index]['first_name']} ${_workers[index]['last_name']} ID#${_workers[index]['btn_id']}',
                                        style: TextStyle(
                                            color: Colors.grey[800],
                                            fontSize: 18),
                                      ),
                                    )),
                                  ),
                                  Checkbox(
                                    activeColor: Hexcolor('42E948'),
                                    value: _driversWork
                                        .contains(_workers[index]['id']),
                                    onChanged: (bool selected) {
                                      _onWorkerSelected(
                                        selected,
                                        _workers[index]['id'],
                                      );
                                    },
                                  )
                                ],
                              );
                            }),
                      ),
                      /* Container(
                        height: 100,
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return index == 0
                                ? _searchBar()
                                : _listItem(index - 1);
                          },
                          itemCount: _workersForDisplay.length + 1,
                        ),
                      ),*/
                      Container(
                          margin: EdgeInsets.only(left: 20, top: 15),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              '¿Hubo stand-by?',
                              style: TextStyle(
                                  color: Hexcolor('EA6012'),
                                  fontFamily: 'OpenSans-Regular',
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
                            ),
                          )),
                      Row(children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Text(
                            'Si',
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Radio(
                          value: 1,
                          groupValue: selectedRadio4,
                          activeColor: Colors.green,
                          onChanged: (val) {
                            print("$val");
                            setSelectedRadio4(val);
                          },
                        ),
                        Text('No',
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold)),
                        Radio(
                          value: 2,
                          groupValue: selectedRadio4,
                          activeColor: Colors.green,
                          onChanged: (val) {
                            print("$val");
                            setSelectedRadio4(val);
                          },
                        ),
                      ]),
                      if (selectedRadio4 == 1) ...[
                        Container(
                            margin: EdgeInsets.only(left: 20),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                '¿Deseas indicar la hora de inicio/fin o la duración?',
                                style: TextStyle(
                                    color: Hexcolor('EA6012'),
                                    fontFamily: 'OpenSans-Regular',
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                        Row(children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 20),
                            child: Text(
                              'Inicio/Fin',
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Radio(
                            value: 1,
                            groupValue: selectedRadio5,
                            activeColor: Colors.green,
                            onChanged: (val) {
                              print("sr5 $val");
                              setSelectedRadio5(val);
                            },
                          ),
                          Text('Duración',
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold)),
                          Radio(
                            value: 2,
                            groupValue: selectedRadio5,
                            activeColor: Colors.green,
                            onChanged: (val) {
                              print("sr5 $val");
                              setSelectedRadio5(val);
                            },
                          ),
                        ]),
                        if (selectedRadio5 == 1) ...[
                          Row(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Container(
                                      margin: EdgeInsets.only(left: 20),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          'Hora Inicio',
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 17),
                                        ),
                                      )),
                                  Container(
                                      margin: EdgeInsets.only(left: 10),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          _time4,
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 17),
                                        ),
                                      )),
                                ],
                              ),
                              IconButton(
                                icon: Icon(Icons.timer),
                                color: Hexcolor('EA6012'),
                                onPressed: () {
                                  DatePicker.showTimePicker(context,
                                      theme: DatePickerTheme(
                                          containerHeight: 210.0,
                                          doneStyle: TextStyle(
                                              color: Hexcolor('EA6012'))),
                                      showTitleActions: true,
                                      onConfirm: (time4) {
                                    print('confirm $time4');
                                    hourClock4 = time4;
                                    String formattedTime4 =
                                        DateFormat('hh:mm:aa').format(time4);
                                    _time4 = formattedTime4;
                                    setState(() {});
                                  },
                                      currentTime: DateTime.now(),
                                      locale: LocaleType.en);
                                  setState(() {});
                                },
                              ),
                              Column(
                                children: <Widget>[
                                  Container(
                                      margin: EdgeInsets.only(left: 30),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          'Hora Fin',
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 17),
                                        ),
                                      )),
                                  Container(
                                      margin: EdgeInsets.only(left: 30),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          _time5,
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 17),
                                        ),
                                      )),
                                ],
                              ),
                              IconButton(
                                icon: Icon(Icons.timer_off),
                                color: Hexcolor('EA6012'),
                                onPressed: () {
                                  DatePicker.showTimePicker(context,
                                      theme: DatePickerTheme(
                                          containerHeight: 210.0,
                                          doneStyle: TextStyle(
                                              color: Hexcolor('EA6012'))),
                                      showTitleActions: true,
                                      onConfirm: (time5) {
                                    print('confirm $time5');
                                    hourClock5 = time5;
                                    String formattedTime5 =
                                        DateFormat('hh:mm:aa').format(time5);
                                    _time5 = formattedTime5;
                                    setState(() {});
                                  },
                                      currentTime: DateTime.now(),
                                      locale: LocaleType.en);
                                  setState(() {});
                                },
                              ),
                            ],
                          )
                        ],
                        if (selectedRadio5 == 2) ...[
                          Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: TextFormField(
                              // initialValue: _initValuesU['dependents_number'],
                              decoration: InputDecoration(
                                  labelText: 'Duración en minutos'),
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Es obligatorio!';
                                }
                                return null;
                              },
                              onChanged: (value) => setState(() {
                                durationStandBy = value;
                              }),
                            ),
                          ),
                        ],
                      ],
                      Container(
                          margin: EdgeInsets.only(left: 20, top: 15),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              '¿Hubo un viaje de ida al sitio de trabajo?',
                              style: TextStyle(
                                  color: Hexcolor('EA6012'),
                                  fontFamily: 'OpenSans-Regular',
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
                            ),
                          )),
                      Row(children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Text(
                            'Si',
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Radio(
                          value: 1,
                          groupValue: selectedRadio6,
                          activeColor: Colors.green,
                          onChanged: (val) {
                            print("$val");
                            setSelectedRadio6(val);
                          },
                        ),
                        Text('No',
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold)),
                        Radio(
                          value: 2,
                          groupValue: selectedRadio6,
                          activeColor: Colors.green,
                          onChanged: (val) {
                            print("$val");
                            setSelectedRadio6(val);
                          },
                        ),
                      ]),
                      if (selectedRadio6 == 1) ...[
                        Container(
                            margin: EdgeInsets.only(left: 20),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                '¿Deseas indicar la hora de inicio/fin o la duración?',
                                style: TextStyle(
                                    color: Hexcolor('EA6012'),
                                    fontFamily: 'OpenSans-Regular',
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                        Row(children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 20),
                            child: Text(
                              'Inicio/Fin',
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Radio(
                            value: 1,
                            groupValue: selectedRadio7,
                            activeColor: Colors.green,
                            onChanged: (val) {
                              print("sr7 $val");
                              setSelectedRadio7(val);
                            },
                          ),
                          Text('Duración',
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold)),
                          Radio(
                            value: 2,
                            groupValue: selectedRadio7,
                            activeColor: Colors.green,
                            onChanged: (val) {
                              print("sr7 $val");
                              setSelectedRadio7(val);
                            },
                          ),
                        ]),
                        if (selectedRadio7 == 1) ...[
                          Row(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Container(
                                      margin: EdgeInsets.only(left: 20),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          'Hora Inicio',
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 17),
                                        ),
                                      )),
                                  Container(
                                      margin: EdgeInsets.only(left: 10),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          _time6,
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 17),
                                        ),
                                      )),
                                ],
                              ),
                              IconButton(
                                icon: Icon(Icons.timer),
                                color: Hexcolor('EA6012'),
                                onPressed: () {
                                  DatePicker.showTimePicker(context,
                                      theme: DatePickerTheme(
                                          containerHeight: 210.0,
                                          doneStyle: TextStyle(
                                              color: Hexcolor('EA6012'))),
                                      showTitleActions: true,
                                      onConfirm: (time6) {
                                    print('confirm $time6');
                                    hourClock6 = time6;
                                    String formattedTime6 =
                                        DateFormat('hh:mm:aa').format(time6);
                                    _time6 = formattedTime6;
                                    setState(() {});
                                  },
                                      currentTime: DateTime.now(),
                                      locale: LocaleType.en);
                                  setState(() {});
                                },
                              ),
                              Column(
                                children: <Widget>[
                                  Container(
                                      margin: EdgeInsets.only(left: 30),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          'Hora Fin',
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 17),
                                        ),
                                      )),
                                  Container(
                                      margin: EdgeInsets.only(left: 30),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          _time7,
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 17),
                                        ),
                                      )),
                                ],
                              ),
                              IconButton(
                                icon: Icon(Icons.timer_off),
                                color: Hexcolor('EA6012'),
                                onPressed: () {
                                  DatePicker.showTimePicker(context,
                                      theme: DatePickerTheme(
                                          containerHeight: 210.0,
                                          doneStyle: TextStyle(
                                              color: Hexcolor('EA6012'))),
                                      showTitleActions: true,
                                      onConfirm: (time7) {
                                    print('confirm $time7');
                                    hourClock7 = time7;
                                    String formattedTime7 =
                                        DateFormat('hh:mm:aa').format(time7);
                                    _time7 = formattedTime7;
                                    setState(() {});
                                  },
                                      currentTime: DateTime.now(),
                                      locale: LocaleType.en);
                                  setState(() {});
                                },
                              ),
                            ],
                          )
                        ],
                        if (selectedRadio7 == 2) ...[
                          Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: TextFormField(
                              // initialValue: _initValuesU['dependents_number'],
                              decoration: InputDecoration(
                                  labelText: 'Duración en horas o minutos'),
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Es obligatorio!';
                                }
                                return null;
                              },
                              onChanged: (value) => setState(() {
                                durationTravel = value;
                              }),
                            ),
                          ),
                        ],
                        Container(
                            margin: EdgeInsets.only(left: 20, top: 15),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                '¿Hubo un viaje de retorno?',
                                style: TextStyle(
                                    color: Hexcolor('EA6012'),
                                    fontFamily: 'OpenSans-Regular',
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                        Row(children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 20),
                            child: Text(
                              'Si',
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Radio(
                            value: 1,
                            groupValue: selectedRadio8,
                            activeColor: Colors.green,
                            onChanged: (val) {
                              print("$val");
                              setSelectedRadio8(val);
                            },
                          ),
                          Text('No',
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold)),
                          Radio(
                            value: 2,
                            groupValue: selectedRadio8,
                            activeColor: Colors.green,
                            onChanged: (val) {
                              print("$val");
                              setSelectedRadio8(val);
                            },
                          ),
                        ]),
                        if (selectedRadio8 == 1) ...[
                          Container(
                              margin: EdgeInsets.only(left: 20),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  '¿Deseas indicar la hora de inicio/fin o la duración?',
                                  style: TextStyle(
                                      color: Hexcolor('EA6012'),
                                      fontFamily: 'OpenSans-Regular',
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                          Row(children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(left: 20),
                              child: Text(
                                'Inicio/Fin',
                                style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Radio(
                              value: 1,
                              groupValue: selectedRadio9,
                              activeColor: Colors.green,
                              onChanged: (val) {
                                print("sr9 $val");
                                setSelectedRadio9(val);
                              },
                            ),
                            Text('Duración',
                                style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold)),
                            Radio(
                              value: 2,
                              groupValue: selectedRadio9,
                              activeColor: Colors.green,
                              onChanged: (val) {
                                print("sr9 $val");
                                setSelectedRadio9(val);
                              },
                            ),
                          ]),
                          if (selectedRadio9 == 1) ...[
                            Row(
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Container(
                                        margin: EdgeInsets.only(left: 20),
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            'Hora Inicio',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 17),
                                          ),
                                        )),
                                    Container(
                                        margin: EdgeInsets.only(left: 10),
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            _time8,
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 17),
                                          ),
                                        )),
                                  ],
                                ),
                                IconButton(
                                  icon: Icon(Icons.timer),
                                  color: Hexcolor('EA6012'),
                                  onPressed: () {
                                    DatePicker.showTimePicker(context,
                                        theme: DatePickerTheme(
                                            containerHeight: 210.0,
                                            doneStyle: TextStyle(
                                                color: Hexcolor('EA6012'))),
                                        showTitleActions: true,
                                        onConfirm: (time8) {
                                      print('confirm $time8');
                                      hourClock8 = time8;
                                      String formattedTime8 =
                                          DateFormat('hh:mm:aa').format(time8);
                                      _time8 = formattedTime8;
                                      setState(() {});
                                    },
                                        currentTime: DateTime.now(),
                                        locale: LocaleType.en);
                                    setState(() {});
                                  },
                                ),
                                Column(
                                  children: <Widget>[
                                    Container(
                                        margin: EdgeInsets.only(left: 30),
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            'Hora Fin',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 17),
                                          ),
                                        )),
                                    Container(
                                        margin: EdgeInsets.only(left: 30),
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            _time9,
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 17),
                                          ),
                                        )),
                                  ],
                                ),
                                IconButton(
                                  icon: Icon(Icons.timer_off),
                                  color: Hexcolor('EA6012'),
                                  onPressed: () {
                                    DatePicker.showTimePicker(context,
                                        theme: DatePickerTheme(
                                            containerHeight: 210.0,
                                            doneStyle: TextStyle(
                                                color: Hexcolor('EA6012'))),
                                        showTitleActions: true,
                                        onConfirm: (time9) {
                                      print('confirm $time9');
                                      hourClock9 = time9;
                                      String formattedTime9 =
                                          DateFormat('hh:mm:aa').format(time9);
                                      _time9 = formattedTime9;
                                      setState(() {});
                                    },
                                        currentTime: DateTime.now(),
                                        locale: LocaleType.en);
                                    setState(() {});
                                  },
                                ),
                              ],
                            )
                          ],
                          if (selectedRadio9 == 2) ...[
                            Container(
                              margin: EdgeInsets.only(left: 20, right: 20),
                              child: TextFormField(
                                // initialValue: _initValuesU['dependents_number'],
                                decoration: InputDecoration(
                                    labelText: 'Duración en horas o minutos'),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Es obligatorio!';
                                  }
                                  return null;
                                },
                                onChanged: (value) => setState(() {
                                  durationReturn = value;
                                }),
                              ),
                            ),
                          ],
                        ],
                      ],
                      Container(
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child: TextFormField(
                            initialValue: '',
                            decoration:
                                InputDecoration(labelText: 'Comentarios'),
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.next,
                            maxLength: 1000,
                            onChanged: (value) {
                              setState(() {
                                comments = value;
                              });
                            },
                          )),
                      Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              '¿Deseas agregar archivos adjuntos?',
                              style: TextStyle(
                                  color: Hexcolor('EA6012'),
                                  fontFamily: 'OpenSans-Regular',
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
                            ),
                          )),
                      Row(children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Text(
                            'Desde Galeria',
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(
                            icon: Icon(
                              Icons.image,
                              color: Hexcolor('EA6012'),
                            ),
                            onPressed: () {
                              _openGallery();
                            }),
                        Text('Desde Camara',
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold)),
                        IconButton(
                            icon: Icon(
                              Icons.camera,
                              color: Hexcolor('EA6012'),
                            ),
                            onPressed: () {
                              _openCamera();
                            }),
                      ]),
                      Container(
                          height: MediaQuery.of(context).size.height * .4,
                          decoration:
                              BoxDecoration(border: Border.all(width: 2)),
                          child: imageArray.isEmpty
                              ? Center(child: Text('No Images'))
                              : GridView.count(
                                  crossAxisCount: 3,
                                  children:
                                      List.generate(imageArray.length, (index) {
                                    var img = imageArray[index];
                                    return Image.file(img);
                                  }),
                                )),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            width: 350,
                            height: 50.0,
                            // margin: EdgeInsets.only(left:15),
                            child: isLoading
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : RaisedButton(
                                    elevation: 5.0,
                                    onPressed: _submit,
                                    // padding: EdgeInsets.only(left: 20, right: 20,top: 15, bottom: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    color: Hexcolor('009444'),
                                    child: Text(
                                      'Registrar',
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
                      SizedBox(
                        height: 15,
                      ),
                    ])))),
        bottomNavigationBar: AppBarButton(
          user: user,
          selectIndex: 0,
        ));
  }

  _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(hintText: 'Search...'),
        onChanged: (text) {
          text = text.toLowerCase();
          setState(() {
            _workersForDisplay = _workers.where((worker) {
              var workTitle = worker.btn_id.toLowerCase();
              return workTitle.contains(text);
            }).toList();
          });
        },
      ),
    );
  }

  _listItem(index) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(
            top: 32.0, bottom: 32.0, left: 16.0, right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              _workersForDisplay[index].btn_id,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              _workersForDisplay[index].text,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  // ignore: unused_element

}
