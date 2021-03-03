import 'package:flutter/material.dart';
import 'package:sps/dao/sps_dao_questionario_class.dart';
import 'package:sps/dao/sps_dao_questionario_item_class.dart';
import 'package:sps/dao/sps_dao_questionario_midia_class.dart';
import 'package:sps/http/sps_http_questionario_class.dart';
import 'package:sps/http/sps_http_questionario_item_class.dart';
import 'package:sps/http/sps_http_questionario_midia_class.dart';
import 'package:sps/http/sps_http_verificar_conexao_class.dart';
import 'package:sps/models/sps_questionario_midia.dart';
import 'package:sps/models/sps_usuario_class.dart';
import 'package:sps/models/sps_notificacao.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:dio/adapter.dart';


class spsSincronizacao {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

  //Função que atualiza os dados de questionários(cabeçalho) e os itens do Local(Sqlite) para o Server(Rest API)
  static Future<bool> sincronizarQuestionariosLocalToServer() async {

    FlutterLocalNotificationsPlugin flip = spsNotificacao.iniciarNotificacaoGrupo();

    //Criar tabela "checklist_lista" caso não exista
    final SpsDaoQuestionario objQuestionarioDao = SpsDaoQuestionario();
    final int resulcreateLista = await objQuestionarioDao.create_table();

    //Criar tabela "checklist_item" caso não exista
    final SpsDaoQuestionarioItem objQuestionarioItemDao =
        SpsDaoQuestionarioItem();
    final int resulcreateitem = await objQuestionarioItemDao.create_table();

    //Criar tabela "sps_checklist_tb_resp_anexo" caso não exista
    final SpsDaoQuestionarioMidia objSpsDaoQuestionarioMidia =
        SpsDaoQuestionarioMidia();
    final int resulcreateMidia =
        await objSpsDaoQuestionarioMidia.create_table();

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
        final atualizacaoLista =
            await objQuestionarioHttp.QuestionarioSaveReferencia(
                resultLista[windexLista]["codigo_empresa"],
                resultLista[windexLista]["codigo_programacao"],
                resultLista[windexLista]["referencia_parceiro"],
                usuarioAtual.tipo == "INTERNO" ||
                        usuarioAtual.tipo == "COLIGADA"
                    ? usuarioAtual.registro_usuario
                    : usuarioAtual.codigo_usuario);
        if (atualizacaoLista != true) {
          sincLista = 1;
          debugPrint("ERRO => registro sincronizado: " +
              resultLista[windexLista].toString());
        }
        if (sincLista == 0) {
          print('Iniciando a limpeza dos itens a serem sincronizados');
          objQuestionarioDao.updateQuestionarioSincronizacao(
              resultLista[windexLista]["codigo_empresa"],
              resultLista[windexLista]["codigo_programacao"].toString());
        }

        windexLista = windexLista + 1;

        await spsNotificacao.notificarProgresso(0, _wregistrosLista , windexLista, 'SPS - Atualização', 'Upload de Questionários', flip);

      }
//      await flip.cancel(0);

      //debugPrint("=== INICIO SINCRONIZAÇÃO DE DADOS (Tabela: checklist_item) =============================================");
      //Ler dados não sincronizados do SQlite
      final List<Map<String, dynamic>> result =
          await objQuestionarioItemDao.selectSincronizacaoItens();
      var _wregistros = result.length;
      //debugPrint("Ler dados não sincronizados do SQlite (quantidade de registro: " +_wregistros.toString() +")");
      var windex = 0;
      while (windex < _wregistros) {
        var _wsincronizado = "";
        var sincItem = 0;
        //Atualizar registro no PostgreSQL (via API REST) campo RESP_CQ
        final SpsHttpQuestionarioItem objQuestionarioItemHttp =
            SpsHttpQuestionarioItem();
        final atualizacaoitem =
            await objQuestionarioItemHttp.QuestionarioSaveOpcao(
                result[windex]["codigo_empresa"],
                result[windex]["codigo_programacao"].toString(),
                result[windex]["registro_colaborador"],
                result[windex]["identificacao_utilizador"],
                result[windex]["item_checklist"].toString(),
                result[windex]["resp_cq"],
                usuarioAtual.tipo == "INTERNO" ||
                        usuarioAtual.tipo == "COLIGADA"
                    ? usuarioAtual.registro_usuario
                    : usuarioAtual.codigo_usuario);
        if (atualizacaoitem != true) {
          sincItem = 1;
          debugPrint("ERRO => Dados do registro não sincronizado: " +
              result[windex].toString());
        }

        //Atualizar registro no PostgreSQL (via API REST) campo DESCR_COMENTARIOS
        final atualizacaoComentario =
            await objQuestionarioItemHttp.QuestionarioSaveComentario(
                "",
                result[windex]["codigo_empresa"],
                result[windex]["codigo_programacao"].toString(),
                result[windex]["registro_colaborador"],
                result[windex]["identificacao_utilizador"],
                result[windex]["item_checklist"].toString(),
                result[windex]["descr_comentarios"],
                usuarioAtual.tipo == "INTERNO" ||
                        usuarioAtual.tipo == "COLIGADA"
                    ? usuarioAtual.registro_usuario
                    : usuarioAtual.codigo_usuario);
        if (atualizacaoComentario != true) {
          sincItem = 1;
          debugPrint(
              "ERRO => Dados do cometario do registro não sincronizado: " +
                  result[windex].toString());
        }

        if (sincItem == 0) {
          print('Iniciando a limpeza dos itens a serem sincronizados');
          objQuestionarioItemDao.updateQuestionarioItemSincronizacao(
              result[windex]["codigo_empresa"],
              result[windex]["codigo_programacao"].toString(),
              result[windex]["registro_colaborador"],
              result[windex]["identificacao_utilizador"],
              result[windex]["item_checklist"].toString());
        }

        windex = windex + 1;

        await spsNotificacao.notificarProgresso(1, _wregistros , windex, 'SPS - Atualização', 'Upload de Itens', flip);

      }

