import 'package:shared_preferences/shared_preferences.dart';
import 'package:worker/model/warnings.dart';
import 'package:worker/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../model/user.dart';
import '../../model/workday.dart';

import '../widgets.dart';

class DetailBanns extends StatefulWidget {
  static const routeName = '/detail-banns';
  final User user;
  final Warnings workday;

  DetailBanns({@required this.user, @required this.workday});

  @override
  _DetailBannsState createState() => _DetailBannsState(user, workday);
}

class _DetailBannsState extends State<DetailBanns> {
  User user;
  Warnings workday;
  _DetailBannsState(this.user, this.workday);

  // ignore: unused_field
  int _selectedIndex = 4;

  getToken() async {
    SharedPreferences token = await SharedPreferences.getInstance();
    String stringValue = token.getString('stringValue');
    return stringValue;
  }

  @override
  void initState() {
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
        // ignore: missing_required_param
        endDrawer: MenuLateral(
          user: user,
        ),
        body: SingleChildScrollView(
            child: Container(
                margin: EdgeInsets.only(top: 30),
                child: Column(children: <Widget>[
                  Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.only(left: 20),
                            child: Image.asset(
                              'assets/amonestacion.png',
                              width: 50,
                            )),
                        Container(
                          margin: EdgeInsets.only(left: 10, top: 15),
                          child: Text('Detalle Amonestación',
                              style: TextStyle(
                                  color: Hexcolor('EA6012'),
                                  fontFamily: 'OpenSans-Regular',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ]),
                  Container(
                      margin: EdgeInsets.only(left: 20, top: 10),
                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                              // margin: EdgeInsets.only(right: 70),
                              child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'Fecha de creación:',
                                    style: TextStyle(
                                        color: Hexcolor('EA6012'),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ))),
                          Container(
                              margin: EdgeInsets.only(left: 15),
                              child: Text(
                                  '${this.widget.workday.occurrence_date}',
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.grey)))
                        ],
                      )),
                  Container(
                      margin: EdgeInsets.only(left: 20, top: 15),
                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                              // margin: EdgeInsets.only(right: 70),
                              child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'Tipo de amonestación:',
                                    style: TextStyle(
                                        color: Hexcolor('EA6012'),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ))),
                          Container(
                              margin: EdgeInsets.only(left: 15),
                              child: Text(this.widget.workday.warning_type,
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.grey)))
                        ],
                      )),
                  Container(
                      margin: EdgeInsets.only(left: 20, top: 15),
                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                              // margin: EdgeInsets.only(right: 70),
                              child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'Contrato:',
                                    style: TextStyle(
                                        color: Hexcolor('EA6012'),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ))),
                          Container(
                              margin: EdgeInsets.only(left: 15),
                              child: Text(this.widget.workday.contract,
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.grey)))
                        ],
                      )),
                  Container(
                      margin: EdgeInsets.only(left: 20, top: 15),
                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                              // margin: EdgeInsets.only(right: 70),
                              child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'Motivo:',
                                    style: TextStyle(
                                        color: Hexcolor('EA6012'),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ))),
                          Container(
                              margin: EdgeInsets.only(left: 15),
                              child: Text(this.widget.workday.reason,
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.grey)))
                        ],
                      )),
                  Container(
                      margin: EdgeInsets.only(left: 20, top: 15),
                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                              // margin: EdgeInsets.only(right: 70),
                              child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'Fecha de ocurrencia del evento:',
                                    style: TextStyle(
                                        color: Hexcolor('EA6012'),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ))),
                          Container(
                              margin: EdgeInsets.only(left: 15),
                              child: Text(
                                  '${this.widget.workday.occurrence_date}',
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.grey)))
                        ],
                      )),
                  Container(
                      margin: EdgeInsets.only(left: 20, top: 15),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Descripción de los hechos:',
                            style: TextStyle(
                                color: Hexcolor('EA6012'),
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ))),
                  Container(
                      margin: EdgeInsets.only(left: 20, right: 20, top: 15),
                      child: Text(
                        this.widget.workday.description,
                        style: TextStyle(fontSize: 17, color: Colors.grey),
                        textAlign: TextAlign.justify,
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        width: 150,
                        height: 50.0,
                        // margin: EdgeInsets.only(left:15),
                        child: RaisedButton(
                          elevation: 5.0,
                          onPressed: () {},
                          // padding: EdgeInsets.only(left: 20, right: 20,top: 15, bottom: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          color: Hexcolor('009444'),
                          child: Text(
                            'Modificar',
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
                          onPressed: () {},
                          // padding: EdgeInsets.only(left: 20, right: 20,top: 10, bottom: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          color: Hexcolor('EA6012'),
                          child: Text(
                            'Eliminar',
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
                ]))),
        bottomNavigationBar: AppBarButton(
          user: user,
          selectIndex: 0,
        ));
  }

  // ignore: unused_element

}
