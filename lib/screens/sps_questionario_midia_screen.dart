import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sps/components/centered_message.dart';
import 'package:sps/components/progress.dart';
import 'package:sps/dao/sps_dao_questionario_class.dart';
import 'package:sps/dao/sps_dao_questionario_midia_class.dart';
import 'package:sps/http/sps_http_verificar_conexao_class.dart';
import 'package:sps/models/sps_erro_conexao_class.dart';
import 'package:sps/models/sps_imageGrid.dart';
import 'package:sps/models/sps_midia_utils.dart';
import 'package:sps/models/sps_login.dart';
import 'package:sps/models/sps_questionario_utils.dart';
import 'package:sps/models/sps_usuario_class.dart';
import 'package:sps/screens/sps_drawer_screen.dart';
import 'package:video_player/video_player.dart';
import 'package:sps/models/sps_questionario_midia.dart';
import 'package:flutter/painting.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:sps/http/sps_http_questionario_midia_class.dart';
import 'package:badges/badges.dart';
import 'package:sps/screens/sps_pdf_viewer_screen.dart';
import 'package:sps/models/sps_notificacao.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class sps_questionario_midia_screen extends StatefulWidget {
  final Function({int index_posicao_retorno, String acao}) funCallback;
  final String _codigo_empresa;
  final int _codigo_programacao;
  final int _item_checklist;
  String _descr_comentarios;
  final String _registro_colaborador;
  final String _identificacao_utilizador;
  final String _codigo_grupo;
  final int _codigo_checklist;
  final String _descr_programacao;
  final String _codigo_pedido;
  final String _item_pedido;
  final String _codigo_material;
  final String _referencia_parceiro;
  final String _nome_fornecedor;
  final int _qtde_pedido;
  final String _codigo_projeto;
  final String _sincronizado;
  final String _status_aprovacao;
  final String _origemUsuario;
  final String _filtro;
  final int    _indexLista;
  final String _filtroReferenciaProjeto;
  final String _qtImagens;
  final String _qtVideos;
  final String _qtOutros;
  String _acao;

  sps_questionario_midia_screen(
      this._codigo_empresa,
      this._codigo_programacao,
      this._item_checklist,
      this._descr_comentarios,
      this._registro_colaborador,
      this._identificacao_utilizador,
      this._codigo_grupo,
      this._codigo_checklist,
      this._descr_programacao,
      this._codigo_pedido,
      this._item_pedido,
      this._codigo_material,
      this._referencia_parceiro,
      this._nome_fornecedor,
      this._qtde_pedido,
      this._codigo_projeto,
      this._sincronizado,
      this._status_aprovacao,
      this._origemUsuario,
      this._filtro,
      this._indexLista,
      this._filtroReferenciaProjeto,
      this._qtImagens,
      this._qtVideos,
      this._qtOutros,
      this._acao,
      {this.funCallback});

  @override
  _sps_questionario_midia_screen createState() =>
      _sps_questionario_midia_screen(
          this._codigo_empresa,
          this._codigo_programacao,
          this._item_checklist,
          this._descr_comentarios,
          this._registro_colaborador,
          this._identificacao_utilizador,
          this._codigo_grupo,
          this._codigo_checklist,
          this._descr_programacao,
          this._codigo_pedido,
          this._item_pedido,
          this._codigo_material,
          this._referencia_parceiro,
          this._nome_fornecedor,
          this._qtde_pedido,
          this._codigo_projeto,
          this._sincronizado,
          this._status_aprovacao,
          this._origemUsuario,
          this._filtro,
          this._indexLista,
          this._filtroReferenciaProjeto,
          this._qtImagens,
          this._qtVideos,
          this._qtOutros,
          this._acao,
          {this.funCallback}
      );
}

