import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sps/dao/sps_dao_questionario_resp_multipla_class.dart';
import 'package:sps/models/sps_sincronizacao.dart';

class SpsQuestionarioRespMultipla_ch {
  @override
  Future<List<Map<String, dynamic>>> listarQuestionarioRespMultipla_ch(
      h_codigo_empresa,
      h_codigo_programacao,
      h_registro_colaborador,
      h_identificacao_utilizador,
      h_codigo_grupo,
      h_codigo_checklist,
      h_item_checklist) async {

    //Sincronização de itens  de questionarios Server to Local
    spsSincronizacao objspsSincronizacao = spsSincronizacao();
    await objspsSincronizacao.sincronizarQuestionariosRespMultiplaServerToLocal(
        h_codigo_empresa,
        h_codigo_programacao,
        h_registro_colaborador,
        h_identificacao_utilizador,
        h_codigo_grupo,
        h_codigo_checklist);

    //Ler dados do SQlite
    debugPrint("Ler dados do SQlite (Tabela: checklist_resp_multipla)");
    final SpsDaoQuestionarioRespMultipla objQuestionarioRespMultiplaDao =
        SpsDaoQuestionarioRespMultipla();
    final List<Map<String, dynamic>> DadosSessao =
        await objQuestionarioRespMultiplaDao.listarQuestionarioRespMultiplaLocal(
            h_codigo_empresa, h_codigo_programacao, h_item_checklist);

    print ("adriano =>1 ->"+DadosSessao.toString());
    return DadosSessao;
  }
}
