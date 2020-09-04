import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class ImageInputRierCamera extends StatefulWidget {
  final Function onSelectImage;

  ImageInputRierCamera(this.onSelectImage);

  @override
  _ImageInputRierCameraState createState() => _ImageInputRierCameraState();
}

class _ImageInputRierCameraState extends State<ImageInputRierCamera> {
  // ignore: unused_field
  File _storedImage;

  Future<void> _takePicture() async {
    // ignore: deprecated_member_use
    final imageFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );
    if (imageFile == null) {
      return;
    }
    setState(() {
      _storedImage = imageFile;
    });
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage = await imageFile.copy('${appDir.path}/$fileName');
    widget.onSelectImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 5),
        Container(
            child: IconButton(
          icon: Icon(Icons.camera),
          color: Hexcolor('EA6012'),
          onPressed: _takePicture,
        )),
      ],
    );
  }
}
