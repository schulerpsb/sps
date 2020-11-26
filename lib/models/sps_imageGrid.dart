import 'dart:io';
import 'package:flutter/material.dart';

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
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: InkWell(
                onTap: () => {
                  refreshGridView = Navigator.push(
                          context, MaterialPageRoute(builder: (context) {}))
                      .then((refreshGridView) {
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
        });
  }
}
