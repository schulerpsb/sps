import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sps/models/sps_login.dart';
import 'package:sps/screens/sps_drawer_screen.dart';
import 'package:extended_image/extended_image.dart';
import 'package:exif/exif.dart';
import 'package:image/image.dart' as img;

class sps_imagePlayer_screen extends StatefulWidget {
  final String _filePath;
  final String _fileType;

  sps_imagePlayer_screen(this._filePath, this._fileType);

  @override
  _sps_imagePlayer_screen createState() => _sps_imagePlayer_screen();
}

class _sps_imagePlayer_screen extends State<sps_imagePlayer_screen> {
  final SpsLogin spslogin = SpsLogin();
  GlobalKey<ScaffoldState> _key = GlobalKey();
  final GlobalKey<ExtendedImageEditorState> editorKey =
  GlobalKey<ExtendedImageEditorState>();

  File _teste;

  @override
  Widget build(BuildContext context) {
    //imageCache.clear();
    return Scaffold(
      backgroundColor: Color(0xFFe9eef7), // Cinza Azulado
      appBar: AppBar(
        backgroundColor: Color(0xFF004077), // Azul Schuler
        title: Text(
          'VISUALIZADOR DE IMAGENS',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      endDrawer: sps_drawer(spslogin: spslogin),
      body: SizedBox.expand(
        // child: Hero(
        // tag: heroTag,
        child: ExtendedImageSlidePage(
          slideAxis: SlideAxis.both,
          slideType: SlideType.onlyImage,
          child: buildExtendedImage(),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "btn1",
            onPressed: _reset,
            tooltip: 'Increment',
            child: Icon(Icons.flip_to_back),
          ),
          FloatingActionButton(
            heroTag: "btn2",
            onPressed: _girarEsquerda,
            tooltip: 'Increment',
            child: Icon(Icons.rotate_left),
          ),
          FloatingActionButton(
            heroTag: "btn3",
            onPressed: _girarDireita,
            tooltip: 'Increment',
            child: Icon(Icons.rotate_right),
          ),
        ],
      ),
    );
  }

  ExtendedImage buildExtendedImage() {
    imageCache.clear();
    return ExtendedImage.file(
          File(this.widget._filePath),
          fit: BoxFit.contain,
          mode: ExtendedImageMode.editor,
          extendedImageEditorKey: editorKey,
          initEditorConfigHandler: (state) {
            return EditorConfig(
                editorMaskColorHandler:
                    (BuildContext context, bool pointerDown) {
                  return pointerDown
                      ? Colors.transparent
                      : Colors.transparent;
                },
                lineColor: Colors.transparent,
                maxScale: 8.0,
                cropRectPadding: EdgeInsets.all(0.0),
                cornerPainter:
                    ExtendedImageCropLayerPainterNinetyDegreesCorner(
                        color: Colors.transparent,
                        cornerSize: Size(30.0, 3.0)),
                hitTestSize: 20.0,
                cropAspectRatio: 0.0);
          },
        );
  }

  void _girarDireita() {
    fixExifRotation(this.widget._filePath, 90).then((value){
      editorKey.currentState.rotate(right: true);
      imageCache.clear();
    });
  }

  void _girarEsquerda() {
    fixExifRotation(this.widget._filePath, -90).then((value){
      editorKey.currentState.rotate(right: false);
      imageCache.clear();
    });
  }

  void _reset() {
    editorKey.currentState.reset();
  }

  Future<File> fixExifRotation(String imagePath, int degree) async {
    final originalFile = File(imagePath);
    List<int> imageBytes = await originalFile.readAsBytes();
    final originalImage = img.decodeImage(imageBytes);

    img.Image fixedImage;

    fixedImage = img.copyRotate(originalImage, degree);

    final fixedFile = await originalFile.writeAsBytes(img.encodeJpg(fixedImage));

    return fixedFile;
  }

}
