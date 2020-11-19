import 'dart:convert';
import 'package:http/http.dart';
import 'package:http_interceptor/http_client_with_interceptor.dart';
import 'Json_interceptor.dart';

class SpsHttpLogin {
  final String usuario;
  final String senha;
  //Servidor de produção.
  //static const baseUrl = 'https://teklist.schuler.de/webapi/api/login/read.php';
  //Servidor DEV
  static const baseUrl = 'http://10.17.20.45/webapi/api/login/read.php';

  //..static const baseUrl = 'https://teklist.schuler.de/webapi/api/post/read.php';

  SpsHttpLogin(this.usuario, this.senha);

  Future<Map<String, dynamic>> efetuaLogin(String usuario, String senha) async {
    final Map<String, dynamic> dadosParaLogon = {
      'usuario': usuario,
      'senha': senha,
    };

    final String dadosParaLogonJson = jsonEncode(dadosParaLogon);

    Client client = HttpClientWithInterceptor.build(interceptors: [
      JsonInterceptor(),
    ]);

    final Response response = await client
        .post(
          baseUrl,
          headers: {'Content-type': 'application/json'},
          body: dadosParaLogonJson,
        )
        .timeout(
          Duration(
            seconds: 5,
          ),
        );

    final List<dynamic> transactionJsonList = jsonDecode(response.body);
    Map<String, dynamic> transactionJsonMap = null;
    for (Map<String, dynamic> element in transactionJsonList) {
      transactionJsonMap = {
        'nmusuario': element['nmusuario'].trim(),
        'cdnivel': element['cdnivel'],
        'nrregistro': element['nrregistro'],
        'cddepartam': element['cddepartam'],
        'nmfunciona': element['nmfunciona'],
        'cdcentcust': element['cdcentcust'],
        'datainclus': element['datainclus'],
        'dataaltera': element['dataaltera'],
        'nmusuaralt': element['nmusuaralt'],
        'dtvalidade': element['dtvalidade'],
        'nmmaquina': element['nmmaquina'],
        'nmusuariorede': element['nmusuariorede'],
        'nmusuariosap': element['nmusuariosap'],
        'dthratualizacao': element['dthratualizacao'],
      };
    }
    return transactionJsonMap;
  }
}
