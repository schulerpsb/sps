import 'dart:io';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sps/components/centered_message.dart';

class SpsVerificarConexao {
  Future<bool> verificar_conexao() async {
    bool _wrede_conectada = false;
    bool _wservidor_conectado = false;
    String _msg;

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
        if (result.isNotEmpty) {
          print("Verificar conexão com o servidor de API´s");
          final response =
              //await http.head('http://teklist.schuler.de/webapi/api/questionario/read_cq_ext.php'); //Pode ser utilizado qualquer URL
              await http.get(
                  'http://10.17.20.45/webapi/api/questionario/read_cq_ext.php'); //Pode ser utilizado qualquer URL
          print("Retorno da verificação => " + response.statusCode.toString());
          if (response.statusCode == 200) {
            _wservidor_conectado = true;
            debugPrint('STATUS DA CONEXÃO -> connected');
          } else {
            _wservidor_conectado = false;
            debugPrint('STATUS DA CONEXÃO -> not connected');
            _msg =
                "Estamos com problemas nas conexões com nossos servidores, sugerimos colocar o aparelho em modo avião para trabalhar offline, dentro de alguns minutos o problema será resolvido e as informações serão sincronizadas automaticamente com nossos serviores. Pedimos desculpas pelo inconveniente.";
            print(_msg);

            return _wservidor_conectado;
          }
        }
      } on SocketException catch (_) {
        _wservidor_conectado = false;
        debugPrint('STATUS DA CONEXÃO -> not connected');
      }
    }

    print("retorno conexao: " + _wservidor_conectado.toString());
    return _wservidor_conectado;
  }
}
