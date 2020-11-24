import 'dart:convert';
import 'package:http/http.dart';
import 'package:http_interceptor/http_client_with_interceptor.dart';
import 'Json_interceptor.dart';

class SpsHttpQuestionarioItem {
  //Servidor de produção
  //static const baseUrl = 'https://teklist.schuler.de/webapi/api/questionario/read.php';

  //Servidor DEV
  static const baseUrl = 'http://10.17.20.45/webapi/api/questionario/read_item.php';

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
          baseUrl,
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
        'item_checklist': element['item_checklist'],
        'seq_pergunta': element['seq_pergunta'],
        'descr_pergunta': element['descr_pergunta'],
        'resp_cq': element['resp_cq'],
        'descr_comentarios': element['descr_comentarios'],
      };
      transactionJsonItemOcorrencias.add(transactionJsonMap);
    }
    return transactionJsonItemOcorrencias;
  }
}
