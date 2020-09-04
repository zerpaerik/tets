import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:worker/model/certification.dart';
import 'package:worker/providers/certifications.dart';
import 'package:worker/widgets/dashboard/index.dart';
import 'package:worker/widgets/my-profile/certifications/base.dart';
import 'package:worker/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:http/http.dart' as http;

import '../../../model/user.dart';
import '../../global.dart';

class CertifactionsPage extends StatefulWidget {
  static const routeName = '/my-certifications';
  final User user;

  CertifactionsPage({@required this.user});

  @override
  _CertifactionsPageState createState() => _CertifactionsPageState(user);
}

class _CertifactionsPageState extends State<CertifactionsPage> {
  User user;
  _CertifactionsPageState(this.user);
  int _selectedIndex = 4;
  bool loading = false;
  final String url = ApiWebServer.API_CERTIFICATION;
  List data = List();
  Certification crt;
  bool isData = false;
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
    var res = await http
        .get(Uri.encodeFull(url), headers: {"Authorization": "Token $token"});
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

  @override
  void initState() {
    this.getSWData();
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
    print(loading);
    return new Scaffold(
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
      body: isData ? _getListCert() : _getBase(),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Hexcolor('EA6012'),
        ),
        backgroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BaseCertification()),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/home.png'), size: 25),
            title: Text(''),
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/chat.png'), size: 25),
            title: Text(''),
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/codigo-qr.png'),
                color: Colors.black, size: 35),
            title: Text(''),
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/notif.png'), size: 25),
            title: Text(''),
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/usuario.png'), size: 25),
            title: Text(''),
          )
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onTap,
      ),
    );
  }

  Widget _getBase() {
    return Center(
      child: Container(
          margin: EdgeInsets.only(top: 50),
          child: Column(children: <Widget>[
            /* Image.asset(
              'assets/certificate.png',
              width: 150,
            ),*/
            SizedBox(height: 15),
            if (dat == 'Si') ...[
              Center(child: CircularProgressIndicator()),
            ],
            if (dat == 'No') ...[
              Image.asset(
                'assets/certificate.png',
                width: 150,
              ),
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
            ]
          ])),
    );
  }

  Widget _getListCert() {
    return Container(
        margin: EdgeInsets.all(5),
        child: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: <Widget>[
                      Expanded(
                          child: ListTile(
                        title: Text(
                          '${data[index]['certification_type']['name']}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                            '${data[index]['certification_type']['description']}'),
                        leading: Icon(Icons.note),
                        onTap: () {
                          print(data[index]);
                          Certification crt =
                              new Certification.fromJson(data[index]);
                          print(crt.id);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DetailCertification(cert: crt)),
                          );
                        },
                      )),
                      IconButton(
                          icon: Icon(
                            Icons.delete_outline,
                            color: Hexcolor('EA6012'),
                          ),
                          onPressed: () {
                            Certification crtId =
                                new Certification.fromJson(data[index]);
                            int crtID = crtId.id;
                            _showDeleteDialog(crtID);
                          })
                    ],
                  );
                },
              ));
  }
}
