import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:worker/model/certification.dart';
import 'package:worker/providers/workday.dart';
import 'package:worker/widgets/dashboard/index.dart';
import 'package:worker/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../providers/workday.dart';

import '../../model/user.dart';
import '../../model/workday.dart';

class ListClockIn extends StatefulWidget {
  static const routeName = '/my-clockin';
  final User user;
  final int workday;
  final DateTime workday_date;

  ListClockIn(
      {@required this.user,
      @required this.workday,
      @required this.workday_date});

  @override
  _ListClockInState createState() =>
      _ListClockInState(user, workday, workday_date);
}

class _ListClockInState extends State<ListClockIn> {
  User user;
  int workday;
  DateTime workday_date;
  _ListClockInState(this.user, this.workday, this.workday_date);
  // ignore: unused_field
  int _selectedIndex = 3;
  bool loading = false;
  String verified;
  bool scanning = false;
  String qrCodeResult = "Not Yet Scanned";
  bool finish = false;
  Workday _wd;
  final String url =
      'http://emplooy.turpialdev.webfactional.com/api/v-1/workday/2/clock-ins/list';

  List data = List();
  List data1 = List();

  Certification crt;
  bool isData = false;
  bool isData1 = false;

  bool isLoading = false;
  String _time = "Sin Cambios";

  String dat;

