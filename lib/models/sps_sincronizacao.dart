import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sps/dao/sps_dao_questionario_class.dart';
import 'package:sps/dao/sps_dao_questionario_item_class.dart';
import 'package:sps/dao/sps_dao_questionario_midia_class.dart';
import 'package:sps/dao/sps_dao_sincronizacao_class.dart';
import 'package:sps/http/sps_http_questionario_class.dart';
import 'package:sps/http/sps_http_questionario_item_class.dart';
import 'package:sps/http/sps_http_questionario_midia_class.dart';
import 'package:sps/http/sps_http_verificar_conexao_class.dart';
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
    getApplicationDocumentsDirectory().then((value){
      usuarioAtual.document_root_folder = value.path.toString();
    });
    DateTime now = new DateTime.now();
    DateTime dataHoraAtual = new DateTime(now.year, now.month, now.day, now.hour, now.minute);

    SpsDaoSincronizacao objSpsDaoSincronizacao = SpsDaoSincronizacao();
    var dadosSincronizacaoAtual = await objSpsDaoSincronizacao.listaDadosSincronizacao();
    Map<String, dynamic> dadosSincronizacao;
    dadosSincronizacao = null;
    dadosSincronizacao = {
      'id_isolate': dadosSincronizacaoAtual[0]['id_isolate'],
      'status': 2,
    };
    objSpsDaoSincronizacao.update(dadosSincronizacao);

    //print('Fernando' + usuarioAtual.document_root_folder);
    //instancia do mecanismo de notificação
    FlutterLocalNotificationsPlugin flip = spsNotificacao.iniciarNotificacaoGrupo();
    int jaNotificado = 0;

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
      debugPrint("UPLOAD - SINCRONIZAÇÃO - Rotina de atualização Local(Sqlite) para o servidor(Rest API) - Cabeçalhos, Itens e anexos) =============================================");
      debugPrint("=== UPLOAD - INICIO SINCRONIZAÇÃO DE DADOS (Tabela: checklist_lista) =============================================");
      //Ler dados não sincronizados do SQlite
      final List<Map<String, dynamic>> resultLista = await objQuestionarioDao.select_sincronizacao();
      var _wregistrosLista = resultLista.length;
      if(resultLista.length > 0){
        if(jaNotificado == 0){
          await spsNotificacao.notificarInicioProgressoIndeterminado(0, 'SPS-Schuler Production System','Sincronização de Dados', flip);
          jaNotificado = 1;
        }
      }
      //debugPrint("Ler dados não sincronizados do SQlite (quantidade de registro: " +resultLista.toString() +")");
      var windexLista = 0;
      await Future.forEach(resultLista, (questionario) async {
        var _wsincronizado = "";
        var sincLista = 0;
        //Atualizar registro no PostgreSQL (via API REST)
        final SpsHttpQuestionario objQuestionarioHttp = SpsHttpQuestionario();
        final atualizacaoLista = await objQuestionarioHttp.QuestionarioSaveReferencia(
            questionario["codigo_empresa"],
            questionario["codigo_programacao"],
            questionario["referencia_parceiro"],
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
              questionario["codigo_empresa"],
              questionario["codigo_programacao"].toString());
          print('=== === UPLOAD - Update dados de Referência. Código programação: '+questionario["codigo_programacao"].toString());
        }
        windexLista = windexLista + 1;
      });
