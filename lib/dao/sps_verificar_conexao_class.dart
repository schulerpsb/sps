import 'dart:io';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';

class SpsVerificarConexao {
  Future <bool> verificar_conexao() async {
    bool _wrede_conectada = false;
    bool _wservidor_conectado = false;

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      //_wrede_conectada = true;
      print("3G/4G");
      debugPrint('STATUS DA CONEXÃO -> not connected');
    } else {
      if (connectivityResult == ConnectivityResult.wifi) {
        _wrede_conectada = true;
        print("WIFI");
      } else {
        print("SEM CONEXÃO");
        debugPrint('STATUS DA CONEXÃO -> not connected');
      }
    }

    if (_wrede_conectada == true) {
      try {
        final result = await InternetAddress.lookup('teklist.schuler.de');
        //if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (result.isNotEmpty) {
          _wservidor_conectado = true;
          debugPrint('STATUS DA CONEXÃO -> connected');
        }
      } on SocketException catch (_) {
        _wservidor_conectado = false;
        debugPrint('STATUS DA CONEXÃO -> not connected');
      }
    }

    print ("retorno conexao: "+_wservidor_conectado.toString());
    return _wservidor_conectado;
   }
}

