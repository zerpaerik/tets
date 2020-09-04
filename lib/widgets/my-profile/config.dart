import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import '../../providers/auth.dart';

class ConfigPage extends StatelessWidget {
  _launchURLTerms() async {
    const url =
        'http://emplooy.turpialdev.webfactional.com/legal/terms-and-conditions';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchURLPolicy() async {
    const url =
        'http://emplooy.turpialdev.webfactional.com/legal/privacy-policies';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    void _showErrorDialog() {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Estás Intentando Salir'),
          content: Text('¿Estás seguro que deseas cerrar sesión?'),
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
                Provider.of<Auth>(context, listen: false).logout();
                Navigator.of(context, rootNavigator: true).pop('/auth');
                Navigator.of(context).pushReplacementNamed('/auth');
              },
            )
          ],
        ),
      );
    }

    return new Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
          elevation: 2.0,
          backgroundColor: Colors.white,
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Hexcolor('EA6012'),
          ),
          title: Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Configuración',
                style: TextStyle(color: Hexcolor('EA6012')),
              ))),
      body: Column(children: <Widget>[
        Container(
            margin: EdgeInsets.only(left: 15, top: 15),
            child: Align(
                alignment: Alignment.topLeft,
                child: FlatButton.icon(
                    onPressed: _launchURLTerms,
                    icon: Icon(
                      Icons.info_outline,
                      color: Colors.grey,
                    ),
                    label: Text(
                      'Terminos y Condiciones',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    )))),
        Container(
            margin: EdgeInsets.only(left: 15, top: 5),
            child: Align(
                alignment: Alignment.topLeft,
                child: FlatButton.icon(
                    onPressed: _launchURLPolicy,
                    icon: Icon(
                      Icons.lock_outline,
                      color: Colors.grey,
                    ),
                    label: Text(
                      'Politicas de Privacidad',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    )))),
        Container(
            margin: EdgeInsets.only(left: 15, top: 5),
            child: Align(
                alignment: Alignment.topLeft,
                child: FlatButton.icon(
                    onPressed: _showErrorDialog,
                    icon: Icon(
                      Icons.exit_to_app,
                      color: Colors.grey,
                    ),
                    label: Text(
                      'Cerrar Sesión',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ))))
      ]),
    );
  }
}
