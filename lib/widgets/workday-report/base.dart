import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:worker/model/workday_register.dart';
import 'package:worker/widgets/dashboard/index.dart';
import 'package:worker/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' show DateFormat;
import 'package:worker/widgets/workday-report/edit.dart';

import '../../model/user.dart';
import '../../model/workday_register.dart';

import '../widgets.dart';

class WorkDayPage extends StatefulWidget {
  static const routeName = '/workday-page';
  final User user;
  final int workday;

  WorkDayPage({@required this.user, @required this.workday});

  @override
  _WorkDayPageState createState() => _WorkDayPageState(user, workday);
}

class _WorkDayPageState extends State<WorkDayPage> {
  User user;
  int workday;
  _WorkDayPageState(this.user, this.workday);
  //List<int> _selectWorkers = [];
  List _selectWorkers = List();
  List _selectWorkersInfo = List();

  int selectedRadio;
  bool _isData = false;

  final String url =
      'http://emplooy.turpialdev.webfactional.com/api/v-1/workday/79/workday-report/worker-report/';

  //List data = List();
  List data = List();
  Map<String, dynamic> dataw;
  Map<String, dynamic> data1;

  String isData = '';
  bool _isEdit = false;
  bool _selectw = false;
  // FOR EDIT DATA

  var drivers;
  final _form = GlobalKey<FormState>();

  // ignore: unused_field
  int _selectedIndex = 4;

  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  getToken() async {
    SharedPreferences token = await SharedPreferences.getInstance();
    String stringValue = token.getString('stringValue');
    return stringValue;
  }

