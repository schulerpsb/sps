import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:sps/components/centered_message.dart';
import 'package:sps/components/progress.dart';
import 'package:sps/models/sps_erro_conexao_class.dart';
import 'package:sps/models/sps_login.dart';
import 'package:sps/models/sps_questionario.dart';
import 'package:sps/models/sps_questionario_item_ch.dart';
import 'package:sps/models/sps_usuario_class.dart';
import 'package:sps/screens/sps_drawer_screen.dart';
import 'package:sps/screens/sps_home_authenticated_fromlocal_screen.dart';
import 'package:sps/screens/sps_questionario_ch_item_screen_resposta.dart';
import 'package:sps/screens/sps_questionario_ch_lista_screen.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sps/screens/sps_questionario_cq_int_filtro_screen.dart';

class sps_questionario_cq_filtro_fornecedor_screen extends StatefulWidget {
  @override
  _sps_questionario_cq_filtro_fornecedor_screen createState() =>
      _sps_questionario_cq_filtro_fornecedor_screen();
}

class _sps_questionario_cq_filtro_fornecedor_screen
    extends State<sps_questionario_cq_filtro_fornecedor_screen> {
  //Carregar Itens
  final SpsQuestionario spsQuestionario_fornecedor = SpsQuestionario();

  final SpsLogin spslogin = SpsLogin();

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  _sps_questionario_cq_filtro_fornecedor_screen();

  @override
  Widget build(BuildContext context) {
    debugPrint("TELA => SPS_QUESTIONARIO_CQ_FILTRO_FORNECEDOR_SCREEN");

    return WillPopScope(
      onWillPop: () {
        return new Future(() => false);
      },
      child: Scaffold(
        backgroundColor: Color(0xFFe9eef7), // Cinza Azulado
        appBar: AppBar(
          backgroundColor: Color(0xFF004077),
          title: Text(
            'FOLLOW_UP',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  usuarioAtual.index_perguntas = 0;
                  Navigator.pop;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomeSpsAuthenticatedFromLocal()),
                  );
                },
              );
            },
          ),
        ),
        endDrawer: sps_drawer(spslogin: spslogin),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: spsQuestionario_fornecedor.listarQuestionarioFornecedor(),
          builder: (context, snapshot) {
            //debugPrint(snapshot.data.toString());
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
                    '(Ponto 14) Falha de conexão! \n\n(' + werror + ')',
                    icon: Icons.error,
                  );
                }
                if (erroConexao.msg_erro_conexao.toString() == "") {
                  if (snapshot.data.isNotEmpty) {
                    return Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 15, 0, 5),
                          child: Text("Selecione o fornecedor desejado",
                              style: TextStyle(
                                  color: Colors.indigo,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 5, left: 0, right: 0, bottom: 0),
                            child: ScrollablePositionedList.builder(
                              itemScrollController: itemScrollController,
                              itemPositionsListener: itemPositionsListener,
                              padding: EdgeInsets.only(
                                  top: 5, left: 10, right: 10, bottom: 0),
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  child: Card(
                                    color: index == 0
                                        ? Colors.lightBlue[100]
                                        : Colors.white60,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 0, left: 5, right: 5, bottom: 0),
                                      child: Column(
                                        children: [
                                          //Tratar descrição da pergunta
                                          nome_fornecedor(snapshot, index, 1),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(5, 3, 5, 0),
                        ),
                        //Tratar botão SALVAR
                      ],
                    );
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
    );
  }

  ListTile nome_fornecedor(
      AsyncSnapshot<List<Map<String, dynamic>>> snapshot, int index, tamanho) {
    return ListTile(
      title: Column(
        children: [
          Text(
            snapshot.data[index]["nome_fornecedor"],
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 5.0,
          ),
          RichText(
            text: new TextSpan(
              style:
                  TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
              children: <TextSpan>[
                new TextSpan(
                  text: "Pendente: ",
                  style: TextStyle(
                      fontWeight: FontWeight.normal, color: Colors.red),
                ),
                new TextSpan(
                  text:
                      snapshot.data[index]["qtde_pendente"].toString() + "      ",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                ),
                new TextSpan(
                  text: "Parcial: ",
                  style: TextStyle(
                      fontWeight: FontWeight.normal, color: Colors.orange),
                ),
                new TextSpan(
                  text: snapshot.data[index]["qtde_parcial"].toString() + "      ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.orange),
                ),
                new TextSpan(
                  text: "Concluído: ",
                  style: TextStyle(
                      fontWeight: FontWeight.normal, color: Colors.green),
                ),
                new TextSpan(
                  text: snapshot.data[index]["qtde_ok"].toString() ,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.green),
                ),
              ],
            ),
          ),
        ],
      ),
      onTap: () {
        usuarioAtual.index_perguntas = index;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => sps_questionario_cq_int_filtro_screen(
                index == 0 ? "" : snapshot.data[index]["nome_fornecedor"]),
          ),
        );
      },
    );
  }
}
