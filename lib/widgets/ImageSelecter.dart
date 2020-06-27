import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

import 'uploader.dart';

/// Widget to capture and crop the image
class ImageCapture extends StatefulWidget {
  final source;
  ImageCapture(this.source);
  createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  /// Active image file
  final picker = ImagePicker();
  File _imageFile;
  // print("here");

  /// Cropper plugin
  Future<void> _cropImage() async {
    File cropped = await ImageCropper.cropImage(
      sourcePath: _imageFile.path,
      // ratioX: 1.0,
      // ratioY: 1.0,
      // maxWidth: 512,
      // maxHeight: 512,
      androidUiSettings: AndroidUiSettings(
        toolbarColor: Colors.purple,
        toolbarWidgetColor: Colors.white,
        toolbarTitle: 'Crop Image',
      ),
    );

    setState(() {
      _imageFile = cropped ?? _imageFile;
    });
  }

  /// Select an image via gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    final _pic = await picker.getImage(source: source);
    File selected = File(_pic.path);

    setState(() {
      _imageFile = selected;
    });
  }

  /// Remove image
  void _clear() {
    setState(() => _imageFile = null);
  }

  Widget viewImage() {
    return SafeArea(
      child: Column(
        children: <Widget>[
          Image.file(_imageFile),

          Row(
            children: <Widget>[
              FlatButton(
                child: Icon(Icons.refresh),
                onPressed: _clear,
              ),
              FlatButton(
                child: Icon(Icons.save),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Uploader(_imageFile),
                  ),
                ),
              )
            ],
          ),

          // Uploader(file: _imageFile)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_imageFile == null) {
      _pickImage(widget.source);
    }
    return Scaffold(
      // Preview the image and crop it
      body: ListView(
        children: <Widget>[
          if (_imageFile != null) ...[viewImage()]
        ],
      ),
    );
  }
}
