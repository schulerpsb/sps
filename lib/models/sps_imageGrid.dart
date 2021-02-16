import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sps/components/centered_message.dart';
import 'package:sps/components/media.dart';
import 'package:sps/components/progress.dart';
import 'package:sps/dao/sps_dao_questionario_cq_midia_class.dart';
import 'package:sps/models/sps_questionario_cq_midia.dart';
import 'package:sps/screens/sps_mediaPlayer_screen.dart';
import 'dart:io' as io;

class ImageGrid extends StatelessWidget {
  final Directory directory;
  final String extensao;
  final String tipo;
  final String codigo_empresa;
  final int codigo_programacao;
  final int item_checklist;

  const ImageGrid({Key key, this.directory, this.extensao, this.tipo, this.codigo_empresa, this.codigo_programacao, this.item_checklist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //var fileWithExtensionpath = List();
    String teste = "";
    var refreshGridView;
    int indicemedia;
    final objSpsQuestionarioCqMidia = SpsQuestionarioCqMidia();

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: objSpsQuestionarioCqMidia.listarQuestionarioCqMidia(codigo_empresa: this.codigo_empresa ,codigo_programacao: this.codigo_programacao,item_checklist: this.item_checklist),
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
            }else{
              print('PROCESSEI A CONSULTA');
              List _listaArquivos = new List();
              if (snapshot.data.isNotEmpty) {
                for(var i = 0; i < snapshot.data.length; i++){
                  String _extensao = snapshot.data[i]['nome_arquivo'].toString().substring(snapshot.data[i]['nome_arquivo'].toString().length - 4);
                  if(_extensao  == '.mp4' && tipo == 'video') {
                    String _nomeArquivoSemExtensao = snapshot.data[i]['nome_arquivo'].toString().substring(0, snapshot.data[i]['nome_arquivo'].toString().length - 4);
                    if(File('/storage/emulated/0/Android/data/com.example.sps/files/Pictures/'+snapshot.data[i]['nome_arquivo'].toString()).existsSync() == true && File('/storage/emulated/0/Android/data/com.example.sps/files/Pictures/thumbs/'+_nomeArquivoSemExtensao+'.jpg').existsSync() == true){
                      Map<String,dynamic> _registroArquivo = new Map<String,dynamic>();
                      _registroArquivo['codigo_empresa'] = snapshot.data[i]['codigo_empresa'].toString();
                      _registroArquivo['codigo_programacao'] = snapshot.data[i]['codigo_programacao'].toString();
                      _registroArquivo['item_checklist'] = snapshot.data[i]['item_checklist'].toString();
                      _registroArquivo['item_anexo'] = snapshot.data[i]['item_anexo'].toString();
                      _registroArquivo['nome_arquivo'] = snapshot.data[i]['nome_arquivo'].toString();
                      _registroArquivo['titulo_arquivo'] = snapshot.data[i]['titulo_arquivo'].toString();
                      _registroArquivo['caminho'] = '/storage/emulated/0/Android/data/com.example.sps/files/Pictures/thumbs/'+_nomeArquivoSemExtensao+'.jpg';
                      _listaArquivos.add(_registroArquivo);
                    }else{
                      final SpsDaoQuestionarioCqMidia objQuestionarioCqMidiaDao = SpsDaoQuestionarioCqMidia();
                      objQuestionarioCqMidiaDao.deletarQuestionarioCqMidia(codigo_empresa: snapshot.data[i]['codigo_empresa'].toString(), codigo_programacao: snapshot.data[i]['codigo_programacao'], item_checklist: snapshot.data[i]['item_checklist'], item_anexo: snapshot.data[i]['item_anexo']).then((value) => print('Registro apagado'));
                    }
                  }
                  if(_extensao  == '.jpg' && tipo == 'image') {
                      String _nomeArquivoSemExtensao =   snapshot.data[i]['nome_arquivo'].toString();
                      if(File('/storage/emulated/0/Android/data/com.example.sps/files/Pictures/'+snapshot.data[i]['nome_arquivo'].toString()).existsSync() == true){
                        Map<String,dynamic> _registroArquivo = new Map<String,dynamic>();
                        _registroArquivo['codigo_empresa'] = snapshot.data[i]['codigo_empresa'].toString();
                        _registroArquivo['codigo_programacao'] = snapshot.data[i]['codigo_programacao'].toString();
                        _registroArquivo['item_checklist'] = snapshot.data[i]['item_checklist'].toString();
                        _registroArquivo['item_anexo'] = snapshot.data[i]['item_anexo'].toString();
                        _registroArquivo['nome_arquivo'] = snapshot.data[i]['nome_arquivo'].toString();
                        _registroArquivo['titulo_arquivo'] = snapshot.data[i]['titulo_arquivo'].toString();
                        _registroArquivo['caminho'] = '/storage/emulated/0/Android/data/com.example.sps/files/Pictures/'+snapshot.data[i]['nome_arquivo'].toString();
                        _listaArquivos.add(_registroArquivo);
                      }else{
                        final SpsDaoQuestionarioCqMidia objQuestionarioCqMidiaDao = SpsDaoQuestionarioCqMidia();
                        objQuestionarioCqMidiaDao.deletarQuestionarioCqMidia(codigo_empresa: snapshot.data[i]['codigo_empresa'].toString(), codigo_programacao: snapshot.data[i]['codigo_programacao'], item_checklist: snapshot.data[i]['item_checklist'], item_anexo: snapshot.data[i]['item_anexo']).then((value) => print('Registro apagado'));
                      }
                  }
                 }
              }
              print('LISTA DE ARQUVIOS '+_listaArquivos.toString());
//                var imageList = directory
//                    .listSync()
//                    .map((item) => item.path)
//                    .where((item) => item.endsWith(extensao))
//                    .toList(growable: false);

              if(_listaArquivos.length >= 1){
                return GridView.builder(
                    itemCount: _listaArquivos.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, childAspectRatio: 3.0 / (tipo == 'image' ? 5.0 : 6.1)),
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
                              InkWell(
                                onTap: () => {
                                  refreshGridView = Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => sps_mediaPlayer_screen(_listaArquivos[index]['caminho'], tipo)),
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
                                    File(_listaArquivos[index]['caminho']),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              FlatButton(
                                onPressed: () => {},
                                padding: EdgeInsets.all(0.0),
                                child: Column( // Replace with a Row for horizontal icon + text
                                  children: <Widget>[
                                      Text(_listaArquivos[index]['titulo_arquivo'],
                                      style: TextStyle(fontSize: 10, color: Colors.black, backgroundColor: Colors.white)),
                                    Icon(Icons.edit, size: 15),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              }else{
                if(tipo == 'image'){
                  return CenteredMessage(
                    'Nenhuma imagem encontrada!',
                    icon: Icons.error,
                  );
                }
                if(tipo == 'video'){
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
