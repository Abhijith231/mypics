import 'dart:io';

import 'package:flutter/material.dart';

class Photo {
  String id;
  String name;
  String imageUrl;
  Photo({
    @required this.id,
    @required this.name,
    @required this.imageUrl,
  });
}
