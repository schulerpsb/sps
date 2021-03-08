import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:dio/adapter.dart';


class spsUpDown {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
  Future<bool> uploadQuestionarioMidia(FormData formData) async {
    try {
      Response response;
      Dio dio = new Dio();
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };
      response = await dio.post("http://10.17.20.45/webapi/api/midia/upload.php", data: formData);
      print(response);
      return true;
    } catch (e) {
      print('Erro');
      print(e);
      return false;
    }
  }

  Future<String> downloadQuestionarioMidia(String ArquivoParaDownload, String destinoLocal) async {
    try {
      Response response;
      Dio dio = new Dio();
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };
      response = await dio.download(ArquivoParaDownload, destinoLocal);
      //print(response);
      return '1';
    } catch (e) {
      //print(e.response.statusCode.toString());
      return e.response.statusCode.toString();
    }

  }

}
