import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sps/dao/sps_dao_questionario_cq_midia_class.dart';
import 'package:thumbnails/thumbnails.dart';

class spsMidiaUtils {


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

  static Future<String> criarVideoThumb({List fileList}) async {
    final Directory _thumbspath = new Directory('/storage/emulated/0/Android/data/com.example.sps/files/Pictures/thumbs');
//    final Directory _videospath = new Directory('/storage/emulated/0/Android/data/com.example.sps/files/Pictures');
    final checkPathExistence = await _thumbspath.exists();
    if(!checkPathExistence){
      new Directory('/storage/emulated/0/Android/data/com.example.sps/files/Pictures/thumbs').create();
    }
//    var fileList = _videospath
//        .listSync()
//        .map((item) => item.path)
//        .where((item) => item.endsWith('.mp4'))
//        .toList(growable: false);

    fileList.forEach( (item) async {
      String thumb = await Thumbnails.getThumbnail(
          thumbnailFolder: '/storage/emulated/0/Android/data/com.example.sps/files/Pictures/thumbs',
          videoFile: item,
          imageType: ThumbFormat.JPEG,
          quality: 30);
    });
  }

  static Future<String> processarArquivoCapturado({String tipo = "", Map<String,dynamic> dadosArquivo = null}) async {
    File sourceFile = new File(dadosArquivo['arquivo']);
    String _extensaoArquivo = sourceFile.path.split('.').last;
    final SpsDaoQuestionarioCqMidia objQuestionarioCqMidiaDao = SpsDaoQuestionarioCqMidia();
    List<Map<String, dynamic>> arquivosArmazenados = await objQuestionarioCqMidiaDao.listarQuestionarioCqMidia(codigo_empresa: dadosArquivo['codigo_empresa'], codigo_programacao: dadosArquivo['codigo_programacao'], item_checklist:dadosArquivo['item_checklist']);
    int _proximoRegistro;
    if(arquivosArmazenados.length < 1){
       _proximoRegistro = 1;
     }else{
       _proximoRegistro = arquivosArmazenados[0]['item_anexo'] + 1;
     }
    String _nomeArquivo = dadosArquivo['codigo_empresa']+'_'+dadosArquivo['codigo_programacao'].toString()+'_'+dadosArquivo['item_checklist'].toString()+'_'+_proximoRegistro.toString()+'.'+_extensaoArquivo.toString();
    String newPath = '/storage/emulated/0/Android/data/com.example.sps/files/Pictures/'+_nomeArquivo.toString();
    final util  = new spsMidiaUtils();
    File arquivoRenomeado = await util.moveFile(sourceFile, newPath);
    return arquivoRenomeado.path;
  }

// when an output folder is not specified thumbnail are stored in app temporary directory
  static Future<String> noFolder(path) async {
    String thumb = await Thumbnails.getThumbnail(
        videoFile: path, imageType: ThumbFormat.JPEG, quality: 30);
    //print('Path to cache folder $thumb');
    return thumb.toString();
  }

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

}