  void _editInfoUnit(data) {
    WorkdayRegister wk_r = WorkdayRegister.fromJson(data);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Container(
            height: 340,
            child: Column(
              children: <Widget>[
                Container(
                  child: Image.asset(
                    'assets/test.png',
                    width: 140,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 40),
                  child: Text(
                    'Edita los campos en el siguiente formulario para cambiar la información en el reporte.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Hexcolor('233062'), fontSize: 18),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: FlatButton(
                    textColor: Hexcolor('EA6012'),
                    child: Text(
                      'Aceptar',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditWorkdayReport(
                                  user: user,
                                  workday: this.widget.workday,
                                  wr: wk_r,
                                )),
                      );
                    },
                  ),
                )
              ],
            )),
        titleTextStyle: TextStyle(
            color: Hexcolor('373737'),
            fontFamily: 'OpenSansRegular',
            fontWeight: FontWeight.bold,
            fontSize: 20),
      ),
    );
  }

  void _editInfoMasivo() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Container(
            height: 340,
            child: Column(
              children: <Widget>[
                Container(
                  child: Image.asset(
                    'assets/check.png',
                    width: 140,
                    height: 160,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 30),
                  child: Text(
                    'Para editar masivo, por favor chequea las tarjetas de los trabajadores.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Hexcolor('233062'), fontSize: 18),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: FlatButton(
                    textColor: Hexcolor('EA6012'),
                    child: Text(
                      'Aceptar',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      /* Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditWorkdayReport(
                                  user: user,
                                  wr: wk_r,
                                )),
                      );¨*/
                    },
                  ),
                )
              ],
            )),
        titleTextStyle: TextStyle(
            color: Hexcolor('373737'),
            fontFamily: 'OpenSansRegular',
            fontWeight: FontWeight.bold,
            fontSize: 20),
      ),
    );
  }

  Future<String> getSWData() async {
    String token = await getToken();
    int workday = this.widget.workday;
    var res = await http.get(
        'http://emplooy.turpialdev.webfactional.com/api/v-1/workday/$workday/workday-report/worker-report/',
        headers: {
          "Authorization": "Token 4ead92aa67e22337c35db38e019437eba1fe4ab5"
        });
    var resBody = json.decode(res.body);
    print(resBody);

    if (res.statusCode == 200) {
      setState(() {
        _isData = true;
      });
      if (resBody.length == 0) {
        print('no hay data');
        setState(() {
          isData = 'N';
        });
      } else {
        print('hay data');
        setState(() {
          isData = 'Y';
          data = resBody;
        });
      }
    } else {
      // print(res.statusCode);
    }

    return "Sucess";
  }

  void _onWorkerSelected(
      bool selected, worker_id, worker_name, worker_lastname, worker_btnid) {
    if (selected == true) {
      setState(() {
        _selectWorkers.add(worker_id);
        _selectWorkersInfo
            .add(worker_name + ' ' + worker_lastname + ' ' + worker_btnid);
        print(_selectWorkers);
        print(_selectWorkersInfo);
      });
    } else {
      setState(() {
        _selectWorkers.remove(worker_id);
        _selectWorkersInfo
            .remove(worker_name + ' ' + worker_lastname + ' ' + worker_btnid);
        print(_selectWorkers);
        print(_selectWorkersInfo);
      });
    }
  }

  @override
  void initState() {
    this.getSWData();
    selectedRadio = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(this.widget.workday);
    return Scaffold(
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
        ),
        body: !_isData
            ? Center(
                child: CircularProgressIndicator(),
              )
            : isData == 'Y'
                ? Column(
                    children: <Widget>[
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(left: 15, top: 10),
                              child: Image.asset(
                                'assets/work.png',
                                width: 50,
                              )),
                          Container(
                            margin: EdgeInsets.only(left: 10, top: 25),
                            child: Text(
                                'Clock-in y Clock-out' + '\n' + 'del dia.',
                                style: TextStyle(
                                    color: Hexcolor('EA6012'),
                                    fontFamily: 'OpenSans-Regular',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                          ),
                          if (!_isEdit) ...[
                            Container(
                              margin: EdgeInsets.only(left: 120),
                              child: FloatingActionButton(
                                  heroTag: "btn1",
                                  child: Icon(
                                    Icons.edit,
                                    color: Hexcolor('EA6012'),
                                  ),
                                  backgroundColor: Colors.white,
                                  onPressed: () {
                                    print(_selectWorkers.length);
                                    if (_selectWorkers.length == 0) {
                                      _editInfoMasivo();
                                    } else {
                                      setState(() {
                                        _isEdit = true;
                                      });
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EditWorkdayMReport(
                                                    user: user,
                                                    workday:
                                                        this.widget.workday,
                                                    worker: _selectWorkers,
                                                    workerDescription:
                                                        _selectWorkersInfo)),
                                      );
                                    }
                                  }),
                            )
                          ],
                          if (_isEdit) ...[
                            Container(
                              margin: EdgeInsets.only(left: 120),
                              child: FloatingActionButton(
                                  heroTag: "btn2",
                                  child: Icon(
                                    Icons.cancel,
                                    color: Hexcolor('EA6012'),
                                  ),
                                  backgroundColor: Colors.white,
                                  onPressed: () {
                                    setState(() {
                                      _isEdit = false;
                                    });
                                  }),
                            )
                          ]
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                        child: Text(
                          '${_selectWorkers.length} Trabajadores seleccionados',
                          style: TextStyle(
                              color: Hexcolor('42E948'),
                              fontWeight: FontWeight.bold,
                              fontSize: 17),
                        ),
                      ),
                      _getListCert()
                    ],
                  )
                : _getBase()
        // ignore: unrelated_type_equality_checks
        ,
        floatingActionButton: Visibility(
            visible: isData == 'Y' ? false : true,
            child: FloatingActionButton(
              heroTag: "btn3",
              child: Icon(
                Icons.add,
                color: Hexcolor('EA6012'),
              ),
              backgroundColor: Colors.white,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NewWorkdayReport(
                            user: user,
                            workday: this.widget.workday,
                          )),
                );
              },
            )),
        bottomNavigationBar: AppBarButton(
          user: this.widget.user,
          selectIndex: 4,
        ));
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
            Image.asset(
              'assets/workday.png',
              width: 180,
            ),
            SizedBox(
              height: 20,
            ),
            Text('Reporte del dia',
                style: TextStyle(
                  color: Hexcolor('EA6012'),
                  fontFamily: 'OpenSans-Regular',
                  fontSize: 30,
                )),
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.only(left: 30, right: 30),
              child: Text(
                'Agrega un nuevo reporte seleccionando el botón en la parte inferior derecha de tu pantalla.',
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
        height: 550,
        child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            return Card(
              /* shape: (selectedIndex == position)
            ? RoundedRectangleBorder(
                side: BorderSide(color: Colors.green, width: 2))
            : null,*/
              elevation: 10,
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
                          'ID:' + ' ' + '${data[index]['btn_id']}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Hexcolor('EA6012'),
                              fontSize: 17),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(left: 125, top: 10),
                          child: Image.asset(
                            'assets/worker.png',
                            width: 30,
                          )),
                      Container(
                          margin: EdgeInsets.only(right: 10, top: 10),
                          child: Checkbox(
                            activeColor: Hexcolor('42E948'),
                            value: _selectWorkers.contains(data[index]['id']),
                            onChanged: (bool selected) {
                              _onWorkerSelected(
                                selected,
                                data[index]['id'],
                                data[index]['first_name'],
                                data[index]['last_name'],
                                data[index]['btn_id'],
                              );
                            },
                          )),
                    ],
                  ),
                  Divider(
                    color: Colors.grey[200],
                    // height: 1,
                    thickness: 2,
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
                                    'Nombre:',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 18),
                                  ))),
                          Container(
                              margin: EdgeInsets.only(left: 5),
                              child: Text(
                                '${data[index]['first_name']}',
                                style: TextStyle(fontSize: 18),
                              )),
                          Container(
                              margin: EdgeInsets.only(left: 90),
                              child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'Apellido:',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 18),
                                  ))),
                          Container(
                              margin: EdgeInsets.only(left: 5),
                              child: Text('${data[index]['last_name']}',
                                  style: TextStyle(fontSize: 18))),
                        ],
                      )),
                  Divider(
                    color: Colors.grey[200],
                    // height: 1,
                    thickness: 1,
                    indent: 15,
                    endIndent: 15,
                  ),
                  Divider(
                    color: Colors.grey[200],
                    // height: 1,
                    thickness: 1,
                    indent: 15,
                    endIndent: 15,
                  ),
                  Row(children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(left: 20, right: 10),
                        child: Column(
                          children: <Widget>[
                            Image.asset('assets/001-clock.png', width: 30),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Clock-in',
                              style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                                '${data[index]['clock_in'].substring(11, 19)}'),
                          ],
                        )),
                    Container(
                        height: 50,
                        child: VerticalDivider(color: Colors.grey[400])),
                    Container(
                        margin: EdgeInsets.only(
                            left: 20, right: 10, top: 5, bottom: 5),
                        child: Column(
                          children: <Widget>[
                            Image.asset('assets/entrada.png', width: 30),
                            SizedBox(
                              height: 5,
                            ),
                            Text('Entrada',
                                style: TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center),
                            Text(
                                '${data[index]['workday_entry_time'].substring(11, 19)}'),
                          ],
                        )),
                    Container(
                        height: 50,
                        child: VerticalDivider(color: Colors.grey[400])),
                    Container(
                        margin: EdgeInsets.only(
                            left: 20, right: 10, top: 5, bottom: 5),
                        child: Column(
                          children: <Widget>[
                            Image.asset(
                              'assets/002-clock-1.png',
                              width: 30,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text('Clock-out',
                                style: TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center),
                            Text(
                                '${data[index]['clock_out'].substring(11, 19)}'),
                          ],
                        )),
                    Container(
                        height: 50,
                        child: VerticalDivider(color: Colors.grey[400])),
                    Container(
                        margin: EdgeInsets.only(left: 20),
                        child: Column(
                          children: <Widget>[
                            Image.asset('assets/salida.png', width: 30),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Salida',
                              style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                                '${data[index]['workday_departure_time'].substring(11, 19)}'),
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

                  SizedBox(height: 10),
                  Row(children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(left: 20, right: 10),
                        child: Column(
                          children: <Widget>[
                            Image.asset('assets/horast.png', width: 30),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Horas T',
                              style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            Text('${data[index]['worked_hours']}'),
                          ],
                        )),
                    Container(
                        height: 50,
                        child: VerticalDivider(color: Colors.grey[400])),
                    Container(
                        margin: EdgeInsets.only(
                            left: 20, right: 10, top: 5, bottom: 5),
                        child: Column(
                          children: <Widget>[
                            Image.asset('assets/lunch.png', width: 30),
                            SizedBox(
                              height: 5,
                            ),
                            Text('Almuerzo',
                                style: TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center),
                            Text('12:00:00'),
                          ],
                        )),
                    Container(
                        height: 50,
                        child: VerticalDivider(color: Colors.grey[400])),
                    Container(
                        margin: EdgeInsets.only(
                            left: 20, right: 10, top: 5, bottom: 5),
                        child: Column(
                          children: <Widget>[
                            Image.asset(
                              'assets/stand.png',
                              width: 30,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text('Stand',
                                style: TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center),
                            Text('12:00:00'),
                          ],
                        )),
                    Container(
                        height: 50,
                        child: VerticalDivider(color: Colors.grey[400])),
                    Container(
                        margin: EdgeInsets.only(left: 20),
                        child: Column(
                          children: <Widget>[
                            Image.asset('assets/duracion.png', width: 30),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Viaje',
                              style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            Text('12:00:00'),
                          ],
                        )),
                  ]),

                  SizedBox(height: 10),
                  SizedBox(
                      width: 800,
                      height: 30,
                      // margin: EdgeInsets.only(left: 190),
                      //padding: EdgeInsets.only(left: 60, right: 60),
                      child: RaisedButton(
                          color: Colors.grey,
                          onPressed: () {
                            _editInfoUnit(data[index]);
                          },
                          child: Text(
                            'Editar información',
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

  // ignore: unused_element

}
