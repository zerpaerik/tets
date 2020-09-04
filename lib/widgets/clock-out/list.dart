import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:worker/model/certification.dart';
import 'package:worker/providers/workday.dart';
import 'package:worker/widgets/clock-in/test.dart';
import 'package:worker/widgets/dashboard/index.dart';
import 'package:worker/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../model/user.dart';
import '../../model/workday.dart';

class ListClockOut extends StatefulWidget {
  static const routeName = '/my-clockout';
  final User user;
  final int workday;
  final DateTime workday_date;

  ListClockOut(
      {@required this.user,
      @required this.workday,
      @required this.workday_date});

  @override
  _ListClockOutState createState() =>
      _ListClockOutState(user, workday, workday_date);
}

class _ListClockOutState extends State<ListClockOut> {
  User user;
  int workday;
  Workday _wd;
  DateTime workday_date;
  _ListClockOutState(this.user, this.workday, this.workday_date);
  // ignore: unused_field
  int _selectedIndex = 3;
  bool loading = false;
  bool isLoading = false;
  String verified;
  bool scanning = false;
  String qrCodeResult = "Not Yet Scanned";
  int workDayCurrent;

  //List data = List();
  List data = List();

  Certification crt;
  bool isData = false;

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
            child: Text(
              'Ok',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            textColor: Hexcolor('EA6012'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  void _showErrorDialogCI(String message, User worker) {
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
            child: Text(
              'Ok',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            textColor: Hexcolor('EA6012'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
          FlatButton(
            textColor: Hexcolor('EA6012'),
            child: Text(
              'Hacer Clock in',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailClockIn(
                          user: this.widget.user,
                          //workday: this.widget.workday,
                        )),
              );
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

  Future<bool> scanQRWorker(String identification) async {
    String token = await getToken();
    setState(() {
      scanning = true;
    });

    final response = await http.get(
        'http://emplooy.turpialdev.webfactional.com/api/v-1/user/get-registered-user/$identification/1/out',
        headers: {
          "Authorization": "Token 4ead92aa67e22337c35db38e019437eba1fe4ab5"
        });
    setState(() {
      scanning = false;
    });
    var resBody = json.decode(response.body);
    int wd = this.widget.workday;
    print(resBody);

    if (response.statusCode == 200 &&
        resBody['first_name'] != null &&
        resBody['detail'] == null) {
      print('dio bienpara escanear');
      print(resBody);
      User worker = new User.fromJson1(resBody);

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetailClockOut(
                  user: worker,
                  workday: wd,
                )),
      );
    }
    if (response.statusCode == 200 &&
        resBody['detail'] == 'The worker has not clocked in') {
      print('dio bien para escanear sin clock in');
      print(resBody);
      User worker = new User.fromJson1(resBody);
      _showErrorDialogCI('El trabajador no ha hecho clock in.', worker);
    }

    if (response.statusCode == 200 &&
        resBody['detail'] == 'The worker has already clocked out') {
      _showErrorDialog('El trabajador ya hizo clock out para esta jornada.');
    }

    /*else {
      print('dio error');
      String error = resBody['detail'];
      if (error == 'The worker has not clocked in') {
        _showErrorDialogCI('El trabajador no ha hecho clock in.');
      } else {
        _showErrorDialog('Verifique la información.');
      }
    }¨*/
  }

  Future<bool> scanQRWorkerCI(String identification) async {
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
    var resBody = json.decode(response.body);

    if (response.statusCode == 200 && resBody['first_name'] != null) {
      print('dio 200');
      User worker = new User.fromJson1(resBody);
      String fn = resBody['first_name'];

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetailClockIn(
                  user: worker,
                )),
      );
    } else {
      print('dio error');
      String error = resBody['detail'];
      if (error == 'worker not belongs to a project') {
        _showErrorDialog('El trabajador no esta dentro del proyecto.');
      } else {
        _showErrorDialog('Verifique la información.');
      }
    }
  }

  Future<String> getSWData() async {
    String token = await getToken();
    int wk = this.widget.workday;
    setState(() {
      loading = true;
    });
    var res = await http.get(
        'http://emplooy.turpialdev.webfactional.com/api/v-1/workday/$wk/clock-out/list',
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

  Future<void> _submit() async {
    setState(() {
      isLoading = true;
    });
    try {
      Provider.of<WorkDay>(context, listen: false)
          .endClockOut(this.widget.workday)
          .then((response) {
        setState(() {
          isLoading = false;
        });
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

  @override
  void initState() {
    this.getSWData();
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
        length: 1,
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
                          margin: EdgeInsets.only(left: 30),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Clock Out',
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
                          left: 190, right: 10, top: 5, bottom: 5),
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
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 30),
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
                    labelStyle: TextStyle(fontSize: 17),
                    tabs: [
                      new Container(
                        child: Container(
                          margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                          // padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            onChanged: (value) {},
                            //controller: editingController,
                            decoration: InputDecoration(
                                labelText: "Search",
                                hintText: "Search",
                                prefixIcon: Icon(Icons.search),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(5.0)))),
                          ),
                        ),
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
                          onPressed:
                              this.widget.workday_date != null ? null : _submit,
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
}
