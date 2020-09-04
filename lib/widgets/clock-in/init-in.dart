import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../model/user.dart';
import '../widgets.dart';

class ClockIn extends StatefulWidget {
  final User user;

  ClockIn({@required this.user});

  @override
  _ClockInState createState() => _ClockInState(user);
}

class _ClockInState extends State<ClockIn> {
  User user;
  _ClockInState(this.user);
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
        body: SingleChildScrollView(
            child: Container(
                margin: EdgeInsets.only(top: 50),
                child: Column(children: <Widget>[
                  SizedBox(height: 30),
                  Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/init_clockin.png',
                        width: 200,
                      )),
                  SizedBox(height: 20),
                  Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          '¿Desea iniciar el proceso de Clock-in?',
                          style: TextStyle(
                            color: Hexcolor('252850'),
                            fontFamily: 'OpenSans-Regular',
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      )),
                  SizedBox(height: 150),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        width: 150,
                        height: 50.0,
                        // margin: EdgeInsets.only(left:15),
                        child: RaisedButton(
                          elevation: 5.0,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ScanQr(
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
                            'Si',
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
                        width: 150,
                        height: 50.0,
                        child: RaisedButton(
                          elevation: 5.0,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => InitClockIn(
                                        user: user,
                                      )),
                            );
                          },
                          // padding: EdgeInsets.only(left: 20, right: 20,top: 10, bottom: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          color: Hexcolor('EA6012'),
                          child: Text(
                            'No',
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
                ]))),
        bottomNavigationBar: AppBarButton(
          user: user,
          selectIndex: 0,
        ));
  }
}
