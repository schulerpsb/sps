import 'dart:convert';
import 'package:http/http.dart';
import 'package:http_interceptor/http_client_with_interceptor.dart';
import 'Json_interceptor.dart';

class SpsHttpQuestionarioItem {
  //Servidor de produção
  //static const baseUrl_read = 'https://teklist.schuler.de/webapi/api/questionario/read_item.php';
  //static const baseUrl_saveOpcao = 'https://teklist.schuler.de/webapi/api/questionario/save_opcao.php';
  //static const baseUrl_saveComentarios = 'http://teklist.schuler.de/webapi/api/questionario/save_comentarios.php';

  //Servidor DEV
  static const baseUrl_read = 'http://10.17.20.45/webapi/api/questionario/read_item.php';
  static const baseUrl_saveOpcao = 'http://10.17.20.45/webapi/api/questionario/save_opcao.php';
  static const baseUrl_saveComentarios = 'http://10.17.20.45/webapi/api/questionario/save_comentarios.php';

  SpsHttpQuestionarioItem();

  Future<List<Map<String, dynamic>>> listarQuestionarioItem(String acao, String sessao_checklist, String codigo_empresa, int codigo_programacao, String registro_colaborador, String identificacao_utilizador, String codigo_grupo, int codigo_checklist) async {
    final Map<String, dynamic> keyQuestionarioItem = {
      'acao': acao,
      'sessao_checklist': sessao_checklist,
      'codigo_empresa': codigo_empresa,
      'codigo_programacao': codigo_programacao,
      'registro_colaborador': registro_colaborador,
      'identificacao_utilizador': identificacao_utilizador,
      'codigo_grupo': codigo_grupo,
      'codigo_checklist': codigo_checklist,
    };

    final String dadosQuestionarioItemJson = jsonEncode(keyQuestionarioItem);

    Client client = HttpClientWithInterceptor.build(interceptors: [
      JsonInterceptor(),
    ]);

    final Response response = await client
        .post(
          baseUrl_read,
          headers: {'Content-type': 'application/json'},
          body: dadosQuestionarioItemJson,
        )
        .timeout(
          Duration(
            seconds: 5,
          ),
        );

    final List<dynamic> transactionJsonList = jsonDecode(response.body);
    final List<Map<String, dynamic>> transactionJsonItemOcorrencias = [];
    Map<String, dynamic> transactionJsonMap = null;
    for (Map<String, dynamic> element in transactionJsonList) {
      transactionJsonMap = {
        'codigo_empresa': element['codigo_empresa'],
        'codigo_programacao': element['codigo_programacao'],
        'registro_colaborador': element['registro_colaborador'],
        'identificacao_utilizador': element['identificacao_utilizador'],
        'item_checklist': element['item_checklist'],
        'seq_pergunta': element['seq_pergunta'],
        'descr_pergunta': element['descr_pergunta'],
        'resp_cq': element['resp_cq'],
        'descr_comentarios': element['descr_comentarios'],
        'status_resposta': element['status_resposta'],
        'status_aprovacao': element['status_aprovacao'],
      };
      transactionJsonItemOcorrencias.add(transactionJsonMap);
    }
    return transactionJsonItemOcorrencias;
  }

  Future QuestionarioSaveOpcao(String codigo_empresa, String codigo_programacao, String registro_colaborador, String identificacao_utilizador, String item_checklist, String resp_cq, String usuresponsavel) async {
    final Map<String, dynamic> fieldQuestionario = {
      'codigo_empresa': codigo_empresa,
      'codigo_programacao': codigo_programacao,
      'registro_colaborador': registro_colaborador,
      'identificacao_utilizador': identificacao_utilizador,
      'item_checklist': item_checklist,
      'resp_cq': resp_cq,
      'usuresponsavel': usuresponsavel, //verificcar com Fernando
    };
    final String dadosQuestionarioJson = jsonEncode(fieldQuestionario);

    Client client = HttpClientWithInterceptor.build(interceptors: [
      JsonInterceptor(),
    ]);

    final Response response = await client
        .post(
      baseUrl_saveOpcao,
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

  Future QuestionarioSaveComentario(String codigo_empresa, String codigo_programacao, String registro_colaborador, String identificacao_utilizador, String item_checklist, String descr_comentarios, String usuresponsavel) async {
    final Map<String, dynamic> fieldQuestionario = {
      'codigo_empresa': codigo_empresa,
      'codigo_programacao': codigo_programacao,
      'registro_colaborador': registro_colaborador,
      'identificacao_utilizador': identificacao_utilizador,
      'item_checklist': item_checklist,
      'descr_comentarios': descr_comentarios,
      'usuresponsavel': usuresponsavel, //verificar com Fernando
    };
    final String dadosQuestionarioJson = jsonEncode(fieldQuestionario);

    Client client = HttpClientWithInterceptor.build(interceptors: [
      JsonInterceptor(),
    ]);

    final Response response = await client
        .post(
      baseUrl_saveComentarios,
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
