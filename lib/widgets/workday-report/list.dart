import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:worker/model/warnings.dart';
import 'package:worker/model/workday.dart';
import 'package:worker/widgets/banns/detail.dart';
import 'package:worker/widgets/dashboard/index.dart';
import 'package:worker/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;

import '../../model/user.dart';
import '../widgets.dart';

class ListWorkDay extends StatefulWidget {
  static const routeName = '/list-workday';
  final User user;

  ListWorkDay({@required this.user});

  @override
  _ListWorkDayState createState() => _ListWorkDayState(user);
}

class _ListWorkDayState extends State<ListWorkDay> {
  User user;
  _ListWorkDayState(this.user);
  List _selectWorkers;
  int selectedRadio;

  final String url =
      'http://emplooy.turpialdev.webfactional.com/api/v-1/workday/77/detail';

  //List data = List();
  List data = List();
  Map<String, dynamic> dataw;
  Map<String, dynamic> data1;

  String isData = '';
  bool _isEdit = false;
  bool _selectw = false;

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

  Future<String> getSWData() async {
    String token = await getToken();
    var res = await http.get(url, headers: {
      "Authorization": "Token 4ead92aa67e22337c35db38e019437eba1fe4ab5"
    });
    var resBody = json.decode(res.body);

    if (res.statusCode == 200) {
      setState(() {
        data = resBody['workday_registers'];
        dataw = resBody['report'];
        print(dataw);
        isData = 'Y';
      });
    } else {
      // print(res.statusCode);
    }

    return "Sucess";
  }

  @override
  void initState() {
    this.getSWData();
    selectedRadio = 0;
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
            ),
            body: Column(
              // Column
              children: <Widget>[
                if (_isEdit) ...[
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                          width: 432,
                          height: 50,
                          color: Hexcolor('EA6012'),
                          // margin: EdgeInsets.only(top: 20),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Panel para Editar',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          )),
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
                            margin:
                                EdgeInsets.only(top: 10, left: 10, right: 10),
                            // padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              onChanged: (value) {},
                              //controller: editingController,
                              decoration: InputDecoration(
                                  labelText: "Buscar trabajador",
                                  hintText: "Buscar trabajador",
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
                ],
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
                      child: Text('Clock-in y Clock-out' + '\n' + 'del dia.',
                          style: TextStyle(
                              color: Hexcolor('EA6012'),
                              fontFamily: 'OpenSans-Regular',
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                    ),
                    if (!_isEdit) ...[
                      Container(
                        margin: EdgeInsets.only(left: 80),
                        child: FloatingActionButton(
                            heroTag: "btn1",
                            child: Icon(
                              Icons.edit,
                              color: Hexcolor('EA6012'),
                            ),
                            backgroundColor: Colors.white,
                            onPressed: () {
                              setState(() {
                                _isEdit = true;
                              });
                            }),
                      )
                    ],
                    if (_isEdit) ...[
                      Container(
                        margin: EdgeInsets.only(left: 80),
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
                Expanded(
                  flex: 3,
                  child: TabBarView(
                    // Tab Bar View
                    physics: BouncingScrollPhysics(),
                    children: <Widget>[
                      _getListCert(),
                      // ignore: unrelated_type_equality_checks
                    ],
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              heroTag: "btn3",
              child: Icon(
                Icons.add,
                color: Hexcolor('EA6012'),
              ),
              backgroundColor: Colors.white,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewWorkdayReport()),
                );
              },
            ),
            bottomNavigationBar: AppBarButton(
              user: this.widget.user,
              selectIndex: 4,
            )),
      ),
    );
  }

  Widget _getListCert() {
    return Container(
        margin: EdgeInsets.all(5),
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
                      if (_isEdit) ...[
                        Container(
                            margin:
                                EdgeInsets.only(left: 150, right: 10, top: 10),
                            child: Checkbox(
                              activeColor: Hexcolor('42E948'),
                              value: _selectw,
                              onChanged: (
                                bool value,
                              ) async {
                                setState(() {
                                  _selectw = value;
                                  _selectWorkers = [2];
                                  print(_selectWorkers);
                                  print(_selectw);
                                });
                              },
                            ))
                      ]
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
                            Text('${dataw['workday_entry_time']}'),
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
                            Text('${dataw['workday_entry_time']}'),
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
                            Text('${dataw['workday_departure_time']}'),
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
                            Text('${dataw['workday_departure_time']}'),
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
            );
          },
        ));
  }

  Widget _getListClocks() {
    return Container(
        child: InkWell(
      //onTap: () => setState(() => selectedIndex = position),
      child: Card(
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
                    'ID: 345585',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Hexcolor('EA6012'),
                        fontSize: 17),
                    textAlign: TextAlign.left,
                  ),
                ),
                if (_isEdit) ...[
                  Container(
                      margin: EdgeInsets.only(left: 150, right: 10, top: 10),
                      child: Checkbox(
                        activeColor: Hexcolor('42E948'),
                        value: _selectw,
                        onChanged: (
                          bool value,
                        ) async {
                          setState(() {
                            _selectw = value;
                            _selectWorkers = [2];
                            print(_selectWorkers);
                            print(_selectw);
                          });
                        },
                      ))
                ]
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
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 18),
                            ))),
                    Container(
                        margin: EdgeInsets.only(left: 5),
                        child: Text(
                          'Erik',
                          style: TextStyle(fontSize: 18),
                        )),
                    Container(
                        margin: EdgeInsets.only(left: 90),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Apellido:',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 18),
                            ))),
                    Container(
                        margin: EdgeInsets.only(left: 5),
                        child: Text('Zerpa', style: TextStyle(fontSize: 18))),
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
                      Text('12:00:12'),
                    ],
                  )),
              Container(
                  height: 50, child: VerticalDivider(color: Colors.grey[400])),
              Container(
                  margin:
                      EdgeInsets.only(left: 20, right: 10, top: 5, bottom: 5),
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
                      Text('12:00:00'),
                    ],
                  )),
              Container(
                  height: 50, child: VerticalDivider(color: Colors.grey[400])),
              Container(
                  margin:
                      EdgeInsets.only(left: 20, right: 10, top: 5, bottom: 5),
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
                      Text('12:00:00'),
                    ],
                  )),
              Container(
                  height: 50, child: VerticalDivider(color: Colors.grey[400])),
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
                      Text('12:00:00'),
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
                      Text('12:00:00'),
                    ],
                  )),
              Container(
                  height: 50, child: VerticalDivider(color: Colors.grey[400])),
              Container(
                  margin:
                      EdgeInsets.only(left: 20, right: 10, top: 5, bottom: 5),
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
                  height: 50, child: VerticalDivider(color: Colors.grey[400])),
              Container(
                  margin:
                      EdgeInsets.only(left: 20, right: 10, top: 5, bottom: 5),
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
                  height: 50, child: VerticalDivider(color: Colors.grey[400])),
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
    ));
  }

  // ignore: unused_element

}
