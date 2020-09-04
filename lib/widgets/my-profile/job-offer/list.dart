import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:worker/model/certification.dart';
import 'package:worker/providers/certifications.dart';
import 'package:worker/widgets/dashboard/index.dart';
import 'package:worker/widgets/my-profile/job-offer/detail.dart';
import 'package:worker/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:http/http.dart' as http;

import '../../../model/user.dart';
import '../../widgets.dart';

class JobOfferPage extends StatefulWidget {
  static const routeName = '/my-jobs';
  final User user;

  JobOfferPage({@required this.user});

  @override
  _JobOfferPageState createState() => _JobOfferPageState(user);
}

class _JobOfferPageState extends State<JobOfferPage> {
  User user;
  _JobOfferPageState(this.user);

  // ignore: unused_field
  int _selectedIndex = 4;

  final String url =
      'http://emplooy.turpialdev.webfactional.com/api/v-1/contract/joboffer/not-accepted';
  final String url1 =
      'http://emplooy.turpialdev.webfactional.com/api/v-1/contract/joboffer/accepted';

  List data = List();
  List data1 = List();
  Certification crt;
  String isData = '';
  String isData1 = '';

  getToken() async {
    SharedPreferences token = await SharedPreferences.getInstance();
    String stringValue = token.getString('stringValue');
    return stringValue;
  }

  Future<String> getSWData() async {
    String token = await getToken();
    var res = await http.get(url, headers: {"Authorization": "Token $token"});
    var resBody = json.decode(res.body);
    print(resBody);

    if (res.statusCode == 200) {
      setState(() {
        data = json.decode(res.body);
        isData = 'Y';
      });
    } else {
      print(res.statusCode);
    }

    return "Sucess";
  }

  Future<String> getSWData1() async {
    String token = await getToken();
    var res = await http.get(url1, headers: {"Authorization": "Token $token"});
    var resBody = json.decode(res.body);
    print(resBody);

    if (res.statusCode == 200) {
      setState(() {
        data1 = json.decode(res.body);
        isData1 = 'Y';
      });
    } else {
      print(res.statusCode);
    }

    return "Sucess";
  }

  @override
  void initState() {
    this.getSWData();
    this.getSWData1();
    super.initState();
  }

