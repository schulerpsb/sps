import 'package:flutter/material.dart';
import 'package:sps/dao/sps_dao_questionario_class.dart';
import 'package:sps/dao/sps_dao_questionario_item_class.dart';
import 'package:sps/dao/sps_dao_questionario_midia_class.dart';
import 'package:sps/http/sps_http_questionario_class.dart';
import 'package:sps/http/sps_http_questionario_item_class.dart';
import 'package:sps/http/sps_http_questionario_midia_class.dart';
import 'package:sps/http/sps_http_verificar_conexao_class.dart';
import 'package:sps/models/sps_questionario_midia.dart';
import 'package:sps/models/sps_updown.dart';
import 'package:sps/models/sps_usuario_class.dart';
import 'package:sps/models/sps_notificacao.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:sps/models/sps_midia_utils.dart';

class spsSincronizacao {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

  //Função que atualiza os dados de questionários(cabeçalho), itens e Anexos entre Local(Sqlite) e o Server(Rest API)
  static Future<bool> sincronizarQuestionarios() async {
    //instancia do mecanismo de notificação
    FlutterLocalNotificationsPlugin flip =
        spsNotificacao.iniciarNotificacaoGrupo();

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
//UPLOAD - SINCRONIZAÇÃO - Rotina de atualização Local(Sqlite) para o servidor(Rest API) - Cabeçalhos, Itens e anexos
      debugPrint(
          "UPLOAD - SINCRONIZAÇÃO - Rotina de atualização Local(Sqlite) para o servidor(Rest API) - Cabeçalhos, Itens e anexos) =============================================");
      debugPrint(
          "=== UPLOAD - INICIO SINCRONIZAÇÃO DE DADOS (Tabela: checklist_lista) =============================================");
      //Ler dados não sincronizados do SQlite
      final List<Map<String, dynamic>> resultLista =
          await objQuestionarioDao.select_sincronizacao();
      var _wregistrosLista = resultLista.length;
      //debugPrint("Ler dados não sincronizados do SQlite (quantidade de registro: " +_wregistrosLista.toString() +")");
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
          //debugPrint("ERRO => registro sincronizado: " +resultLista[windexLista].toString());
        }
        if (sincLista == 0) {
          //print('Iniciando a limpeza dos itens a serem sincronizados');
          objQuestionarioDao.updateQuestionarioSincronizacao(
              resultLista[windexLista]["codigo_empresa"],
              resultLista[windexLista]["codigo_programacao"].toString());
        }

