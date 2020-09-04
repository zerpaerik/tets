import 'package:worker/widgets/dashboard/index.dart';
import 'package:worker/widgets/my-profile/body.dart';
import 'package:worker/widgets/my-profile/config.dart';
import 'package:worker/widgets/my-profile/info-personal/part_acad.dart';
import 'package:worker/widgets/my-profile/job-offer/list.dart';
import 'package:worker/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../widgets.dart';
import '../../model/user.dart';
import '../../providers/auth.dart';

class MyProfile extends StatefulWidget {
  static const routeName = '/my-profile';
  final User user;

  MyProfile({@required this.user});

  @override
  _MyProfileState createState() => _MyProfileState(user);
}

class _MyProfileState extends State<MyProfile> {
  User user;
  _MyProfileState(this.user);
  // ignore: unused_field
  int _selectedIndex = 4;

  @override
  void initState() {
    _viewUser();
    super.initState();
  }

  //ListNotifications

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
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ListNotifications(
                    user: user,
                  )),
        );
        break;
      case 4:
        break;
    }
    setState(() {
      _selectedIndex = index;
    });
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
                      Text('ID#' + ' ' + user.btn_id,
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

  void _viewUser() {
    Provider.of<Auth>(context, listen: false).fetchUser().then((value) {
      setState(() {
        user = value;
      });
    });
  }

  // ignore: unused_element
  void _showInfo() {
    Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: true,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(left: 30, top: 20, right: 30),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text('ID# 0001',
                        style: TextStyle(
                            color: Colors.grey,
                            fontFamily: 'OpenSans-Regular',
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                  )),
              Container(
                  margin: EdgeInsets.only(left: 30, top: 20, right: 30),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text('Completitud de Perfil',
                        style: TextStyle(
                            color: Hexcolor('EA6012'),
                            fontFamily: 'OpenSans-Regular',
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                  )),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                child: Text('ID#' + ' ' + this.widget.user.btn_id,
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
                              builder: (context) =>
                                  ViewProfileOblig(user: this.widget.user)),
                        );
                      },
                      icon: ImageIcon(
                        AssetImage('assets/001-identity.png'),
                        color: Colors.grey,
                      ),
                      label: Text(
                        'Información personal',
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
                              builder: (context) =>
                                  ViewProfileAcad(user: this.widget.user)),
                        );
                      },
                      icon: ImageIcon(
                        AssetImage('assets/002-data.png'),
                        color: Colors.grey,
                      ),
                      label: Text(
                        'Información' + '\n' + 'academica/profesional',
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
      ),
      body: BodyProfile(this.widget.user),
      bottomNavigationBar: AppBarButton(user: this.widget.user, selectIndex: 4),
    );
  }
}

class ShowInfo extends StatelessWidget {
  final String name;
  final String lastname;
  final String email;

  ShowInfo(this.name, this.lastname, this.email);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 30, top: 20, right: 30),
      child: CircleAvatar(
        radius: 80,
        backgroundColor: Colors.transparent,
        child: CircleAvatar(
          radius: 150,
          backgroundColor: Colors.transparent,
          backgroundImage: AssetImage('assets/logo.png'),
        ),
      ),
    );
  }
}
