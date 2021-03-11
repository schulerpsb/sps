import 'dart:io';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sps/components/centered_message.dart';
import 'package:sps/components/media.dart';
import 'package:sps/components/progress.dart';
import 'package:sps/dao/sps_dao_questionario_midia_class.dart';
import 'package:sps/models/sps_questionario_midia.dart';
import 'package:sps/screens/sps_imagePlayer_screen.dart';
import 'package:sps/screens/sps_videoPlayer_screen.dart';
import 'dart:io' as io;
import 'package:flutter/painting.dart';

class ImageGrid extends StatelessWidget {
  final Directory directory;
  final String extensao;
  final String tipo;
  final String codigo_empresa;
  final int codigo_programacao;
  final int item_checklist;
  final Function() funCallback;


  const ImageGrid(
      {this.funCallback,
      Key key,
      this.directory,
      this.extensao,
      this.tipo,
      this.codigo_empresa,
      this.codigo_programacao,
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
                'Falha de conexão!',
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
                  if ((_extensao == '.mp4' || _extensao == '.MP4') && tipo == 'video') {
                    String _nomeArquivoSemExtensao = snapshot.data[i]['nome_arquivo'].toString().substring(0, snapshot.data[i]['nome_arquivo'].toString().length - 4);
                    if (File('/storage/emulated/0/Android/data/com.example.sps/files/Pictures/' + snapshot.data[i]['nome_arquivo'].toString()).existsSync() == true
                        && File('/storage/emulated/0/Android/data/com.example.sps/files/Pictures/thumbs/' + _nomeArquivoSemExtensao + '.jpg')
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
                          '/storage/emulated/0/Android/data/com.example.sps/files/Pictures/thumbs/' +
                              _nomeArquivoSemExtensao +
                              '.jpg';
                      _listaArquivos.add(_registroArquivo);
                    }
//                    else {
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
//                    }
                  }
                  if ((_extensao == '.jpg' || _extensao == '.JPG' || _extensao == '.png' || _extensao == '.PNG') && tipo == 'image') {
                    String _nomeArquivoSemExtensao =
                        snapshot.data[i]['nome_arquivo'].toString();
                    if (File('/storage/emulated/0/Android/data/com.example.sps/files/Pictures/' +
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
                          '/storage/emulated/0/Android/data/com.example.sps/files/Pictures/' +
                              snapshot.data[i]['nome_arquivo'].toString();
                      _listaArquivos.add(_registroArquivo);
                    }
//                    else {
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
//                    }
                  }
                }
              }
//              print('LISTA DE ARQUVIOS ' + _listaArquivos.toString());
              if (_listaArquivos.length >= 1) {
                return GridView.builder(
                    itemCount: _listaArquivos.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 3.0 / (tipo == 'image' ? 5.0 : 5.1)),
                    itemBuilder: (context, index) {
                      indicemedia = index;
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
                                        child: Image.file(
                                          File(
                                              _listaArquivos[index]['caminho']),
                                          fit: BoxFit.contain,
                                          height: 156,
                                        ),
                                      ),
                                    ),
                                    Row(
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
                                    ),
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

}