  void _showErrorDialog(String message) {
    print(message);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Oops, ha ocurrido un Error!'),
        content: Text(message),
        titleTextStyle: TextStyle(
            color: Hexcolor('373737'),
            fontFamily: 'OpenSansRegular',
            fontWeight: FontWeight.bold,
            fontSize: 20),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            textColor: Hexcolor('EA6012'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  void _showErrorDialogADD(String message) {
    print(message);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Oops, ha ocurrido un Error!'),
        content: Text(message),
        titleTextStyle: TextStyle(
            color: Hexcolor('373737'),
            fontFamily: 'OpenSansRegular',
            fontWeight: FontWeight.bold,
            fontSize: 20),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            textColor: Hexcolor('EA6012'),
            onPressed: () {},
          ),
          FlatButton(
              child: Text('Enviar oferta.'),
              textColor: Hexcolor('EA6012'),
              onPressed: () {
                Navigator.of(ctx).pop();
                _submitOffer();
              })
        ],
      ),
    );
  }

  void _showConfirmEnd() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Estás Intentando Cerrar el Proceso'),
        content:
            Text('¿Estás seguro que deseas cerrar el proceso de clock in?'),
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
              _submit();
            },
          )
        ],
      ),
    );
  }

  getToken() async {
    SharedPreferences token = await SharedPreferences.getInstance();
    String stringValue = token.getString('stringValue');
    return stringValue;
  }

  getContract() async {
    SharedPreferences contract = await SharedPreferences.getInstance();
    //Return String
    int intValue = contract.getInt('intValue');
    return intValue;
  }

  Future<bool> scanQRWorker(String identification) async {
    String token = await getToken();
    setState(() {
      scanning = true;
    });

    final response = await http.get(
        'http://emplooy.turpialdev.webfactional.com/api/v-1/user/get-registered-user/$identification/1/in',
        headers: {
          "Authorization": "Token 4ead92aa67e22337c35db38e019437eba1fe4ab5"
        });
    setState(() {
      scanning = false;
    });
    // ignore: await_only_futures
    print(response.body);
    var resBody = json.decode(response.body);

    if (response.statusCode == 200 && resBody['first_name'] != null) {
      print('dio 200 scan list');
      User _user = new User.fromJson1(resBody);

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetailClockIn(
                  user: _user,
                )),
      );
    } else {
      print('dio error');
      //The worker has already clocked-in
      String error = resBody['detail'];
      if (error == 'worker not belongs to a project') {
        _showErrorDialogADD('El trabajador no esta dentro del proyecto.');
      }
      if (error == 'The worker has already clocked-in') {
        _showErrorDialog('El trabajador ya hizo clock in en la jornada.');
      }
      /*else {
        _showErrorDialog('Verifique la información.');
      }*/
    }
  }

  Future<String> getSWData() async {
    String token = await getToken();
    int wd = this.widget.workday;
    setState(() {
      loading = true;
    });
    var res = await http.get(
        'http://emplooy.turpialdev.webfactional.com/api/v-1/workday/$wd/clock-in/list',
        headers: {
          "Authorization": "Token 4ead92aa67e22337c35db38e019437eba1fe4ab5"
        });
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

  Future<String> getSWDataNO() async {
    String token = await getToken();
    int wd = this.widget.workday;
    setState(() {
      loading = true;
    });
    var res = await http.get(
        'http://emplooy.turpialdev.webfactional.com/api/v-1/workday/$wd/not-clocked-ins/list',
        headers: {
          "Authorization": "Token 4ead92aa67e22337c35db38e019437eba1fe4ab5"
        });
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

  Future<void> _submit() async {
    setState(() {
      isLoading = true;
    });
    try {
      Provider.of<WorkDay>(context, listen: false)
          .endClockIn(this.widget.workday)
          .then((response) {
        setState(() {
          isLoading = false;
          finish = true;
        });
        print(finish);
        if (response == '200') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DashboardHome()),
          );
        } else {
          _showErrorDialog('Verifique la información');
        }
      });
    } catch (error) {}
  }

  Future<void> _submitOffer() async {
    var res = await http.get(
        'http://emplooy.turpialdev.webfactional.com/api/v-1/user/check-worker-profile/5/1/',
        headers: {
          "Authorization": "Token 4ead92aa67e22337c35db38e019437eba1fe4ab5"
        });

    var response = json.decode(res.body);
    if (response['code'] == 0) {
      _showErrorDialog(
          'El trabajador no cumple los requerimientos minimos para aplicar a la oferta.');
    } else {
      _showErrorDialog(
          'Se envío la oferta al trabajador, debe aceptarla para poder hacer clock in.');
    }
    print(response);
  }

  void _viewWorkDay() {
    Provider.of<WorkDay>(context, listen: false).fetchWorkDay().then((value) {
      setState(() {
        _wd = value;
      });
    });
  }

  @override
  void initState() {
    this.getSWData();
    this.getSWDataNO();
    _viewWorkDay();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(data);
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
            endDrawer: MenuLateral(
              user: user,
              workday: this.widget.workday,
            ),
            body: Column(
              // Column
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Clock in inicial',
                              style: TextStyle(
                                  color: Hexcolor('EA6012'),
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: 170, right: 10, top: 5, bottom: 5),
                      child: FloatingActionButton(
                        child: Icon(
                          Icons.add,
                          color: Hexcolor('EA6012'),
                        ),
                        backgroundColor: Colors.white,
                        onPressed: () async {
                          String codeSanner =
                              await BarcodeScanner.scan(); //barcode scnner
                          setState(() {
                            qrCodeResult = codeSanner;
                          });
                          print(qrCodeResult);
                          bool scanResult = await scanQRWorker(qrCodeResult);
                        },
                      ),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Proyecto 000001',
                          style: TextStyle(
                              color: Hexcolor('252850'),
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
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
                          text: 'Presentes',
                        ),
                      ),
                      Tab(
                        text: "Ausentes",
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
                          : _getList(),
                      // ignore: unrelated_type_equality_checks
                      isData1 == ''
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : _getListNO()
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 30, right: 30),
                  width: 360,
                  height: 50.0,
                  // margin: EdgeInsets.only(left:15),
                  child: isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : RaisedButton(
                          elevation: 5.0,
                          onPressed: this.widget.workday_date != null
                              ? null
                              : _showConfirmEnd,
                          // padding: EdgeInsets.only(left: 20, right: 20,top: 15, bottom: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          color: Hexcolor('009444'),
                          child: Text(
                            'Finalizar Proceso',
                            style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 1,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'OpenSans',
                            ),
                          ),
                        ),
                )
              ],
            ),
            bottomNavigationBar: AppBarButton(
              user: this.widget.user,
              selectIndex: 4,
            )),
      ),
    );
  }

  Widget _getList() {
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
                          '${data[index]['last_name']}' +
                              ' ' +
                              '${data[index]['first_name']}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle:
                            Text('ID#' + ' ' + '${data[index]['btn_id']}'),
                        leading: Icon(Icons.note),
                        onTap: () {},
                      )),
                    ],
                  );
                },
              ));
  }

  Widget _getListNO() {
    return Container(
        margin: EdgeInsets.all(5),
        child: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: data1.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: <Widget>[
                      Expanded(
                          child: ListTile(
                        title: Text(
                          '${data1[index]['last_name']}' +
                              ' ' +
                              '${data1[index]['first_name']}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle:
                            Text('ID#' + ' ' + '${data1[index]['btn_id']}'),
                        leading: Icon(Icons.note),
                        onTap: () {},
                      )),
                    ],
                  );
                },
              ));
  }
}

class SnackBarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        onPressed: () {
          final snackBar = SnackBar(
            content: Text('Yay! A SnackBar!'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                // Algo de código para ¡deshacer el cambio!
              },
            ),
          );

          // Encuentra el Scaffold en el árbol de widgets y ¡úsalo para mostrar un SnackBar!
          Scaffold.of(context).showSnackBar(snackBar);
        },
        child: Text('Show SnackBar'),
      ),
    );
  }
}
