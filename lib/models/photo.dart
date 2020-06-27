import 'dart:io';

import 'package:flutter/material.dart';

class Photo {
  String id;
  String name;
  String imageUrl;
  bool like;
  String blurhash;
  Photo({
    @required this.id,
    @required this.name,
    @required this.imageUrl,
    @required this.like,
    @required this.blurhash,
  });
}
