import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sps/dao/sps_dao_questionario_item_class.dart';
import 'package:sps/models/sps_sincronizacao.dart';

class SpsQuestionarioItem_ch {
  @override
  Future<List<Map<String, dynamic>>> listarQuestionarioItem_ch(
      h_codigo_empresa,
      h_codigo_programacao,
      h_registro_colaborador,
      h_identificacao_utilizador,
      h_codigo_grupo,
      h_codigo_checklist,
      h_acao,
      h_sessao_checklist) async {
    final acao = h_acao;
    final sessao_checklist = h_sessao_checklist;
    final codigo_empresa = h_codigo_empresa;
    final codigo_programacao = h_codigo_programacao;
    final registro_colaborador = h_registro_colaborador;
    final identificacao_utilizador = h_identificacao_utilizador;
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
    final SpsDaoQuestionarioItem objQuestionarioItemDao = SpsDaoQuestionarioItem();
    final List<Map<String, dynamic>> DadosSessao = await objQuestionarioItemDao.listarQuestionarioItemLocal(
            h_codigo_empresa, h_codigo_programacao, h_acao, h_sessao_checklist);
    return DadosSessao;
  }
}

class SpsQuestionarioItem_ch_item {
  @override
  Future<List<Map<String, dynamic>>> listarQuestionarioItem_ch_item(
      h_codigo_empresa,
      h_codigo_programacao,
      h_registro_colaborador,
      h_identificacao_utilizador,
      h_codigo_grupo,
      h_codigo_checklist,
      h_acao,
      h_sessao_checklist,
      h_item_checklist) async {

    //Ler dados do SQlite
    debugPrint("Ler dados do SQlite (Tabela: checklist_item) -> item especifico");
    final SpsDaoQuestionarioItem objQuestionarioItemDao = SpsDaoQuestionarioItem();
    final List<Map<String, dynamic>> DadosSessao = await objQuestionarioItemDao.listarQuestionarioItemLocal_item(
        h_codigo_empresa, h_codigo_programacao, h_acao, h_sessao_checklist, h_item_checklist);
    return DadosSessao;
  }
}