      //debugPrint("=== INICIO SINCRONIZAÇÃO DE DADOS (Tabela: sps_checklist_tb_resp_anexo) =============================================");
      //Ler dados não sincronizados do SQlite
      final List<Map<String, dynamic>> resultMidia = await objSpsDaoQuestionarioMidia.select_sincronizacao();
      var _wregistrosMidia = resultMidia.length;
      //debugPrint("Ler dados não sincronizados do SQlite (quantidade de registro: " +_wregistrosMidia.toString() +")");
      var windexMidia = 0;
      Map<String, dynamic> dadosArquivo;
      while (windexMidia < _wregistrosMidia) {
        var _wsincronizadoMidia = "";
        //Atualizar registro no PostgreSQL (via API REST)
        final SpsHttpQuestionarioMidia objSpsHttpQuestionarioMidia = SpsHttpQuestionarioMidia();
        dadosArquivo = null;
        dadosArquivo = {
          'codigo_empresa': resultMidia[windexMidia]["codigo_empresa"],
          'codigo_programacao': resultMidia[windexMidia]["codigo_programacao"].toString(),
          'registro_colaborador': resultMidia[windexMidia]["registro_colaborador"],
          'identificacao_utilizador': resultMidia[windexMidia]['identificacao_utilizador'].toString(),
          'item_checklist': resultMidia[windexMidia]['item_checklist'].toString(),
          'item_anexo': resultMidia[windexMidia]['item_anexo'].toString(),
          'nome_arquivo': resultMidia[windexMidia]['nome_arquivo'].toString(),
          'titulo_arquivo': resultMidia[windexMidia]["titulo_arquivo"].toString(),
          'usuresponsavel': resultMidia[windexMidia]['usuresponsavel'].toString(),
          'dthratualizacao': resultMidia[windexMidia]['dthratualizacao'].toString(),
          'dthranexo': resultMidia[windexMidia]['dthranexo'].toString(),
          'sincronizado': resultMidia[windexMidia]['sincronizado'].toString(),
        };
        //print('arquvivoMidia==>'+dadosArquivo.toString());

        var retorno1Midia = await objSpsHttpQuestionarioMidia.atualizarQuestionarioMidia(dadosArquivo: dadosArquivo);

        if (retorno1Midia == "1") {
          debugPrint("registro deletado com sucesso no servidor: " + resultMidia[windexMidia].toString());
        }
        if (retorno1Midia == "2") {
          debugPrint("registro de dados de anexo atualizado com sucesso no servidor: " + resultMidia[windexMidia].toString());

          //upload do arquivo
          try {
            FormData formData = FormData.fromMap({
              "files": [
                await MultipartFile.fromFile("/storage/emulated/0/Android/data/com.example.sps/files/Pictures/"+resultMidia[windexMidia]['nome_arquivo'].toString(), filename: resultMidia[windexMidia]['nome_arquivo'].toString()),
              ],
              "codigo_programacao": resultMidia[windexMidia]["codigo_programacao"].toString(),
              "registro_colaborador": resultMidia[windexMidia]["registro_colaborador"].toString(),
              "identificacao_utilizador": resultMidia[windexMidia]["identificacao_utilizador"].toString(),
              "item_checklist": resultMidia[windexMidia]["item_checklist"].toString(),
            });

            Response response;
            Dio dio = new Dio();
            (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
                (HttpClient client) {
              client.badCertificateCallback =
                  (X509Certificate cert, String host, int port) => true;
              return client;
            };
            response = await dio.post("http://10.17.20.45/webapi/api/midia/upload.php", data: formData);
            print('Foi');
            print(response);
          } catch (e) {
            print('Erro');
            print(e);
          }
          //FIM - Upload arquivo

//          print('Iniciando a anexo dos itens a serem sincronizados');
//          objSpsDaoQuestionarioMidia.updateQuestionarioMidiaSincronizacao(
//              result[windex]["codigo_empresa"],
//              result[windex]["codigo_programacao"].toString(),
//              result[windex]["registro_colaborador"],
//              result[windex]["identificacao_utilizador"],
//              result[windex]["item_checklist"].toString(),
//              result[windex]["item_anexo"].toString());
        }
        if (retorno1Midia == "0") {
          debugPrint("ERRO ao processar arquivo no servidor: " + resultMidia[windexMidia].toString());
        }

        windexMidia = windexMidia + 1;

        await spsNotificacao.notificarProgresso(2, _wregistrosMidia , windexMidia, 'SPS - Atualização', 'Upload de Dados de anexos', flip);

      }
      //debugPrint("=== FIM SINCRONIZAÇÃO DE DADOS (Tabela: sps_checklist_tb_resp_anexo) =============================================");


    }