//      while (windexLista < _wregistrosLista) {
//
//      }
      debugPrint("=== UPLOAD - FIM SINCRONIZAÇÃO DE DADOS (Tabela: checklist_lista) =============================================");

      debugPrint("=== UPLOAD - INICIO SINCRONIZAÇÃO DE DADOS (Tabela: checklist_item) =============================================");
      //Ler dados não sincronizados do SQlite
      final List<Map<String, dynamic>> result =
      await objQuestionarioItemDao.selectSincronizacaoItens();
      var _wregistros = result.length;
      if(result.length > 0){
        if(jaNotificado == 0){
          await spsNotificacao.notificarInicioProgressoIndeterminado(0, 'SPS - Schuler Production System','Sincronização de Dados', flip);
          jaNotificado = 1;
        }
      }
      //debugPrint("Ler dados não sincronizados do SQlite (quantidade de registro: " +_wregistros.toString() +")");
      var windex = 0;
      await Future.forEach(result, (item) async {
        var _wsincronizado = "";
        var sincItem = 0;
        //Atualizar registro no PostgreSQL (via API REST) campo RESP_CQ
        final SpsHttpQuestionarioItem objQuestionarioItemHttp = SpsHttpQuestionarioItem();
        final atualizacaoitem = await objQuestionarioItemHttp.QuestionarioSaveOpcao(
            item["codigo_empresa"],
            item["codigo_programacao"].toString(),
            item["registro_colaborador"],
            item["identificacao_utilizador"],
            item["item_checklist"].toString(),
            item["resp_cq"],
            usuarioAtual.tipo == "INTERNO" ||
                usuarioAtual.tipo == "COLIGADA"
                ? usuarioAtual.registro_usuario
                : usuarioAtual.codigo_usuario);
        if (atualizacaoitem != true) {
          sincItem = 1;
          //debugPrint("ERRO => Dados do registro não sincronizado: " + item.toString());
        }

        //Atualizar registro no PostgreSQL (via API REST) campo status_aprovacao
        final atualizacaostatus = await objQuestionarioItemHttp.QuestionarioSaveAprovacao(
            item["codigo_empresa"],
            item["codigo_programacao"].toString(),
            item["item_checklist"].toString(),
            item["status_aprovacao"],
            usuarioAtual.registro_usuario);
        if (atualizacaostatus != true) {
          sincItem = 1;
        }

        //Atualizar registro no PostgreSQL (via API REST) campo DESCR_COMENTARIOS
        final atualizacaoComentario = await objQuestionarioItemHttp.QuestionarioSaveComentario(
            "",
            item["codigo_empresa"],
            item["codigo_programacao"].toString(),
            item["registro_colaborador"],
            item["identificacao_utilizador"],
            item["item_checklist"].toString(),
            item["descr_comentarios"],
            usuarioAtual.tipo == "INTERNO" ||
                usuarioAtual.tipo == "COLIGADA"
                ? usuarioAtual.registro_usuario
                : usuarioAtual.codigo_usuario);
        if (atualizacaoComentario != true) {
          sincItem = 1;
          //debugPrint("ERRO => Dados do cometario do registro não sincronizado: " +item.toString());
        }

        //Atualizar registro no PostgreSQL (via API REST) SAVE_RESPOSTA tipo checklist
        final atualizacaoSaveResposta = await objQuestionarioItemHttp.QuestionarioSaveResposta(
            item["codigo_empresa"],
            item["codigo_programacao"].toString(),
            item["registro_colaborador"],
            item["identificacao_utilizador"],
            item["item_checklist"].toString(),
            item["resp_texto"],
            item["resp_numero"].toString(),
            item["resp_data"],
            item["resp_hora"],
            item["resp_simnao"],
            item["resp_escala"].toString(),
            item["descr_comentarios"],
            item["resp_nao_se_aplica"],
            usuarioAtual.tipo == "INTERNO" || usuarioAtual.tipo == "COLIGADA"
                ? usuarioAtual.registro_usuario
                : usuarioAtual.codigo_usuario);
        if (atualizacaoSaveResposta != true) {
          sincItem = 1;
          //debugPrint("ERRO => Dados do cometario do registro não sincronizado: " +item.toString());
        }

        //Atualizar registro no PostgreSQL (via API REST) SAVE_RESPOSTA tipo checklist
        final atualizacaoStatusResposta = await objQuestionarioItemHttp.QuestionarioSaveStatusResposta(
                 item["codigo_empresa"],
                 item["codigo_programacao"],
                 item["registro_colaborador"],
                 item["identificacao_utilizador"],
                 item["item_checklist"],
                 item["status_resposta"],
                 usuarioAtual.tipo == "INTERNO" ||
                         usuarioAtual.tipo == "COLIGADA"
                     ? usuarioAtual.registro_usuario
                     : usuarioAtual.codigo_usuario);
        if (atualizacaoStatusResposta != true) {
          sincItem = 1;
          //debugPrint("ERRO => Dados do cometario do registro não sincronizado: " +item.toString());
        }

        if (sincItem == 0) {
          //print('Iniciando a limpeza dos itens a serem sincronizados');
          objQuestionarioItemDao.updateQuestionarioItemSincronizacao(
              item["codigo_empresa"],
              item["codigo_programacao"].toString(),
              item["registro_colaborador"],
              item["identificacao_utilizador"],
              item["item_checklist"].toString());
          print('=== === UPLOAD - Update dados de Item, comentários, aprovação e respostas. Codigo_programação: '+item["codigo_programacao"].toString()+', item: '+item["item_checklist"].toString());
        }
        windex = windex + 1;
      });
