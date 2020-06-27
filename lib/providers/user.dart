import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class User {
  String _name;
  List<String> _likedPhotos = [];

  Future<void> setInitial() async {
    _name = await _getUsername();
    _likedPhotos = await _getLikes();
  }

  Future<String> _getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    var username = prefs.getString('userName');
    if (username == null) {
      username = 'User-${DateTime.now()}';
      await prefs.setString('userName', username);
    }
    return username;
  }

  Future<List<String>> _getLikes() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> like = prefs.getStringList('likedPhotos');
    if (like == null) {
      like = [];
    }
    return like;
  }

  Future<void> addLike(String photo) async {
    final prefs = await SharedPreferences.getInstance();
    _likedPhotos.add(photo);
    await prefs.setStringList('likedPhotos', _likedPhotos);
  }

  Future<void> removeLike(String photo) async {
    final prefs = await SharedPreferences.getInstance();
    _likedPhotos.remove(photo);
    await prefs.setStringList('likedPhotos', _likedPhotos);
  }

  Future<void> refreshLikes() async {
    _likedPhotos = await _getLikes();
  }

  String get username {
    return _name;
  }

  List<String> get likes {
    return [..._likedPhotos];
  }

  bool _isliked(String photoName) {
    if (_likedPhotos != null) {
      if (_likedPhotos.contains(photoName)) {
        return true;
      }
    }
    return false;
  }

  void likePhoto(String photoName) {
    _isliked(photoName) ? addLike(photoName) : removeLike(photoName);
    refreshLikes();
  }
}
