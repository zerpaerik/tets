import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:worker/model/workday.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../model/user.dart';
import '../../providers/workday.dart';
import '../widgets.dart';

class DetailClockIn extends StatefulWidget {
  final User user;

  DetailClockIn({@required this.user});

  @override
  _DetailClockInState createState() => _DetailClockInState(user);
}

class _DetailClockInState extends State<DetailClockIn> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  User user;
  Workday _wd;
  _DetailClockInState(this.user);
  //DateFormat format = DateFormat("yyyy-MM-dd");
  bool isLoading = false;
  // DateTime hour = DateFormat('HH:mm').format(DateTime.now()) as DateTime;
  final hour = new DateTime.now();
  DateFormat dateFormat = DateFormat("HH:mm:ss");
  String _time = "Sin Cambios";
  DateTime hourClock;
  String qrCodeResult = "Not Yet Scanned";

  String _locationMessage = "";

  // String formatter = DateFormat('yMd').format(hour);
  //int time = DateTime.now().millisecondsSinceEpoch;
  //String t = "$time";

  todayDateTime() {
    var now = new DateTime.now();
    String formattedTime = DateFormat('hh:mm:aa').format(now);
    return formattedTime;
  }

  todayDateTimeWork() {
    var now = _wd.clock_in_start;
    String formattedTime = DateFormat('hh:mm:aa').format(now);
    return formattedTime;
  }

  getCurrency() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  getHworkDay() async {
    SharedPreferences hworkday = await SharedPreferences.getInstance();
    String stringValue = hworkday.getString('stringValue');
    return stringValue;
  }

  void _viewWorkDay() {
    Provider.of<WorkDay>(context, listen: false).fetchWorkDay().then((value) {
      setState(() {
        _wd = value;
      });
    });
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

  void _showErrorDialogADD(String message) {
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
          ),
          FlatButton(
            child: Text('Enviar oferta.'),
            textColor: Hexcolor('EA6012'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<bool> scanQRWorker(String identification) async {
    final response = await http.get(
        'http://emplooy.turpialdev.webfactional.com/api/v-1/user/get-registered-user/$identification/1/in',
        headers: {
          "Authorization": "Token 4ead92aa67e22337c35db38e019437eba1fe4ab5"
        });

    // ignore: await_only_futures
    print(response.body);
    var resBody = json.decode(response.body);

    if (response.statusCode == 200 && resBody['first_name'] != null) {
      print('dio 200 scan list');
      User _user = new User.fromJson1(resBody);

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetailClockIn(
                  user: _user,
                )),
      );
    } else {
      print('dio error');
      //The worker has already clocked-in
      String error = resBody['detail'];
      if (error == 'worker not belongs to a project') {
        _showErrorDialogADD('El trabajador no esta dentro del proyecto.');
      }
      if (error == 'The worker has already clocked-in') {
        _showErrorDialog('El trabajador ya hizo clock in en la jornada.');
      }
      /*else {
        _showErrorDialog('Verifique la información.');
      }*/
    }
  }

  Future<void> _scan() async {
    String codeSanner = await BarcodeScanner.scan(); //barcode scnner
    setState(() {
      qrCodeResult = codeSanner;
    });
    print(qrCodeResult);
    bool scanResult = await scanQRWorker(qrCodeResult);
  }

  Future<void> _submit() async {
    setState(() {
      isLoading = true;
    });
    try {
      Provider.of<WorkDay>(context, listen: false)
          .addClockIn(user.id, hourClock, _locationMessage, _wd)
          .then((response) {
        setState(() {
          isLoading = false;
        });
        if (response == '201') {
          //_scan();
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ListClockIn(
                    user: user,
                    workday: _wd.id,
                    workday_date: _wd.clock_in_end)),
          );
        } else {
          _showErrorDialog('Verifique la información');
        }
      });
    } catch (error) {}
    /* Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfilePartOblig2()),
          );*/
  }

  @override
  void initState() {
    _viewWorkDay();
    getCurrency();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        endDrawer: MenuLateral(
          user: user,
          workday: _wd != null ? _wd.id : null,
        ),
        body: Form(
            key: _formKey,
            child: SingleChildScrollView(
                child: Container(
                    margin: EdgeInsets.only(top: 30),
                    child: Column(children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 30, right: 30),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text('Clock-in',
                              style: TextStyle(
                                color: Hexcolor('EA6012'),
                                //letterSpacing: 1,
                                fontSize: 19.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'OpenSans-Regular',
                              )),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 30),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Proyecto 000001',
                                style: TextStyle(
                                    color: Hexcolor('252850'),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 143, right: 30),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Text(
                                todayDateTime(),
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 20),
                      Container(
                        margin: EdgeInsets.only(left: 30, right: 30),
                        child: Card(
                          elevation: 3,
                          color: Hexcolor('F7F7F7'),
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Container(
                                          margin: EdgeInsets.only(left: 20),
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                                user.first_name +
                                                    ' ' +
                                                    user.last_name,
                                                style: TextStyle(
                                                    color: Hexcolor('252850'),
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          )),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 20),
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Text('ID#' + user.btn_id,
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      )
                                    ],
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                      left: 120,
                                    ),
                                    child: Image.asset(
                                      'assets/clock-in-inicio.png',
                                      width: 70,
                                    ),
                                  )
                                ],
                              ),
                              Divider(
                                color: Hexcolor('EA6012'),
                                // height: 1,
                                thickness: 2,
                                indent: 15,
                                endIndent: 15,
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(left: 20),
                                    child: Image.asset(
                                      'assets/clock1.png',
                                      width: 30,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 20),
                                    child: Text(
                                      'Hora de escaneo:',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 17,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 20),
                                    child: Text(
                                      todayDateTime(),
                                      style: TextStyle(
                                        color: Hexcolor('EA6012'),
                                        fontSize: 17,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(left: 20),
                                    child: Image.asset(
                                      'assets/clock2.png',
                                      width: 30,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 20),
                                    child: Text(
                                      'Hora de clock-in:',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 17,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 20),
                                    child: Text(
                                      _wd != null ? todayDateTimeWork() : '0',
                                      style: TextStyle(
                                        color: Hexcolor('EA6012'),
                                        fontSize: 17,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(left: 20),
                                    child: Image.asset(
                                      'assets/coordenadas.png',
                                      width: 30,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 20),
                                    child: Text(
                                      'Coord.Geo:',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 17,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 20),
                                    child: Text(
                                      '26.2  12.5 ',
                                      style: TextStyle(
                                        color: Hexcolor('EA6012'),
                                        fontSize: 17,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(left: 20),
                                    child: Image.asset(
                                      'assets/clock3.png',
                                      width: 33,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 20),
                                    child: Text(
                                      'Hizo clock-in hoy?:',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 17,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 20),
                                    child: Text(
                                      'Si',
                                      style: TextStyle(
                                        color: Hexcolor('EA6012'),
                                        fontSize: 17,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(left: 20),
                                    child: Image.asset(
                                      'assets/verificado.png',
                                      width: 30,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 20),
                                    child: Text(
                                      'Esta verificado?:',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 17,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 20),
                                    child: Text(
                                      'Si',
                                      style: TextStyle(
                                        color: Hexcolor('EA6012'),
                                        fontSize: 17,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0)),
                                elevation: 4.0,
                                onPressed: () {
                                  DatePicker.showTimePicker(context,
                                      theme: DatePickerTheme(
                                          containerHeight: 210.0,
                                          doneStyle: TextStyle(
                                              color: Hexcolor('EA6012'))),
                                      showTitleActions: true,
                                      onConfirm: (time) {
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
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 50.0,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Container(
                                            child: Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.access_time,
                                                  size: 17.0,
                                                  color: Hexcolor('EA6012'),
                                                ),
                                                Text(
                                                  " $_time",
                                                  style: TextStyle(
                                                      color: Hexcolor('EA6012'),
                                                      fontSize: 17.0),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      Text(
                                        "Cambiar Hora Clock in",
                                        style: TextStyle(
                                            color: Hexcolor('EA6012'),
                                            fontSize: 17.0),
                                      ),
                                    ],
                                  ),
                                ),
                                color: Colors.white,
                              ),
                              SizedBox(
                                height: 10,
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 30, right: 30),
                        width: 360,
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
                                  'Aceptar',
                                  style: TextStyle(
                                    color: Colors.white,
                                    letterSpacing: 1,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'OpenSans',
                                  ),
                                ),
                              ),
                      )
                    ])))),
        bottomNavigationBar: AppBarButton(
          user: user,
          selectIndex: 0,
        ));
  }
}