//      while (windex < _wregistros) {
//      }
      debugPrint("=== UPLOAD - FIM INICIO SINCRONIZAÇÃO DE DADOS (Tabela: checklist_item) =============================================");

      debugPrint("=== UPLOAD - INICIO SINCRONIZAÇÃO DE DADOS (Tabela: sps_checklist_tb_resp_anexo) =============================================");

      //Ler dados não sincronizados do SQlite
      final List<Map<String, dynamic>> resultMidia = await objSpsDaoQuestionarioMidia.select_sincronizacao();
      var _wregistrosMidia = resultMidia.length;
      if(resultMidia.length > 0){
        if(jaNotificado == 0){
          await spsNotificacao.notificarInicioProgressoIndeterminado(0, 'SPS - Schuler Production System','Sincronização de Dados', flip);
          jaNotificado = 1;
        }
      }
      //debugPrint("Ler dados não sincronizados do SQlite (quantidade de registro: " +_wregistrosMidia.toString() +")");
      var windexMidia = 0;
      Map<String, dynamic> dadosArquivo;
      await Future.forEach(resultMidia, (midia) async {
        var _wsincronizadoMidia = "";
        //Atualizar registro no PostgreSQL (via API REST)
        final SpsHttpQuestionarioMidia objSpsHttpQuestionarioMidia = SpsHttpQuestionarioMidia();
        dadosArquivo = null;
        dadosArquivo = {
          'codigo_empresa': midia["codigo_empresa"],
          'codigo_programacao': midia["codigo_programacao"]
              .toString(),
          'registro_colaborador': midia["registro_colaborador"],
          'identificacao_utilizador': midia['identificacao_utilizador']
              .toString(),
          'item_checklist': midia['item_checklist']
              .toString(),
          'item_anexo': midia['item_anexo'].toString(),
          'nome_arquivo': midia['nome_arquivo'].toString(),
          'titulo_arquivo': midia["titulo_arquivo"]
              .toString(),
          'usuresponsavel': midia['usuresponsavel']
              .toString(),
          'dthratualizacao': midia['dthratualizacao']
              .toString(),
          'dthranexo': midia['dthranexo'].toString(),
          'sincronizado': midia['sincronizado'].toString(),
        };
        //print('arquvivoMidia==>'+dadosArquivo.toString());

        var retorno1Midia = await objSpsHttpQuestionarioMidia.atualizarQuestionarioMidia(dadosArquivo: dadosArquivo);

        if (retorno1Midia == "1") {
          //debugPrint("registro deletado com sucesso no servidor: " + midia.toString());
          //print('apagando o registro de atualização (D) do sqlite');
          objSpsDaoQuestionarioMidia.deleteQuestionarioMidiaSincronizacao(
              midia["codigo_empresa"],
              midia["codigo_programacao"].toString(),
              midia["registro_colaborador"],
              midia["identificacao_utilizador"],
              midia["item_checklist"].toString(),
              midia["item_anexo"].toString());
        }
        if (retorno1Midia == "2") {
          //debugPrint("registro de dados de anexo atualizado com sucesso no servidor: " + midia.toString());
          if (midia['sincronizado'].toString() == "T" ||
              midia['sincronizado'].toString() == "M") {
            //Prepara dados para upload do arquivo.
            FormData formData = FormData.fromMap({
              "files": [
                await MultipartFile.fromFile(
                    usuarioAtual.document_root_folder.toString() + '/' +
                        midia['nome_arquivo'].toString(),
                    filename: midia['nome_arquivo']
                        .toString()),
              ],
              "codigo_programacao": midia["codigo_programacao"].toString(),
              "registro_colaborador": midia["registro_colaborador"].toString(),
              "identificacao_utilizador": midia["identificacao_utilizador"].toString(),
              "item_checklist": midia["item_checklist"].toString(),
            });
            spsUpDown objspsUpDown = spsUpDown();
            bool statusUpload = await objspsUpDown.uploadQuestionarioMidia(
                formData);
            if (statusUpload == true) {
              //print('Limpando o registro de atualização (N) do sqlite');
              objSpsDaoQuestionarioMidia.updateQuestionarioMidiaSincronizacao(
                  midia["codigo_empresa"],
                  midia["codigo_programacao"].toString(),
                  midia["registro_colaborador"],
                  midia["identificacao_utilizador"],
                  midia["item_checklist"].toString(),
                  midia["item_anexo"].toString());
            } else {
              //debugPrint("ERRO ao processar upload do arquivo no servidor: " + midia.toString());
            }
          } else {
            //print('Limpando o registro de atualização (D) do sqlite');
            objSpsDaoQuestionarioMidia.updateQuestionarioMidiaSincronizacao(
                midia["codigo_empresa"],
                midia["codigo_programacao"].toString(),
                midia["registro_colaborador"],
                midia["identificacao_utilizador"],
                midia["item_checklist"].toString(),
                midia["item_anexo"].toString());
            print('=== === UPLOAD - Update de anexo. Codigo_programação: '+midia["codigo_programacao"].toString()+', item: '+midia["item_checklist"].toString()+', anexo: '+midia["item_anexo"].toString());
          }
        }
        if (retorno1Midia == "0") {
          //debugPrint("ERRO ao processar arquivo no servidor: " + midia.toString());
        }
        windexMidia = windexMidia + 1;
      });
