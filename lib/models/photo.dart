import 'dart:io';

import 'package:flutter/material.dart';

class Photo {
  String id;
  String name;
  String imageUrl;
  bool like;
  Photo({
    @required this.id,
    @required this.name,
    @required this.imageUrl,
    @required this.like,
  });
}