  void _showQr() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return Scaffold(
            body: SingleChildScrollView(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 25,
                ),
                Image.asset(
                  'assets/emplooy.png',
                  width: 130,
                ),
                Container(
                  margin: EdgeInsets.only(left: 30, top: 10, right: 30),
                  child: ClipOval(
                    child: Image.network(
                      user.profile_image.path,
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                  width: 285,
                  height: 350,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100.0)),
                  ),
                  child: Card(
                    elevation: 6,
                    child: Column(children: <Widget>[
                      SizedBox(height: 20),
                      Text(user.first_name + ' ' + user.last_name,
                          style: TextStyle(
                              color: Hexcolor('233062'),
                              fontFamily: 'OpenSans-Regular',
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      Text('EMPLOOY' + ' ' + user.btn_id,
                          style: TextStyle(
                              color: Hexcolor('9c9c9c'),
                              fontFamily: 'OpenSans-Regular',
                              fontSize: 22,
                              fontWeight: FontWeight.bold)),
                      //SizedBox(height:30),
                      QrImage(
                        data: user.btn_id,
                        gapless: true,
                        size: 260,
                        errorCorrectionLevel: QrErrorCorrectLevel.H,
                      )
                    ]),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 40.0, right: 40.0),
                  width: double.infinity,
                  child: RaisedButton(
                    elevation: 5.0,
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 4;
                      });
                      Navigator.of(ctx).pop();
                    },
                    padding: EdgeInsets.only(
                        left: 25, right: 25, top: 10, bottom: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    color: Colors.green[700],
                    child: Text(
                      'Aceptar',
                      style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 1,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            )),
          );
        });
  }

  // ignore: unused_element
  _onTap(int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DashboardHome()),
        );
        break;
      case 1:
        break;
      case 2:
        _showQr();
        break;
      case 4:
        break;
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  // ignore: unused_element
  _showDeleteDialog(int id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Estás intentando borrar un registro'),
        content: Text('¿Estás seguro que deseas borrar la certificación?'),
        titleTextStyle: TextStyle(
            color: Hexcolor('373737'),
            fontFamily: 'OpenSansRegular',
            fontWeight: FontWeight.bold,
            fontSize: 20),
        actions: <Widget>[
          FlatButton(
            textColor: Hexcolor('EA6012'),
            child: Text('No',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
          FlatButton(
            textColor: Hexcolor('EA6012'),
            child: Text(
              'Si',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            onPressed: () {
              _submitDelete(id);
              // Navigator.of(context, rootNavigator: true) .pop ('/auth');
              //Navigator.of(context).pushReplacementNamed('/auth');
            },
          )
        ],
      ),
    );
  }

  Future<void> _submitDelete(id) async {
    try {
      Provider.of<Certifications>(context, listen: false)
          .deleteCert(id)
          .then((response) {
        Navigator.push(
          context,
          // ignore: missing_required_param
          MaterialPageRoute(builder: (context) => CertifactionsPage()),
        );
        Navigator.of(context, rootNavigator: true).pop('/my-certifications');
        Navigator.of(context).pushReplacementNamed('/my-certifications');
      });
    } catch (error) {}
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
                        'Mis Ofertas Laborales',
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
                          text: 'Activas',
                        ),
                      ),
                      Tab(
                        text: "Aplicadas",
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
                      isData == ''
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : _getListCert(),
                      isData == ''
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : _getListCert1()
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

  // ignore: unused_element
  Widget _getBase() {
    return Center(
      child: Container(
          margin: EdgeInsets.only(top: 50),
          child: Column(children: <Widget>[
            Image.asset(
              'assets/certificate.png',
              width: 150,
            ),
            SizedBox(height: 15),
            Text('Mis certificaciones',
                style: TextStyle(
                  color: Hexcolor('EA6012'),
                  fontFamily: 'OpenSans-Regular',
                  fontSize: 30,
                )),
            SizedBox(height: 15),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: Text(
                'Agrega una nueva certificación seleccionando el botón en la parte inferior derecha de tu pantalla.',
                style: TextStyle(
                  color: Hexcolor('9c9c9c'),
                  fontFamily: 'OpenSans-Regular',
                  fontSize: 18,
                ),
                textAlign: TextAlign.justify,
              ),
            )
          ])),
    );
  }

  Widget _getListCert() {
    return Container(
        margin: EdgeInsets.all(5),
        child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 5,
              margin: EdgeInsets.only(top: 10, left: 20, right: 20),
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 15, right: 80, top: 15),
                        child: Text(
                          'Cliente oferente: BTN',
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
                    color: Colors.grey[200],
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
                                    'Fecha de Envío:',
                                    style: TextStyle(color: Colors.grey),
                                  ))),
                          Container(
                              margin: EdgeInsets.only(left: 5),
                              child: Text(
                                  '${data[index]['created'].substring(0, 10)}'))
                        ],
                      )),
                  Divider(
                    color: Colors.grey[200],
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
                                    'Ubicación de oferta:',
                                    style: TextStyle(color: Colors.grey),
                                  ))),
                          Container(
                              margin: EdgeInsets.only(left: 5),
                              child: Text('${data[index]['city']}'))
                        ],
                      )),
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
                                    'Fecha de Salida:',
                                    style: TextStyle(color: Colors.grey),
                                  ))),
                          Container(
                              margin: EdgeInsets.only(left: 5),
                              child: Text('${data[index]['start_date']}'))
                        ],
                      )),
                  Divider(
                    color: Colors.grey[200],
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
                            Image.asset('assets/contrato.png',
                                width: 25, color: Hexcolor('EA6012')),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Fecha de Inicio de contrato',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 10),
                              textAlign: TextAlign.center,
                            ),
                            Text('${data[index]['start_date']}'),
                          ],
                        )),
                    Container(
                        height: 50,
                        child: VerticalDivider(color: Colors.grey[400])),
                    Container(
                        margin: EdgeInsets.only(
                            left: 8, right: 8, top: 5, bottom: 5),
                        child: Column(
                          children: <Widget>[
                            Image.asset('assets/efectivo.png',
                                width: 25, color: Hexcolor('EA6012')),
                            SizedBox(
                              height: 5,
                            ),
                            Text('Pago por hora',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 10),
                                textAlign: TextAlign.center),
                            Text('${data[index]['worker_hour_payment']}'),
                          ],
                        )),
                    Container(
                        height: 50,
                        child: VerticalDivider(color: Colors.grey[400])),
                    Container(
                        margin: EdgeInsets.only(
                            left: 8, right: 8, top: 5, bottom: 5),
                        child: Column(
                          children: <Widget>[
                            Image.asset(
                              'assets/hora_extra.png',
                              width: 30,
                              color: Hexcolor('EA6012'),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text('Pago por hora extra',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 10),
                                textAlign: TextAlign.center),
                            Text('${data[index]['worker_extra_payment']}'),
                          ],
                        )),
                  ]),
                  Divider(
                    color: Colors.grey[200],
                    // height: 1,
                    thickness: 1,
                    indent: 15,
                    endIndent: 15,
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 21, top: 10),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text('¿Qué incluye?',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Hexcolor('EA6012'),
                                fontSize: 17)),
                      )),
                  SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(left: 50, right: 10),
                          child: Column(
                            children: <Widget>[
                              Image.asset(
                                'assets/transporte.png',
                                width: 50,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text('Transporte',
                                  style: TextStyle(
                                      color: Hexcolor('EA6012'),
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center),
                            ],
                          )),
                      Container(
                          margin: EdgeInsets.only(left: 50, right: 10),
                          child: Column(
                            children: <Widget>[
                              Image.asset(
                                'assets/almuerzo.png',
                                width: 50,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text('Almuerzo',
                                  style: TextStyle(
                                      color: Hexcolor('EA6012'),
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center),
                            ],
                          )),
                      Container(
                          margin: EdgeInsets.only(left: 50, right: 10),
                          child: Column(
                            children: <Widget>[
                              Image.asset(
                                'assets/hospedaje.png',
                                width: 50,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text('Hospedaje',
                                  style: TextStyle(
                                      color: Hexcolor('EA6012'),
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center),
                            ],
                          ))
                    ],
                  ),
                  SizedBox(height: 10),
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
                                  builder: (context) => DetailJobOfferPage(
                                      user: this.widget.user,
                                      offer: '${data[index]['id']}')),
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
            );
          },
        ));
  }

  Widget _getListCert1() {
    return Container(
        margin: EdgeInsets.all(5),
        child: ListView.builder(
          itemCount: data1.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 5,
              margin: EdgeInsets.only(top: 10, left: 20, right: 20),
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 15, right: 80, top: 15),
                        child: Text(
                          'Cliente oferente: BTN',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: data1[index]['is_accepted'] == true
                                  ? Colors.grey
                                  : Hexcolor('EA6012'),
                              fontSize: 17),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      if (data1[index]['is_accepted'] == true) ...[
                        Container(
                            margin:
                                EdgeInsets.only(left: 60, right: 10, top: 10),
                            child: Image.asset(
                              'assets/aplicar.png',
                              width: 30,
                            ))
                      ],
                    ],
                  ),
                  Divider(
                    color: Colors.grey[200],
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
                                    'Fecha de Envío:',
                                    style: TextStyle(color: Colors.grey),
                                  ))),
                          Container(
                              margin: EdgeInsets.only(left: 5),
                              child: Text(
                                  '${data1[index]['created'].substring(0, 10)}'))
                        ],
                      )),
                  Divider(
                    color: Colors.grey[200],
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
                                    'Ubicación de oferta:',
                                    style: TextStyle(color: Colors.grey),
                                  ))),
                          Container(
                              margin: EdgeInsets.only(left: 5),
                              child: Text('${data1[index]['city']}'))
                        ],
                      )),
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
                                    'Fecha de Salida:',
                                    style: TextStyle(color: Colors.grey),
                                  ))),
                          Container(
                              margin: EdgeInsets.only(left: 5),
                              child: Text('${data1[index]['start_date']}'))
                        ],
                      )),
                  Divider(
                    color: Colors.grey[200],
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
                            Image.asset('assets/contrato.png',
                                width: 25,
                                color: data1[index]['is_accepted'] == true
                                    ? Colors.grey
                                    : Hexcolor('EA6012')),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Fecha de Inicio de contrato',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 10),
                              textAlign: TextAlign.center,
                            ),
                            Text('${data1[index]['start_date']}'),
                          ],
                        )),
                    Container(
                        height: 50,
                        child: VerticalDivider(color: Colors.grey[400])),
                    Container(
                        margin: EdgeInsets.only(
                            left: 8, right: 8, top: 5, bottom: 5),
                        child: Column(
                          children: <Widget>[
                            Image.asset('assets/efectivo.png',
                                width: 25,
                                color: data1[index]['is_accepted'] == true
                                    ? Colors.grey
                                    : Hexcolor('EA6012')),
                            SizedBox(
                              height: 5,
                            ),
                            Text('Pago por hora',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 10),
                                textAlign: TextAlign.center),
                            Text('${data1[index]['worker_hour_payment']}'),
                          ],
                        )),
                    Container(
                        height: 50,
                        child: VerticalDivider(color: Colors.grey[400])),
                    Container(
                        margin: EdgeInsets.only(
                            left: 8, right: 8, top: 5, bottom: 5),
                        child: Column(
                          children: <Widget>[
                            Image.asset(
                              'assets/hora_extra.png',
                              width: 30,
                              color: data1[index]['is_accepted'] == true
                                  ? Colors.grey
                                  : Hexcolor('EA6012'),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text('Pago por hora extra',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 10),
                                textAlign: TextAlign.center),
                            Text('${data1[index]['worker_extra_payment']}'),
                          ],
                        )),
                  ]),
                  Divider(
                    color: Colors.grey[200],
                    // height: 1,
                    thickness: 1,
                    indent: 15,
                    endIndent: 15,
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 21, top: 10),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text('¿Qué incluye?',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: data1[index]['is_accepted'] == true
                                    ? Colors.grey
                                    : Hexcolor('EA6012'),
                                fontSize: 17)),
                      )),
                  SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(left: 50, right: 10),
                          child: Column(
                            children: <Widget>[
                              if (data1[index]['is_accepted'] == true) ...[
                                Image.asset(
                                  'assets/transporte_gris.png',
                                  width: 50,
                                )
                              ],
                              if (data1[index]['is_accepted'] == false) ...[
                                Image.asset(
                                  'assets/transporte.png',
                                  width: 50,
                                )
                              ],
                              SizedBox(
                                height: 10,
                              ),
                              Text('Transporte',
                                  style: TextStyle(
                                      color: data1[index]['is_accepted'] == true
                                          ? Colors.grey
                                          : Hexcolor('EA6012'),
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center),
                            ],
                          )),
                      Container(
                          margin: EdgeInsets.only(left: 50, right: 10),
                          child: Column(
                            children: <Widget>[
                              if (data1[index]['is_accepted'] == true) ...[
                                Image.asset(
                                  'assets/almuerzo_gris.png',
                                  width: 50,
                                )
                              ],
                              if (data1[index]['is_accepted'] == false) ...[
                                Image.asset(
                                  'assets/almuerzo.png',
                                  width: 50,
                                )
                              ],
                              SizedBox(
                                height: 10,
                              ),
                              Text('Almuerzo',
                                  style: TextStyle(
                                      color: data1[index]['is_accepted'] == true
                                          ? Colors.grey
                                          : Hexcolor('EA6012'),
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center),
                            ],
                          )),
                      Container(
                          margin: EdgeInsets.only(left: 50, right: 10),
                          child: Column(
                            children: <Widget>[
                              if (data1[index]['is_accepted'] == true) ...[
                                Image.asset(
                                  'assets/hospedaje_gris.png',
                                  width: 50,
                                )
                              ],
                              if (data1[index]['is_accepted'] == false) ...[
                                Image.asset(
                                  'assets/hospedaje.png',
                                  width: 50,
                                )
                              ],
                              SizedBox(
                                height: 10,
                              ),
                              Text('Hospedaje',
                                  style: TextStyle(
                                      color: data1[index]['is_accepted'] == true
                                          ? Colors.grey
                                          : Hexcolor('EA6012'),
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center),
                            ],
                          ))
                    ],
                  ),
                  SizedBox(height: 10),
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
                                  builder: (context) => DetailJobOfferPage(
                                      user: this.widget.user,
                                      offer: '${data1[index]['id']}')),
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
            );
          },
        ));
  }
}
