import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:worker/model/certification.dart';
import 'package:worker/widgets/dashboard/index.dart';
import 'package:worker/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../model/user.dart';
import '../../providers/auth.dart';

class ListNotifications extends StatefulWidget {
  static const routeName = '/my-certifications';
  final User user;

  ListNotifications({@required this.user});

  @override
  _ListNotificationsState createState() => _ListNotificationsState(user);
}

class _ListNotificationsState extends State<ListNotifications> {
  User user;
  _ListNotificationsState(this.user);
  // ignore: unused_field
  int _selectedIndex = 3;
  bool loading = false;
  String verified;
  final String url =
      'http://emplooy.turpialdev.webfactional.com/api/v-1/notification/not_read';
  final String url1 =
      'http://emplooy.turpialdev.webfactional.com/api/v-1/notification/read';
  List data = List();
  List data1 = List();

  Certification crt;
  bool isData = false;
  bool isData1 = false;

  String dat;

  getToken() async {
    SharedPreferences token = await SharedPreferences.getInstance();
    String stringValue = token.getString('stringValue');
    return stringValue;
  }

  Future<String> getSWData() async {
    String token = await getToken();
    setState(() {
      loading = true;
    });
    var res = await http.get(url, headers: {"Authorization": "Token $token"});
    var resBody = json.decode(res.body);

    setState(() {
      data = resBody;
      if (data.length > 0) {
        isData = true;
        dat = 'Si';
        loading = false;
      } else {
        dat = 'No';
        loading = false;
      }
    });

    return "Sucess";
  }

  Future<String> getSWData1() async {
    String token = await getToken();
    setState(() {
      loading = true;
    });
    var res = await http.get(url1, headers: {"Authorization": "Token $token"});
    var resBody = json.decode(res.body);

    setState(() {
      data1 = resBody;
      if (data1.length > 0) {
        isData1 = true;
        dat = 'Si';
        loading = false;
      } else {
        dat = 'No';
        loading = false;
      }
    });

    return "Sucess";
  }

  Future<void> _verificationNotifi(id) async {
    try {
      Provider.of<Auth>(context, listen: false).verifiedN(id);
    } catch (error) {}
  }

