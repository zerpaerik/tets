import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:worker/widgets/dashboard/index.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../model/user.dart';
import '../widgets.dart';

class AppBarButton extends StatefulWidget {
  final User user;
  final int selectIndex;

  AppBarButton({@required this.user, @required this.selectIndex});

  @override
  _AppBarButtonState createState() => _AppBarButtonState(user, selectIndex);
}

class _AppBarButtonState extends State<AppBarButton> {
  User user;
  int selectIndex;
  _AppBarButtonState(this.user, this.selectIndex);

  var jsonData;
  User userModel;
  // ignore: unused_field
  int _selectedIndex = 0;

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
                  margin: EdgeInsets.only(left: 30, right: 30, top: 30),
                  child: ClipOval(
                    child: Image.network(
                      this.widget.user.profile_image.path,
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    )
                    /* Image.asset(
                      "assets/codigo-qr.png",
                      width: 200,
                      height: 200,
                    )*/
                    ,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10, top: 20),
                  width: 352,
                  height: 420,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100.0)),
                  ),
                  child: Card(
                    elevation: 6,
                    child: Column(children: <Widget>[
                      SizedBox(height: 20),
                      Text(
                          this.widget.user.first_name +
                              ' ' +
                              this.widget.user.last_name,
                          style: TextStyle(
                              color: Hexcolor('233062'),
                              fontFamily: 'OpenSans-Regular',
                              fontSize: 23,
                              fontWeight: FontWeight.bold)),
                      Text('ID#' + ' ' + this.widget.user.btn_id,
                          style: TextStyle(
                              color: Hexcolor('9c9c9c'),
                              fontFamily: 'OpenSans-Regular',
                              fontSize: 25,
                              fontWeight: FontWeight.bold)),
                      //SizedBox(height:30),
                      QrImage(
                        data: this.widget.user.btn_id,
                        gapless: true,
                        size: 320,
                        errorCorrectionLevel: QrErrorCorrectLevel.H,
                      )
                    ]),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 40.0, right: 40.0, top: 10),
                  width: double.infinity,
                  child: RaisedButton(
                    elevation: 5.0,
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 0;
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
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ListNotifications(
                    user: this.widget.user,
                  )),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MyProfile(user: this.widget.user)),
        );
        break;
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    int _selectedIndex = selectIndex;
    return BottomNavigationBar(
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
              color: Colors.black, size: 40),
          title: Text('Codigo QR'),
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
      selectedItemColor: Hexcolor('EA6012'),
      onTap: _onTap,
    );
  }
}
