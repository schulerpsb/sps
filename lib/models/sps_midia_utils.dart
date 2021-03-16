import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sps/dao/sps_dao_questionario_midia_class.dart';
import 'package:sps/http/sps_http_verificar_conexao_class.dart';
//import 'package:thumbnails/thumbnails.dart';
import 'package:exif/exif.dart';
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';
import 'package:sps/models/sps_usuario_class.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class spsMidiaUtils {


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

  static Future<String> criarVideoThumb({List fileList}) async {
    final Directory _thumbspath = new Directory(usuarioAtual.document_root_folder.toString() + '/thumbs');
    final checkPathExistence = await _thumbspath.exists();
    if(!checkPathExistence){
      new Directory(usuarioAtual.document_root_folder.toString() + '/thumbs').create();
    }
    fileList.forEach( (item) async {
        final thumb = await VideoThumbnail.thumbnailFile(
          video: item,
          thumbnailPath: usuarioAtual.document_root_folder.toString() + '/thumbs',
          imageFormat: ImageFormat.JPEG,
          quality: 30,
        );
    });
  }

  static Future<String> processarArquivoCapturado({String tipo = "", Map<String,dynamic> dadosArquivo = null}) async {
    File sourceFile = new File(dadosArquivo['arquivo']);
    String _extensaoArquivo = sourceFile.path.split('.').last;
    DateFormat dateFormat = DateFormat("yyyyMMdd_HHmmss");
    DateTime now = DateTime.now();
    String _nomeArquivo = dateFormat.format(now)+'.'+_extensaoArquivo.toString();
    String newPath = usuarioAtual.document_root_folder.toString() + '/' +_nomeArquivo.toString();
    final util  = new spsMidiaUtils();
    File arquivoRenomeado = await util.moveFile(sourceFile, newPath);
    return arquivoRenomeado.path;
  }

// when an output folder is not specified thumbnail are stored in app temporary directory
//  static Future<String> noFolder(path) async {
//    String thumb = await Thumbnails.getThumbnail(
//        videoFile: path, imageType: ThumbFormat.JPEG, quality: 30);
//    //print('Path to cache folder $thumb');
//    return thumb.toString();
//  }

  Future<File> moveFile(File sourceFile, String newPath) async {
    try {
      // prefer using rename as it is probably faster
      return await sourceFile.rename(newPath);
    } on FileSystemException catch (e) {
      // if rename fails, copy the source file and then delete it
      final newFile = await sourceFile.copy(newPath);
      await sourceFile.delete();
      return newFile;
    }
  }

  Future<void> deleteFile(String arquivo) async {
    File file = File(arquivo);
    try {
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      // Error in getting access to the file.
    }
  }

  Future<File> normalizarArquivo(String imagePath) async {
    final originalFile = File(imagePath);
    List<int> imageBytes = await originalFile.readAsBytes();

    final originalImage = img.decodeImage(imageBytes);

    final originalHeight = originalImage.height;
    final originalWidth = originalImage.width;

    print('Resolução original ==>width: '+originalWidth.toString()+' original height: '+originalHeight.toString());

    img.Image fixedImage;

     fixedImage = originalImage;

    final fixedHeight = fixedImage.height;
    final fixedWidth = fixedImage.width;

    if (fixedHeight <= 1920) {
      print('Arquivo mantido ==>width: '+fixedWidth.toString()+' original height: '+fixedHeight.toString());
    }else{
      final porcentagemReducao = 192000 / fixedHeight;
      print('Reduzir==>'+porcentagemReducao.toInt().toString());
      final newHeight = fixedHeight * porcentagemReducao.toInt() / 100;
      final newWidth = fixedWidth * porcentagemReducao.toInt() / 100;
      print('Arquivo NOVO redimensionado ==>width: '+newWidth.toString()+' original height: '+newHeight.toString());
      fixedImage = img.copyResize(fixedImage, height: newHeight.toInt());
    }

    final fixedFile = await originalFile.writeAsBytes(img.encodeJpg(fixedImage));

    return fixedFile;

  }

}