    return true;
  }

  //Função que atualiza os dados de questionários(cabeçalho) do Server(Rest API) para o Local(Sqlite)
  Future sincronizarQuestionariosServerToLocal(
      origem_usuario,
      String doc_action,
      String registro_colaborador,
      String identificacao_utilizador,
      String tipo_frequencia,
      String tipo_checklist,
      String registro_aprovador) async {
    //Criar tabela "checklist_lista" caso não exista
    final SpsDaoQuestionario objQuestionarioDao = SpsDaoQuestionario();
    final int resulcreate = await objQuestionarioDao.create_table();

    //Verificar se existe conexão
    final SpsVerificarConexao ObjVerificarConexao = SpsVerificarConexao();
    final bool result = await ObjVerificarConexao.verificar_conexao();
    if (result == true) {
      //Ler registros do PostgreSQL (via API REST) / Deletar dados do SQlite / Gravar dados no SQlite
      debugPrint(
          "Ler registros do PostgreSQL (via API REST) / Deletar dados do SQlite / Gravar dados no SQlite");
      final SpsHttpQuestionario objQuestionarioHttp = SpsHttpQuestionario();
      final List<Map<String, dynamic>> dadosQuestionario =
          await objQuestionarioHttp.httplistarQuestionario(
              origem_usuario,
              doc_action,
              registro_colaborador,
              identificacao_utilizador,
              tipo_frequencia,
              tipo_checklist,
              registro_aprovador);
      if (dadosQuestionario != null) {
        final SpsDaoQuestionario objQuestionarioDao = SpsDaoQuestionario();
        final int resullimpar = await objQuestionarioDao.emptyTable();
        final int resultsave = await objQuestionarioDao.save(dadosQuestionario);
      }
      debugPrint(
          "=== FIM SINCRONIZAÇÃO DE DADOS (Tabela: checklist_lista) ============================================");
    }
  }

  //Função que atualiza os dados de itens de qustionario do Server(Rest API) para o Local(Sqlite)
  Future<SpsDaoQuestionarioItem> sincronizarQuestionariosItensServerToLocal(acao, sessao_checklist, codigo_empresa, codigo_programacao, String registro_colaborador, String identificacao_utilizador, codigo_grupo, codigo_checklist, h_codigo_empresa, h_codigo_programacao) async {
    //Criar tabela "checklist_item" caso não exista
    final SpsDaoQuestionarioItem objQuestionarioItemDao =  SpsDaoQuestionarioItem();
    final int resulcreate = await objQuestionarioItemDao.create_table();

    //Criar tabela "sps_checklist_tb_resp_anexo" caso não exista
    final SpsDaoQuestionarioMidia objSpsDaoQuestionarioMidia =  SpsDaoQuestionarioMidia();
    final int resulcreateMidia = await objSpsDaoQuestionarioMidia.create_table();

    //Verificar se existe conexão
    final SpsVerificarConexao ObjVerificarConexao = SpsVerificarConexao();
    final bool result = await ObjVerificarConexao.verificar_conexao();
    if (result == true) {
      //Ler registros do PostgreSQL (via API REST) / Deletar dados do SQlite / Gravar dados no SQlite
      // debugPrint("Ler registros do PostgreSQL (via API REST) / Deletar dados do SQlite / Gravar dados no SQlite");
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
      //debugPrint("=== FIM SINCRONIZAÇÃO DE DADOS (Tabela: checklist_item) ============================================");

      //debugPrint("=== INICIO SINCRONIZAÇÃO DE DADOS (Tabela: sps_checklist_tb_resp_anexo) =============================================");
      //Ler registros do PostgreSQL (via API REST) / Deletar dados do SQlite / Gravar dados no SQlite
      debugPrint("Ler registros do PostgreSQL (via API REST) / Deletar dados do SQlite / Gravar dados no SQlite");
      final SpsQuestionarioMidia objSpsQuestionarioMidia = SpsQuestionarioMidia();
      final int dadosarquivosLocais =  await objSpsQuestionarioMidia.atualizarArquivosQuestionarioMidia(codigo_empresa: codigo_empresa, codigo_programacao: codigo_programacao, registro_colaborador: registro_colaborador,identificacao_utilizador: identificacao_utilizador);
      //debugPrint("=== FIM SINCRONIZAÇÃO DE DADOS (Tabela: sps_checklist_tb_resp_anexo) =============================================");

    }
    return objQuestionarioItemDao;
  }



}
