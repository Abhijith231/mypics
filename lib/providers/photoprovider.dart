import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/photo.dart';

class PhotoProvider extends ChangeNotifier {
  List<Photo> _photos = [];

  List<Photo> get photos {
    return [..._photos];
  }

  Future<void> fetchAndSetPhotos() async {
    var url = 'https://mypics-481ed.firebaseio.com/photos.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Photo> loadedPhoto = [];
      if (extractedData == null) {
        return;
      }
      extractedData.forEach((id, photoData) {
        loadedPhoto.add(Photo(
          id: id,
          name: photoData['name'],
          imageUrl: photoData['url'],
        ));
      });
      _photos = loadedPhoto;
      notifyListeners();
    } catch (error) {}
  }

  Future<void> addPhoto(String url, String filename) async {
    var postUrl = 'https://mypics-481ed.firebaseio.com/photos.json';
    try {
      final response = await http.post(
        postUrl,
        body: json.encode({
          'name': filename,
          'url': url,
        }),
      );
      final newPhoto = Photo(
        id: json.decode(response.body)['name'],
        name: filename,
        imageUrl: url,
      );
      _photos.add(newPhoto);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
