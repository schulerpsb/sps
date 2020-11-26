import 'dart:io';

import 'package:flutter/material.dart';
import 'package:thumbnails/thumbnails.dart';

class spsCriarThumbs {


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

  static Future<String> toUserFolder() async {
    final Directory _thumbspath = new Directory('/storage/emulated/0/Android/data/com.example.sps/files/Pictures/thumbs');
    final Directory _videospath = new Directory('/storage/emulated/0/Android/data/com.example.sps/files/Pictures');
    final checkPathExistence = await _thumbspath.exists();
    if(!checkPathExistence){
      new Directory('/storage/emulated/0/Android/data/com.example.sps/files/Pictures/thumbs').create();
    }
    var imageList = _videospath
        .listSync()
        .map((item) => item.path)
        .where((item) => item.endsWith('.mp4'))
        .toList(growable: false);
    imageList.forEach( (item) async {
      String thumb = await Thumbnails.getThumbnail(
          thumbnailFolder: '/storage/emulated/0/Android/data/com.example.sps/files/Pictures/thumbs',
          videoFile: item,
          imageType: ThumbFormat.JPEG,
          quality: 30);
      //print('path to File: $thumb');
    });
  }

// when an output folder is not specified thumbnail are stored in app temporary directory
  static Future<String> noFolder(path) async {
    String thumb = await Thumbnails.getThumbnail(
        videoFile: path, imageType: ThumbFormat.JPEG, quality: 30);
    //print('Path to cache folder $thumb');
    return thumb.toString();
  }

}