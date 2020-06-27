import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../models/photo.dart';
import '../providers/user.dart';

class PhotoProvider extends ChangeNotifier {
  List<Photo> _photos = [];
  User user = User();
  List<String> _liked;

  List<Photo> get photos {
    return [..._photos];
  }

  Future<void> fetchAndSetPhotos() async {
    var url = 'https://mypics-481ed.firebaseio.com/photos.json';
    //await user.setInitial();
    // final _liked = user.likes;
    await user.setInitial();
    _liked = user.likes;

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Photo> loadedPhoto = [];
      if (extractedData == null) {
        return;
      }
      extractedData.forEach((id, photoData) {
        loadedPhoto.add(
          Photo(
            id: id,
            name: photoData['name'],
            imageUrl: photoData['url'],
            like: _liked != null
                ? _liked.contains(photoData['name']) ? true : false
                : false,
          ),
        );
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
        like: false,
      );
      _photos.add(newPhoto);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> toggleLikePhoto(String photoName) async {
    _liked.contains(photoName)
        ? await user.removeLike(photoName)
        : await user.addLike(photoName);
    _photos.firstWhere((element) => element.name == photoName).like =
        !_photos.firstWhere((element) => element.name == photoName).like;
    await user.refreshLikes();
    _liked = user.likes;
    notifyListeners();
  }
}
