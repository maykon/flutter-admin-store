import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourcesSheet extends StatelessWidget {
  final Function(File) onImageSelected;

  const ImageSourcesSheet({Key key, @required this.onImageSelected})
      : super(key: key);

  void imageSelected(File image) async {
    if (image != null) {
      File croppedImage = await ImageCropper.cropImage(
        sourcePath: image.path,
        ratioX: 1.0,
        ratioY: 1.0,
      );
      onImageSelected(croppedImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      builder: (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              FlatButton(
                child: Text("Camera"),
                onPressed: () async {
                  File image =
                      await ImagePicker.pickImage(source: ImageSource.camera);
                  imageSelected(image);
                },
              ),
              FlatButton(
                child: Text("Galeria"),
                onPressed: () async {
                  File image =
                      await ImagePicker.pickImage(source: ImageSource.gallery);
                  imageSelected(image);
                },
              ),
            ],
          ),
      onClosing: () {},
    );
  }
}