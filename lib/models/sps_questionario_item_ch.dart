import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sps/dao/sps_dao_questionario_item_class.dart';
import 'file:///C:/Mobile/sps/lib/http/sps_http_verificar_conexao_class.dart';
import 'package:sps/http/sps_http_questionario_item_class.dart';
import 'Dart:io';
import 'package:sps/models/sps_usuario_class.dart';

class SpsQuestionarioItem_ch {
  @override
  Future<List<Map<String, dynamic>>> listarQuestionarioItem_ch(
      h_codigo_empresa,
      h_codigo_programacao,
      h_codigo_grupo,
      h_codigo_checklist,
      h_acao,
      h_sessao_checklist) async {
    final acao = h_acao;
    final sessao_checklist = h_sessao_checklist;
    final codigo_empresa = h_codigo_empresa;
    final codigo_programacao = h_codigo_programacao;
    final registro_colaborador = '';
    final identificacao_utilizador = '';
    final codigo_grupo = h_codigo_grupo;
    final codigo_checklist = h_codigo_checklist;

    //Criar tabela "checklist_item" caso não exista
    final SpsDaoQuestionarioItem objQuestionarioItemDao =
    SpsDaoQuestionarioItem();
    final int resulcreate = await objQuestionarioItemDao.create_table();

    //Verificar se existe conexão
    final SpsVerificarConexao ObjVerificarConexao = SpsVerificarConexao();
    final bool result = await ObjVerificarConexao.verificar_conexao();
    if (result == true) {
      debugPrint(
          "=== INICIO SINCRONIZAÇÃO DE DADOS (Tabela: checklist_item) =============================================");
      //Ler dados não sincronizados do SQlite
      final List<Map<String, dynamic>> result = await objQuestionarioItemDao
          .select_sincronizacao(h_codigo_empresa, h_codigo_programacao);
      var _wregistros = result.length;
      debugPrint(
          "Ler dados não sincronizados do SQlite (quantidade de registro: " +
              _wregistros.toString() +
              ")");
      var windex = 0;
      while (windex < _wregistros) {
        var _wsincronizado = "";
        //Atualizar registro no PostgreSQL (via API REST) resposta do questionario
        final SpsHttpQuestionarioItem objQuestionarioItemHttp =
            SpsHttpQuestionarioItem();
        final retorno1 = await objQuestionarioItemHttp.QuestionarioSave(
            result[windex]["codigo_empresa"],
            result[windex]["codigo_programacao"].toString(),
            result[windex]["registro_colaborador"],
            result[windex]["identificacao_utilizador"],
            result[windex]["item_checklist"].toString(),
            result[windex]["resp_cq"],
            usuarioAtual.tipo == "INTERNO" || usuarioAtual.tipo == "COLIGADA" ?usuarioAtual.registro_usuario :usuarioAtual.codigo_usuario); //substituir por variavel global do Fernando
        if (retorno1.toString() == true) {
          debugPrint("registro sincronizado: " + result[windex].toString());
        } else {
          debugPrint(
              "ERRO => registro sincronizado: " + result[windex].toString());
        }

        //Atualizar registro no PostgreSQL (via API REST) campo DESCR_COMENTARIOS
        final retorno2 =
            await objQuestionarioItemHttp.QuestionarioSaveComentario(
                null,
                result[windex]["codigo_empresa"],
                result[windex]["codigo_programacao"].toString(),
                result[windex]["registro_colaborador"],
                result[windex]["identificacao_utilizador"],
                result[windex]["item_checklist"].toString(),
                result[windex]["descr_comentarios"],
                usuarioAtual.tipo == "INTERNO" || usuarioAtual.tipo == "COLIGADA" ?usuarioAtual.registro_usuario :usuarioAtual.codigo_usuario); //substituir por variavel global do Fernando
        if (retorno2.toString() == true) {
          debugPrint("registro sincronizado: " + result[windex].toString());
        } else {
          debugPrint(
              "ERRO => registro sincronizado: " + result[windex].toString());
        }

        windex = windex + 1;
      }

      //Ler registros do PostgreSQL (via API REST) / Deletar dados do SQlite / Gravar dados no SQlite
      debugPrint(
          "Ler registros do PostgreSQL (via API REST) / Deletar dados do SQlite / Gravar dados no SQlite");
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
        final SpsDaoQuestionarioItem objQuestionarioItemDao =
            SpsDaoQuestionarioItem();
        final int resullimpar = await objQuestionarioItemDao.emptyTable(
            h_codigo_empresa, h_codigo_programacao);
        final int resultsave =
            await objQuestionarioItemDao.save(dadosQuestionarioItem);
      }
      debugPrint(
          "=== FIM SINCRONIZAÇÃO DE DADOS (Tabela: checklist_item) ============================================");
    }

    //Ler dados do SQlite
    debugPrint("Ler dados do SQlite (Tabela: checklist_item)");
    final List<Map<String, dynamic>> DadosSessao = await objQuestionarioItemDao
        .listarQuestionarioItemLocal(h_codigo_empresa, h_codigo_programacao, h_acao, h_sessao_checklist);
    return DadosSessao;
  }
}
