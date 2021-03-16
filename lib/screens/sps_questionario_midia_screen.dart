import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sps/components/centered_message.dart';
import 'package:sps/components/progress.dart';
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

  final Directory _photoDir = new Directory(
      '/storage/emulated/0/Android/data/com.example.sps/files/Pictures');
  final Directory _videoDir = new Directory(
      '/storage/emulated/0/Android/data/com.example.sps/files/Pictures/thumbs');

  final SpsLogin spslogin = SpsLogin();
  GlobalKey<ScaffoldState> _key = GlobalKey();

  //FIM - Declaração de variáveis da classe _sps_questionario_midia_screen

  //Métodos da classe _sps_questionario_midia_screen

  void _onImageButtonPressed(ImageSource source, {BuildContext context}) async {
    if (_controller != null) {
      await _controller.setVolume(0.0);
    }
    if (isVideo) {
      _picker
          .getVideo(source: source, maxDuration: const Duration(seconds: 60))
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
          heroTag: 'image1',
          tooltip: 'Tirar uma foto',
          child: const Icon(Icons.camera_alt),
        );
        break;
      case 1: // Vídeos
        return FloatingActionButton(
          backgroundColor: Colors.red,
          onPressed: () {
            isVideo = true;
            _onImageButtonPressed(ImageSource.camera);
          },
          heroTag: 'video1',
          tooltip: 'Gravar um víceo',
          child: const Icon(Icons.videocam),
        );
        break;
      case 2: // audios
        return FloatingActionButton(
          onPressed: null,
          heroTag: 'audio1',
          tooltip: 'Gravar um audio',
          child: const Icon(Icons.mic),
        );
        break;
      case 3: // anexos
        return null;
        break;
    }
  }

  //FIM - Métodos da classe _sps_questionario_midia_screen

  //Widget Build da classe  _sps_questionario_midia_screen
  @override
  Widget build(BuildContext context) {
    //limpar cache de imagem
    print('Acao====>'+this.widget._acao.toString());
    imageCache.clear();
    new Directory('/storage/emulated/0/Android/data/com.example.sps/files/Pictures/thumbs').create();
    SpsDaoQuestionarioMidia objQuestionarioCqMidiaDao = SpsDaoQuestionarioMidia();
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
                      directory: _photoDir,
                      extensao: ".jpg",
                      tipo: "image",
                      codigo_empresa: this.widget._codigo_empresa,
                      codigo_programacao: this.widget._codigo_programacao,
                      item_checklist: this.widget._item_checklist),
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
                      directory: _videoDir,
                      extensao: ".jpg",
                      tipo: "video",
                      codigo_empresa: this.widget._codigo_empresa,
                      codigo_programacao: this.widget._codigo_programacao,
                      item_checklist: this.widget._item_checklist),
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
                              'Falha de conexão! \n\n(' + werror + ')',
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
                                              trailing: Icon(Icons.description, color: Colors.green, size: 40),
                                              title: Text(snapshot.data[index]["titulo_arquivo"] != "" ? '${snapshot.data[index]["titulo_arquivo"]}' +
                                                  " - " +
                                                  '${snapshot.data[index]["nome_arquivo"].toString().split('.').last}' : snapshot.data[index]["nome_arquivo"],
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.normal,
                                                      fontSize: 15)),
                                              subtitle: Text(""),
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
                                'NÃO FOI ENCONTRADO NENHUM REGISTRO!',
                                icon: Icons.warning,
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
                      return Text('Unkown error.');
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
          floatingActionButton: _bottomButtons(controller.index),
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
