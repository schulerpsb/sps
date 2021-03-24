import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sps/dao/sps_dao_questionario_item_class.dart';
import 'package:sps/models/sps_sincronizacao.dart';

class SpsQuestionarioItem {
  @override
    Future<List<Map<String, dynamic>>> listarQuestionarioItem(
      h_origem_usuario,
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

    //Sincronização de itens  de questionarios Server to Local
    spsSincronizacao objspsSincronizacao = spsSincronizacao();
    await objspsSincronizacao.sincronizarQuestionariosItensServerToLocal(
        acao,
        sessao_checklist,
        codigo_empresa,
        codigo_programacao,
        registro_colaborador,
        identificacao_utilizador,
        codigo_grupo,
        codigo_checklist,
        h_codigo_empresa,
        h_codigo_programacao);

    //Ler dados do SQlite
    debugPrint("Ler dados do SQlite (Tabela: checklist_item)");
    final SpsDaoQuestionarioItem objQuestionarioItemDao =
        SpsDaoQuestionarioItem();
    final List<Map<String, dynamic>> DadosSessao =
        await objQuestionarioItemDao.listarQuestionarioItemLocal(
            h_codigo_empresa, h_codigo_programacao, h_acao, h_sessao_checklist);
    return DadosSessao;
  }
}
