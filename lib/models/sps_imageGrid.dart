import 'dart:io';
import 'package:flutter/material.dart';
import 'package:thumbnails/thumbnails.dart';

class ImageGrid extends StatelessWidget {
  final Directory directory;
  final String extensao;

  const ImageGrid({Key key, this.directory, this.extensao}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var refreshGridView;
    var imageList = directory
        .listSync()
        .map((item) => item.path)
        .where((item) => item.endsWith(extensao))
        .toList(growable: false);
    return GridView.builder(
      itemCount: imageList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, childAspectRatio: 3.0 / 4.6),
      itemBuilder: (context, index) {
        File file = new File(imageList[index]);
        String name = file.path.split('/').last;
        if(extensao == ".mp4"){
  //        imageList[index] = _noFolder(imageList[index]);
        }
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: InkWell(
              onTap: () => {
                refreshGridView =
                    Navigator.push(context, MaterialPageRoute(builder: (context) {

                    })).then((refreshGridView) {
                      if (refreshGridView != null) {
                        build(context);
                      }
                    }).catchError((er) {
                      print(er);
                    }),
              },
              child: Padding(
                padding: new EdgeInsets.all(4.0),
                child: Image.file(
                  File(imageList[index]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _toUserFolder() async {
    String thumb = await Thumbnails.getThumbnail(
        thumbnailFolder: '/storage/emulated/0/Android/data/com.example.sps/files/Pictures',
        videoFile: '/storage/emulated/0/Android/data/com.example.sps/files/Pictures/be4fff80-4f45-4828-8b15-1dffdf81a3525342915838841891007.mp4',
        imageType: ThumbFormat.PNG,
        quality: 30);
    print('path to File: $thumb');
  }

// when an output folder is not specified thumbnail are stored in app temporary directory
  Future<String> _noFolder(path) async {
    String thumb = await Thumbnails.getThumbnail(
        videoFile: path,
        imageType: ThumbFormat.JPEG,
        quality: 30);
    print('Path to cache folder $thumb');
    return thumb.toString();
  }

}