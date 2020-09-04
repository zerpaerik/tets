import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../model/user.dart';
import '../../providers/workday.dart';
import '../widgets.dart';

class InitClockIn extends StatefulWidget {
  final User user;

  InitClockIn({@required this.user});

  @override
  _InitClockInState createState() => _InitClockInState(user);
}

class _InitClockInState extends State<InitClockIn> {
  User user;
  _InitClockInState(this.user);
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool isLoading = false;

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

  Future<void> _submit() async {
    setState(() {
      isLoading = true;
    });
    try {
      Provider.of<WorkDay>(context, listen: false)
          .addWorkday()
          .then((response) {
        setState(() {
          isLoading = false;
        });
        if (response == '201') {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ClockIn(
                      user: user,
                    )),
          );
        } else {
          _showErrorDialog('Verifique la información');
        }
      });
    } catch (error) {}
    /* Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfilePartOblig2()),
          );*/
  }

  @override
  Widget build(BuildContext context) {
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
        ),
        body: Form(
            key: _formKey,
            child: SingleChildScrollView(
                child: Container(
                    margin: EdgeInsets.only(top: 50),
                    child: Column(children: <Widget>[
                      SizedBox(height: 30),
                      Align(
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/init_clockin.png',
                            width: 200,
                          )),
                      SizedBox(height: 20),
                      Container(
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Aún no han ingresado trabajadores.',
                              style: TextStyle(
                                color: Hexcolor('9c9c9c'),
                                fontFamily: 'OpenSans-Regular',
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          )),
                      SizedBox(height: 150),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            width: 150,
                            height: 50.0,
                            // margin: EdgeInsets.only(left:15),
                            child: isLoading
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : RaisedButton(
                                    elevation: 5.0,
                                    onPressed: _submit,
                                    // padding: EdgeInsets.only(left: 20, right: 20,top: 15, bottom: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    color: Hexcolor('252850'),
                                    child: Text(
                                      'Clock-In inicial',
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
                          Container(
                            width: 150,
                            height: 50.0,
                            child: RaisedButton(
                              elevation: 5.0,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ConfirmClockIn(
                                          user: this.widget.user)),
                                );
                              },
                              // padding: EdgeInsets.only(left: 20, right: 20,top: 10, bottom: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              color: Colors.grey[700],
                              child: Text(
                                'Clock-In',
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
                        ],
                      )
                    ])))),
        bottomNavigationBar: AppBarButton(
          user: user,
          selectIndex: 0,
        ));
  }
}
