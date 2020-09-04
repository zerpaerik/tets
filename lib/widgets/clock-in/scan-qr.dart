import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import '../../model/user.dart';
import '../widgets.dart';

class ScanQr extends StatefulWidget {
  final User user;

  ScanQr({@required this.user});

  @override
  _ScanQrState createState() => _ScanQrState(user);
}

class _ScanQrState extends State<ScanQr> {
  User user;
  _ScanQrState(this.user);
  String _barcode = "";
  bool _scanResult;
  bool scanning = false;
  String _scanBarcode = 'Unknown';
  String qrCodeResult = "Not Yet Scanned";

  getToken() async {
    SharedPreferences token = await SharedPreferences.getInstance();
    String stringValue = token.getString('stringValue');
    return stringValue;
  }

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

  Future<dynamic> scanQRWorkerIN(String identification) async {
    print('entro');
    String token = await getToken();
    setState(() {
      scanning = true;
    });

    print(identification);
    print('consulto');

    //http://emplooy.turpialdev.webfactional.com/api/v-1/user/get-registered-user/$identification/1/in

    final response = await http.get(
        'http://emplooy.turpialdev.webfactional.com/api/v-1/user/get-registered-user/$identification/1/in',
        headers: {
          "Authorization": "Token 8d32aa31c8f0afed16631c53068aa3de7ce9dae3"
        });
    setState(() {
      scanning = false;
    });
    // ignore: await_only_futures
    print(response.body);
    print(response.statusCode);
    var resBody = json.decode(response.body);

    if (response.statusCode == 200 && resBody['first_name'] != null) {
      print('dio 200 scan in');
      User worker = new User.fromJson1(resBody);

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
        body: SingleChildScrollView(
            child: Container(
                margin: EdgeInsets.only(top: 30),
                child: Column(children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 30, right: 30),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text('Escanear código QR',
                          style: TextStyle(
                            color: Hexcolor('EA6012'),
                            //letterSpacing: 1,
                            fontSize: 19.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'OpenSans-Regular',
                          )),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                      margin: EdgeInsets.only(left: 30, right: 30),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Escanea el código qr del empleado para hacer clock-in en el sistema.',
                          style: TextStyle(
                            color: Colors.grey,
                            fontFamily: 'OpenSans-Regular',
                            fontSize: 17,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      )),
                  SizedBox(height: 15),
                  Container(
                    margin: EdgeInsets.only(left: 30, right: 30),
                    child: Align(
                        alignment: Alignment.center,
                        child: Image.asset(
                          'assets/camara.png',
                          width: 400,
                        )),
                  ),
                  SizedBox(height: 60),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        width: 200,
                        height: 50.0,
                        // margin: EdgeInsets.only(left:15),
                        child: OutlineButton.icon(
                          padding: EdgeInsets.all(15),
                          borderSide: BorderSide(color: Hexcolor('EA6012')),
                          onPressed: () async {
                            String codeSanner =
                                await BarcodeScanner.scan(); //barcode scnner
                            setState(() {
                              qrCodeResult = codeSanner;
                            });
                            print(qrCodeResult);
                            scanQRWorkerIN(qrCodeResult);

                            // try{
                            //   BarcodeScanner.scan()    this method is used to scan the QR code
                            // }catch (e){
                            //   BarcodeScanner.CameraAccessDenied;   we can print that user has denied for the permisions
                            //   BarcodeScanner.UserCanceled;   we can print on the page that user has cancelled
                            // }
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          label: Text(
                            'Escanear imagen',
                            style: TextStyle(
                              color: Hexcolor('EA6012'),
                              letterSpacing: 1.5,
                              fontSize: 13.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'OpenSans-Regular',
                            ),
                          ),
                          icon: Icon(
                            Icons.image,
                            color: Hexcolor('EA6012'),
                          ),
                        ),
                      ),
                    ],
                  )
                ]))),
        bottomNavigationBar: AppBarButton(
          user: user,
          selectIndex: 0,
        ));
  }

  /* Future scan() async {
    try {
     // var barcode = await BarcodeScanner.scan();
      setState(() => this._barcode = barcode.toString());
      bool scanResult = await scanQRWorker(_scanBarcode);
      setState(() {
        _scanResult = scanResult;
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          this._barcode = 'El usuario no dio permiso para el uso de la cámara!';
        });
      } else {
        setState(() => this._barcode = 'Error desconocido $e');
      }
    } on FormatException {
      setState(() => this._barcode =
          'nulo, el usuario presionó el botón de volver antes de escanear algo)');
    } catch (e) {
      setState(() => this._barcode = 'Error desconocido : $e');
    }
  }*/
}