//      while (windexMidia < _wregistrosMidia) {
//
//      }
      debugPrint("=== UPLOAD - FIM SINCRONIZAÇÃO DE DADOS (Tabela: sps_checklist_tb_resp_anexo) =============================================");
      debugPrint("UPLOAD - FIM SINCRONIZAÇÃO - Rotina de atualização Local(Sqlite) para o servidor(Rest API) - Cabeçalhos, Itens e anexos) =============================================");

//DOWNLOAD - SINCRONIZAÇÃO - Rotina de atualização servidor(Rest API) para Local(Sqlite) - Anexos (to be done: Cabeçalhos, Itens)
      debugPrint("DOWNLOAD - SINCRONIZAÇÃO - Rotina de atualização servidor(Rest API) para Local(Sqlite) - Anexos (to be done: Cabeçalhos, Itens) =============================================");
      jaNotificado = await sincronizarAnexosServerToLocal('EXTERNO', 'CONTROLE DE QUALIDADE',flip, jaNotificado);
      jaNotificado = await sincronizarAnexosServerToLocal('INTERNO', 'CONTROLE DE QUALIDADE',flip, jaNotificado);
      jaNotificado = await sincronizarAnexosServerToLocal('EXTERNO', 'CHECKLIST',flip, jaNotificado);
      jaNotificado = await sincronizarAnexosServerToLocal('INTERNO', 'CHECKLIST',flip, jaNotificado);
      jaNotificado = await sincronizarAnexosServerToLocal('EXTERNO', 'PESQUISA',flip, jaNotificado);
      jaNotificado = await sincronizarAnexosServerToLocal('INTERNO', 'PESQUISA',flip, jaNotificado);
      debugPrint("DOWNLOAD - FIM SINCRONIZAÇÃO - Rotina de atualização servidor(Rest API) para Local(Sqlite) - Anexos (to be done: Cabeçalhos, Itens) =============================================");
