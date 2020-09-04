import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class ImageInputRier extends StatefulWidget {
  final Function onSelectImage;

  ImageInputRier(this.onSelectImage);

  @override
  _ImageInputRierState createState() => _ImageInputRierState();
}

class _ImageInputRierState extends State<ImageInputRier> {
  File _storedImage;

  Future<void> _takePicture() async {
    // ignore: deprecated_member_use
    final imageFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
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
        SizedBox(
          height: 20,
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                  child: FlatButton(
                onPressed: _takePicture,
                child: Text('Foto Trasera',
                    style: TextStyle(
                      fontFamily: 'OpenSans-Regular',
                      fontWeight: FontWeight.bold,
                      color: Hexcolor('EA6012'),
                      fontSize: 18.0,
                    )),
              )),
              Container(
                width: 160,
                height: 70,
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Hexcolor('EA6012')),
                    borderRadius: BorderRadius.circular(5)),
                child: _storedImage != null
                    ? Image.file(
                        _storedImage,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      )
                    : Text(
                        'No hay Imagen',
                        textAlign: TextAlign.center,
                      ),
                alignment: Alignment.center,
              )
            ])
      ],
    );
  }
}
