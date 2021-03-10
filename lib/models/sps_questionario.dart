import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sps/dao/sps_dao_questionario_class.dart';
import 'package:sps/models/sps_usuario_class.dart';
import 'package:sps/models/sps_sincronizacao.dart';

class SpsQuestionario {
  @override
  Future<List<Map<String, dynamic>>> listarQuestionario(
      _origemUsuario, _tipoChecklist, _parametro, _filtro, _filtroReferenciaProjeto, _filtroDescrProgramacao) async {

    //Tipos de usuário: "INTERNO / COLIGADA/ CLIENTE / FORNECEDOR / CLIENTE-FORNECEDOR / OUTROS

    String registro_colaborador;
    String identificacao_utilizador;
    String tipo_checklist;
    String tipo_frequencia;
    String registro_aprovador;

    final origem_usuario = _origemUsuario;

    String doc_action;
    if (_tipoChecklist == "CONTROLE DE QUALIDADE") {
      doc_action = 'PREENCHER_CQ';
      tipo_checklist = 'CHECKLIST';
      tipo_frequencia = 'CONTROLE DE QUALIDADE';
      if (sps_usuario().tipo == "INTERNO" || sps_usuario().tipo == "COLIGADA") {
        registro_colaborador = sps_usuario().registro_usuario;
        identificacao_utilizador = 'SCHULER';
      }else{
        registro_colaborador = '';
        identificacao_utilizador = sps_usuario().codigo_usuario;
      }
      registro_aprovador = sps_usuario().registro_usuario;
    }
    if (_tipoChecklist == "CHECKLIST") {
      doc_action = 'PREENCHER_CHECKLIST';
      tipo_checklist = 'CHECKLIST';
      tipo_frequencia = 'ESPORADICA';
      registro_colaborador = sps_usuario().registro_usuario;
      identificacao_utilizador = '';
      registro_aprovador = '';
    }
    if (_tipoChecklist == "PESQUISA") {
      doc_action = 'PREENCHER_PESQUISA';
      tipo_checklist = 'PESQUISA';
      tipo_frequencia = 'ESPORADICA';
      if (sps_usuario().tipo == "INTERNO" || sps_usuario().tipo == "COLIGADA") {
        registro_colaborador = sps_usuario().registro_usuario;
        identificacao_utilizador = '';
      }else{
        registro_colaborador = '';
        identificacao_utilizador = sps_usuario().codigo_usuario;
      }
      registro_aprovador = '';
    }

    //Sincronização de questionarios Server to Local
    spsSincronizacao objspsSincronizacao = spsSincronizacao();
    await objspsSincronizacao.sincronizarQuestionariosServerToLocal(origem_usuario, doc_action, registro_colaborador, identificacao_utilizador, tipo_frequencia, tipo_checklist, registro_aprovador,);

    //Ler dados do SQlite (contar)
    if (_parametro == "CONTAR") {
      debugPrint("Ler dados do SQlite (Tabela: checklist_lista) contador");
      final SpsDaoQuestionario objQuestionarioDao = SpsDaoQuestionario();
      final List<Map<String, dynamic>> DadosSessao =
          await objQuestionarioDao.contarQuestionarioGeral(doc_action);
      return DadosSessao;
    }

    //Ler dados do SQlite (listar)
    if (_parametro == "LISTAR") {
      debugPrint("Ler dados do SQlite (Tabela: checklist_lista) contador");
      final SpsDaoQuestionario objQuestionarioDao = SpsDaoQuestionario();
      final List<Map<String, dynamic>> DadosSessao =
          await objQuestionarioDao.listarQuestionarioGeral(
              _filtro, _filtroReferenciaProjeto, _filtroDescrProgramacao, _origemUsuario, doc_action);
      return DadosSessao;
    }
  }

}
