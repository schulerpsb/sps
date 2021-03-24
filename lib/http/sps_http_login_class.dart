import 'dart:convert';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_client_with_interceptor.dart';
import 'Json_interceptor.dart';

class SpsHttpLogin {
  final String usuario;
  final String senha;
  //Servidor de produção.
  //static const baseUrl = 'https://teklist.schuler.de/webapi/api/login/read.php';
  //Servidor DEV
  static const baseUrlAutentica = 'http://10.17.20.45/webapi/api/login/read.php';
  static const baseUrlAutenticaJWT = 'http://10.17.20.45/webapi/api/login/readjwt.php';
  static const baseUrlListaUsuario = 'http://10.17.20.45/webapi/api/login/read_usuario.php';
  static const baseUrlLEsqueciMinhaSenha = 'http://10.17.20.45/webapi/api/login/read_esqueci.php';

  SpsHttpLogin(this.usuario, this.senha);

  Future<Map<String, dynamic>> efetuaLogin(String usuario, String senha) async {

//    final Map<String, dynamic> dadosParaLogon = {
//      'codigo_usuario': usuario,
//      'senha_usuario': senha,
//    };
//    final String dadosParaLogonJson = jsonEncode(dadosParaLogon);

    //implementação de JWT
    String token;
    final jwt = JWT(
      {
        'iis': 'ChecklistApp',
        'sub': usuario,
        'codigo_usuario': usuario,
        'senha_usuario': senha
      },
    );
    token = jwt.sign(SecretKey('schulerchecklistApp2021'));
    print('Token Para Login: $token\n');

    final String dadosParaLogonJson = jsonEncode(token);
    //FIM implementação de JWT
    print('Token Para Login JSON: $dadosParaLogonJson\n');


    Client client = HttpClientWithInterceptor.build(interceptors: [
      JsonInterceptor(),
    ]);

    final Response response = await client
        .post(
//          baseUrlAutentica,
          baseUrlAutenticaJWT,
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
      if(element['mensagem'].trim() != ""){
        transactionJsonMap = {
          'mensagem': element['mensagem'].trim()
        };
      }else{
        transactionJsonMap = {
          'codigo_usuario': element['codigo_usuario'].trim(),
          'nome_usuario': element['nome_usuario'].trim(),
          'telefone_usuario': element['telefone_usuario'].trim(),
          'email_usuario': element['email_usuario'].trim(),
          'cargo_usuario': element['cargo_usuario'].trim(),
          'pais_usuario': element['pais_usuario'].trim(),
          'lingua_usuario': element['lingua_usuario'].trim(),
          'senha_usuario': element['senha_usuario'].trim(),
          'status_usuario': element['status_usuario'].trim(),
          'dt_validade_senha': element['dt_validade_senha'].trim(),
          'qtd_tentativas_senha': element['qtd_tentativas_senha'].trim(),
          'codigo_planta': element['codigo_planta'].trim(),
          'dthratualizacao': element['dthratualizacao'].trim(),
          'chave': element['chave'].trim(),
          'status_token': element['status_token'].trim(),
          'dt_validade_usuario': element['dt_validade_usuario'].trim(),
          'dt_reset_senha': element['dt_reset_senha'].trim(),
          'tipo': element['tipo'].trim(),
          'registro_usuario': element['registro_usuario'].trim(),
          'mensagem': element['mensagem'].trim()
        };
      }
    }
    return transactionJsonMap;
  }

  Future<Map<String, dynamic>> listaUsuariofromserver(String usuario) async {
    final Map<String, dynamic> dadosParaLogon = {
      'codigo_usuario': usuario,
    };

    final String dadosParaLogonJson = jsonEncode(dadosParaLogon);

    Client client = HttpClientWithInterceptor.build(interceptors: [
      JsonInterceptor(),
    ]);

    final Response response = await client
        .post(
      baseUrlListaUsuario,
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
      if(element['mensagem'].trim() != ""){
        transactionJsonMap = {
          'mensagem': element['mensagem'].trim()
        };
      }else{
        transactionJsonMap = {
          'codigo_usuario': element['codigo_usuario'].trim(),
          'nome_usuario': element['nome_usuario'].trim(),
          'telefone_usuario': element['telefone_usuario'].trim(),
          'email_usuario': element['email_usuario'].trim(),
          'cargo_usuario': element['cargo_usuario'].trim(),
          'pais_usuario': element['pais_usuario'].trim(),
          'lingua_usuario': element['lingua_usuario'].trim(),
          'senha_usuario': element['senha_usuario'].trim(),
          'status_usuario': element['status_usuario'].trim(),
          'dt_validade_senha': element['dt_validade_senha'].trim(),
          'qtd_tentativas_senha': element['qtd_tentativas_senha'].trim(),
          'codigo_planta': element['codigo_planta'].trim(),
          'dthratualizacao': element['dthratualizacao'].trim(),
          'chave': element['chave'].trim(),
          'status_token': element['status_token'].trim(),
          'dt_validade_usuario': element['dt_validade_usuario'].trim(),
          'dt_reset_senha': element['dt_reset_senha'].trim(),
          'tipo': element['tipo'].trim(),
          'registro_usuario': element['registro_usuario'].trim(),
          'mensagem': element['mensagem'].trim()
        };
      }
    }
    return transactionJsonMap;
  }

  Future<Map<String, dynamic>> esqueciMinhaSenha(String usuario) async {
    final Map<String, dynamic> dadosParaLogon = {
      'codigo_usuario': usuario,
    };

    final String dadosParaLogonJson = jsonEncode(dadosParaLogon);

    Client client = HttpClientWithInterceptor.build(interceptors: [
      JsonInterceptor(),
    ]);

    final Response response = await client
        .post(
      baseUrlLEsqueciMinhaSenha,
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
          'mensagem': element['mensagem'].trim()
        };
      }
    return transactionJsonMap;
  }

}


