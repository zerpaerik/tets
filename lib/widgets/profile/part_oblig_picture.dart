import 'dart:io';
import 'package:worker/widgets/profile/preview_complete.dart';
import 'package:worker/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../model/user.dart';
import '../../providers/auth.dart';
import '../widgets.dart';

class ProfilePartPicture extends StatefulWidget {
  static const routeName = '/add-profile-picture2';

  @override
  _ProfilePartPictureState createState() => _ProfilePartPictureState();
}

class _ProfilePartPictureState extends State<ProfilePartPicture> {
  final _titleController = TextEditingController();
  File _pickedImage;
  var _isLoading = false;

  // ignore: unused_element
  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  // ignore: unused_field
  var _editedUser1 = User(
    profile_image: null,
  );

  // ignore: unused_element
  void _savePlace() {
    if (_titleController.text.isEmpty || _pickedImage == null) {
      return;
    }
    Navigator.of(context).pop();
  }

  Future<void> _saveForm() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<Auth>(context, listen: false)
          .updatePart3(_pickedImage)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PreviewComplete()),
        );
      });
    } catch (error) {}
  }

  @override
  Widget build(BuildContext context) {
    String _titleReg = 'Datos básicos obligatorios';
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Form(
            child: ListView(children: <Widget>[
          TitleProfile(_titleReg),
          Text(
            'Debes agregar tu fotografia para completar el registro básico',
            style: TextStyle(
                fontSize: 17,
                fontFamily: 'OpenSans-Regular',
                color: Hexcolor('9c9c9c'),
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 30),
          //ImageInputCamera(),
          SizedBox(height: 40),
          Row(
            children: <Widget>[
              Expanded(
                child: SizedBox(
                  height: 50.0,
                  child: RaisedButton(
                    elevation: 5.0,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    padding: EdgeInsets.only(
                        left: 20, right: 20, top: 15, bottom: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    color: Hexcolor('EA6012'),
                    child: Text(
                      'Anterior',
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
              ),
              Expanded(
                child: SizedBox(
                  height: 50.0,
                  child: _isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : RaisedButton(
                          elevation: 5.0,
                          onPressed: _saveForm,
                          padding: EdgeInsets.only(
                              left: 20, right: 20, top: 10, bottom: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          color: Hexcolor('009444'),
                          child: Text(
                            'Siguiente',
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
              ),
            ],
          )
        ])),
      ),
    );
  }
}
