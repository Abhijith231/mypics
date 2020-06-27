import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:blurhash/blurhash.dart';

import '../providers/photoprovider.dart';

class Uploader extends StatefulWidget {
  final File file;
  bool up;
  Uploader(
    this.file,
    this.up,
  );
  @override
  _UploaderState createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://mypics-481ed.appspot.com');

  StorageUploadTask _uploadTask;

  /// Starts an upload task
  Future<void> _startUpload() async {
    /// Unique file name for the file
    String filename = DateTime.now().toString();
    String filePath = 'images/$filename.jpg';

    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
    });
    var image = Image.file(widget.file);
    // ByteData bytes = await image.bodyBytes,
    // Uint8List pixels = bytes.buffer.asUint8List();

    var dowurl = await (await _uploadTask.onComplete).ref.getDownloadURL();
    var url = dowurl.toString();
    http.Response response = await http.get(
      url,
    );
    Uint8List pixels = response.bodyBytes;
    var blurHash = await BlurHash.encode(pixels, 4, 3);
    Provider.of<PhotoProvider>(context, listen: false)
        .addPhoto(url, filename, blurHash);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.up) {
      _startUpload();
    }
    if (_uploadTask != null) {
      /// Manage the task state and event subscription with a StreamBuilder
      return Scaffold(
        body: StreamBuilder<StorageTaskEvent>(
            stream: _uploadTask.events,
            builder: (_, snapshot) {
              var event = snapshot?.data?.snapshot;

              double progressPercent = event != null
                  ? event.bytesTransferred / event.totalByteCount
                  : 0;

              if (_uploadTask.isComplete) {
                Navigator.of(context).pop();
              } else {
                return CircularProgressIndicator();
              }
              // return Column(
              //   children: [
              //     if (_uploadTask.isComplete) Text('🎉🎉🎉'),

              //     if (_uploadTask.isPaused)
              //       FlatButton(
              //         child: Icon(Icons.play_arrow),
              //         onPressed: _uploadTask.resume,
              //       ),

              //     if (_uploadTask.isInProgress)
              //       FlatButton(
              //         child: Icon(Icons.pause),
              //         onPressed: _uploadTask.pause,
              //       ),

              //     // Progress bar
              //     LinearProgressIndicator(value: progressPercent),
              //     Text('${(progressPercent * 100).toStringAsFixed(2)} % '),
              //   ],
              // );
            }),
      );
    } else {
      // Allows user to decide when to start the upload
      return Scaffold(
        body: Center(
          child: FlatButton.icon(
            label: Text('Upload to Firebase'),
            icon: Icon(Icons.cloud_upload),
            onPressed: _startUpload,
          ),
        ),
      );
    }
  }
}
