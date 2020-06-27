import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mypics/constants.dart';

import '../widgets/ImageSelecter.dart';
import '../widgets/showImages.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MyPics"),
      ),
      body: Center(
        child: ShowImages(),
      ),
      floatingActionButton: SpeedDial(
        backgroundColor: colorCustom,
        animatedIcon: AnimatedIcons.add_event,
        children: [
          SpeedDialChild(
            backgroundColor: Color(0xFFFA8E44),
            child: Icon(Icons.camera),
            label: "Open Camera",
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ImageCapture(ImageSource.camera),
              ),
            ),
          ),
          SpeedDialChild(
            backgroundColor: Color(0xFFFA8E44),
            child: Icon(Icons.image),
            label: "Open Gallery",
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ImageCapture(ImageSource.gallery),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
