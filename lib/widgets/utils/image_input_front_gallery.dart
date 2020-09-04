import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class ImageInputFrontGallery extends StatefulWidget {
  final Function onSelectImage;

  ImageInputFrontGallery(this.onSelectImage);

  @override
  _ImageInputFrontGalleryState createState() => _ImageInputFrontGalleryState();
}

class _ImageInputFrontGalleryState extends State<ImageInputFrontGallery> {
  // ignore: unused_field
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
        SizedBox(height: 5),
        Container(
            child: IconButton(
          icon: Icon(Icons.image),
          color: Hexcolor('EA6012'),
          onPressed: _takePicture,
        )),
      ],
    );
  }
}