//DOWNLOAD - SINCRONIZAÇÃO - Rotina de atualização servidor(Rest API) para Local(Sqlite) - Anexos (to be done: Cabeçalhos, Itens)
      jaNotificado = 0;

      DateTime now = new DateTime.now();
      DateTime dataHoraAtual = new DateTime(now.year, now.month, now.day, now.hour, now.minute);

      var dadosSincronizacaoAtual = await objSpsDaoSincronizacao.listaDadosSincronizacao();
      await objSpsDaoSincronizacao.emptyTable();
      Map<String, dynamic> dadosSincronizacao;
      dadosSincronizacao = null;
      dadosSincronizacao = {
        'id_isolate': dadosSincronizacaoAtual[0]['id_isolate'],
        'data_ultima_sincronizacao': dataHoraAtual.toString(),
        'status': 1,
      };
      objSpsDaoSincronizacao.save(dadosSincronizacao);

      await spsNotificacao.cancelarNotificacao(0, flip);
    }

    return true;
  }

  static Future<int> sincronizarAnexosServerToLocal(_origemUsuario,_tipoChecklist,flip, jaNotificado) async {

    //Tipos de usuário: "INTERNO / COLIGADA/ CLIENTE / FORNECEDOR / CLIENTE-FORNECEDOR / OUTROS
    final SpsHttpQuestionarioMidia objSpsHttpQuestionarioMidia = SpsHttpQuestionarioMidia();
    final SpsDaoQuestionarioMidia objSpsDaoQuestionarioMidia = SpsDaoQuestionarioMidia();
    final spsUpDown objspsUpDown = spsUpDown();

    debugPrint("=== DOWNLOAD - SINCRONIZAÇÃO DE Anexos (Tabela: sps_checklist_tb_resp_anexo) =============================================");

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
    final List<Map<String, dynamic>> dadosQuestionario = await objQuestionarioHttp
        .httplistarQuestionario(
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
      await Future.forEach(dadosQuestionario, (questionario) async {
        dadosArquivo = {
          'codigo_empresa': questionario["codigo_empresa"],
          'codigo_programacao': questionario["codigo_programacao"]
              .toString(),
          'registro_colaborador': questionario["registro_colaborador"],
          'identificacao_utilizador': questionario['identificacao_utilizador']
              .toString(),
        };
        final List<Map<String,
            dynamic>> dadosDeAnexosServidor = await objSpsHttpQuestionarioMidia
            .listarMidiaAll(dadosArquivo: dadosArquivo);
        //print('Sincronizar o arquivo do servidor====>' +dadosDeAnexosServidor.toString());
        final int criarTabelaLocal = await objSpsDaoQuestionarioMidia.create_table();
        final int limparTabeLaLOCAL = await objSpsDaoQuestionarioMidia.emptyTable(questionario["codigo_programacao"].toString());
        final int ResultadoSave = await objSpsDaoQuestionarioMidia.save(dadosDeAnexosServidor);
        if (ResultadoSave == 1) {
          //print('Dados de Anexos de midia sincronizados com sucesso - Server to Local!');
          var indexMidia = 0;
          var registrosMidia = dadosDeAnexosServidor.length;
          await Future.forEach(dadosDeAnexosServidor, (AnexoServidor) async {
            String path = usuarioAtual.document_root_folder + '/' +AnexoServidor["nome_arquivo"].toString();
            //print('Verificar==> ' +AnexoServidor["nome_arquivo"].toString());
            bool status = await File(path).exists();
            if (status == false) {
                if(jaNotificado == 0){
                  await spsNotificacao.notificarInicioProgressoIndeterminado(0, 'SPS - Schuler Production System','Sincronização de Dados', flip);
                  jaNotificado = 1;
                }
//              print('Arquivo da web ===>'+AnexoServidor["nome_arquivo"].toString());
              if(AnexoServidor["nome_arquivo"].toString() != null && AnexoServidor["nome_arquivo"].toString() != "null"){
                String ArquivoParaDownload = 'https://10.17.20.45/CHECKLIST/ANEXOS/' + AnexoServidor["codigo_programacao"].toString() + '_' + '_' + AnexoServidor["identificacao_utilizador"].toString() + '_' + AnexoServidor["item_checklist"].toString() +'/' + AnexoServidor["nome_arquivo"].toString();
                String destinoLocal = usuarioAtual.document_root_folder.toString() + '/' + AnexoServidor["nome_arquivo"].toString();
                print('baixar ==> ' + ArquivoParaDownload.toString() + ' Para ' +destinoLocal.toString());
                await objspsUpDown.downloadQuestionarioMidia(ArquivoParaDownload, destinoLocal).then((String statusDownload) async{
                  if (statusDownload == '1') {
                    print('Download efetuado ==> ' + ArquivoParaDownload.toString() + ' Para ' +destinoLocal.toString());
                    //print('Download de Anexos de midia efetuado com sucesso - Server to Local!==>' +ArquivoParaDownload.toString());
                    File arquivoLocal = new File(destinoLocal);
                    String tipoArquivo = arquivoLocal.path
                        .split('.')
                        .last;
                    if (tipoArquivo == 'mp4' || tipoArquivo == 'MP4') {
                      //Processamento do arquivo capturado - Gerar thumbnail.
                      List _listaArquivos = new List();
                      _listaArquivos.add(destinoLocal);
                      spsMidiaUtils.criarVideoThumb(fileList: _listaArquivos).then((value) => null);
                      //print('Thumbnail de Download de Anexos de video efetuado com sucesso - Server to Local!==>' +ArquivoParaDownload.toString());
                    }
                  } else {
                    if(statusDownload == '404'){
                      var dadosApagarArquivoComErro = null;
                      dadosApagarArquivoComErro = {
                        'codigo_empresa': AnexoServidor["codigo_empresa"],
                        'codigo_programacao': AnexoServidor["codigo_programacao"].toString(),
                        'registro_colaborador': AnexoServidor["registro_colaborador"],
                        'identificacao_utilizador': AnexoServidor['identificacao_utilizador'].toString(),
                        'item_checklist': AnexoServidor['item_checklist'].toString(),
                        'item_anexo': AnexoServidor['item_anexo'].toString(),
                        'nome_arquivo': AnexoServidor['nome_arquivo'].toString(),
                        'titulo_arquivo': AnexoServidor["titulo_arquivo"].toString(),
                        'usuresponsavel': AnexoServidor['usuresponsavel'].toString(),
                        'dthratualizacao': AnexoServidor['dthratualizacao'].toString(),
                        'dthranexo': AnexoServidor['dthranexo'].toString(),
                        'sincronizado': 'D',
                      };
                      var retorno1Midia = await objSpsHttpQuestionarioMidia.atualizarQuestionarioMidia(dadosArquivo: dadosApagarArquivoComErro);
                      print('ERRO ao processar download de Anexos de midia - Server to Local! ' +ArquivoParaDownload.toString());
                    }
                  }
                });
              }else{
                print('ERRO ao processar download de Anexos de midia - Server to Local! ARQUVIVO CORROMPIDO NA WEB');
              }
            }else{
              print('Não foi necessário baixar o arquivo pois ja existe no dispositivo ==> ' +AnexoServidor["nome_arquivo"].toString());
            };
            indexMidia = indexMidia + 1;
          });
//          while (indexMidia < registrosMidia) {
//
//          }
        } else {
          print('ERRO ao processar dados de Anexos de midia - Server to Local! ' +ResultadoSave.toString());
        }
        indexQuestionario = indexQuestionario + 1;
      });
//      while (indexQuestionario < registrosQuestionario) {
//
//      }
      debugPrint("=== DOWNLOAD - FIM SINCRONIZAÇÃO DE Anexos (Tabela: sps_checklist_tb_resp_anexo) =============================================");
    }
    if(jaNotificado == 0){
      return 0;
    }else{
      return 1;
    }

  }


    //Função que atualiza os dados de questionários(cabeçalho) do Server(Rest API) para o Local(Sqlite)
    Future sincronizarQuestionariosServerToLocal(origem_usuario,
        String doc_action,
        String registro_colaborador,
        String identificacao_utilizador,
        String tipo_frequencia,
        String tipo_checklist,
        String registro_aprovador) async {

      debugPrint("=== INICIO SINCRONIZAÇÃO DE DADOS (Tabela: checklist_lista) ============================================");
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
        final List<
            Map<String, dynamic>> dadosQuestionario = await objQuestionarioHttp
            .httplistarQuestionario(
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
          final int resultsave = await objQuestionarioDao.save(dadosQuestionario,doc_action);
        }
        debugPrint("=== FIM SINCRONIZAÇÃO DE DADOS (Tabela: checklist_lista) ============================================");
      }
    }

    //Função que atualiza os dados de itens de questionario do Server(Rest API) para o Local(Sqlite)
    Future<SpsDaoQuestionarioItem> sincronizarQuestionariosItensServerToLocal(
        acao, sessao_checklist, codigo_empresa, codigo_programacao,
        String registro_colaborador, String identificacao_utilizador,
        codigo_grupo, codigo_checklist, h_codigo_empresa,
        h_codigo_programacao) async {
      //Criar tabela "checklist_item" caso não exista
      final SpsDaoQuestionarioItem objQuestionarioItemDao = SpsDaoQuestionarioItem();
      final int resulcreate = await objQuestionarioItemDao.create_table();

      //Criar tabela "sps_checklist_tb_resp_anexo" caso não exista
      final SpsDaoQuestionarioMidia objSpsDaoQuestionarioMidia = SpsDaoQuestionarioMidia();
      final int resulcreateMidia = await objSpsDaoQuestionarioMidia.create_table();

      //Verificar se existe conexão
      final SpsVerificarConexao ObjVerificarConexao = SpsVerificarConexao();
      final bool result = await ObjVerificarConexao.verificar_conexao();
      if (result == true) {
        //Ler registros do PostgreSQL (via API REST) / Deletar dados do SQlite / Gravar dados no SQlite
        //debugPrint("Ler registros do PostgreSQL (via API REST) - Itens / Deletar dados do SQlite / Gravar dados no SQlite");
        final SpsHttpQuestionarioItem objQuestionarioItemHttp = SpsHttpQuestionarioItem();
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
          final int resullimpar = await objQuestionarioItemDao.emptyTable(
              h_codigo_empresa, h_codigo_programacao);
          final int resultsave = await objQuestionarioItemDao.save(
              dadosQuestionarioItem);
        }

      }
      return objQuestionarioItemDao;
    }
  }
