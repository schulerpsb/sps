import 'dart:convert';
import 'dart:math';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_client_with_interceptor.dart';
import 'package:sps/models/sps_usuario_class.dart';
import 'Json_interceptor.dart';

class SpsHttpLogin {
  final String usuario;
  final String senha;
  //Servidor de produção.
  //static const baseUrl = 'https://teklist.schuler.de/webapi/api/login/read.php';
  //Servidor DEV
  static const baseUrlAutentica = 'http://10.17.20.45/webapi/api/login/read.php';//ok jwt
  static const baseUrlListaUsuario = 'http://10.17.20.45/webapi/api/login/read_usuario.php';//ok jwt
  static const baseUrlLEsqueciMinhaSenha = 'http://10.17.20.45/webapi/api/login/read_esqueci.php';//ok jwt
  static const baseUrlLZenviaSMS = 'https://api-rest.zenvia.com/services/send-sms';//ok jwt
  SpsHttpLogin(this.usuario, this.senha);

  Future<Map<String, dynamic>> efetuaLogin(String usuario, String senha) async {
//    implementação de JWT somente para o Login
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
    final String dadosParaLogonJson = jsonEncode(token);

//    FIM implementação de JWT somente para o Login


    Client client = HttpClientWithInterceptor.build(interceptors: [
      JsonInterceptor(),
    ]);

    final Response response = await client
        .post(
          baseUrlAutentica,
          headers: {'Content-type': 'application/json'},
          body: dadosParaLogonJson,
        )
        .timeout(
          Duration(
            seconds: 5,
          ),
        );

    //print ("Fernando=>"+response.body.toString());

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

//    implementação de JWT comum
    String token;
    final jwt = JWT(
      {
        //Parte Fixa - Não alterar
        'iis': 'ChecklistApp',
        'sub': usuarioAtual.codigo_usuario,
        //A Partir daqui coloque seus dados que deseja passar para a REST API
        'codigo_usuario': usuario

      },
    );

    final storage = new FlutterSecureStorage();
    String jwtKey;
    jwtKey = await storage.read(key: 'jwtKey');
    token = jwt.sign(SecretKey(jwtKey));

    final Map<String, dynamic> dadosParaLogon = {
      'codigo_usuario': usuario,
      'jwt': token,
    };
    final String dadosParaLogonJson = jsonEncode(dadosParaLogon);
//    FIM implementação de JWT comum

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
//    implementação de JWT comum
    String token;
    final jwt = JWT(
      {
        //Parte Fixa - Não alterar
        'iis': 'ChecklistApp',
        'sub': usuarioAtual.codigo_usuario,
        //A Partir daqui coloque seus dados que deseja passar para a REST API
        'codigo_usuario': usuario

      },
    );

    final storage = new FlutterSecureStorage();
    String jwtKey;
    jwtKey = await storage.read(key: 'jwtKey');
    token = jwt.sign(SecretKey(jwtKey));

    final Map<String, dynamic> dadosParaLogon = {
      'codigo_usuario': usuario,
      'jwt': token,
    };
    final String dadosParaLogonJson = jsonEncode(dadosParaLogon);
//    FIM implementação de JWT comum

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

  Future<int> enviaCodigoVerificacao(String telefoneUsuario) async {

    Random rnd = new Random();
    int min = 100000, max = 999999;
    int codigoUsuario = min + rnd.nextInt(max - min);

    final Map<String, dynamic> dadosParaLogon = {
      'sendSmsRequest': {
        'from': 'Schuler SPS',
        'to': telefoneUsuario.replaceAll("+", "").replaceAll(" ", "").replaceAll("-", ""),
        'msg': 'Use o código '+codigoUsuario.toString()+' para autenticação no Supplier Portal',
        'callbackOption': 'NONE',
        'aggregateId': '1111',
        'flashSms': 'false',
        'dataCoding': '8',
      }
    };

    final Map<String, String> custonHeader = {
      "Content-type": "application/json",
      "Accept": "application/json",
      "Authorization": "Basic c2NodWxlci53ZWI6eGUwQlZMYlBBZg==",
    };

    final String dadosParaLogonJson = jsonEncode(dadosParaLogon);

      Client client = HttpClientWithInterceptor.build(interceptors: [
      JsonInterceptor(),
    ]);

    final Response response = await client
        .post(
      baseUrlLZenviaSMS,
      headers: custonHeader,
      body: dadosParaLogonJson,
    ).timeout(
      Duration(
        seconds: 5,
      ),
    );
//    final List<dynamic> transactionJsonList = jsonDecode(response.body);
    Map<String, dynamic> transactionJsonMap = jsonDecode(response.body);
    if(transactionJsonMap['sendSmsResponse']['statusCode'].toString() == "00" || transactionJsonMap['sendSmsResponse']['statusCode'].toString() == "01" || transactionJsonMap['sendSmsResponse']['statusCode'].toString() == "02" || transactionJsonMap['sendSmsResponse']['statusCode'].toString() == "03"){
      return codigoUsuario;
    }else{
      return 0;
    }
  }

}


