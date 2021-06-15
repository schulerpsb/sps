import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sps/components/centered_message.dart';
import 'package:sps/components/media.dart';
import 'package:sps/components/progress.dart';
import 'package:sps/dao/sps_dao_questionario_midia_class.dart';
import 'package:sps/models/sps_questionario_midia.dart';
import 'package:sps/models/sps_usuario_class.dart';
import 'package:sps/screens/sps_imagePlayer_screen.dart';
import 'package:sps/screens/sps_videoPlayer_screen.dart';
import 'dart:io' as io;
import 'package:flutter/painting.dart';
import 'package:path_provider/path_provider.dart';

class ImageGrid extends StatelessWidget {
  final Directory directory;
  final String extensao;
  final String tipo;
  final String codigo_empresa;
  final int codigo_programacao;
  final int item_checklist;
  final double progress;
  final Function() funCallback;
  final Function({String uri, String filename}) funcDownload;


  const ImageGrid(
      {this.funCallback,
      this.funcDownload,
      Key key,
      this.directory,
      this.extensao,
      this.tipo,
      this.codigo_empresa,
      this.codigo_programacao,
      this.progress,
      this.item_checklist})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //var fileWithExtensionpath = List();
    String teste = "";
    var refreshGridView;
    int indicemedia;
    final objSpsQuestionarioCqMidia = SpsQuestionarioMidia();


