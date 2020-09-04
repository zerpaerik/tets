import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:worker/model/certification.dart';
import 'package:worker/providers/certifications.dart';
import 'package:worker/widgets/banns/detail.dart';
import 'package:worker/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../../model/user.dart';
import '../../widgets.dart';

class BannsLeadPage extends StatefulWidget {
  static const routeName = '/my-jobs';
  final User user;

  BannsLeadPage({@required this.user});

  @override
  _BannsLeadPageState createState() => _BannsLeadPageState(user);
}

class _BannsLeadPageState extends State<BannsLeadPage> {
  User user;
  _BannsLeadPageState(this.user);

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
                  Container(
                    margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                    // padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      onChanged: (value) {},
                      //controller: editingController,
                      decoration: InputDecoration(
                          labelText: "Search",
                          hintText: "Search",
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)))),
                    ),
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
                                'Fecha de creación:',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Hexcolor('EA6012'),
                                    fontSize: 17),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Container(
                              margin:
                                  EdgeInsets.only(left: 19, right: 15, top: 15),
                              child: Text(
                                '04/08/2020',
                                style: TextStyle(fontSize: 17),
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
                                          'Tipo de Amonestación:',
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 17),
                                        ))),
                                Container(
                                    margin: EdgeInsets.only(left: 15),
                                    child: Text('Tipo 2',
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
                                          'Motivo:',
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 17),
                                        ))),
                                Container(
                                    margin: EdgeInsets.only(left: 15),
                                    child: Text('Llegada tarde',
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
                        Container(
                            margin:
                                EdgeInsets.only(left: 15, right: 80, top: 15),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Trabajador amonestado:',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Hexcolor('EA6012'),
                                    fontSize: 17),
                                textAlign: TextAlign.left,
                              ),
                            )),
                        Container(
                            margin: EdgeInsets.only(left: 15, top: 10),
                            child: Row(
                              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Container(
                                    // margin: EdgeInsets.only(right: 70),
                                    child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          'Nombre y apellido:',
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 17),
                                        ))),
                                Container(
                                    margin: EdgeInsets.only(left: 15),
                                    child: Text('Iván Favreau',
                                        style: TextStyle(fontSize: 17)))
                              ],
                            )),
                        Container(
                            margin: EdgeInsets.only(left: 15, top: 10),
                            child: Row(
                              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Container(
                                    // margin: EdgeInsets.only(right: 70),
                                    child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          'ID#:',
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 17),
                                        ))),
                                Container(
                                    margin: EdgeInsets.only(left: 15),
                                    child: Text('0000000',
                                        style: TextStyle(
                                            fontSize: 17, color: Colors.blue)))
                              ],
                            )),
                        Divider(
                          color: Colors.grey[400],
                          // height: 1,
                          thickness: 1,
                          indent: 15,
                          endIndent: 15,
                        ),
                        Container(
                            margin: EdgeInsets.only(left: 15, top: 10),
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
                                              color: Colors.grey, fontSize: 17),
                                        ))),
                                Container(
                                    margin: EdgeInsets.only(left: 15),
                                    child: Text('BTN 0001',
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
                        Row(
                          children: <Widget>[
                            Container(
                              margin:
                                  EdgeInsets.only(left: 15, right: 10, top: 15),
                              child: Text(
                                'Fecha de creación del evento:',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Hexcolor('EA6012'),
                                    fontSize: 17),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Container(
                              margin:
                                  EdgeInsets.only(left: 5, right: 15, top: 15),
                              child: Text(
                                '04/08/2020',
                                style: TextStyle(fontSize: 17),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
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
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DetailBanns(
                                              user: user,
                                            )),
                                  );
                                },
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
                  builder: (context) => NewBannsPage(
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
