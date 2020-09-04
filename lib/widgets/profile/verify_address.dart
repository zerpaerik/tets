import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
//import 'package:pedantic/analysis_options.yaml';

class VerifyAddress extends StatefulWidget {
  final String add1;
  final String add2;
  VerifyAddress({@required this.add1, @required this.add2});

  @override
  _VerifyAddressState createState() => _VerifyAddressState(add1, add2);
}

class _VerifyAddressState extends State<VerifyAddress> {
  final String add1;
  final String add2;
  _VerifyAddressState(this.add1, this.add2);
  bool addres1 = false;
  bool addres2 = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Row(children: <Widget>[
            Checkbox(
              activeColor: Hexcolor('EA6012'),
              value: addres1,
              onChanged: (bool value) {
                setState(() {
                  addres1 = value;
                  print(addres1);
                });
              },
            ),
            Text(add1)
          ]),
          Divider(),
          if (add2 != 'no-data') ...[
            Row(children: <Widget>[
              Checkbox(
                activeColor: Hexcolor('EA6012'),
                value: addres2,
                onChanged: (bool value) {
                  setState(() {
                    addres2 = value;
                  });
                },
              ),
              Text(add2)
            ])
          ] //
        ],
      ),
    );
  }
}
