import 'package:flutter/material.dart';
import 'package:sps/dao/sps_dao_questionario_class.dart';
import 'package:sps/dao/sps_dao_questionario_item_class.dart';
import 'package:sps/dao/sps_dao_questionario_midia_class.dart';
import 'package:sps/http/sps_http_questionario_class.dart';
import 'package:sps/http/sps_http_questionario_item_class.dart';
import 'package:sps/http/sps_http_questionario_midia_class.dart';
import 'package:sps/http/sps_http_verificar_conexao_class.dart';
import 'package:sps/models/sps_usuario_class.dart';

class spsSincronizacao {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

  static Future<bool> sincronizarQuestionarios() async {
    //Criar tabela "checklist_lista" caso não exista
    final SpsDaoQuestionario objQuestionarioDao = SpsDaoQuestionario();
    final int resulcreateLista = await objQuestionarioDao.create_table();

    //Criar tabela "checklist_item" caso não exista
    final SpsDaoQuestionarioItem objQuestionarioItemDao =  SpsDaoQuestionarioItem();
    final int resulcreateitem = await objQuestionarioItemDao.create_table();

    //Criar tabela "sps_checklist_tb_resp_anexo" caso não exista
    final SpsDaoQuestionarioMidia objSpsDaoQuestionarioMidia =  SpsDaoQuestionarioMidia();
    final int resulcreateMidia = await objSpsDaoQuestionarioMidia.create_table();

    //Verificar se existe conexão
    final SpsVerificarConexao ObjVerificarConexao = SpsVerificarConexao();
    final bool result = await ObjVerificarConexao.verificar_conexao();
    if (result == true) {

      //debugPrint("=== INICIO SINCRONIZAÇÃO DE DADOS (Tabela: checklist_lista) =============================================");
      //Ler dados não sincronizados do SQlite
      final List<Map<String, dynamic>> resultLista =
      await objQuestionarioDao.select_sincronizacao();
      var _wregistrosLista = resultLista.length;
      debugPrint(
          "Ler dados não sincronizados do SQlite (quantidade de registro: " +
              _wregistrosLista.toString() +
              ")");
      var windexLista = 0;
      while (windexLista < _wregistrosLista) {
        var _wsincronizado = "";
        var sincLista = 0;
        //Atualizar registro no PostgreSQL (via API REST)
        final SpsHttpQuestionario objQuestionarioHttp = SpsHttpQuestionario();
        final atualizacaoLista = await objQuestionarioHttp.QuestionarioSaveReferencia(
            resultLista[windexLista]["codigo_empresa"],
            resultLista[windexLista]["codigo_programacao"],
            resultLista[windexLista]["referencia_parceiro"],
            usuarioAtual.tipo == "INTERNO" || usuarioAtual.tipo == "COLIGADA" ?usuarioAtual.registro_usuario :usuarioAtual.codigo_usuario);
        if (atualizacaoLista != true) {
          sincLista = 1;
          debugPrint("ERRO => registro sincronizado: " + resultLista[windexLista].toString());
        }
        if(sincLista == 0){
          print('Iniciando a limpeza dos itens a serem sincronizados');
          objQuestionarioDao.updateQuestionarioSincronizacao(
              resultLista[windexLista]["codigo_empresa"],
              resultLista[windexLista]["codigo_programacao"].toString()
          );
        }
        windexLista = windexLista + 1;
      }

      //debugPrint("=== INICIO SINCRONIZAÇÃO DE DADOS (Tabela: checklist_item) =============================================");
      //Ler dados não sincronizados do SQlite
      final List<Map<String, dynamic>> result = await objQuestionarioItemDao
          .selectSincronizacaoItens();
      var _wregistros = result.length;
      //debugPrint("Ler dados não sincronizados do SQlite (quantidade de registro: " +_wregistros.toString() +")");
      var windex = 0;
      while (windex < _wregistros) {
        var _wsincronizado = "";
        var sincItem = 0;
        //Atualizar registro no PostgreSQL (via API REST) campo RESP_CQ
        final SpsHttpQuestionarioItem objQuestionarioItemHttp = SpsHttpQuestionarioItem();
        final atualizacaoitem = await objQuestionarioItemHttp.QuestionarioSaveOpcao(
            result[windex]["codigo_empresa"],
            result[windex]["codigo_programacao"].toString(),
            result[windex]["registro_colaborador"],
            result[windex]["identificacao_utilizador"],
            result[windex]["item_checklist"].toString(),
            result[windex]["resp_cq"],
            usuarioAtual.tipo == "INTERNO" || usuarioAtual.tipo == "COLIGADA" ?usuarioAtual.registro_usuario :usuarioAtual.codigo_usuario);
        if (atualizacaoitem != true) {
          sincItem = 1;
          debugPrint("ERRO => Dados do registro não sincronizado: " + result[windex].toString());
        }

        //Atualizar registro no PostgreSQL (via API REST) campo DESCR_COMENTARIOS
        final atualizacaoComentario = await objQuestionarioItemHttp.QuestionarioSaveComentario(
            "",
            result[windex]["codigo_empresa"],
            result[windex]["codigo_programacao"].toString(),
            result[windex]["registro_colaborador"],
            result[windex]["identificacao_utilizador"],
            result[windex]["item_checklist"].toString(),
            result[windex]["descr_comentarios"],
            usuarioAtual.tipo == "INTERNO" || usuarioAtual.tipo == "COLIGADA" ?usuarioAtual.registro_usuario :usuarioAtual.codigo_usuario);
        if (atualizacaoComentario != true) {
          sincItem = 1;
          debugPrint("ERRO => Dados do cometario do registro não sincronizado: " + result[windex].toString());
        }

        if(sincItem == 0){
          print('Iniciando a limpeza dos itens a serem sincronizados');
          objQuestionarioItemDao.updateQuestionarioItemSincronizacao(
              result[windex]["codigo_empresa"],
              result[windex]["codigo_programacao"].toString(),
              result[windex]["registro_colaborador"],
              result[windex]["identificacao_utilizador"],
              result[windex]["item_checklist"].toString()
          );
        }
        windex = windex + 1;
      }
    }
    return true;
  }


 }