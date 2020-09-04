import 'dart:convert';

import 'package:flutter/rendering.dart';
import 'package:worker/providers/workday.dart';
import 'package:worker/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:http/http.dart' as http;

import '../widgets.dart';
import '../../model/user.dart';
import '../../model/workday.dart';
import '../../providers/auth.dart';

class DashboardHome extends StatefulWidget {
  static const routeName = '/dashboard';

  @override
  _DashboardHomeState createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<DashboardHome> {
  User user;
  User _user;
  Workday _wd;
  var jsonData;
  User userModel;
  String text =
      'Hola, Registrate en la mejor plataforma de empleo de EUA, a traves del siguiente enlace: http://emplooy.turpialdev.webfactional.com/user/register-worker?referralCode=';
  String url = 'www.google.com';
  // ignore: unused_field
  int _selectedIndex = 0;

  void _viewUser() {
    Provider.of<Auth>(context, listen: false).fetchUser().then((value) {
      setState(() {
        _user = value;
        user = value;
      });
    });
  }

  Future<String> getSWData() async {
    var res = await http.get(
        'http://emplooy.turpialdev.webfactional.com/api/v-1/workday/1/get-current',
        headers: {
          "Authorization": "Token 4ead92aa67e22337c35db38e019437eba1fe4ab5"
        });
    var resBody = json.decode(res.body);
    print(resBody);

    if (res.statusCode == 200) {
      setState(() {
        _wd = Workday.fromJson(resBody);
      });
    } else {
      // print(res.statusCode);
    }

    return "Sucess";
  }

  /*void _viewWorkDay() {
    Provider.of<WorkDay>(context, listen: false).fetchWorkDay().then((value) {
      setState(() {
        _wd = value;
      });
    });
  }*/

  @override
  void initState() {
    _viewUser();
    this.getSWData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_wd != null) {
      print(_wd.id);
    }
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
          ),
        ),
        endDrawer: MenuLateral(
          user: user,
          workday: _wd != null ? _wd.id : null,
        ),
        body: Image.asset(
          'assets/referido.png',
          height: 1000,
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.share,
            color: Hexcolor('EA6012'),
          ),
          backgroundColor: Colors.white,
          onPressed: () {
            final RenderBox box = context.findRenderObject();
            Share.share(text + _user.referral_code,
                subject: url,
                sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
          },
        ),
        bottomNavigationBar: AppBarButton(
          user: _user,
          selectIndex: 0,
        ));
  }
}
