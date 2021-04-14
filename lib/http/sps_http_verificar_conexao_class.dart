import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;
import 'package:sps/models/sps_erro_conexao_class.dart';

class SpsVerificarConexao {
  Future<bool> verificar_conexao() async {
    bool _wrede_conectada = false;
    bool _wservidor_conectado = false;
    String _msg_erro_conexao = "";

    erroConexao.msg_erro_conexao = "";

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      _wrede_conectada = true;
      //print("3G/4G");
      //debugPrint('STATUS DA CONEXÃO -> not connected');
    } else {
      if (connectivityResult == ConnectivityResult.wifi) {
        _wrede_conectada = true;
        //print("WIFI");
      } else {
        //print("SEM CONEXÃO");
        //debugPrint('STATUS DA CONEXÃO -> not connected');
      }
    }

    if (_wrede_conectada == true) {
      try {
        //print("Verificar conexão com o servidor de aplicação");
        final result = await InternetAddress.lookup('teklist.schuler.de');
        if (result.isNotEmpty) {
          //print("Verificar conexão com o servidor de banco de dados");
          final result = await InternetAddress.lookup('10.17.20.45');
          if (result.isNotEmpty) {
            //print("Verificar conexão com o servidor de API´s");
            final response =
                //await http.head('http://teklist.schuler.de/webapi/api/questionario/read_lista.php'); //Pode ser utilizado qualquer URL
                await http.get('http://10.17.20.45/webapi/api/questionario/read_lista.php'); //Pode ser utilizado qualquer URL
            //print("Retorno da verificação => " + response.statusCode.toString());
            if (response.statusCode == 200) {
              _wservidor_conectado = true;
              //debugPrint('STATUS DA CONEXÃO -> connected');
              return _wservidor_conectado;
            }
          }
        }
      } on SocketException catch (_) {
      }
      //debugPrint('STATUS DA CONEXÃO -> not connected');
      _msg_erro_conexao =
      "Estamos com problemas na conexão com nossos servidores!\n\n Favor colocar o aparelho em modo avião para trabalhar normalmente em offline, dentro de alguns minutos o problema será resolvido!\n Ao desativar o modo avião as informações serão sincronizadas automaticamente com nossos serviores.\n\n Pedimos desculpas pelo transtorno.";
      erroConexao.msg_erro_conexao = _msg_erro_conexao;
      return _wservidor_conectado;
    }
    //print("retorno conexao: " + _wservidor_conectado.toString());
    return _wservidor_conectado;
  }
}