//Declaração da classe _sps_questionario_midia_screen
class _sps_questionario_midia_screen
    extends State<sps_questionario_midia_screen>
    with TickerProviderStateMixin {
  //Declaração de variáveis da classe _sps_questionario_midia_screen
  final SpsQuestionarioMidia spsquestionariocqmidia =
      SpsQuestionarioMidia();

  _sps_questionario_midia_screen(
      _codigo_empresa,
      _codigo_programacao,
      _item_checklist,
      _descr_comentarios,
      _registro_colaborador,
      _identificacao_utilizador,
      _codigo_grupo,
      _codigo_checklist,
      _descr_programacao,
      _codigo_pedido,
      _item_pedido,
      _codigo_material,
      _referencia_parceiro,
      _nome_fornecedor,
      _qtde_pedido,
      _codigo_projeto,
      _sincronizado,
      _status_aprovacao,
      _origemUsuario,
      _filtro,
      _indexLista,
      _filtroReferenciaProjeto,
      _qtImagens,
      _qtVideos,
      _qtOutros,
      _acao,
      funCallback,
      );

  // manage state of modal progress HUD widget
  bool _isLoading = false;

  PickedFile _imageFile;
  dynamic _pickImageError;
  bool isVideo = false;
  VideoPlayerController _controller;
  VideoPlayerController _toBeDisposed;
  String _retrieveDataError;

  final ImagePicker _picker = ImagePicker();
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();

  TabController controller;

  final Directory _photoDir = new Directory(usuarioAtual.document_root_folder.toString());
  final Directory _videoDir = new Directory(usuarioAtual.document_root_folder.toString() + '/thumbs');

  final SpsLogin spslogin = SpsLogin();
  GlobalKey<ScaffoldState> _key = GlobalKey();

  bool downloading = false;
  double progress = 0;
  bool isDownloaded = false;

  FlutterLocalNotificationsPlugin flip = spsNotificacao.iniciarNotificacaoGrupo();

  //FIM - Declaração de variáveis da classe _sps_questionario_midia_screen

  //Métodos da classe _sps_questionario_midia_screen

  void _onImageButtonPressed(ImageSource source, {BuildContext context}) async {
    if (_controller != null) {
      await _controller.setVolume(0.0);
    }
    if (isVideo) {
      _picker
          .getVideo(source: source, maxDuration: const Duration(seconds: 30))
          .then((final PickedFile file) async {
        setState(() {
          _isLoading = true;
        });

        DateTime now = DateTime.now();
        DateTime _currentTime = new DateTime(now.year, now.month, now.day, now.hour, now.minute, now.second);
        //Arquivo de video capturado
        //Montagem do arquivo de dados para processamento do arquivo.
        Map<String, dynamic> _dadosArquivo = new Map<String, dynamic>();
        _dadosArquivo['codigo_empresa'] = this.widget._codigo_empresa;
        _dadosArquivo['codigo_programacao'] = this.widget._codigo_programacao;
        _dadosArquivo['item_checklist'] = this.widget._item_checklist;
        _dadosArquivo['arquivo'] = file.path.toString();
        if (usuarioAtual.tipo == "INTERNO") {
          _dadosArquivo['registro_colaborador'] = this.widget._registro_colaborador;
          _dadosArquivo['identificacao_utilizador'] = '';
        } else {
          _dadosArquivo['registro_colaborador'] = '';
          _dadosArquivo['identificacao_utilizador'] = this.widget._identificacao_utilizador;
        }
        _dadosArquivo['usuresponsavel'] = usuarioAtual.codigo_usuario;
        _dadosArquivo['dthratualizacao'] = _currentTime.toString();
        _dadosArquivo['dthranexo'] = _currentTime.toString();

        //Processamento do arquivo capturado - Renomear - mover.
        final String arquivoMovido = await spsMidiaUtils.processarArquivoCapturado(tipo: ".mp4", dadosArquivo: _dadosArquivo);
        _dadosArquivo['nome_arquivo'] = arquivoMovido.split('/').last;

        List _listaArquivos = new List();
        _listaArquivos.add(arquivoMovido);

        //Processamento do arquivo capturado - Gerar thumbnail.
        await spsMidiaUtils.criarVideoThumb(fileList: _listaArquivos);

//        //Verificar se existe conexão
//        final SpsVerificarConexao ObjVerificarConexao = SpsVerificarConexao();
//        final bool result = await ObjVerificarConexao.verificar_conexao();
//        if (result == true) {
//          //Gravação do registro na tabela de anexos Online
//          SpsHttpQuestionarioMidia objSpsHttpQuestionarioMidia = new SpsHttpQuestionarioMidia();
//          _dadosArquivo['item_anexo'] = await objSpsHttpQuestionarioMidia.InserirQuestionarioMidia(dadosArquivo: _dadosArquivo);
//
//          _dadosArquivo['sincronizado'] = 'M';
//          SpsDaoQuestionarioMidia objQuestionarioCqMidiaDao = SpsDaoQuestionarioMidia();
//          //Gravação do registro na tabela de anexos do SQLITE
//          final int registroGravado =  await objQuestionarioCqMidiaDao.InserirQuestionarioMidia(dadosArquivo: _dadosArquivo);
//
//        }else{
          _dadosArquivo['sincronizado'] = 'T';
          SpsDaoQuestionarioMidia objQuestionarioCqMidiaDao = SpsDaoQuestionarioMidia();
          //Gravação do registro na tabela de anexos do SQLITE
          final int registroGravado =  await objQuestionarioCqMidiaDao.InserirQuestionarioMidia(dadosArquivo: _dadosArquivo);
//        }
        //Atualizar Status das respostas
        spsQuestionarioUtils objspsQuestionarioUtils = new spsQuestionarioUtils();
        final statusrespostas =  await objspsQuestionarioUtils.atualizar_status_resposta(
            _dadosArquivo['codigo_empresa'],
            _dadosArquivo['codigo_programacao'],
            _dadosArquivo['registro_colaborador'],
            _dadosArquivo['identificacao_utilizador'],
            _dadosArquivo['item_checklist']
        );
        //Analisar e Atualizar Status da Lista (cabecalho) em função do status da resposta
        final SpsDaoQuestionario objQuestionarioDao = SpsDaoQuestionario();
        final int resultupdateLista = await objQuestionarioDao.update_lista_status_resposta(
            _dadosArquivo['codigo_empresa'],
            _dadosArquivo['codigo_programacao'],
            _dadosArquivo['registro_colaborador'],
            _dadosArquivo['identificacao_utilizador']);
        setState(() {
          _isLoading = false;
        });
      });
    } else {
//      final pickedFile = await _picker.getImage(
//        source: source,
//        maxWidth: null,
//        maxHeight: null,
//        imageQuality: null,
//      );
      _picker.getImage(
        source: source,
        maxWidth: null,
        maxHeight: null,
        imageQuality: null,
      ).then((pickedFile) async {
        if(pickedFile != null){
          setState(() {
            _isLoading = true;
          });
          spsMidiaUtils objspsMidiaUtils = spsMidiaUtils();
          File arquivoNormalizado = await objspsMidiaUtils.normalizarArquivo(pickedFile.path.toString());

          DateTime now = DateTime.now();
          DateTime _currentTime = new DateTime(now.year, now.month, now.day, now.hour, now.minute, now.second);
          //Arquivo de imagem capturado
          //Montagem do arquivo de dados para processamento do arquivo.
          Map<String, dynamic> _dadosArquivo = new Map<String, dynamic>();
          _dadosArquivo['codigo_empresa'] = this.widget._codigo_empresa;
          _dadosArquivo['codigo_programacao'] = this.widget._codigo_programacao;
          _dadosArquivo['item_checklist'] = this.widget._item_checklist;
          _dadosArquivo['arquivo'] = arquivoNormalizado.path.toString();
          if (usuarioAtual.tipo == "INTERNO") {
            _dadosArquivo['registro_colaborador'] = this.widget._registro_colaborador;
            _dadosArquivo['identificacao_utilizador'] = '';
          } else {
            _dadosArquivo['registro_colaborador'] = '';
            _dadosArquivo['identificacao_utilizador'] = this.widget._identificacao_utilizador;
          }
          _dadosArquivo['usuresponsavel'] = usuarioAtual.codigo_usuario;
          _dadosArquivo['dthratualizacao'] = _currentTime.toString();
          _dadosArquivo['dthranexo'] = _currentTime.toString();

          //Processamento do arquivo capturado - Renomear - mover.
          final String arquivoMovido = await spsMidiaUtils.processarArquivoCapturado(tipo: ".jpg", dadosArquivo: _dadosArquivo);
          _dadosArquivo['nome_arquivo'] = arquivoMovido.split('/').last;

          List _listaArquivos = new List();
          _listaArquivos.add(arquivoMovido);

//        //Verificar se existe conexão
//        final SpsVerificarConexao ObjVerificarConexao = SpsVerificarConexao();
//        final bool result = await ObjVerificarConexao.verificar_conexao();
//        if (result == true) {
//
//          //Gravação do registro na tabela de anexos Online
//          SpsHttpQuestionarioMidia objSpsHttpQuestionarioMidia = new SpsHttpQuestionarioMidia();
//          _dadosArquivo['item_anexo'] = await objSpsHttpQuestionarioMidia.InserirQuestionarioMidia(dadosArquivo: _dadosArquivo);
//
//          _dadosArquivo['sincronizado'] = 'M';
//          //Gravação do registro na tabela de anexos do SQLITE
//          SpsDaoQuestionarioMidia objQuestionarioCqMidiaDao = SpsDaoQuestionarioMidia();
//          final int arquivoGravadoSQLite = await objQuestionarioCqMidiaDao.InserirQuestionarioMidia(dadosArquivo: _dadosArquivo);
//          //print('gravei anexo Online');
//        }else{
          _dadosArquivo['sincronizado'] = 'T';
          //Gravação do registro na tabela de anexos do SQLITE
          SpsDaoQuestionarioMidia objQuestionarioCqMidiaDao = SpsDaoQuestionarioMidia();
          final int arquivoGravadoSQLite = await objQuestionarioCqMidiaDao.InserirQuestionarioMidia(dadosArquivo: _dadosArquivo);
          //print('gravei anexo offline');
//        }
          //Atualizar Status das respostas
          spsQuestionarioUtils objspsQuestionarioUtils = new spsQuestionarioUtils();
          final statusrespostas =  await objspsQuestionarioUtils.atualizar_status_resposta(
              _dadosArquivo['codigo_empresa'],
              _dadosArquivo['codigo_programacao'],
              _dadosArquivo['registro_colaborador'],
              _dadosArquivo['identificacao_utilizador'],
              _dadosArquivo['item_checklist']
          );
          //Analisar e Atualizar Status da Lista (cabecalho) em função do status da resposta
          final SpsDaoQuestionario objQuestionarioDao = SpsDaoQuestionario();
          final int resultupdateLista = await objQuestionarioDao.update_lista_status_resposta(
              _dadosArquivo['codigo_empresa'],
              _dadosArquivo['codigo_programacao'],
              _dadosArquivo['registro_colaborador'],
              _dadosArquivo['identificacao_utilizador']);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    controller = new TabController(vsync: this, length: 3);
    controller.addListener(updateIndex);
  }

  void updateIndex() {
    setState(() {});
  }

  @override
  void deactivate() {
    if (_controller != null) {
      _controller.setVolume(0.0);
      _controller.pause();
    }
    super.deactivate();
  }

  @override
  void dispose() {
    _disposeVideoController();
    maxWidthController.dispose();
    maxHeightController.dispose();
    qualityController.dispose();
    controller.dispose();
    super.dispose();
  }

  Future<void> _disposeVideoController() async {
    if (_toBeDisposed != null) {
      await _toBeDisposed.dispose();
    }
    _toBeDisposed = _controller;
    _controller = null;
  }

  Widget _previewVideo() {
    final Text retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_controller == null) {
      return const Text(
        'Nenhum vídeo disponível.',
        textAlign: TextAlign.center,
      );
    }
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: AspectRatioVideo(_controller),
    );
  }

  Widget _previewImage() {
    final Text retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFile != null) {
      if (kIsWeb) {
        // Why network?
        // See https://pub.dev/packages/image_picker#getting-ready-for-the-web-platform
        return Image.network(_imageFile.path);
      } else {
        //debugPrint(_imageFile.path.toString());
        return Semantics(
            child: Image.file(File(_imageFile.path)),
            label: 'image_picker_example_picked_image');
      }
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'Nenhuma imagem disponível.',
        textAlign: TextAlign.center,
      );
    }
  }

  Text _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Widget _bottomButtons(int index) {
    switch (index) {
      case 0: // Fotos
        return FloatingActionButton(
                onPressed: () {
                  isVideo = false;
                  _onImageButtonPressed(ImageSource.camera, context: context);
                },
                heroTag: 'image',
                tooltip: 'Tirar uma foto',
                child: const Icon(Icons.camera_alt),
              );
        break;
      case 1: // Vídeos
        return FloatingActionButton(
          onPressed: () {
            isVideo = true;
            _onImageButtonPressed(ImageSource.camera);
          },
          heroTag: 'video',
          tooltip: 'Gravar um víceo',
          child: const Icon(Icons.videocam),
        );
        break;
      case 2: // anexos
        return FloatingActionButton(
          onPressed: () {
          },
          heroTag: 'video',
          tooltip: 'Anexar um arquivo',
          child: const Icon(Icons.attach_file),
        );
        break;
      case 3: // anexos
        return null;
        break;
    }
  }

  Future<void> downloadFile(uri, fileName) async {

    Random random = new Random();
    int id_notificacao = random.nextInt(1000);

    await spsNotificacao.notificarProgresso(id_notificacao, 100, 0, 'SPS - Supplier Portal','Baixando arquivo 0%', flip);

    String savePath = usuarioAtual.document_root_folder.toString() + '/' + fileName;

    Dio dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    dio.download(
      uri,
      savePath,
      onReceiveProgress: (rcv, total) {
//        setState(() {
          progress = (rcv / total);
//        });
//        print('received: ${rcv.toStringAsFixed(0)} out of total: ${total.toStringAsFixed(0)} %'+(progress * 100).round().toString());
        print('id not: '+id_notificacao.toString());
        spsNotificacao.notificarProgresso(id_notificacao, 100, (progress * 100).round(), 'SPS - Supplier Portal','Baixando arquivo '+(progress * 100).round().toString()+'%', flip);
//        if (progress == 1) {
//          setState(() {
//            isDownloaded = true;
//          });
//        } else if (progress < 1) {}
      },
      deleteOnError: true,
    ).then((_) {
      print('Download efetuado ==> ' + uri.toString() + ' Para ' +savePath.toString());
      //print('Download de Anexos de midia efetuado com sucesso - Server to Local!==>' +ArquivoParaDownload.toString());
      File arquivoLocal = new File(savePath);
      String tipoArquivo = arquivoLocal.path
          .split('.')
          .last;
      if (tipoArquivo == 'mp4' || tipoArquivo == 'MP4' || tipoArquivo == 'mov' || tipoArquivo == 'MOV') {
        //Processamento do arquivo capturado - Gerar thumbnail.
        List _listaArquivos = new List();
        _listaArquivos.add(savePath);
        print('Converter Vídeo: '+_listaArquivos.toString());
        spsMidiaUtils.criarVideoThumb(fileList: _listaArquivos).then((value){
          print('Thumbnail de Download de Anexos de video efetuado com sucesso - Server to Local!==>' +savePath.toString());
        });
      }
      spsNotificacao.cancelarNotificacao(id_notificacao, flip);
      setState(() {
//        if (progress == 1) {
//          isDownloaded = true;
//        }
//        downloading = false;
      });
    });
  }

  Future<void> downloadList(List<Map<String, dynamic>> listaArquivos) async {
    setState(() {
      downloading = true;
    });
    double progress = 0;

    Random random = new Random();
    int id_notificacao = random.nextInt(1000);

    await spsNotificacao.notificarProgresso(id_notificacao, 100, 0, 'SPS - Supplier Portal','Baixando arquivos 0%', flip);

    double passo = 1 / listaArquivos.length / 2;
    print('passo: '+passo.toString());

    await Future.forEach(listaArquivos, (arquivo) async {
      double progress_individual = 0;
      double limit = 0.5;
      String uri = 'https://10.17.20.45/CHECKLIST/ANEXOS/' + arquivo['codigo_programacao'].toString() + '_' + arquivo['registro_colaborador'].toString()+ '_' + arquivo['identificacao_utilizador'].toString() + '_' + arquivo['item_checklist'].toString() +'/' + arquivo['nome_arquivo'].toString();
      String savePath = usuarioAtual.document_root_folder.toString() + '/' + arquivo['nome_arquivo'].toString();
      Dio dio = Dio();
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };
      await dio.download(
        uri,
        savePath,
        onReceiveProgress: (rcv, total) {
          progress_individual = (rcv / total);
          progress_individual = double.parse(progress_individual.toStringAsFixed(1));
          print('Progresso individual: '+progress_individual.toString());
          //        print('received: ${rcv.toStringAsFixed(0)} out of total: ${total.toStringAsFixed(0)} %'+(progress_individual * 100).round().toString());
          if (progress_individual >= limit && progress < 1.0) {
            limit = limit + 0.5;
            print('aumentei o limite: ' + limit.toString());
              if(progress < 1.0){
                progress = progress + double.parse(passo.toStringAsFixed(1));
                spsNotificacao.notificarProgresso(id_notificacao, 100, (progress * 100).round(), 'SPS - Supplier Portal','Baixando arquivos '+(progress * 100).round().toString()+'%', flip);
                print('aumentei o progress: ' + progress.toString());
              }else{
                progress = 1.0;
              }
          }
//          print('Progresso: '+progress.toString());
        },
        deleteOnError: true,
      );
      print('Download de Anexos de midia efetuado com sucesso - Server to Local!==>' +arquivo['nome_arquivo'].toString());
      File arquivoLocal = new File(savePath);
      String tipoArquivo = arquivoLocal.path
          .split('.')
          .last;
      if (tipoArquivo == 'mp4' || tipoArquivo == 'MP4' || tipoArquivo == 'mov' || tipoArquivo == 'MOV') {
        //Processamento do arquivo capturado - Gerar thumbnail.
        List _listaArquivos = new List();
        _listaArquivos.add(savePath);
        print('Converter Vídeo: '+_listaArquivos.toString());
        spsMidiaUtils.criarVideoThumb(fileList: _listaArquivos).then((value){
          print('Thumbnail de Download de Anexos de video efetuado com sucesso - Server to Local!==>' +savePath.toString());
        });
      }
      if (progress >= 0.9) {
        spsNotificacao.cancelarNotificacao(id_notificacao, flip);
        setState(() {
          downloading = false;
        });
      }else{
        setState(() {
        });
      }
    });
  }

  //FIM - Métodos da classe _sps_questionario_midia_screen

  //Widget Build da classe  _sps_questionario_midia_screen
  @override
  Widget build(BuildContext context) {
    //limpar cache de imagem
    //print('Acao====>'+this.widget._acao.toString());
    imageCache.clear();
    new Directory(usuarioAtual.document_root_folder.toString() + '/thumbs').create();
    SpsDaoQuestionarioMidia objQuestionarioCqMidiaDao = SpsDaoQuestionarioMidia();
    final objSpsQuestionarioCqMidia = SpsQuestionarioMidia();
    return DefaultTabController(
        length: 3,
        child: new Scaffold(
          backgroundColor: Color(0xFFe9eef7),
          // Cinza Azulado
          appBar: AppBar(
            backgroundColor: Color(0xFF004077),
            title: Text(
              'QUESTIONÁRIO - MÍDIA',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
              leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                      widget.funCallback(index_posicao_retorno: this.widget._indexLista, acao: this.widget._acao);
                    },
                  );
                },
              ),
            bottom: TabBar(controller: controller, tabs: [
              Tab(
                icon: Badge(
                  badgeContent: Text(this.widget._qtImagens == '0' ? '' : this.widget._qtImagens, style: TextStyle(color: Colors.white, fontSize: 10)),
                  showBadge: true,
                  badgeColor: Color(0xFF004077),
                  child: Icon(Icons.collections ),
                ),
              ),
              Tab(
                icon: Badge(
                  badgeContent: Text(this.widget._qtVideos == '0' ? '' : this.widget._qtVideos, style: TextStyle(color: Colors.white, fontSize: 10)),
                  showBadge: true,
                  badgeColor: Color(0xFF004077),
                  child: Icon(Icons.video_library),
                ),
              ),
              Tab(
                icon: Badge(
                  badgeContent: Text(this.widget._qtOutros == '0' ? '' : this.widget._qtOutros, style: TextStyle(color: Colors.white, fontSize: 10)),
                  showBadge: true,
                  badgeColor: Color(0xFF004077),
                  child: Icon(Icons.library_books),
                ),
              ),
            ]),
          ),
          endDrawer: sps_drawer(spslogin: spslogin),
          body: LoadingOverlay(
            child: TabBarView(controller: controller, children: [
//             any widget can work very well here <3
              //Container com a galeria de imagens
              new Container(
                child: Center(
                  child: ImageGrid(
                      funCallback: () {
                        setState(() {
                          //limpar cache de imagem
                          imageCache.clear();
                        });
                      },
                      funcDownload: ({String uri, String filename}) {
                        downloadFile(uri, filename);
                      },
                      directory: _photoDir,
                      extensao: ".jpg",
                      tipo: "image",
                      codigo_empresa: this.widget._codigo_empresa,
                      codigo_programacao: this.widget._codigo_programacao,
                      item_checklist: this.widget._item_checklist,
                      progress: progress),
                ),
              ),
              //Container com a galeria de vídeos
              new Container(
                child: Center(
                  child: ImageGrid(
                      funCallback: () {
                        setState(() {
                          //limpar cache de imagem
                          imageCache.clear();
                        });
                      },
                      funcDownload: ({String uri, String filename}) {
                        downloadFile(uri, filename);
                      },
                      directory: _videoDir,
                      extensao: ".jpg",
                      tipo: "video",
                      codigo_empresa: this.widget._codigo_empresa,
                      codigo_programacao: this.widget._codigo_programacao,
                      item_checklist: this.widget._item_checklist,
                      progress: progress),
                ),
              ),
              new Container(
                color: Color(0xFFe9eef7),
                child: Center(
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: objQuestionarioCqMidiaDao.listarArquivosOutros(this.widget._codigo_empresa,this.widget._codigo_programacao,this.widget._item_checklist),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                          break;
                        case ConnectionState.waiting:
                          return Progress();
                          break;
                        case ConnectionState.active:
                          break;
                        case ConnectionState.done:
                          if (snapshot.hasError) {
                            var werror;
                            werror = snapshot.error.toString();
                            return CenteredMessage(
                              '(Ponto 13) Falha de conexão! \n\n(' + werror + ')',
                              icon: Icons.error,
                            );
                          }
                          if (erroConexao.msg_erro_conexao.toString() == "") {
                            if (snapshot.data.isNotEmpty) {
                              return Column(children: <Widget>[
                                Expanded(
                                  child: ListView.builder(
                                    padding: EdgeInsets.only(top: 5),
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (context, index) {
                                      return Card(
                                        color: Colors.white,
                                        child: Column(
                                          children: <Widget>[
                                            //Tratar descrição da pergunta
                                            ListTile(
                                              trailing: snapshot.data[index]["nome_arquivo"].toString().split('.').last == "PDF" || snapshot.data[index]["nome_arquivo"].toString().split('.').last == "pdf" ? Icon(Icons.picture_as_pdf, color: Colors.green, size: 40) : Icon(Icons.description, color: Colors.grey, size: 40),
                                              title: Text(snapshot.data[index]["titulo_arquivo"] != "" ? '${snapshot.data[index]["titulo_arquivo"]}' +
                                                  " - " +
                                                  '${snapshot.data[index]["nome_arquivo"].toString().split('.').last}' : snapshot.data[index]["nome_arquivo"],
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.normal,
                                                      fontSize: 15)),
                                              subtitle: Text(""),
                                              onTap: () {
                                                snapshot.data[index]["nome_arquivo"].toString().split('.').last == "PDF" || snapshot.data[index]["nome_arquivo"].toString().split('.').last == "pdf" ?
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        PDFScreen(path: usuarioAtual.document_root_folder.toString() + '/' + snapshot.data[index]['nome_arquivo'].toString()),
                                                  ),
                                                ) : '';
                                              },
                                            ),
                                          ],
                                        ),

                                      );
                                    },
                                  ),
                                ),
                              ]);
                            } else {
                              return CenteredMessage(
                                'Nenhum anexo encontrado!',
                                icon: Icons.error,
                              );
                            }
                          } else {
                            return CenteredMessage(
                              erroConexao.msg_erro_conexao.toString(),
                              icon: Icons.warning,
                            );
                          }
                          break;
                      }
                      return Text('');
                    },
                  ),
                ),
              ),
            ]),
            isLoading: _isLoading,
            // demo of some additional parameters
            opacity: 0.5,
            progressIndicator: CircularProgressIndicator(),
            color: Colors.white,
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(left: 35.0),
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: objSpsQuestionarioCqMidia.listarQuestionarioMidiaFaltante(codigo_empresa: this.widget._codigo_empresa,codigo_programacao: this.widget._codigo_programacao,item_checklist: this.widget._item_checklist),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    break;
                  case ConnectionState.waiting:
                    return Progress();
                    break;
                  case ConnectionState.active:
                    break;
                  case ConnectionState.done:
                    if (snapshot.hasError) {

                    }
                    if (erroConexao.msg_erro_conexao.toString() == "") {
                      if (snapshot.data.isNotEmpty) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            downloading == false
                                ? CircleAvatar(
                              radius: 15,
                              backgroundColor: Color(0xFF004077),
                              child: IconButton(
                                icon: Icon(
                                  Icons.download_sharp,
                                  color: Colors.white,
                                  size: 15,
                                ),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                            title: Text("SPS App"),
                                            content: Text(
                                                "Deseja fazer o download de todas as mídas desse item?"),
                                            actions: [
                                              FlatButton(
                                                child: Text("Cancelar"),
                                                onPressed: () {
                                                  Navigator.of(context,
                                                      rootNavigator:
                                                      true)
                                                      .pop();
                                                },
                                              ),
                                              FlatButton(
                                                  child: Text("Sim"),
                                                  onPressed: () {
                                                    downloadList(snapshot.data);
                                                    Navigator.of(context,
                                                        rootNavigator:
                                                        true)
                                                        .pop();
                                                  }),
                                            ]);
                                      });
                                },
                              ),
                            ) : Text(''),
                            _bottomButtons(controller.index),
                          ],
                        );
                      }else{
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(''),
                            _bottomButtons(controller.index),
                          ],
                        );
                      }
                    } else {
                      return CenteredMessage(
                        erroConexao.msg_erro_conexao.toString(),
                        icon: Icons.warning,
                      );
                    }
                    break;
                }
                return Text('');
              },
            ),
          ),
        )
    );
  }
}
//FIM - Widget Build da classe  _sps_questionario_midia_screen
//FIM - Declaração da classe _sps_questionario_midia_screen

typedef void OnPickImageCallback(
    double maxWidth, double maxHeight, int quality);

// Declaração da classe AspectRatioVideo
class AspectRatioVideo extends StatefulWidget {
  AspectRatioVideo(this.controller);

  final VideoPlayerController controller;

  @override
  AspectRatioVideoState createState() => AspectRatioVideoState();
}
//FIM -  Declaração da classe AspectRatioVideo

// Declaração da classe AspectRatioVideoState
class AspectRatioVideoState extends State<AspectRatioVideo> {
  VideoPlayerController get controller => widget.controller;
  bool initialized = false;

  void _onVideoControllerUpdate() {
    if (!mounted) {
      return;
    }
    if (initialized != controller.value.initialized) {
      initialized = controller.value.initialized;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    controller.addListener(_onVideoControllerUpdate);
  }

  @override
  void dispose() {
    controller.removeListener(_onVideoControllerUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (initialized) {
      return Center(
        child: AspectRatio(
          aspectRatio: controller.value?.aspectRatio,
          child: VideoPlayer(controller),
        ),
      );
    } else {
      return Container();
    }
  }
}
// FIM - Declaração da classe AspectRatioVideoState