  @override
  void initState() {
    this.getSWData();
    this.getSWData1();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        accentColor: Colors.deepOrange,
        fontFamily: 'OpenSans-Regular',
      ),
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              elevation: 2.0,
              backgroundColor: Colors.white,
              centerTitle: true,
              iconTheme: IconThemeData(
                color: Hexcolor('EA6012'),
              ),
              title: Image.asset(
                "assets/homelogo.png",
                width: 120,
                alignment: Alignment.topLeft,
              ),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DashboardHome()),
                ),
              ),
            ),
            endDrawer: Container(
              width: 240,
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
                      child: Text('Emplooy' + ' ' + this.widget.user.btn_id,
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ViewProfileOblig(
                                        user: this.widget.user)),
                              );
                            },
                            icon: ImageIcon(
                              AssetImage('assets/001-identity.png'),
                              color: Colors.grey,
                            ),
                            label: Text(
                              'Información personal',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            )))),
                Divider(),
                Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: FlatButton.icon(
                            onPressed: () {},
                            icon: ImageIcon(
                              AssetImage('assets/002-data.png'),
                              color: Colors.grey,
                            ),
                            label: Text(
                              'Información' + '\n' + 'academica/profesional',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
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
                                    builder: (context) =>
                                        JobOfferPage(user: this.widget.user)),
                              );
                            },
                            icon: ImageIcon(
                              AssetImage('assets/contrato.png'),
                              color: Colors.grey,
                            ),
                            label: Text(
                              'Ofertas laborales',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
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
                                    builder: (context) => ConfigPage()),
                              );
                            },
                            icon: ImageIcon(
                              AssetImage('assets/005-gear.png'),
                              color: Colors.grey,
                            ),
                            label: Text(
                              'Configuración',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            )))),
                Divider(),
              ])),
            ),
            body: Column(
              // Column
              children: <Widget>[
                Container(
                    width: 500,
                    height: 50,
                    color: Hexcolor('EA6012'),
                    // margin: EdgeInsets.only(top: 20),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Mis Notificaciones',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    )),
                Container(
                  color: Colors.white, // Tab Bar color change
                  child: TabBar(
                    // TabBar
                    unselectedLabelColor: Colors.grey,
                    labelColor: Hexcolor('EA6012'),
                    indicatorWeight: 3,
                    indicatorColor: Hexcolor('EA6012'),
                    labelStyle: TextStyle(fontSize: 17),
                    tabs: [
                      new Container(
                        child: Tab(
                          text: 'No Leidas',
                        ),
                      ),
                      Tab(
                        text: "Leidas",
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: TabBarView(
                    // Tab Bar View
                    physics: BouncingScrollPhysics(),
                    children: <Widget>[
                      // ignore: unrelated_type_equality_checks
                      isData == ''
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : _getListNotRead(),
                      // ignore: unrelated_type_equality_checks
                      isData1 == ''
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : _getListRead()
                    ],
                  ),
                ),
              ],
            ),
            bottomNavigationBar: AppBarButton(
              user: this.widget.user,
              selectIndex: 4,
            )),
      ),
    );
  }

  Widget _getListNotRead() {
    return Container(
        margin: EdgeInsets.all(5),
        child: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  String date = data[index]['created'];
                  return Container(
                      height: 90,
                      child: Card(
                        margin: EdgeInsets.only(top: 30, left: 20, right: 20),
                        color: data[index]['verification_date'] != null
                            ? Colors.grey
                            : Hexcolor('0174DF'),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                  margin: EdgeInsets.only(top: 3),
                                  child: Icon(
                                    Icons.notifications,
                                    color: Colors.white,
                                  )),
                              Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: Column(children: <Widget>[
                                    Text('${data[index]['data']['title']}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    Text('Fecha: ${date.substring(0, 10)}',
                                        style: TextStyle(color: Colors.white))
                                  ])),
                              Container(
                                  child: RaisedButton(
                                elevation: 2.0,
                                onPressed: () {
                                  if (data[index]['verification_date'] ==
                                      null) {
                                    _verificationNotifi(data[index]['id']);
                                  }
                                  if (data[index]['data']['identifier'] ==
                                      'JOB_OFFER') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DetailJobOfferPage(
                                              user: this.widget.user,
                                              offer:
                                                  '${data[index]['data']['id']}')),
                                    );
                                  }
                                },
                                padding: EdgeInsets.all(5),
                                color: data[index]['verification_date'] != null
                                    ? Colors.grey
                                    : Colors.blue[600],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Text(
                                  'Ver Detalle',
                                  style: TextStyle(
                                    color: Colors.white,
                                    letterSpacing: 1,
                                    fontSize: 11.0,
                                    fontFamily: 'OpenSans',
                                  ),
                                ),
                              ))
                            ]),
                      ));
                },
              ));
  }

  Widget _getListRead() {
    return Container(
        margin: EdgeInsets.all(5),
        child: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: data1.length,
                itemBuilder: (context, index) {
                  String date = data1[index]['created'];
                  return Container(
                      height: 90,
                      child: Card(
                        margin: EdgeInsets.only(top: 30, left: 20, right: 20),
                        /*color: data[index]['data']['identifier'] == 'JOB_OFFER'
                            ? Hexcolor('0174DF')
                            : Hexcolor('009444'),*/
                        color: Colors.grey,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                  margin: EdgeInsets.only(top: 3),
                                  child: Icon(
                                    Icons.notifications,
                                    color: Colors.white,
                                  )),
                              Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: Column(children: <Widget>[
                                    Text('${data1[index]['data']['title']}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    Text('Fecha: ${date.substring(0, 10)}',
                                        style: TextStyle(color: Colors.white))
                                  ])),
                              Container(
                                  //color: Colors.transparent,
                                  child: RaisedButton(
                                elevation: 2.0,
                                onPressed: () {
                                  if (data1[index]['verification_date'] ==
                                      null) {
                                    _verificationNotifi(data[index]['id']);
                                  }
                                  if (data1[index]['data']['identifier'] ==
                                      'JOB_OFFER') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DetailJobOfferPage(
                                              user: this.widget.user,
                                              offer:
                                                  '${data[index]['data']['id']}')),
                                    );
                                  }
                                },
                                padding: EdgeInsets.all(5),
                                color: Colors.grey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Text(
                                  'Ver Detalle',
                                  style: TextStyle(
                                    color: Colors.white,
                                    letterSpacing: 1,
                                    fontSize: 11.0,
                                    // fontWeight: FontWeight.bold,
                                    fontFamily: 'OpenSans',
                                  ),
                                ),
                              ))
                            ]),
                      ));
                },
              ));
  }
}
