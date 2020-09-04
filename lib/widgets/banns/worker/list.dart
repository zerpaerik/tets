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

import '../../../model/user.dart';
import '../../widgets.dart';

class BannsWorkerPage extends StatefulWidget {
  static const routeName = '/my-banns-worker';
  final User user;

  BannsWorkerPage({@required this.user});

  @override
  _BannsWorkerPageState createState() => _BannsWorkerPageState(user);
}

class _BannsWorkerPageState extends State<BannsWorkerPage> {
  User user;
  _BannsWorkerPageState(this.user);

  final String url =
      'http://emplooy.turpialdev.webfactional.com/api/v-1/emplooy-warnings/warnings';

  List data = List();
  String isData = '';

  // ignore: unused_field
  int _selectedIndex = 4;

  getToken() async {
    SharedPreferences token = await SharedPreferences.getInstance();
    String stringValue = token.getString('stringValue');
    return stringValue;
  }

  Future<String> getSWData() async {
    String token = await getToken();
    var res = await http.get(url, headers: {
      "Authorization": "Token 74dc6aa72198ef5d8b0e61b1a36ea36a9ab46a7f"
    });
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

  @override
  void initState() {
    this.getSWData();
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
                            'Mis Amonestaciones',
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
                          : _getListWarnings(),
                      // ignore: unrelated_type_equality_checks
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

  Widget _getListWarnings() {
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
                          'Fecha de creación:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Hexcolor('EA6012'),
                              fontSize: 17),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 19, right: 15, top: 15),
                        child: Text(
                          '${data[index]['occurrence_date'].substring(0, 10)}',
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
                              child: Text('${data[index]['warning_type']}',
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
                              child: Text('${data[index]['contract']}',
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
                            Warnings wk = new Warnings.fromJson(data[index]);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailBanns(
                                        user: user,
                                        workday: wk,
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
            );
          },
        ));
  }

  // ignore: unused_element

}
