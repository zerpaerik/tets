import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class ImageInputGallery extends StatefulWidget {
  final Function onSelectImage;

  ImageInputGallery(this.onSelectImage);

  @override
  _ImageInputGalleryState createState() => _ImageInputGalleryState();
}

class _ImageInputGalleryState extends State<ImageInputGallery> {
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
        Container(
          width: 340,
          height: 280,
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
                  'No hay Imagen',
                  textAlign: TextAlign.center,
                ),
          alignment: Alignment.center,
        ),
        SizedBox(
          width: 80,
        ),
        SizedBox(height: 10),
        Container(
            child: OutlineButton.icon(
          padding: EdgeInsets.all(15),
          borderSide: BorderSide(color: Hexcolor('EA6012')),
          onPressed: _takePicture,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          label: Text(
            'Agregar Imagen',
            style: TextStyle(
              color: Hexcolor('EA6012'),
              letterSpacing: 1.5,
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans-Regular',
            ),
          ),
          icon: Icon(
            Icons.image,
            color: Hexcolor('EA6012'),
          ),
        ))
      ],
    );
  }
}
