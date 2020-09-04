import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:worker/providers/workday.dart';
import '../widgets.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../model/user.dart';
import '../../model/workday.dart';

class MenuLateral extends StatefulWidget {
  final User user;
  final int workday;

  MenuLateral({@required this.user, @required this.workday});

  @override
  _MenuLateralState createState() => _MenuLateralState(user, workday);
}

class _MenuLateralState extends State<MenuLateral> {
  User user;
  int workday;
  _MenuLateralState(this.user, this.workday);
  Workday _wd;

  getWorkDay() async {
    SharedPreferences workday = await SharedPreferences.getInstance();
    //Return String
    int intValue = workday.getInt('intValue');
    return intValue;
  }

  Future<String> getSWData() async {
    var res = await http.get(
        'http://emplooy.turpialdev.webfactional.com/api/v-1/workday/1/get-current',
        headers: {
          "Authorization": "Token 4ead92aa67e22337c35db38e019437eba1fe4ab5"
        });
    var resBody = json.decode(res.body);
    print(resBody);

    if (res.statusCode == 200) {
      setState(() {
        _wd = Workday.fromJson(resBody);
      });
    } else {
      // print(res.statusCode);
    }

    return "Sucess";
  }

  @override
  void initState() {
    this.getSWData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 210,
      child: Drawer(
          child: ListView(children: <Widget>[
        SizedBox(
          //height : 20.0,
          child: Row(children: <Widget>[
            Container(
                margin: EdgeInsets.only(left: 20, top: 12),
                child: Image.asset('assets/worker.png', width: 25)),
            Container(
              margin: EdgeInsets.only(left: 10, top: 12),
              child: user != null
                  ? Text('ID#' + ' ' + user.btn_id,
                      style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'OpenSans-Regular',
                          fontSize: 18,
                          fontWeight: FontWeight.bold))
                  : Text('ID# 0001',
                      style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'OpenSans-Regular',
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
            )
          ]),
        ),
        Container(
          margin: EdgeInsets.only(top: 2),
          child: Divider(),
        ),
        Container(
            margin: EdgeInsets.only(left: 10),
            child: Align(
                alignment: Alignment.topLeft,
                child: FlatButton.icon(
                    onPressed: () {
                      if (this.widget.workday != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ListClockIn(
                                    user: user,
                                    workday: this.widget.workday,
                                    workday_date: _wd.clock_in_end,
                                  )),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InitClockIn(user: user)),
                        );
                      }
                    },
                    icon: ImageIcon(
                      AssetImage('assets/clock-in-lat.png'),
                      color: Colors.grey,
                    ),
                    label: Text(
                      'Clock In',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    )))),
        Divider(),
        Container(
            margin: EdgeInsets.only(left: 10),
            child: Align(
                alignment: Alignment.topLeft,
                child: FlatButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ListClockOut(
                                  user: user,
                                  workday: _wd != null ? _wd.id : 47,
                                  workday_date: _wd.clock_out_end,
                                )),
                      );
                    },
                    icon: ImageIcon(
                      AssetImage('assets/clock-out-lat.png'),
                      color: Colors.grey,
                    ),
                    label: Text(
                      'Clock Out',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    )))),
        Divider(),
        Container(
            margin: EdgeInsets.only(left: 10),
            child: Align(
                alignment: Alignment.topLeft,
                child: FlatButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WorkDayPage(
                                user: user, workday: this.widget.workday)),
                      );
                    },
                    icon: ImageIcon(
                      AssetImage('assets/002-data.png'),
                      color: Colors.grey,
                    ),
                    label: Text(
                      'Reporte del Dia',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    )))),
        Divider(),
        Container(
            margin: EdgeInsets.only(left: 10),
            child: Align(
                alignment: Alignment.topLeft,
                child: FlatButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BannsLeadPage(user: user)),
                      );
                    },
                    icon: ImageIcon(
                      AssetImage('assets/amonestaciones.png'),
                      color: Colors.grey,
                    ),
                    label: Text(
                      'Amonestaciones',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    )))),
        Divider(),
        Container(
            margin: EdgeInsets.only(left: 10),
            child: Align(
                alignment: Alignment.topLeft,
                child: FlatButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ExpensesPage(user: user)),
                      );
                    },
                    icon: ImageIcon(
                      AssetImage('assets/gastos.png'),
                      color: Colors.grey,
                    ),
                    label: Text(
                      'Gastos',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    )))),
        Divider(),
        Container(
            margin: EdgeInsets.only(left: 10),
            child: Align(
                alignment: Alignment.topLeft,
                child: FlatButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ConfigPage()),
                      );
                    },
                    icon: ImageIcon(
                      AssetImage('assets/005-gear.png'),
                      color: Colors.grey,
                    ),
                    label: Text(
                      'Configuración',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    )))),
        Divider(),
      ])),
    );
  }
}
