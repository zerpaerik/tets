import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import '../../model/user.dart';
import '../widgets.dart';

class ConfirmClockOut extends StatefulWidget {
  final User user;

  ConfirmClockOut({@required this.user});

  @override
  _ConfirmClockOutState createState() => _ConfirmClockOutState(user);
}

class _ConfirmClockOutState extends State<ConfirmClockOut> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  User user;
  _ConfirmClockOutState(this.user);
  String _date = "Not set";
  String _time = "Not set";

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
        ),
        body: Form(
            key: _formKey,
            child: SingleChildScrollView(
                child: Container(
                    margin: EdgeInsets.only(top: 50),
                    child: Column(children: <Widget>[
                      SizedBox(height: 30),
                      Align(
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/clock-in-inicio.png',
                            width: 200,
                          )),
                      SizedBox(height: 50),
                      Container(
                          margin: EdgeInsets.only(left: 30, right: 30),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Para terminar el Clock-in Inicial haga clic en el botón.',
                              style: TextStyle(
                                color: Hexcolor('252850'),
                                fontFamily: 'OpenSans-Regular',
                                fontWeight: FontWeight.bold,
                                fontSize: 19,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        elevation: 4.0,
                        onPressed: () {
                          DatePicker.showTimePicker(context,
                              theme: DatePickerTheme(
                                containerHeight: 210.0,
                              ),
                              showTitleActions: true, onConfirm: (time) {
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.access_time,
                                          size: 18.0,
                                          color: Colors.teal,
                                        ),
                                        Text(
                                          " $_time",
                                          style: TextStyle(
                                              color: Colors.teal,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Text(
                                "  Change",
                                style: TextStyle(
                                    color: Colors.teal,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0),
                              ),
                            ],
                          ),
                        ),
                        color: Colors.white,
                      ),
                      SizedBox(height: 150),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 30, right: 30),
                            width: 360,
                            height: 50.0,
                            // margin: EdgeInsets.only(left:15),
                            child: RaisedButton(
                              elevation: 5.0,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DetailClockIn(
                                            user: user,
                                          )),
                                );
                              },
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
                          ),
                        ],
                      )
                    ])))),
        bottomNavigationBar: AppBarButton(
          user: user,
          selectIndex: 0,
        ));
  }
}