        windexLista = windexLista + 1;
        await spsNotificacao.notificarProgresso(0, _wregistrosLista,
            windexLista, 'SPS - Atualização', 'Upload de Questionários', flip);
      }
      debugPrint(
          "=== UPLOAD - FIM SINCRONIZAÇÃO DE DADOS (Tabela: checklist_lista) =============================================");

      debugPrint(
          "=== UPLOAD - INICIO SINCRONIZAÇÃO DE DADOS (Tabela: checklist_item) =============================================");
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
          //debugPrint("ERRO => Dados do registro não sincronizado: " + result[windex].toString());
        }

        //Atualizar registro no PostgreSQL (via API REST) campo status_aprovacao
        final atualizacaostatus =
            await objQuestionarioItemHttp.QuestionarioSaveAprovacao(
                result[windex]["codigo_empresa"],
                result[windex]["codigo_programacao"].toString(),
                result[windex]["item_checklist"].toString(),
                result[windex]["status_aprovacao"],
                usuarioAtual.tipo == "INTERNO" ||
                        usuarioAtual.tipo == "COLIGADA"
                    ? usuarioAtual.registro_usuario
                    : usuarioAtual.codigo_usuario);
        if (atualizacaostatus != true) {
          sincItem = 1;
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
          //debugPrint("ERRO => Dados do cometario do registro não sincronizado: " +result[windex].toString());
        }

        //Atualizar registro no PostgreSQL (via API REST) SAVE_RESPOSTA tipo checklist
        final atualizacaoSaveResposta =
            await objQuestionarioItemHttp.QuestionarioSaveResposta(
                result[windex]["codigo_empresa"],
                result[windex]["codigo_programacao"].toString(),
                result[windex]["registro_colaborador"],
                result[windex]["identificacao_utilizador"],
                result[windex]["item_checklist"].toString(),
                result[windex]["resp_texto"],
                result[windex]["resp_numero"],
                result[windex]["resp_data"],
                result[windex]["resp_hora"],
                result[windex]["resp_simnao"],
                result[windex]["resp_escala"].toString(),
                result[windex]["descr_comentarios"],
                result[windex]["resp_nao_se_aplica"],
                usuarioAtual.tipo == "INTERNO" ||
                        usuarioAtual.tipo == "COLIGADA"
                    ? usuarioAtual.registro_usuario
                    : usuarioAtual.codigo_usuario);
        if (atualizacaoSaveResposta != true) {
          sincItem = 1;
          //debugPrint("ERRO => Dados do cometario do registro não sincronizado: " +result[windex].toString());
        }

        if (sincItem == 0) {
          //print('Iniciando a limpeza dos itens a serem sincronizados');
          objQuestionarioItemDao.updateQuestionarioItemSincronizacao(
              result[windex]["codigo_empresa"],
              result[windex]["codigo_programacao"].toString(),
              result[windex]["registro_colaborador"],
              result[windex]["identificacao_utilizador"],
              result[windex]["item_checklist"].toString());
        }

        windex = windex + 1;

        await spsNotificacao.notificarProgresso(1, _wregistros, windex,
            'SPS - Atualização', 'Upload de Itens', flip);
      }
      debugPrint(
          "=== UPLOAD - FIM INICIO SINCRONIZAÇÃO DE DADOS (Tabela: checklist_item) =============================================");

      debugPrint(
          "=== UPLOAD - INICIO SINCRONIZAÇÃO DE DADOS (Tabela: sps_checklist_tb_resp_anexo) =============================================");

      //Ler dados não sincronizados do SQlite
      final List<Map<String, dynamic>> resultMidia =
          await objSpsDaoQuestionarioMidia.select_sincronizacao();
      var _wregistrosMidia = resultMidia.length;
      //debugPrint("Ler dados não sincronizados do SQlite (quantidade de registro: " +_wregistrosMidia.toString() +")");
      var windexMidia = 0;
      Map<String, dynamic> dadosArquivo;
      while (windexMidia < _wregistrosMidia) {
        var _wsincronizadoMidia = "";
        //Atualizar registro no PostgreSQL (via API REST)
        final SpsHttpQuestionarioMidia objSpsHttpQuestionarioMidia =
            SpsHttpQuestionarioMidia();
        dadosArquivo = null;
        dadosArquivo = {
          'codigo_empresa': resultMidia[windexMidia]["codigo_empresa"],
          'codigo_programacao':
              resultMidia[windexMidia]["codigo_programacao"].toString(),
          'registro_colaborador': resultMidia[windexMidia]
              ["registro_colaborador"],
          'identificacao_utilizador':
              resultMidia[windexMidia]['identificacao_utilizador'].toString(),
          'item_checklist':
              resultMidia[windexMidia]['item_checklist'].toString(),
          'item_anexo': resultMidia[windexMidia]['item_anexo'].toString(),
          'nome_arquivo': resultMidia[windexMidia]['nome_arquivo'].toString(),
          'titulo_arquivo':
              resultMidia[windexMidia]["titulo_arquivo"].toString(),
          'usuresponsavel':
              resultMidia[windexMidia]['usuresponsavel'].toString(),
          'dthratualizacao':
              resultMidia[windexMidia]['dthratualizacao'].toString(),
          'dthranexo': resultMidia[windexMidia]['dthranexo'].toString(),
          'sincronizado': resultMidia[windexMidia]['sincronizado'].toString(),
        };
        //print('arquvivoMidia==>'+dadosArquivo.toString());

        var retorno1Midia = await objSpsHttpQuestionarioMidia
            .atualizarQuestionarioMidia(dadosArquivo: dadosArquivo);

        if (retorno1Midia == "1") {
          //debugPrint("registro deletado com sucesso no servidor: " + resultMidia[windexMidia].toString());
          //print('apagando o registro de atualização (D) do sqlite');
          objSpsDaoQuestionarioMidia.deleteQuestionarioMidiaSincronizacao(
              resultMidia[windexMidia]["codigo_empresa"],
              resultMidia[windexMidia]["codigo_programacao"].toString(),
              resultMidia[windexMidia]["registro_colaborador"],
              resultMidia[windexMidia]["identificacao_utilizador"],
              resultMidia[windexMidia]["item_checklist"].toString(),
              resultMidia[windexMidia]["item_anexo"].toString());
        }
        if (retorno1Midia == "2") {
          //debugPrint("registro de dados de anexo atualizado com sucesso no servidor: " + resultMidia[windexMidia].toString());
          if (resultMidia[windexMidia]['sincronizado'].toString() == "T" ||
              resultMidia[windexMidia]['sincronizado'].toString() == "M") {
            //Prepara dados para upload do arquivo.
            FormData formData = FormData.fromMap({
              "files": [
                await MultipartFile.fromFile(
                    "/storage/emulated/0/Android/data/com.example.sps/files/Pictures/" +
                        resultMidia[windexMidia]['nome_arquivo'].toString(),
                    filename:
                        resultMidia[windexMidia]['nome_arquivo'].toString()),
              ],
              "codigo_programacao":
                  resultMidia[windexMidia]["codigo_programacao"].toString(),
              "registro_colaborador":
                  resultMidia[windexMidia]["registro_colaborador"].toString(),
              "identificacao_utilizador": resultMidia[windexMidia]
                      ["identificacao_utilizador"]
                  .toString(),
              "item_checklist":
                  resultMidia[windexMidia]["item_checklist"].toString(),
            });
            spsUpDown objspsUpDown = spsUpDown();
            bool statusUpload =
                await objspsUpDown.uploadQuestionarioMidia(formData);
            if (statusUpload == true) {
              //print('Limpando o registro de atualização (N) do sqlite');
              objSpsDaoQuestionarioMidia.updateQuestionarioMidiaSincronizacao(
                  resultMidia[windexMidia]["codigo_empresa"],
                  resultMidia[windexMidia]["codigo_programacao"].toString(),
                  resultMidia[windexMidia]["registro_colaborador"],
                  resultMidia[windexMidia]["identificacao_utilizador"],
                  resultMidia[windexMidia]["item_checklist"].toString(),
                  resultMidia[windexMidia]["item_anexo"].toString());
            } else {
              //debugPrint("ERRO ao processar upload do arquivo no servidor: " + resultMidia[windexMidia].toString());
            }
          } else {
            //print('Limpando o registro de atualização (D) do sqlite');
            objSpsDaoQuestionarioMidia.updateQuestionarioMidiaSincronizacao(
                resultMidia[windexMidia]["codigo_empresa"],
                resultMidia[windexMidia]["codigo_programacao"].toString(),
                resultMidia[windexMidia]["registro_colaborador"],
                resultMidia[windexMidia]["identificacao_utilizador"],
                resultMidia[windexMidia]["item_checklist"].toString(),
                resultMidia[windexMidia]["item_anexo"].toString());
          }
        }
        if (retorno1Midia == "0") {
          //debugPrint("ERRO ao processar arquivo no servidor: " + resultMidia[windexMidia].toString());
        }

        windexMidia = windexMidia + 1;

        await spsNotificacao.notificarProgresso(
            2,
            _wregistrosMidia,
            windexMidia,
            'SPS - Atualização',
            'Upload de arquivos anexos',
            flip);
      }
      debugPrint(
          "=== UPLOAD - FIM SINCRONIZAÇÃO DE DADOS (Tabela: sps_checklist_tb_resp_anexo) =============================================");
      debugPrint(
          "UPLOAD - FIM SINCRONIZAÇÃO - Rotina de atualização Local(Sqlite) para o servidor(Rest API) - Cabeçalhos, Itens e anexos) =============================================");

