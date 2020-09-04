import 'package:worker/widgets/my-profile/certifications/list.dart';
import 'package:worker/widgets/my-profile/tax/w9.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'package:hexcolor/hexcolor.dart';
import '../widgets.dart';
import '../../model/user.dart';

class BodyProfile extends StatelessWidget {
  final User user;

  BodyProfile(this.user);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: true,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(left: 30, top: 20, right: 30),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: user != null
                        ? Text('ID#' + ' ' + user.btn_id,
                            style: TextStyle(
                                color: Colors.grey,
                                fontFamily: 'OpenSans-Regular',
                                fontSize: 18,
                                fontWeight: FontWeight.bold))
                        : Text('Emplooy 0001',
                            style: TextStyle(
                                color: Colors.grey,
                                fontFamily: 'OpenSans-Regular',
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                  )),
              /*
                Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                margin: EdgeInsets.only(left: 25, top: 10),
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
              Container(
                  margin: EdgeInsets.only(left: 30, top: 10, right: 30),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text('Completitud de Perfil',
                        style: TextStyle(
                            color: Hexcolor('EA6012'),
                            fontFamily: 'OpenSans-Regular',
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                  )),
              Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: new LinearPercentIndicator(
                        width: 317.0,
                        animation: true,
                        animationDuration: 1000,
                        lineHeight: 10.0,
                        percent: 0.8,
                        //center: Text("20.0%"),
                        linearStrokeCap: LinearStrokeCap.butt,
                        progressColor: Hexcolor('233062')),
                  )),
              Container(
                margin: EdgeInsets.only(left: 30, top: 20, right: 30),
                child: ClipOval(
                  child: Image.network(
                    user.profile_image.path,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  )
                  /* Image.asset(
                    "assets/codigo-qr.png",
                    width: 180,
                    height: 180,
                  )*/
                  ,
                ),
              ),
              SizedBox(height: 20),
              Text(user.first_name + ' ' + user.last_name,
                  style: TextStyle(
                      color: Hexcolor('233062'),
                      fontFamily: 'OpenSans-Regular',
                      fontSize: 25,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text(user.email,
                  style: TextStyle(
                      color: Hexcolor('9c9c9c'),
                      fontFamily: 'OpenSans-Regular',
                      fontSize: 17,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              Container(
                  margin: EdgeInsets.only(left: 30, right: 30),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: FlatButton.icon(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CertifactionsPage(user: user)));
                          },
                          icon: ImageIcon(
                            AssetImage('assets/003-suitcase.png'),
                            color: Colors.grey,
                          ),
                          label: Text(
                            'Certificaciones',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          )))),
              Divider(
                color: Colors.grey,
                height: 10,
                //thickness: 5,
                indent: 30,
                endIndent: 30,
              ),
              SizedBox(height: 10),
              Container(
                  margin: EdgeInsets.only(left: 30, right: 30),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: (FlatButton.icon(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      BannsWorkerPage(user: user)));
                        },
                        icon: ImageIcon(
                          AssetImage('assets/amonestaciones.png'),
                          color: Colors.grey,
                        ),
                        label: Text(
                          'Amonestaciones',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ))),
                  )),
              Divider(
                color: Colors.grey,
                height: 10,
                //thickness: 5,
                indent: 30,
                endIndent: 30,
              ),
              SizedBox(height: 10),
              Container(
                  margin: EdgeInsets.only(left: 30, right: 30),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: FlatButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => user.id_type == '1'
                                    ? Taxw4(user: user)
                                    : Taxw9(user: user)),
                          );
                        },
                        icon: ImageIcon(
                          AssetImage('assets/004-tax.png'),
                          color: Colors.grey,
                        ),
                        label: Text(
                          'Impuestos',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        )),
                  )),
              Divider(
                color: Colors.grey,
                height: 10,
                //thickness: 5,
                indent: 30,
                endIndent: 30,
              )
            ],
          ),
        ],
      ),
    );
  }
}
