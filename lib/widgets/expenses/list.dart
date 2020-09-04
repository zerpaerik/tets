import 'package:shared_preferences/shared_preferences.dart';
import 'package:worker/widgets/banns/detail.dart';
import 'package:worker/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../model/user.dart';
import '../widgets.dart';

class ExpensesPage extends StatefulWidget {
  static const routeName = '/my-banns-worker';
  final User user;

  ExpensesPage({@required this.user});

  @override
  _ExpensesPageState createState() => _ExpensesPageState(user);
}

class _ExpensesPageState extends State<ExpensesPage> {
  User user;
  _ExpensesPageState(this.user);

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
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                            margin: EdgeInsets.only(left: 15, top: 20),
                            child: Image.asset(
                              'assets/gastos_icon.png',
                              width: 50,
                            )),
                        Container(
                          margin: EdgeInsets.only(left: 10, top: 25),
                          child: Text('Listar Gastos',
                              style: TextStyle(
                                  color: Hexcolor('EA6012'),
                                  fontFamily: 'OpenSans-Regular',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ]),
                  Card(
                    elevation: 5,
                    margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                    color: Colors.white,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              margin:
                                  EdgeInsets.only(left: 15, right: 80, top: 15),
                              child: Text(
                                'Gasto de Traslado',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Hexcolor('EA6012'),
                                    fontSize: 17),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          color: Colors.grey[400],
                          // height: 1,
                          thickness: 1,
                          indent: 15,
                          endIndent: 15,
                        ),
                        Container(
                            margin: EdgeInsets.only(left: 15),
                            child: Row(
                              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Container(
                                    // margin: EdgeInsets.only(right: 70),
                                    child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          'Tipo de Gasto:',
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 17),
                                        ))),
                                Container(
                                    margin: EdgeInsets.only(left: 15),
                                    child: Text('Traslado de trabajadores.',
                                        style: TextStyle(fontSize: 17)))
                              ],
                            )),
                        Divider(
                          color: Colors.grey[400],
                          // height: 1,
                          thickness: 1,
                          indent: 15,
                          endIndent: 15,
                        ),
                        Row(children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(left: 13),
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Medio de Pago',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 15),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text('Efectivo'),
                                ],
                              )),
                          Container(
                              height: 50,
                              child: VerticalDivider(color: Colors.grey[400])),
                          Container(
                              margin: EdgeInsets.only(
                                  left: 30, right: 20, top: 5, bottom: 5),
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text('Monto',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 15),
                                      textAlign: TextAlign.center),
                                  Text('12.34'),
                                ],
                              )),
                          Container(
                              height: 50,
                              child: VerticalDivider(color: Colors.grey[400])),
                          Container(
                              margin: EdgeInsets.only(
                                  left: 20, right: 20, top: 5, bottom: 5),
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text('Fecha',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 15),
                                      textAlign: TextAlign.center),
                                  Text('05/08/2020'),
                                ],
                              )),
                        ]),
                        Divider(
                          color: Colors.grey[400],
                          // height: 1,
                          thickness: 1,
                          indent: 15,
                          endIndent: 15,
                        ),
                        Container(
                            margin: EdgeInsets.only(left: 15),
                            child: Row(
                              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Container(
                                    // margin: EdgeInsets.only(right: 70),
                                    child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          'Foto de la factura:',
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 17),
                                        ))),
                                Container(
                                    margin: EdgeInsets.only(left: 15),
                                    child: Text('factura1345.jpg',
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: Hexcolor('EA6012'))))
                              ],
                            )),

                        Divider(
                          color: Colors.grey[400],
                          // height: 1,
                          thickness: 1,
                          indent: 15,
                          endIndent: 15,
                        ),

                        SizedBox(
                          height: 20,
                        ),

                        SizedBox(
                            width: 800,
                            height: 30,
                            // margin: EdgeInsets.only(left: 190),
                            //padding: EdgeInsets.only(left: 60, right: 60),
                            child: RaisedButton(
                                color: Colors.grey,
                                onPressed: () {},
                                child: Text(
                                  'Ver Detalle',
                                  style: TextStyle(
                                    color: Colors.white,
                                    letterSpacing: 1,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'OpenSans',
                                  ),
                                ))),
                        //  SizedBox(height: 5)
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Card(
                    elevation: 5,
                    margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                    color: Colors.white,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              margin:
                                  EdgeInsets.only(left: 15, right: 80, top: 15),
                              child: Text(
                                'Gasto de Traslado',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Hexcolor('EA6012'),
                                    fontSize: 17),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          color: Colors.grey[400],
                          // height: 1,
                          thickness: 1,
                          indent: 15,
                          endIndent: 15,
                        ),
                        Container(
                            margin: EdgeInsets.only(left: 15),
                            child: Row(
                              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Container(
                                    // margin: EdgeInsets.only(right: 70),
                                    child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          'Tipo de Gasto:',
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 17),
                                        ))),
                                Container(
                                    margin: EdgeInsets.only(left: 15),
                                    child: Text('Traslado de trabajadores.',
                                        style: TextStyle(fontSize: 17)))
                              ],
                            )),
                        Divider(
                          color: Colors.grey[400],
                          // height: 1,
                          thickness: 1,
                          indent: 15,
                          endIndent: 15,
                        ),
                        Row(children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(left: 13),
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Medio de Pago',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 15),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text('Efectivo'),
                                ],
                              )),
                          Container(
                              height: 50,
                              child: VerticalDivider(color: Colors.grey[400])),
                          Container(
                              margin: EdgeInsets.only(
                                  left: 30, right: 20, top: 5, bottom: 5),
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text('Monto',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 15),
                                      textAlign: TextAlign.center),
                                  Text('12.34'),
                                ],
                              )),
                          Container(
                              height: 50,
                              child: VerticalDivider(color: Colors.grey[400])),
                          Container(
                              margin: EdgeInsets.only(
                                  left: 20, right: 20, top: 5, bottom: 5),
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text('Fecha',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 15),
                                      textAlign: TextAlign.center),
                                  Text('05/08/2020'),
                                ],
                              )),
                        ]),
                        Divider(
                          color: Colors.grey[400],
                          // height: 1,
                          thickness: 1,
                          indent: 15,
                          endIndent: 15,
                        ),
                        Container(
                            margin: EdgeInsets.only(left: 15),
                            child: Row(
                              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Container(
                                    // margin: EdgeInsets.only(right: 70),
                                    child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          'Foto de la factura:',
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 17),
                                        ))),
                                Container(
                                    margin: EdgeInsets.only(left: 15),
                                    child: Text('factura1345.jpg',
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: Hexcolor('EA6012'))))
                              ],
                            )),

                        Divider(
                          color: Colors.grey[400],
                          // height: 1,
                          thickness: 1,
                          indent: 15,
                          endIndent: 15,
                        ),

                        SizedBox(
                          height: 20,
                        ),

                        SizedBox(
                            width: 800,
                            height: 30,
                            // margin: EdgeInsets.only(left: 190),
                            //padding: EdgeInsets.only(left: 60, right: 60),
                            child: RaisedButton(
                                color: Colors.grey,
                                onPressed: () {},
                                child: Text(
                                  'Ver Detalle',
                                  style: TextStyle(
                                    color: Colors.white,
                                    letterSpacing: 1,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'OpenSans',
                                  ),
                                ))),
                        //  SizedBox(height: 5)
                      ],
                    ),
                  ),
                ]))),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Hexcolor('EA6012'),
          ),
          backgroundColor: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NewExpensesPage(
                        user: user,
                      )),
            );
          },
        ),
        bottomNavigationBar: AppBarButton(
          user: user,
          selectIndex: 0,
        ));
  }

  // ignore: unused_element

}