//DOWNLOAD - SINCRONIZAÇÃO - Rotina de atualização servidor(Rest API) para Local(Sqlite) - Anexos (to be done: Cabeçalhos, Itens)
      debugPrint(
          "DOWNLOAD - SINCRONIZAÇÃO - Rotina de atualização servidor(Rest API) para Local(Sqlite) - Anexos (to be done: Cabeçalhos, Itens) =============================================");
      bool StatuExternoCq = await sincronizarAnexosServerToLocal(
          'EXTERNO', 'CONTROLE DE QUALIDADE', flip);
      bool StatuInternoCq = await sincronizarAnexosServerToLocal(
          'INTERNO', 'CONTROLE DE QUALIDADE', flip);
      bool StatuExternoCheck =
          await sincronizarAnexosServerToLocal('EXTERNO', 'CHECKLIST', flip);
      bool StatuInternoCheck =
          await sincronizarAnexosServerToLocal('INTERNO', 'CHECKLIST', flip);
//      bool StatuExternoPesq = await sincronizarAnexosServerToLocal('EXTERNO', 'PESQUISA',flip);
//      bool StatuInternoPesq = await sincronizarAnexosServerToLocal('INTERNO', 'PESQUISA',flip);
      debugPrint(
          "DOWNLOAD - FIM SINCRONIZAÇÃO - Rotina de atualização servidor(Rest API) para Local(Sqlite) - Anexos (to be done: Cabeçalhos, Itens) =============================================");
