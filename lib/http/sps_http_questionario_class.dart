import 'dart:convert';
import 'package:http/http.dart';
import 'package:http_interceptor/http_client_with_interceptor.dart';
import 'Json_interceptor.dart';

class SpsHttpQuestionario {
  //Servidor de produção
  //static const baseUrl_read_lista = 'https://teklist.schuler.de/webapi/api/questionario/read_lista.php';
  //static const baseUrl_read_lista_cq_int = 'https://teklist.schuler.de/webapi/api/questionario/read_lista_cq_int.php';
  //static const baseUrl_saveReferencia = 'https://teklist.schuler.de/webapi/api/questionario/save_referencia.php';

  //Servidor DEV
  static const baseUrl_read_lista = 'http://10.17.20.45/webapi/api/questionario/read_lista.php';
  static const baseUrl_read_lista_cq_int = 'http://10.17.20.45/webapi/api/questionario/read_lista_cq_int.php';
  static const baseUrl_saveReferencia = 'http://10.17.20.45/webapi/api/questionario/save_referencia.php';

  SpsHttpQuestionario();

  Future<List<Map<String, dynamic>>> httplistarQuestionario(String origem_usuario, String doc_action, String registro_colaborador, String identificacao_utilizador, String tipo_frequencia, String tipo_checklist, String registro_aprovador) async {
    final Map<String, dynamic> keyQuestionario = {
      'doc_action': doc_action,
      'registro_colaborador': registro_colaborador,
      'identificacao_utilizador': identificacao_utilizador,
      'tipo_frequencia': tipo_frequencia,
      'tipo_checklist': tipo_checklist,
      'registro_aprovador': registro_aprovador,
    };

    final String dadosQuestionarioJson = jsonEncode(keyQuestionario);

    Client client = HttpClientWithInterceptor.build(interceptors: [
      JsonInterceptor(),
    ]);

    final Response response = await client
        .post(
          origem_usuario == "INTERNO" && doc_action == "PREENCHER_CQ" ? baseUrl_read_lista_cq_int : baseUrl_read_lista,
          headers: {'Content-type': 'application/json'},
          body: dadosQuestionarioJson,
        )
        .timeout(
          Duration(
            seconds: 5,
          ),
        );

    final List<dynamic> transactionJsonList = jsonDecode(response.body);
    final List<Map<String, dynamic>> transactionJsonOcorrencias = [];
    Map<String, dynamic> transactionJsonMap = null;
    for (Map<String, dynamic> element in transactionJsonList) {
      if (element['mensagem'].trim() == "Data not found") {
        transactionJsonMap = {};
      } else {
        transactionJsonMap = {
          'codigo_empresa': element['codigo_empresa'].trim(),
          'codigo_programacao': element['codigo_programacao'],
          'registro_colaborador': element['registro_colaborador'],
          'identificacao_utilizador': element['identificacao_utilizador'],
          'codigo_grupo': element['codigo_grupo'],
          'codigo_checklist': element['codigo_checklist'],
          'descr_programacao': element['descr_programacao'],
          'dtfim_aplicacao': element['dtfim_aplicacao'],
          'percentual_evolucao': element['percentual_evolucao'],
          'status': element['status'],
          'referencia_parceiro': element['referencia_parceiro'],
          'codigo_pedido': element['codigo_pedido'],
          'item_pedido': element['item_pedido'],
          'codigo_projeto': element['codigo_projeto'],
          'descr_projeto': element['descr_projeto'],
          'codigo_material': element['codigo_material'],
          'descr_comentarios': element['descr_comentarios'],
        };
        transactionJsonOcorrencias.add(transactionJsonMap);
      }
    }
    return transactionJsonOcorrencias;
  }

  Future QuestionarioSaveReferencia(String codigo_empresa, int codigo_programacao, String referencia_parceiro, String usuresponsavel) async {
    final Map<String, dynamic> fieldQuestionario = {
      'codigo_empresa': codigo_empresa,
      'codigo_programacao': codigo_programacao,
      'referencia_parceiro': referencia_parceiro,
      'usuresponsavel': usuresponsavel, //substituir por variavel global do Fernando
    };

    final String dadosQuestionarioJson = jsonEncode(fieldQuestionario);

    Client client = HttpClientWithInterceptor.build(interceptors: [
      JsonInterceptor(),
    ]);

    final Response response = await client
        .post(
      baseUrl_saveReferencia,
      headers: {'Content-type': 'application/json'},
      body: dadosQuestionarioJson,
    )
        .timeout(
      Duration(
        seconds: 5,
      ),
    );

    return true;
  }
}
