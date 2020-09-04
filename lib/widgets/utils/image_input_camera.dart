import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'dart:async';
import 'package:percent_indicator/percent_indicator.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import '../../providers/auth.dart';
import '../widgets.dart';

class ImageInputCamera extends StatefulWidget {
  static const routeName = '/add-profile-picture';

  @override
  _ImageInputCameraState createState() => _ImageInputCameraState();
}

enum AppState {
  free,
  picked,
  cropped,
}

class _ImageInputCameraState extends State<ImageInputCamera> {
  AppState state;
  File _storedImage;
  // ignore: unused_field
  File _storedImageC;
  var _isLoading = false;

  void initState() {
    super.initState();
    state = AppState.free;
  }

  Future<void> _takePicture() async {
    // ignore: deprecated_member_use
    final imageFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
      maxWidth: 600,
    );
    if (imageFile == null) {
      return;
    }
    setState(() {
      _storedImage = imageFile;
      _storedImageC = imageFile;
      state = AppState.picked;
    });
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    // ignore: unused_local_variable
    final savedImage = await imageFile.copy('${appDir.path}/$fileName');
    //widget.onSelectImage(savedImage);
  }

  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: _storedImage.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Recortar',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Recortar',
        ));
    if (croppedFile != null) {
      _storedImage = croppedFile;
      setState(() {
        state = AppState.cropped;
      });
    }

    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(croppedFile.path);
    // ignore: unused_local_variable
    final savedImage = await croppedFile.copy('${appDir.path}/$fileName');
    //widget.onSelectImage(savedImage);
  }

  Future<void> _saveForm() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<Auth>(context, listen: false)
          .updatePart3(_storedImage)
          .then((response) {
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
                child: ListView(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Text('Completitud de Perfil',
                      style: TextStyle(
                          color: Hexcolor('EA6012'),
                          fontFamily: 'OpenSans-Regular',
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                ),
                Container(
                    margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: new LinearPercentIndicator(
                          width: 300.0,
                          animation: true,
                          animationDuration: 1000,
                          lineHeight: 10.0,
                          percent: 0.4,
                          //center: Text("20.0%"),
                          linearStrokeCap: LinearStrokeCap.butt,
                          progressColor: Hexcolor('233062')),
                    )),
                Container(
                  margin: EdgeInsets.only(left: 20, top: 5.0),
                  child: Text(_titleReg,
                      style: TextStyle(
                          color: Hexcolor('9c9c9c'),
                          fontFamily: 'OpenSans-Regular',
                          fontSize: 19,
                          fontWeight: FontWeight.bold)),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  width: 340,
                  height: 350,
                  decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Hexcolor('EA6012')),
                      borderRadius: BorderRadius.circular(5)),
                  child: _storedImage != null
                      ? Image.file(
                          _storedImage,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        )
                      : Text(
                          'No hay Foto',
                          textAlign: TextAlign.center,
                        ),
                  alignment: Alignment.center,
                ),
                SizedBox(
                  width: 80,
                ),
                SizedBox(height: 10),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    'Por favor enfoca bien tu rostro!',
                    style: TextStyle(
                        fontSize: 13,
                        fontFamily: 'OpenSans-Regular',
                        color: Hexcolor('9c9c9c'),
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                    margin: EdgeInsets.only(left: 90, right: 90),
                    child: _storedImage == null
                        ? OutlineButton.icon(
                            padding: EdgeInsets.all(15),
                            borderSide: BorderSide(color: Hexcolor('EA6012')),
                            onPressed: _takePicture,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            label: Text(
                              'Capturar',
                              style: TextStyle(
                                color: Hexcolor('EA6012'),
                                letterSpacing: 1.5,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'OpenSans-Regular',
                              ),
                            ),
                            icon: Icon(
                              Icons.camera,
                              color: Hexcolor('EA6012'),
                            ),
                          )
                        : OutlineButton.icon(
                            padding: EdgeInsets.all(15),
                            borderSide: BorderSide(color: Hexcolor('EA6012')),
                            onPressed: _cropImage,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            label: Text(
                              'Recortar',
                              style: TextStyle(
                                color: Hexcolor('EA6012'),
                                letterSpacing: 1.5,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'OpenSans-Regular',
                              ),
                            ),
                            icon: Icon(
                              Icons.crop,
                              color: Hexcolor('EA6012'),
                            ),
                          )),
                SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 38),
                      width: 130,
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
                    //onPressed: _storedImage != null ? _saveForm : null,

                    Container(
                      width: 130,
                      height: 50.0,
                      child: _isLoading
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : RaisedButton(
                              elevation: 5.0,
                              onPressed:
                                  _storedImage != null ? _saveForm : null,
                              // padding: EdgeInsets.only(left: 20, right: 20,top: 10, bottom: 10),
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
                  ],
                )
              ],
            ))));
  }
}
