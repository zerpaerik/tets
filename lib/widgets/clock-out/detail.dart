import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:worker/model/workday.dart';
import 'dart:async';

import '../../model/user.dart';
import '../../model/clock.dart';
import '../../providers/workday.dart';
import '../widgets.dart';

class DetailClockOut extends StatefulWidget {
  final User user;
  final int workday;

  DetailClockOut({@required this.user, @required this.workday});

  @override
  _DetailClockOutState createState() => _DetailClockOutState(user, workday);
}

class _DetailClockOutState extends State<DetailClockOut> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  User user;
  int workday;
  Workday _wd;
  _DetailClockOutState(this.user, this.workday);
  //DateFormat format = DateFormat("yyyy-MM-dd");
  bool isLoading = false;
  // DateTime hour = DateFormat('HH:mm').format(DateTime.now()) as DateTime;
  final hour = new DateTime.now();
  Clocks clock;
  DateFormat dateFormat = DateFormat("HH:mm:ss");
  String _time = "Sin Cambios";

  String _locationMessage = "";

  Future<String> _getCurrentLocation() async {
    final position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position);

    setState(() {
      _locationMessage = "${position.latitude}, ${position.longitude}";
      print(_locationMessage);
    });
  }

  // String formatter = DateFormat('yMd').format(hour);
  //int time = DateTime.now().millisecondsSinceEpoch;
  //String t = "$time";

  todayDateTime() {
    var now = new DateTime.now();
    String formattedTime = DateFormat('kk:mm:a').format(now);
    return formattedTime;
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

  Future<void> _submit() async {
    setState(() {
      isLoading = true;
    });
    try {
      Provider.of<WorkDay>(context, listen: false)
          .addClockOut(this.widget.user.id, _time, this.widget.workday)
          .then((response) {
        setState(() {
          isLoading = false;
          clock = response;
        });
        if (clock != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ListClockOut(
                      user: user,
                      workday: this.widget.workday,
                      workday_date: _wd.clock_out_end,
                    )),
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
    this._getCurrentLocation();
    _viewWorkDay();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(_locationMessage);
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
          workday: this.widget.workday,
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
                          child: Text('Clock Out',
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
                            margin: EdgeInsets.only(left: 140, right: 30),
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
                                      'Hora de clock-out:',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 17,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 20),
                                    child: Text(
                                      'Por Definir',
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
                                      '26.2 12.5',
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
                                  _getCurrentLocation();
                                  DatePicker.showTimePicker(context,
                                      theme: DatePickerTheme(
                                          containerHeight: 210.0,
                                          doneStyle: TextStyle(
                                              color: Hexcolor('EA6012'))),
                                      showTitleActions: true,
                                      onConfirm: (time) {
                                    print('confirm $time');
                                    _time =
                                        '${time.hour} : ${time.minute} : ${time.second}';
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
                                        "Cambiar Hora Clock out",
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
