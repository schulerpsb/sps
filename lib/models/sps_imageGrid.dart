import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sps/components/media.dart';
import 'package:sps/screens/sps_mediaPlayer_screen.dart';

class ImageGrid extends StatelessWidget {
  final Directory directory;
  final String extensao;
  final String tipo;

  const ImageGrid({Key key, this.directory, this.extensao, this.tipo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //var fileWithExtensionpath = List();
    String teste = "";
    var refreshGridView;
    int indicemedia;
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
          indicemedia = index;
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
                    context,
                    MaterialPageRoute(
                        builder: (context) => sps_mediaPlayer_screen(imageList[index], tipo)),
                  ).then((refreshGridView) {
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