//DOWNLOAD - SINCRONIZAÇÃO - Rotina de atualização servidor(Rest API) para Local(Sqlite) - Anexos (to be done: Cabeçalhos, Itens)
    }

    return true;
  }

  static Future<bool> sincronizarAnexosServerToLocal(
      _origemUsuario, _tipoChecklist, flip) async {
    //Tipos de usuário: "INTERNO / COLIGADA/ CLIENTE / FORNECEDOR / CLIENTE-FORNECEDOR / OUTROS
    final SpsHttpQuestionarioMidia objSpsHttpQuestionarioMidia =
        SpsHttpQuestionarioMidia();
    final SpsDaoQuestionarioMidia objSpsDaoQuestionarioMidia =
        SpsDaoQuestionarioMidia();
    final spsUpDown objspsUpDown = spsUpDown();

    debugPrint(
        "=== DOWNLOAD - SINCRONIZAÇÃO DE Anexos (Tabela: sps_checklist_tb_resp_anexo) =============================================");

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
      } else {
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
      } else {
        registro_colaborador = '';
        identificacao_utilizador = sps_usuario().codigo_usuario;
      }
      registro_aprovador = '';
    }

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
      //print('DADOS DE FORMULARIOS PARA DOWNLOAD===>' +dadosQuestionario.toString());
      var indexQuestionario = 0;
      var registrosQuestionario = dadosQuestionario.length;
      Map<String, dynamic> dadosArquivo;
      while (indexQuestionario < registrosQuestionario) {
        dadosArquivo = {
          'codigo_empresa': dadosQuestionario[indexQuestionario]
              ["codigo_empresa"],
          'codigo_programacao': dadosQuestionario[indexQuestionario]
                  ["codigo_programacao"]
              .toString(),
          'registro_colaborador': dadosQuestionario[indexQuestionario]
              ["registro_colaborador"],
          'identificacao_utilizador': dadosQuestionario[indexQuestionario]
                  ['identificacao_utilizador']
              .toString(),
        };

        final List<Map<String, dynamic>> dadosDeAnexosServidor =
            await objSpsHttpQuestionarioMidia.listarMidiaAll(
                dadosArquivo: dadosArquivo);
        //print('Sincronizar o arquivo do servidor====>' +dadosDeAnexosServidor.toString());
        final int criarTabelaLocal =
            await objSpsDaoQuestionarioMidia.create_table();
        final int limparTabeLaLOCAL =
            await objSpsDaoQuestionarioMidia.emptyTable(
                dadosQuestionario[indexQuestionario]["codigo_programacao"]
                    .toString());
        final int ResultadoSave =
            await objSpsDaoQuestionarioMidia.save(dadosDeAnexosServidor);
        if (ResultadoSave == 1) {
          //print('Dados de Anexos de midia sincronizados com sucesso - Server to Local!');
          var indexMidia = 0;
          var registrosMidia = dadosDeAnexosServidor.length;
          while (indexMidia < registrosMidia) {
            String path =
                '/storage/emulated/0/Android/data/com.example.sps/files/Pictures/' +
                    dadosDeAnexosServidor[indexMidia]["nome_arquivo"]
                        .toString();
            //print('Verificar==> ' +dadosDeAnexosServidor[indexMidia]["nome_arquivo"].toString());
            bool status = await File(path).exists();
            if (status == false) {
              if (dadosDeAnexosServidor[indexMidia]["nome_arquivo"]
                          .toString() !=
                      null &&
                  dadosDeAnexosServidor[indexMidia]["nome_arquivo"]
                          .toString() !=
                      "null") {
                String ArquivoParaDownload =
                    'https://10.17.20.45/CHECKLIST/ANEXOS/' +
                        dadosDeAnexosServidor[indexMidia]["codigo_programacao"]
                            .toString() +
                        '_' +
                        '_' +
                        dadosDeAnexosServidor[indexMidia]
                                ["identificacao_utilizador"]
                            .toString() +
                        '_' +
                        dadosDeAnexosServidor[indexMidia]["item_checklist"]
                            .toString() +
                        '/' +
                        dadosDeAnexosServidor[indexMidia]["nome_arquivo"]
                            .toString();
                String destinoLocal =
                    '/storage/emulated/0/Android/data/com.example.sps/files/Pictures/' +
                        dadosDeAnexosServidor[indexMidia]["nome_arquivo"]
                            .toString();
                //print('baixar ==> ' + ArquivoParaDownload.toString() + ' Para ' +destinoLocal.toString());
                await spsNotificacao.notificarProgresso(
                    indexQuestionario,
                    registrosMidia,
                    indexMidia,
                    'SPS - Atualização',
                    'Download de arquivos anexos',
                    flip);
                String statusDownload =
                    await objspsUpDown.downloadQuestionarioMidia(
                        ArquivoParaDownload, destinoLocal);
                if (statusDownload == '1') {
                  //print('Download de Anexos de midia efetuado com sucesso - Server to Local!==>' +ArquivoParaDownload.toString());
                  File arquivoLocal = new File(destinoLocal);
                  String tipoArquivo = arquivoLocal.path.split('.').last;
                  if (tipoArquivo == 'mp4' || tipoArquivo == 'MP4') {
                    //Processamento do arquivo capturado - Gerar thumbnail.
                    List _listaArquivos = new List();
                    _listaArquivos.add(destinoLocal);
                    await spsMidiaUtils.criarVideoThumb(
                        fileList: _listaArquivos);
                    //print('Thumbnail de Download de Anexos de video efetuado com sucesso - Server to Local!==>' +ArquivoParaDownload.toString());
                  }
                  await spsNotificacao.notificarProgresso(
                      indexQuestionario,
                      registrosMidia,
                      indexMidia,
                      'SPS - Atualização',
                      'Download de arquivos anexos',
                      flip);
                } else {
                  if (statusDownload == '404') {
                    var dadosApagarArquivoComErro = null;
                    dadosApagarArquivoComErro = {
                      'codigo_empresa': dadosDeAnexosServidor[indexMidia]
                          ["codigo_empresa"],
                      'codigo_programacao': dadosDeAnexosServidor[indexMidia]
                              ["codigo_programacao"]
                          .toString(),
                      'registro_colaborador': dadosDeAnexosServidor[indexMidia]
                          ["registro_colaborador"],
                      'identificacao_utilizador':
                          dadosDeAnexosServidor[indexMidia]
                                  ['identificacao_utilizador']
                              .toString(),
                      'item_checklist': dadosDeAnexosServidor[indexMidia]
                              ['item_checklist']
                          .toString(),
                      'item_anexo': dadosDeAnexosServidor[indexMidia]
                              ['item_anexo']
                          .toString(),
                      'nome_arquivo': dadosDeAnexosServidor[indexMidia]
                              ['nome_arquivo']
                          .toString(),
                      'titulo_arquivo': dadosDeAnexosServidor[indexMidia]
                              ["titulo_arquivo"]
                          .toString(),
                      'usuresponsavel': dadosDeAnexosServidor[indexMidia]
                              ['usuresponsavel']
                          .toString(),
                      'dthratualizacao': dadosDeAnexosServidor[indexMidia]
                              ['dthratualizacao']
                          .toString(),
                      'dthranexo': dadosDeAnexosServidor[indexMidia]
                              ['dthranexo']
                          .toString(),
                      'sincronizado': 'D',
                    };
                    var retorno1Midia = await objSpsHttpQuestionarioMidia
                        .atualizarQuestionarioMidia(
                            dadosArquivo: dadosApagarArquivoComErro);
                    //await spsNotificacao.notificarErro(900 + indexQuestionario + indexMidia, 'SPS - Falha no download', 'Verifique arquivo na WEB - Cod-Prog:'+dadosDeAnexosServidor[indexMidia]["codigo_programacao"].toString()+' item: '+dadosDeAnexosServidor[indexMidia]["item_checklist"].toString(), flip);
                    print(
                        'ERRO ao processar download de Anexos de midia - Server to Local! ' +
                            ArquivoParaDownload.toString());
                  }
                }
              } else {
                print(
                    'ERRO ao processar download de Anexos de midia - Server to Local! ARQUVIVO CORROMPIDO NA WEB');
              }
            }
            ;
            indexMidia = indexMidia + 1;
          }
        } else {
          print(
              'ERRO ao processar dados de Anexos de midia - Server to Local! ' +
                  ResultadoSave.toString());
        }
        indexQuestionario = indexQuestionario + 1;
      }
      debugPrint(
          "=== DOWNLOAD - FIM SINCRONIZAÇÃO DE Anexos (Tabela: sps_checklist_tb_resp_anexo) =============================================");
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
    debugPrint(
        "=== INICIO SINCRONIZAÇÃO DE DADOS (Tabela: checklist_lista) ============================================");
    //Criar tabela "checklist_lista" caso não exista
    final SpsDaoQuestionario objQuestionarioDao = SpsDaoQuestionario();
    final int resulcreate = await objQuestionarioDao.create_table();

    //Verificar se existe conexão
    final SpsVerificarConexao ObjVerificarConexao = SpsVerificarConexao();
    final bool result = await ObjVerificarConexao.verificar_conexao();
    if (result == true) {
      //Ler registros do PostgreSQL (via API REST) / Deletar dados do SQlite / Gravar dados no SQlite
      //debugPrint("Ler registros do PostgreSQL (via API REST) / Deletar dados do SQlite / Gravar dados no SQlite");
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
        final int resullimpar = await objQuestionarioDao.emptyTable(doc_action);
        final int resultsave =
            await objQuestionarioDao.save(dadosQuestionario, doc_action);
      }
      debugPrint(
          "=== FIM SINCRONIZAÇÃO DE DADOS (Tabela: checklist_lista) ============================================");
    }
  }

  //Função que atualiza os dados de itens de qustionario do Server(Rest API) para o Local(Sqlite)
  Future<SpsDaoQuestionarioItem> sincronizarQuestionariosItensServerToLocal(
      acao,
      sessao_checklist,
      codigo_empresa,
      codigo_programacao,
      String registro_colaborador,
      String identificacao_utilizador,
      codigo_grupo,
      codigo_checklist,
      h_codigo_empresa,
      h_codigo_programacao) async {

    //Criar tabela "checklist_item" caso não exista
    final SpsDaoQuestionarioItem objQuestionarioItemDao =
        SpsDaoQuestionarioItem();
    final int resulcreate = await objQuestionarioItemDao.create_table();

    //Criar tabela "sps_checklist_tb_resp_anexo" caso não exista
    final SpsDaoQuestionarioMidia objSpsDaoQuestionarioMidia =
        SpsDaoQuestionarioMidia();
    final int resulcreateMidia =
        await objSpsDaoQuestionarioMidia.create_table();

    //Verificar se existe conexão
    final SpsVerificarConexao ObjVerificarConexao = SpsVerificarConexao();
    final bool result = await ObjVerificarConexao.verificar_conexao();
    if (result == true) {
      //Ler registros do PostgreSQL (via API REST) / Deletar dados do SQlite / Gravar dados no SQlite
      //debugPrint("Ler registros do PostgreSQL (via API REST) - Itens / Deletar dados do SQlite / Gravar dados no SQlite");
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
//        debugPrint(
//            "Ler registros do PostgreSQL (via API REST) / Deletar dados do SQlite / Gravar dados no SQlite");
//        final SpsQuestionarioMidia objSpsQuestionarioMidia = SpsQuestionarioMidia();
//        final int dadosarquivosLocais = await objSpsQuestionarioMidia
//            .atualizarArquivosQuestionarioMidia(codigo_empresa: codigo_empresa,
//            codigo_programacao: codigo_programacao,
//            registro_colaborador: registro_colaborador,
//            identificacao_utilizador: identificacao_utilizador);
//        //debugPrint("=== FIM SINCRONIZAÇÃO DE DADOS (Tabela: sps_checklist_tb_resp_anexo) =============================================");

    }
    return objQuestionarioItemDao;
  }
}
