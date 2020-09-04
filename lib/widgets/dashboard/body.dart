import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:share/share.dart';
import '../../model/user.dart';

// ignore: must_be_immutable
class BodyDashboard extends StatelessWidget {
  final User user;
  BodyDashboard({this.user});

  String text =
      'Hola, Registrate en la mejor plataforma de empleo de EUA, a traves del siguiente enlace: http://emplooy.turpialdev.webfactional.com/frontoffice/user/register-worker?referralCode=' +
          '123456';
  String url = 'www.google.com';
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: true,
      body: ListView(
        children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
            Container(
                margin: EdgeInsets.only(left: 19, top: 10, right: 30),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text('ID# 0001',
                      style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'OpenSans-Regular',
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                )),
            Container(
              margin: EdgeInsets.only(left: 140, top: 12),
              child: Align(
                  alignment: Alignment.topRight,
                  child: FloatingActionButton(
                    child: Icon(
                      Icons.share,
                      color: Hexcolor('EA6012'),
                    ),
                    backgroundColor: Colors.white,
                    onPressed: () {
                      final RenderBox box = context.findRenderObject();
                      Share.share(text,
                          subject: url,
                          sharePositionOrigin:
                              box.localToGlobal(Offset.zero) & box.size);
                    },
                  )),
            ),
          ]),
          /*  Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                margin: EdgeInsets.only(left: 16, top: 5),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: RatingBarIndicator(
                    rating: _userRating,
                    itemBuilder: (context, index) => Icon(
                      _selectedIcon ?? Icons.star,
                      color: Hexcolor('ffd700'),
                      semanticLabel: 'Calificaciòn',
                    ),
                    itemCount: 5,
                    itemSize: 20.0,
                    unratedColor: Colors.amber.withAlpha(50),
                    direction: _isVertical ? Axis.vertical : Axis.horizontal,
                  ),
                    
                  ),
              ),
              Container(
                margin: EdgeInsets.only(left: 15, top: 13, right: 10),
                child:Text('clasificación', style: TextStyle(color: Colors.grey),) ,
              ),
              
                
                
                ],
             ),*/
          /*
               Container(
                margin: EdgeInsets.only(left: 19, top: 10, right: 10),
                child: Align(
                  alignment: Alignment.topLeft,
                child:Text('Completitud de Perfil', style: TextStyle(color: Hexcolor('EA6012'), fontFamily: 'OpenSans-Regular', fontSize: 18, fontWeight: FontWeight.bold)),
              )),
               Container(
              margin: EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Align(
                alignment: Alignment.topLeft,
              child: new LinearPercentIndicator(
                width: 339.0,
                animation: true,
                animationDuration: 1000,
                lineHeight: 10.0,
                percent: 0.8,
                //center: Text("20.0%"),
                linearStrokeCap: LinearStrokeCap.butt,
                progressColor: Hexcolor('233062')
               ),
              )),*/
          Image.asset(
            'assets/referido.png', /* width: 200, height: 120,*/
          ),
          /* HoursDisp(),
              OfertDisp(),*/
        ],
      ),
    );
  }
}

class HoursDisp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        margin: EdgeInsets.only(top: 10, left: 20, right: 20),
        color: Hexcolor('EA6012'),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const ListTile(
              title: Text('Total de Horas Trabajadas : 1200',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            Container(
                margin: EdgeInsets.only(left: 15),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text('Horas Trabajadas : 1200',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12)))),
            SizedBox(height: 15),
            Row(children: <Widget>[
              Container(
                  margin: EdgeInsets.only(left: 15, right: 15),
                  child: Column(
                    children: <Widget>[
                      Text('Regulares',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12)),
                      Text('12',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15)),
                    ],
                  )),
              Container(
                  height: 50, child: VerticalDivider(color: Colors.white)),
              Container(
                  margin: EdgeInsets.only(left: 15, right: 15),
                  child: Column(
                    children: <Widget>[
                      Text('Overtime',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12)),
                      Text('12',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15)),
                    ],
                  )),
              Container(
                  height: 50, child: VerticalDivider(color: Colors.white)),
              Container(
                  margin: EdgeInsets.only(left: 15, right: 15),
                  child: Column(
                    children: <Widget>[
                      Text('Viaje',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12)),
                      Text('12',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15)),
                    ],
                  )),
              Container(
                  height: 50, child: VerticalDivider(color: Colors.white)),
              Container(
                  margin: EdgeInsets.only(left: 15, right: 15),
                  child: Column(
                    children: <Widget>[
                      Text('Espera',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12)),
                      Text('12',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15)),
                    ],
                  ))
            ]),
            Divider(
              color: Colors.white,
              // height: 1,
              thickness: 1,
              indent: 15,
              endIndent: 15,
            ),
            Container(
                margin: EdgeInsets.only(left: 15),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text('Rango de Tiempo',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12)))),
            SizedBox(height: 15),
            Row(children: <Widget>[
              Container(
                  margin: EdgeInsets.only(left: 15, right: 10),
                  child: Column(
                    children: <Widget>[
                      Text('Ayer',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10)),
                      Text('12',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15)),
                    ],
                  )),
              Container(
                  height: 40, child: VerticalDivider(color: Colors.white)),
              Container(
                  margin: EdgeInsets.only(left: 15, right: 15),
                  child: Column(
                    children: <Widget>[
                      Text('Ultimos 7 dias',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10)),
                      Text('12',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15)),
                    ],
                  )),
              Container(
                  height: 40, child: VerticalDivider(color: Colors.white)),
              Container(
                  margin: EdgeInsets.only(left: 15, right: 15),
                  child: Column(
                    children: <Widget>[
                      Text('Ultimos 30 dias',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10)),
                      Text('12',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15)),
                    ],
                  )),
              Container(
                  height: 40, child: VerticalDivider(color: Colors.white)),
              Container(
                  margin: EdgeInsets.only(left: 15, right: 15),
                  child: Column(
                    children: <Widget>[
                      Text('Anual',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10)),
                      Text('12',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15)),
                    ],
                  )),
              SizedBox(height: 10)
            ]),
          ],
        ),
      ),
    );
  }
}

class OfertDisp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.only(top: 30, left: 20, right: 20),
        color: Hexcolor('0174DF'),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const ListTile(
              leading: Icon(
                Icons.notifications,
                color: Colors.white,
              ),
              title: Text(
                'Ofertas disponibles',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.right,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Text(
                'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry',
                style: TextStyle(color: Colors.white, fontSize: 10),
                textAlign: TextAlign.justify,
              ),
            ),
            ButtonBar(
              children: <Widget>[
                RaisedButton(
                  elevation: 5.0,
                  onPressed: null,
                  padding: EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Text(
                    'Ver Ofertas',
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 1,
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
