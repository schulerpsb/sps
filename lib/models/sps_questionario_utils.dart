import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sps/dao/sps_dao_questionario_item_class.dart';
import 'package:sps/dao/sps_dao_questionario_midia_class.dart';
import 'package:sps/http/sps_http_questionario_item_class.dart';
import 'package:sps/http/sps_http_verificar_conexao_class.dart';
import 'package:sps/models/sps_usuario_class.dart';
import 'package:thumbnails/thumbnails.dart';
import 'package:exif/exif.dart';
import 'package:image/image.dart' as img;

class spsQuestionarioUtils {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

  Future<String> atualizar_status_resposta(
      String wcodigoEmpresa,
      int wcodigoProgramacao,
      String wregistroColaborador,
      String widentificacaoUtilizador,
      int witemChecklist) async {
    debugPrint("Atualizar status resposta");

    var _wsincronizado = "";

    final SpsDaoQuestionarioItem objQuestionarioItemDao =
        SpsDaoQuestionarioItem();

    //Ler dados do SQlite (Checklis Item - chave primaria)
    final List<Map<String, dynamic>> result =
        await objQuestionarioItemDao.select_chave_primaria(
            wcodigoEmpresa,
            wcodigoProgramacao,
            wregistroColaborador,
            widentificacaoUtilizador,
            witemChecklist);

    //Analisar status da resposta
    String _wstatusResposta;
    if (result[0]["resp_texto"] == "") {
      _wstatusResposta = "PENDENTE";
    } else {
      _wstatusResposta = "PREENCHIDA";
      if (result[0]["comentarios"] == "OBRIGATORIO") {
        if (result[0]["descr_comentarios"] == "") {
          _wstatusResposta = "PENDENTE";
        }
      }
      print ("adriano => "+result[0]["midia"]);
      print ("adriano => "+result[0]["qtde_anexos"].toString());
      if (result[0]["midia"] == "OBRIGATORIO") {
        if (result[0]["qtde_anexos"] == 0) {
          _wstatusResposta = "PENDENTE";
        }
      }
    }

    if (_wstatusResposta != result[0]["status_resposta"]) {
      //Verificar se existe conexão
      final SpsVerificarConexao ObjVerificarConexao = SpsVerificarConexao();
      final bool result = await ObjVerificarConexao.verificar_conexao();
      if (result == true) {
        //Gravar PostgreSQL (API REST)
        final SpsHttpQuestionarioItem objQuestionarioItemHttp =
            SpsHttpQuestionarioItem();
        final retorno =
            await objQuestionarioItemHttp.QuestionarioSaveStatusResposta(
                wcodigoEmpresa,
                wcodigoProgramacao,
                wregistroColaborador,
                widentificacaoUtilizador,
                witemChecklist,
                _wstatusResposta,
                usuarioAtual.tipo == "INTERNO" ||
                        usuarioAtual.tipo == "COLIGADA"
                    ? usuarioAtual.registro_usuario
                    : usuarioAtual.codigo_usuario);
        if (retorno == true) {
          _wsincronizado = "";
          debugPrint("registro gravado PostgreSQL");
        } else {
          _wsincronizado = "N";
          debugPrint("ERRO => registro não gravado PostgreSQL");
        }
      } else {
        _wsincronizado = "N";
      }

      //Gravar SQlite
      final SpsDaoQuestionarioItem objQuestionarioItemDao =
          SpsDaoQuestionarioItem();
      final int resultupdate =
          await objQuestionarioItemDao.update_status_resposta(
              wcodigoEmpresa,
              wcodigoProgramacao,
              wregistroColaborador,
              widentificacaoUtilizador,
              witemChecklist,
              _wstatusResposta,
              _wsincronizado);
    }
  }
}
