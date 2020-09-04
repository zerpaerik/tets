import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:http/http.dart' as http;

import '../../../model/user.dart';
import '../../widgets.dart';
import 'package:worker/model/certification.dart';
import 'package:worker/widgets/dashboard/index.dart';
import 'package:worker/widgets/my-profile/job-offer/postulation.dart';

class DetailJobOfferPage extends StatefulWidget {
  static const routeName = '/my-jobs';
  final User user;

  final String offer;

  DetailJobOfferPage({@required this.user, @required this.offer});

  @override
  _DetailJobOfferPageState createState() =>
      _DetailJobOfferPageState(user, offer);
}

class _DetailJobOfferPageState extends State<DetailJobOfferPage> {
  User user;
  String offer;
  _DetailJobOfferPageState(this.user, this.offer);

  int _selectedIndex = 4;

  final String url =
      'http://emplooy.turpialdev.webfactional.com/api/v-1/contract/joboffer/';

  Map<String, dynamic> data;
  var benefitsO;
  Certification crt;
  String isData = '';

  getToken() async {
    SharedPreferences token = await SharedPreferences.getInstance();
    String stringValue = token.getString('stringValue');
    return stringValue;
  }

  Future<String> getSWData() async {
    String token = await getToken();
    var res =
        await http.get(url + offer, headers: {"Authorization": "Token $token"});
    // var resBody = json.decode(res.body);

    if (res.statusCode == 200) {
      setState(() {
        data = json.decode(res.body);
        benefitsO = data['contract']['benefits'];
        isData = 'Y';
      });
    } else {
      print(res.statusCode);
    }

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

  @override
  Widget build(BuildContext context) {
    print(offer);
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
          alignment: Alignment.topLeft,
        ),
      ),
      body: isData == ''
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
              children: <Widget>[
                SizedBox(height: 20),
                Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Image.asset(
                            'assets/offer.jpeg',
                            width: 50,
                          )),
                      Container(
                        margin: EdgeInsets.only(left: 10, top: 35),
                        child: Text('Detalle de la Oferta de trabajo',
                            style: TextStyle(
                                color: Hexcolor('EA6012'),
                                fontFamily: 'OpenSans-Regular',
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                      ),
                    ]),
                SizedBox(
                  height: 15,
                ),
                Container(
                    margin: EdgeInsets.only(left: 21, right: 165),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text('Ubicaciòn del lugar de trabajo',
                          style: TextStyle(
                              color: data['is_accepted'] == false
                                  ? Hexcolor('EA6012')
                                  : Colors.grey,
                              fontFamily: 'OpenSans-Regular',
                              fontSize: 15,
                              fontWeight: FontWeight.bold)),
                    )),
                Row(children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 21),
                    child: Text(data['contract']['country'],
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                        textAlign: TextAlign.center),
                  ),
                  Container(
                      height: 10,
                      child: VerticalDivider(color: Colors.grey[400])),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text(data['contract']['state'],
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                        textAlign: TextAlign.center),
                  ),
                  Container(
                      height: 10,
                      child: VerticalDivider(color: Colors.grey[400])),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text(data['contract']['city'],
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                        textAlign: TextAlign.center),
                  ),
                ]),
                SizedBox(height: 10),
                Container(
                    margin: EdgeInsets.only(left: 21, right: 21),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text('Ofrecemos',
                          style: TextStyle(
                              color: data['is_accepted'] == false
                                  ? Hexcolor('EA6012')
                                  : Colors.grey,
                              fontFamily: 'OpenSans-Regular',
                              fontSize: 15,
                              fontWeight: FontWeight.bold)),
                    )),
                Container(
                    margin: EdgeInsets.only(left: 21, right: 21),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Remuneraciòn de' +
                              ' ' +
                              data['contract']['worker_hour_payment'] +
                              ' ' +
                              ' por hora trabajada.',
                          style: TextStyle(color: Colors.grey, fontSize: 17),
                        ))),
                Container(
                    margin: EdgeInsets.only(left: 21, right: 21),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Remuneraciòn de' +
                              ' ' +
                              data['contract']['worker_extra_payment'] +
                              ' ' +
                              ' por hora extra.',
                          style: TextStyle(color: Colors.grey, fontSize: 17),
                        ))),
                SizedBox(height: 10),
                Container(
                    margin: EdgeInsets.only(left: 21, right: 21),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text('Listado de beneficios',
                          style: TextStyle(
                              color: data['is_accepted'] == false
                                  ? Hexcolor('EA6012')
                                  : Colors.grey,
                              fontFamily: 'OpenSans-Regular',
                              fontSize: 15,
                              fontWeight: FontWeight.bold)),
                    )),
                Container(
                  child: renderBenefits(benefitsO),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                    margin: EdgeInsets.only(left: 21, right: 21),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text('Tipo de contrataciòn',
                          style: TextStyle(
                              color: data['is_accepted'] == false
                                  ? Hexcolor('EA6012')
                                  : Colors.grey,
                              fontFamily: 'OpenSans-Regular',
                              fontSize: 15,
                              fontWeight: FontWeight.bold)),
                    )),
                Container(
                    margin: EdgeInsets.only(left: 21, right: 21),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          data['contract']['hiring_mode'],
                          style: TextStyle(color: Colors.grey, fontSize: 17),
                        ))),
                SizedBox(
                  height: 10,
                ),
                Container(
                    margin: EdgeInsets.only(left: 21, right: 21),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text('Fecha de inicio del contrato',
                          style: TextStyle(
                              color: data['is_accepted'] == false
                                  ? Hexcolor('EA6012')
                                  : Colors.grey,
                              fontFamily: 'OpenSans-Regular',
                              fontSize: 15,
                              fontWeight: FontWeight.bold)),
                    )),
                Container(
                    margin: EdgeInsets.only(left: 21, right: 21),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Duración estimada en semanas :' +
                              data['contract']['weekly_duration'].toString(),
                          style: TextStyle(color: Colors.grey, fontSize: 17),
                        ))),
                SizedBox(
                  height: 10,
                ),
                Container(
                    margin: EdgeInsets.only(left: 21, right: 21),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text('Condiciones del Contrato',
                          style: TextStyle(
                              color: data['is_accepted'] == false
                                  ? Hexcolor('EA6012')
                                  : Colors.grey,
                              fontFamily: 'OpenSans-Regular',
                              fontSize: 15,
                              fontWeight: FontWeight.bold)),
                    )),
                SizedBox(height: 5),
                Container(
                    height: 200,
                    width: 400,
                    child: Card(
                      child: SingleChildScrollView(
                          child: Column(children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(
                              left: 10, right: 10, top: 10, bottom: 5),
                          child: Text(
                            data['contract']['contracting_conditions'],
                            style: TextStyle(color: Colors.grey, fontSize: 17),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ])),
                    )),
                SizedBox(height: 15),
                if (data['is_accepted'] == true) ...[
                  Container(
                      // margin: EdgeInsets.only(left: 55, right: 10, top: 32),
                      child: Text(
                    'YA APLICASTE',
                    style: TextStyle(
                        color: Hexcolor('009444'),
                        fontSize: 23,
                        fontWeight: FontWeight.bold),
                  ))
                ],
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      width: 130,
                      height: 40.0,
                      margin: EdgeInsets.only(bottom: 15),
                      child: RaisedButton(
                        elevation: 5.0,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    JobOfferPage(user: this.widget.user)),
                          );
                        },
                        // padding: EdgeInsets.only(left: 20, right: 20,top: 15, bottom: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        color: Hexcolor('EA6012'),
                        child: Text(
                          'Volver',
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
                    if (data['is_accepted'] == false) ...[
                      Container(
                        width: 130,
                        height: 40.0,
                        margin: EdgeInsets.only(bottom: 15),
                        child: RaisedButton(
                          elevation: 5.0,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PostulationPage(
                                      user: this.widget.user,
                                      offer: this.widget.offer)),
                            );
                          },
                          // padding: EdgeInsets.only(left: 20, right: 20,top: 10, bottom: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          color: Hexcolor('009444'),
                          child: Text(
                            'Aplicar',
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
                    ]
                  ],
                )
              ],
            )),
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

  renderBenefits(benefitsO) {
    return Column(
        children: benefitsO
            .map<Widget>((ben) =>
                //Mostar items
                Container(
                    margin: EdgeInsets.only(left: 21, right: 21),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                          (ben['concept'] != null) ? ben['concept'] : '',
                          style: TextStyle(color: Colors.grey, fontSize: 16)),
                    )))
            .toList());
  }
}
