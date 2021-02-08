import 'package:flutter/cupertino.dart';
import 'package:sps/dao/sps_dao_questionario_item_class.dart';
import 'package:sps/http/sps_http_questionario_item_class.dart';
import 'Dart:io';

class SpsQuestionarioItem_cq {
  @override
  Future<List<Map<String, dynamic>>> listarQuestionarioItem_cq(
      h_origem_usuario,
      h_codigo_empresa,
      h_codigo_programacao,
      h_codigo_grupo,
      h_codigo_checklist) async {

    var _wservidor_conectado = false;

    final acao = 'PROXIMO';
    final sessao_checklist = '';
    final origem_usuario = h_origem_usuario;
    final codigo_empresa = h_codigo_empresa;
    final codigo_programacao = h_codigo_programacao;
    final registro_colaborador = '';
    final identificacao_utilizador = '';
    final codigo_grupo = h_codigo_grupo;
    final codigo_checklist = h_codigo_checklist;

    //Verificar se existe conexão
    try {
      final result = await InternetAddress.lookup('10.17.20.45');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _wservidor_conectado = true;
        debugPrint('STATUS DA CONEXÃO -> connected');
      }
    } on SocketException catch (_) {
      _wservidor_conectado = false;
      debugPrint('STATUS DA CONEXÃO -> not connected');
    }

    //Quando existir conexão
    if (_wservidor_conectado == true) {
      debugPrint("=== INICIO SINCRONIZAÇÃO DE DADOS (Tabela: checklist_item) =============================================");
      //Criar tabela caso não exista
      final SpsDaoQuestionarioItem objQuestionarioItemDao = SpsDaoQuestionarioItem();
      final int resulcreate = await objQuestionarioItemDao.create_table();

      //Ler dados não sincronizados do SQlite
      final List<Map<String, dynamic>> result =
      await objQuestionarioItemDao.select_sincronizacao(h_codigo_empresa, h_codigo_programacao);
      var _wregistros = result.length;
      debugPrint("Ler dados não sincronizados do SQlite (quantidade de registro: " + _wregistros.toString() + ")");
      var windex = 0;
      while (windex < _wregistros) {
        var _wsincronizado = "";
        //Atualizar registro no PostgreSQL (via API REST) campo RESP_CQ
        final SpsHttpQuestionarioItem objQuestionarioItemHttp = SpsHttpQuestionarioItem();
        final retorno1 = await objQuestionarioItemHttp.QuestionarioSaveOpcao(
            result[windex]["codigo_empresa"],
            result[windex]["codigo_programacao"].toString(),
            result[windex]["registro_colaborador"],
            result[windex]["identificacao_utilizador"],
            result[windex]["item_checklist"].toString(),
            result[windex]["resp_cq"],
            '#usuario#'); //substituir por variavel global do Fernando
        if (retorno1.toString() == true) {
          debugPrint("registro sincronizado: " + result[windex].toString());
        } else {
          debugPrint(
              "ERRO => registro sincronizado: " + result[windex].toString());
        }

        //Atualizar registro no PostgreSQL (via API REST) campo DESCR_COMENTARIOS
        final retorno2 = await objQuestionarioItemHttp.QuestionarioSaveComentario(
            h_origem_usuario,
            result[windex]["codigo_empresa"],
            result[windex]["codigo_programacao"].toString(),
            result[windex]["registro_colaborador"],
            result[windex]["identificacao_utilizador"],
            result[windex]["item_checklist"].toString(),
            result[windex]["descr_comentarios"],
            '#usuario#'); //substituir por variavel global do Fernando
        if (retorno2.toString() == true) {
          debugPrint("registro sincronizado: " + result[windex].toString());
        } else {
          debugPrint(
              "ERRO => registro sincronizado: " + result[windex].toString());
        }

        windex = windex + 1;
      }

      //Ler registros do PostgreSQL (via API REST) / Deletar dados do SQlite / Gravar dados no SQlite
      debugPrint("Ler registros do PostgreSQL (via API REST) / Deletar dados do SQlite / Gravar dados no SQlite");
      final SpsHttpQuestionarioItem objQuestionarioItemHttp =
          SpsHttpQuestionarioItem();
      final List<Map<String, dynamic>> dadosQuestionarioItem =
          await objQuestionarioItemHttp.listarQuestionarioItem(
              acao,
              sessao_checklist,
              codigo_empresa,
              codigo_programacao,
              registro_colaborador,
              identificacao_utilizador,
              codigo_grupo,
              codigo_checklist);
      if (dadosQuestionarioItem != null) {
        final SpsDaoQuestionarioItem objQuestionarioItemDao = SpsDaoQuestionarioItem();
        final int resullimpar = await objQuestionarioItemDao.emptyTable(h_codigo_empresa, h_codigo_programacao);
        final int resultsave = await objQuestionarioItemDao.save(dadosQuestionarioItem);
      }
      debugPrint("=== FIM SINCRONIZAÇÃO DE DADOS (Tabela: checklist_item) ============================================");
    }

    //Ler dados do SQlite
    debugPrint("Ler dados do SQlite (Tabela: checklist_item)");
    final SpsDaoQuestionarioItem objQuestionarioItemDao = SpsDaoQuestionarioItem();
    final List<Map<String, dynamic>> DadosSessao =
    await objQuestionarioItemDao.listarQuestionarioItemLocal(h_codigo_empresa, h_codigo_programacao);
    return DadosSessao;
  }
}