    _popup_titulo(String titulo_arquivo, String codigo_empresa, int codigo_programacao, int item_checklist, int item_anexo) {
      TextEditingController _novotitulo = TextEditingController();
      _novotitulo.text = titulo_arquivo;
      Alert(
        context: context,
        title: "Título do arquivo.\n",
        content: TextField(
          controller: _novotitulo,
          maxLengthEnforced: true,
          maxLength: 45,
          textInputAction: TextInputAction.go,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(hintText: "Informe um título para o arquivo."),
        ),
        buttons: [
          DialogButton(
              child: Text(
                "GRAVAR",
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              onPressed: (){
                objSpsQuestionarioCqMidia.salvarTituloQuestionarioMidia(titulo_arquivo: _novotitulo.text, codigo_empresa: codigo_empresa, codigo_programacao: codigo_programacao, item_checklist: item_checklist, item_anexo: item_anexo).then((value){
                  Navigator.of(context,
                      rootNavigator:
                      true)
                      .pop();
                  funCallback();
                });
              }),
        ],
      ).show();
    }

    Future<File> getImageFileFromAssets(String path) async {
      final byteData = await rootBundle.load('assets/$path');

      final file = File('${(await getTemporaryDirectory()).path}/$path');
      await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

      return file;
    }

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: objSpsQuestionarioCqMidia.listarQuestionarioMidia(
          codigo_empresa: this.codigo_empresa,
          codigo_programacao: this.codigo_programacao,
          item_checklist: this.item_checklist),
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
              return CenteredMessage(
                '(Ponto 2) Falha de conexão!',
                icon: Icons.error,
              );
            } else {
//              print('PROCESSEI A CONSULTA');
              List _listaArquivos = new List();
              if (snapshot.data.isNotEmpty) {
                for (var i = 0; i < snapshot.data.length; i++) {
                  String _extensao = snapshot.data[i]['nome_arquivo']
                      .toString()
                      .substring(
                          snapshot.data[i]['nome_arquivo'].toString().length -
                              4);
                  if ((_extensao == '.mp4' || _extensao == '.MP4' || _extensao == '.mov' || _extensao == '.MOV') && tipo == 'video') {
//                    print(snapshot.data[i]['nome_arquivo'].toString());
                    String _nomeArquivoSemExtensao = snapshot.data[i]['nome_arquivo'].toString().substring(0, snapshot.data[i]['nome_arquivo'].toString().length - 4);
                    if (File(usuarioAtual.document_root_folder.toString() + '/' + snapshot.data[i]['nome_arquivo'].toString()).existsSync() == true) {
                      Map<String, dynamic> _registroArquivo =
                          new Map<String, dynamic>();
                      _registroArquivo['codigo_empresa'] =
                          snapshot.data[i]['codigo_empresa'].toString();
                      _registroArquivo['codigo_programacao'] =
                          snapshot.data[i]['codigo_programacao'].toString();
                      _registroArquivo['item_checklist'] =
                          snapshot.data[i]['item_checklist'].toString();
                      _registroArquivo['item_anexo'] =
                          snapshot.data[i]['item_anexo'].toString();
                      _registroArquivo['nome_arquivo'] =
                          snapshot.data[i]['nome_arquivo'].toString();
                      _registroArquivo['titulo_arquivo'] =
                          snapshot.data[i]['titulo_arquivo'].toString();
                      _registroArquivo['caminho'] = usuarioAtual.document_root_folder.toString()+ '/thumbs/' + _nomeArquivoSemExtensao + '.jpg';
                      _registroArquivo['registro_colaborador'] = snapshot.data[i]['registro_colaborador'].toString();
                      _registroArquivo['identificacao_utilizador'] = snapshot.data[i]['identificacao_utilizador'].toString();
                      _listaArquivos.add(_registroArquivo);
                    }else {
                      Map<String, dynamic> _registroArquivo =
                      new Map<String, dynamic>();
                      _registroArquivo['codigo_empresa'] =
                          snapshot.data[i]['codigo_empresa'].toString();
                      _registroArquivo['codigo_programacao'] =
                          snapshot.data[i]['codigo_programacao'].toString();
                      _registroArquivo['item_checklist'] =
                          snapshot.data[i]['item_checklist'].toString();
                      _registroArquivo['item_anexo'] =
                          snapshot.data[i]['item_anexo'].toString();
                      _registroArquivo['nome_arquivo'] =
                          snapshot.data[i]['nome_arquivo'].toString();
                      _registroArquivo['titulo_arquivo'] =
                          snapshot.data[i]['titulo_arquivo'].toString();
                      _registroArquivo['caminho'] = 'images/noimage.jpg';
                      _registroArquivo['registro_colaborador'] = snapshot.data[i]['registro_colaborador'].toString();
                      _registroArquivo['identificacao_utilizador'] = snapshot.data[i]['identificacao_utilizador'].toString();
                      _listaArquivos.add(_registroArquivo);
//                      final SpsDaoQuestionarioMidia
//                          objQuestionarioCqMidiaDao =
//                          SpsDaoQuestionarioMidia();
//                      objQuestionarioCqMidiaDao
//                          .deletarQuestionarioMidia(
//                              codigo_empresa:
//                                  snapshot.data[i]['codigo_empresa'].toString(),
//                              codigo_programacao: snapshot.data[i]
//                                  ['codigo_programacao'],
//                              item_checklist: snapshot.data[i]
//                                  ['item_checklist'],
//                              item_anexo: snapshot.data[i]['item_anexo'])
//                          .then((value) => print('Registro apagado'));
                    }
                  }
                  if ((_extensao == '.jpg' || _extensao == '.JPG' || _extensao == '.png' || _extensao == '.PNG') && tipo == 'image') {
                    String _nomeArquivoSemExtensao =
                        snapshot.data[i]['nome_arquivo'].toString();
                    // print('verifica: '+ usuarioAtual.document_root_folder.toString() + '/' + snapshot.data[i]['nome_arquivo'].toString());
                    // print('Existe: '+File(usuarioAtual.document_root_folder.toString() + '/' + snapshot.data[i]['nome_arquivo'].toString()).existsSync().toString());
                    if (File(usuarioAtual.document_root_folder.toString() + '/' +
                                snapshot.data[i]['nome_arquivo'].toString())
                            .existsSync() ==
                        true) {
                      Map<String, dynamic> _registroArquivo =
                          new Map<String, dynamic>();
                      _registroArquivo['codigo_empresa'] =
                          snapshot.data[i]['codigo_empresa'].toString();
                      _registroArquivo['codigo_programacao'] =
                          snapshot.data[i]['codigo_programacao'].toString();
                      _registroArquivo['item_checklist'] =
                          snapshot.data[i]['item_checklist'].toString();
                      _registroArquivo['item_anexo'] =
                          snapshot.data[i]['item_anexo'].toString();
                      _registroArquivo['nome_arquivo'] =
                          snapshot.data[i]['nome_arquivo'].toString();
                      _registroArquivo['titulo_arquivo'] =
                          snapshot.data[i]['titulo_arquivo'].toString();
                      _registroArquivo['caminho'] =
                          usuarioAtual.document_root_folder.toString() + '/' +
                              snapshot.data[i]['nome_arquivo'].toString();
                      _registroArquivo['registro_colaborador'] = snapshot.data[i]['registro_colaborador'].toString();
                      _registroArquivo['identificacao_utilizador'] = snapshot.data[i]['identificacao_utilizador'].toString();
                      _listaArquivos.add(_registroArquivo);
                    } else {
                      Map<String, dynamic> _registroArquivo =
                      new Map<String, dynamic>();
                      _registroArquivo['codigo_empresa'] =
                          snapshot.data[i]['codigo_empresa'].toString();
                      _registroArquivo['codigo_programacao'] =
                          snapshot.data[i]['codigo_programacao'].toString();
                      _registroArquivo['item_checklist'] =
                          snapshot.data[i]['item_checklist'].toString();
                      _registroArquivo['item_anexo'] =
                          snapshot.data[i]['item_anexo'].toString();
                      _registroArquivo['nome_arquivo'] =
                          snapshot.data[i]['nome_arquivo'].toString();
                      _registroArquivo['titulo_arquivo'] =
                          snapshot.data[i]['titulo_arquivo'].toString();
                      _registroArquivo['caminho'] = 'images/noimage.jpg';
                      _registroArquivo['registro_colaborador'] = snapshot.data[i]['registro_colaborador'].toString();
                      _registroArquivo['identificacao_utilizador'] = snapshot.data[i]['identificacao_utilizador'].toString();
                      _listaArquivos.add(_registroArquivo);
//                      final SpsDaoQuestionarioMidia
//                          objQuestionarioCqMidiaDao =
//                          SpsDaoQuestionarioMidia();
//                      objQuestionarioCqMidiaDao
//                          .deletarQuestionarioMidia(
//                              codigo_empresa:
//                                  snapshot.data[i]['codigo_empresa'].toString(),
//                              codigo_programacao: snapshot.data[i]
//                                  ['codigo_programacao'],
//                              item_checklist: snapshot.data[i]
//                                  ['item_checklist'],
//                              item_anexo: snapshot.data[i]['item_anexo'])
//                          .then((value) => print('Registro apagado'));
                    }
                  }
                }
              }
              int larguraTela = MediaQuery.of(context).size.width.toInt();
              int alturaTela = MediaQuery.of(context).size.height.toInt();
              double alturaCard;
              if(larguraTela > 320){
                if(tipo == 'image'){
                  alturaCard = 5.0;
                }else{
                  alturaCard = 5.1;
                }
              }else{
                if(tipo == 'image'){
                  alturaCard = 6.0;
                }else{
                  alturaCard = 6.1;
                }
              }
//              print('LISTA DE ARQUVIOS ' + _listaArquivos.toString());
              if (_listaArquivos.length >= 1) {
                return GridView.builder(
                    itemCount: _listaArquivos.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 3.0 / alturaCard),
                    itemBuilder: (context, index) {
                      indicemedia = index;
                      var thumbnaodisponivel;
                      thumbnaodisponivel = "";
                      if(tipo == 'video'){
                        // print('video thumb'+_listaArquivos[index]['caminho'].toString());
                        if (File(_listaArquivos[index]['caminho'].toString()).existsSync() == false) {
                          // var videoPath = _listaArquivos[index]['caminho'].replaceAll('.jpg', '.mp4');
                          // videoPath = videoPath.replaceAll('/thumbs/', '/');
                          // _listaArquivos[index]['caminho'] = videoPath;
                          thumbnaodisponivel = 'images/noimage.jpg';
                        }
                        // print('video '+_listaArquivos[index]['caminho'].toString());
                      }
                      File file = new File(_listaArquivos[index]['caminho']);
                      String name = file.path.split('/').last;
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            children: [
                              Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () => {
                                        refreshGridView = Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  tipo == 'video'
                                                      ? sps_videoPlayer_screen(
                                                          _listaArquivos[index]
                                                              ['caminho'],
                                                          tipo)
                                                      : sps_imagePlayer_screen(
                                                          _listaArquivos[index]
                                                              ['caminho'],
                                                          tipo)),
                                        ).then((refreshGridView) {
                                          if (refreshGridView != null) {
                                            build(context);
                                          }
                                        }).catchError((er) {
                                          print(er);
                                        }),
                                      },

                                      child: Padding(
                                        padding: new EdgeInsets.all(0.0),
                                        child: thumbnaodisponivel != "" ? Image.asset(thumbnaodisponivel) : _listaArquivos[index]['caminho'].substring(0, 6) == 'images' ? Image.asset(_listaArquivos[index]['caminho']) : Image.file(File(_listaArquivos[index]['caminho']),
                                          fit: BoxFit.contain,
                                          height: 156,
                                        ),
                                      ),
                                    ),
                                    _listaArquivos[index]['caminho'].substring(0, 6) != 'images' ? OpcoesEdicao(context, objSpsQuestionarioCqMidia, _listaArquivos, index, _popup_titulo, 1): OpcoesEdicao(context, objSpsQuestionarioCqMidia, _listaArquivos, index, _popup_titulo, 0),
                                  ]),
                              Align(
                                alignment: Alignment.center,
                                child: SizedBox(
                                  child: Text(
                                      _listaArquivos[index]['titulo_arquivo']
                                                  .toString()
                                                  .length <=
                                              0
                                          ? ''
                                          : _listaArquivos[index]
                                                          ['titulo_arquivo']
                                                      .toString()
                                                      .length >=
                                                  45
                                              ? _listaArquivos[index]
                                                      ['titulo_arquivo']
                                                  .toString()
                                                  .substring(0, 45)
                                              : _listaArquivos[index]
                                                      ['titulo_arquivo']
                                                  .toString()
                                                  .substring(
                                                      0,
                                                      _listaArquivos[index]
                                                              ['titulo_arquivo']
                                                          .toString()
                                                          .length),
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.black,
                                          backgroundColor: Colors.white)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              } else {
                if (tipo == 'image') {
                  return CenteredMessage(
                    'Nenhuma imagem encontrada!',
                    icon: Icons.error,
                  );
                }
                if (tipo == 'video') {
                  return CenteredMessage(
                    'Nenhum vídeo encontrado!',
                    icon: Icons.error,
                  );
                }
              }
            }
            break;
        }
        return Text('Erro desconhecido');
      },
    );

  }

  Row OpcoesEdicao(BuildContext context, SpsQuestionarioMidia objSpsQuestionarioCqMidia, List _listaArquivos, int index, _popup_titulo(String titulo_arquivo, String codigo_empresa, int codigo_programacao, int item_checklist, int item_anexo), int show) {
    if(show == 1){
      return Row(
        mainAxisAlignment:
        MainAxisAlignment.spaceEvenly,
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: CircleAvatar(
              radius: 15,
              backgroundColor: Colors.white,
              child: IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Color(0xFF004077),
                  size: 15,
                ),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            title: Text("SPS App"),
                            content: Text(
                                "Deseja realmente apagar o arquivo?"),
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
                                    objSpsQuestionarioCqMidia.deletarQuestionarioMidia(arquivo: _listaArquivos[index]['caminho'].toString(), codigo_empresa: _listaArquivos[index]['codigo_empresa'],  codigo_programacao: int.parse(_listaArquivos[index]['codigo_programacao']), item_checklist: int.parse(_listaArquivos[index]['item_checklist']) ,item_anexo: int.parse(_listaArquivos[index]['item_anexo'])).then((value){
                                      //print('Feito');
                                      Navigator.of(context,
                                          rootNavigator:
                                          true)
                                          .pop();
                                      funCallback();
                                    });
                                  }),
                            ]);
                      });
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: CircleAvatar(
              radius: 15,
              backgroundColor: Colors.white,
              child: IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Color(0xFF004077),
                  size: 15,
                ),
                onPressed: () {
                  _popup_titulo(_listaArquivos[index]['titulo_arquivo'].toString(),_listaArquivos[index]['codigo_empresa'],  int.parse(_listaArquivos[index]['codigo_programacao']), int.parse(_listaArquivos[index]['item_checklist']) ,int.parse(_listaArquivos[index]['item_anexo']));
                },
              ),
            ),
          ),
        ],
      );
    }else{
      return Row(
        mainAxisAlignment:
        MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
//              Align(
//                alignment: Alignment.bottomCenter,
//                child: CircularPercentIndicator(
//                  radius: 45.0,
//                  lineWidth: 4.0,
//                  percent: progress,
//                  center: new Text((progress * 100).toStringAsFixed(0)+'%'),
//                  progressColor: Color(0xFF004077),
//                ),
//              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: Icon(
                      Icons.download_sharp,
                      color: Color(0xFF004077),
                      size: 15,
                    ),
                    onPressed: () {
                      String ArquivoParaDownload = 'https://10.17.20.45/APPS/CHECKLIST/ANEXOS/' + _listaArquivos[index]['codigo_programacao'].toString() + '_' + _listaArquivos[index]['registro_colaborador'].toString()+ '_' + _listaArquivos[index]['identificacao_utilizador'].toString() + '_' + _listaArquivos[index]['item_checklist'].toString() +'/' + _listaArquivos[index]['nome_arquivo'].toString();
                      funcDownload(uri: ArquivoParaDownload, filename: _listaArquivos[index]['nome_arquivo'].toString());
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }
  }

}
