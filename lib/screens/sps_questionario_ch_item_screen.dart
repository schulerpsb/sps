import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:sps/components/centered_message.dart';
import 'package:sps/components/progress.dart';
import 'package:sps/models/sps_erro_conexao_class.dart';
import 'package:sps/models/sps_login.dart';
import 'package:sps/models/sps_questionario_item_ch.dart';
import 'package:sps/models/sps_usuario_class.dart';
import 'package:sps/screens/sps_drawer_screen.dart';
import 'package:sps/screens/sps_questionario_ch_item_screen_resposta.dart';
import 'package:sps/screens/sps_questionario_ch_lista_screen.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class sps_questionario_ch_item_screen extends StatefulWidget {
  final String _codigo_empresa;
  final int _codigo_programacao;
  String _registro_colaborador;
  String _identificacao_utilizador;
  final String _codigo_grupo;
  final int _codigo_checklist;
  final String _descr_programacao;
  final String _sincronizado;
  final String _status_aprovacao;
  final String _filtro;
  final String _filtroDescrProgramacao;
  int _indexLista;
  String _acao;
  String _sessao_checklist;
  final String _tipo_questionario;

  final sps_usuario usuarioAtual;

  sps_questionario_ch_item_screen(
      this._codigo_empresa,
      this._codigo_programacao,
      this._registro_colaborador,
      this._identificacao_utilizador,
      this._codigo_grupo,
      this._codigo_checklist,
      this._descr_programacao,
      this._sincronizado,
      this._status_aprovacao,
      this._filtro,
      this._filtroDescrProgramacao,
      this._acao,
      this._sessao_checklist,
      this._indexLista,
      this._tipo_questionario,
      {this.usuarioAtual = null});

  @override
  _sps_questionario_ch_item_screen createState() =>
      _sps_questionario_ch_item_screen(
        this._codigo_empresa,
        this._codigo_programacao,
        this._registro_colaborador,
        this._identificacao_utilizador,
        this._codigo_grupo,
        this._codigo_checklist,
        this._descr_programacao,
        this._sincronizado,
        this._status_aprovacao,
        this._filtro,
        this._filtroDescrProgramacao,
        this._acao,
        this._sessao_checklist,
        this._indexLista,
        this._tipo_questionario,
      );
}

class _sps_questionario_ch_item_screen
    extends State<sps_questionario_ch_item_screen> {
  //Carregar Itens
  final SpsQuestionarioItem_ch spsQuestionarioItem_ch =
      SpsQuestionarioItem_ch();

  final SpsLogin spslogin = SpsLogin();

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  posicionaLista(indexLista) {
    itemScrollController.scrollTo(
        index: indexLista, duration: Duration(seconds: 1));
  }

  _sps_questionario_ch_item_screen(
      _codigo_empresa,
      _codigo_programacao,
      _registro_colaborador,
      _identificacao_utilizador,
      _codigo_grupo,
      _codigo_checklist,
      _descr_programacao,
      _sincronizado,
      _status_aprovacao,
      _filtro,
      _filtroReferenciaProjeto,
      _acao,
      _sessao_checklist,
      _indexLista,
      _tipo_questionario);

  var _singleValue = List();
  int _item_checklist_ant;

  @override
  Widget build(BuildContext context) {
    debugPrint("TELA => SPS_QUESTIONARIO_CH_ITEM_SCREEN");

    if (this.widget._tipo_questionario == "PESQUISA") {
      if (sps_usuario().tipo == "INTERNO" || sps_usuario().tipo == "COLIGADA") {
        this.widget._registro_colaborador = sps_usuario().registro_usuario;
        this.widget._identificacao_utilizador = '';
      } else {
        this.widget._registro_colaborador = '';
        this.widget._identificacao_utilizador = sps_usuario().codigo_usuario;
      }
    }

    return WillPopScope(
      onWillPop: () {
        return new Future(() => false);
      },
      child: Scaffold(
        backgroundColor: Color(0xFFe9eef7), // Cinza Azulado
        appBar: AppBar(
          backgroundColor: Color(0xFF004077),
          title: Text(
            'CHECKLIST',
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
                        builder: (context) => sps_questionario_ch_lista_screen(
                            this.widget._filtro,
                            this.widget._filtroDescrProgramacao,
                            this.widget._tipo_questionario)),
                  );
                },
              );
            },
          ),
        ),
        endDrawer: sps_drawer(spslogin: spslogin),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: spsQuestionarioItem_ch.listarQuestionarioItem_ch(
              this.widget._codigo_empresa,
              this.widget._codigo_programacao,
              this.widget._registro_colaborador,
              this.widget._identificacao_utilizador,
              this.widget._codigo_grupo,
              this.widget._codigo_checklist,
              this.widget._acao,
              this.widget._sessao_checklist),
          builder: (context, snapshot) {
            _singleValue.clear();
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
                    '(Ponto 7) Falha de conexão! \n\n(' + werror + ')',
                    icon: Icons.error,
                  );
                }
                if (erroConexao.msg_erro_conexao.toString() == "") {
                  if (snapshot.data.isNotEmpty) {
                    return Column(
                      children: <Widget>[
                        //Tratar Cabeçalho
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 5, left: 3, right: 3, bottom: 0),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                                minWidth: double.infinity, maxHeight: 50),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(
                                  top: 5, left: 5, right: 5, bottom: 5),
                              color: Color(0xFF494d4a), // Cinza
                              child: Text(
                                  "(" +
                                      this
                                          .widget
                                          ._codigo_programacao
                                          .toString() +
                                      ") " +
                                      this.widget._descr_programacao,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                        //Tratar sessão
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 5, left: 3, right: 3, bottom: 0),
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                      maxWidth: 35, maxHeight: 30),
                                  child: Container(
                                    alignment: Alignment.topLeft,
                                    padding: EdgeInsets.only(
                                        top: 0, left: 0, right: 5, bottom: 5),
                                    color: Colors.black26,
                                    child: IconButton(
                                      icon: Icon(Icons.arrow_back, size: 20),
                                      color: snapshot.data[0]
                                                  ["sessao_anterior"] !=
                                              0
                                          ? Colors.indigo
                                          : Colors.black12,
                                      onPressed: () {
                                        snapshot.data[0]["sessao_anterior"] != 0
                                            ? setState(
                                                () {
                                                  usuarioAtual.index_perguntas = 0;
                                                  this.widget._acao =
                                                      "ANTERIOR";
                                                },
                                              )
                                            : null;
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 5, left: 3, right: 3, bottom: 0),
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                      maxWidth: double.infinity, maxHeight: 20),
                                  child: Text(
                                      snapshot.data[0]["sessao_checklist"],
                                      softWrap: true,
                                      maxLines: 2,
                                      style: TextStyle(
                                          color: Colors.indigo,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 5, left: 3, right: 3, bottom: 0),
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                      maxWidth: 35, maxHeight: 30),
                                  child: Container(
                                    alignment: Alignment.topLeft,
                                    padding: EdgeInsets.only(
                                        top: 0, left: 0, right: 5, bottom: 5),
                                    color: Colors.black26,
                                    child: IconButton(
                                      icon: Icon(Icons.arrow_forward, size: 20),
                                      color: snapshot.data[0]
                                                  ["sessao_posterior"] !=
                                              0
                                          ? Colors.indigo
                                          : Colors.black12,
                                      onPressed: () {
                                        snapshot.data[0]["sessao_posterior"] !=
                                                0
                                            ? setState(
                                                () {
                                                  usuarioAtual.index_perguntas = 0;
                                                  this.widget._acao = "PROXIMO";
                                                },
                                              )
                                            : null;
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 5, left: 0, right: 0, bottom: 0),
                            child: ScrollablePositionedList.builder(
                              itemScrollController: itemScrollController,
                              itemPositionsListener: itemPositionsListener,
                              padding: EdgeInsets.only(top: 5),
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  this.widget._sessao_checklist =
                                      snapshot.data[0]["sessao_checklist"];
                                  _item_checklist_ant = 0;
                                }

                                //Analisar pergunta dependente
                                var _ignorar_pergunta_dependente = false;
                                if (snapshot
                                    .data[index]["codigo_pergunta_dependente"] !=
                                    "") {
                                  if (snapshot
                                      .data[index]["resposta_pergunta_dependente"] != snapshot.data[index]["resposta_pergunta_original"]) {
                                    _ignorar_pergunta_dependente = true;
                                  }
                                }

                                if (snapshot.data[index]["sessao_checklist"] ==
                                        this.widget._sessao_checklist &&
                                    snapshot.data[index]["item_checklist"] !=
                                        _item_checklist_ant) {
                                  _item_checklist_ant =
                                      snapshot.data[index]["item_checklist"];
                                  tratar_posicionar_lista(usuarioAtual.index_perguntas);
                                  if (_ignorar_pergunta_dependente == false) {
                                    return Container(
                                      child: Card(
                                        color: snapshot.data[index]
                                        ["status_resposta"] ==
                                            "PREENCHIDA" && snapshot.data[index]
                                        ["pendente_com_resposta_dependente"] !=
                                            "PENDENTE"
                                            ? Color(0xffdcedc8)
                                            : Colors.white60,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 0,
                                              left: 5,
                                              right: 5,
                                              bottom: 0),
                                          child: Column(
                                            children: [
                                              //Tratar descrição da pergunta
                                              descricao_pergunta(
                                                  snapshot, index, 1),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                } else {
                                  return Container();
                                }
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

  ListTile descricao_pergunta(
      AsyncSnapshot<List<Map<String, dynamic>>> snapshot, int index, tamanho) {
    return ListTile(
      trailing: snapshot.data[index]["status_resposta"] == "PREENCHIDA" && snapshot.data[index]["pendente_com_resposta_dependente"] != "PENDENTE"
          ? Icon(Icons.check, color: Colors.green, size: 40)
          : null,
      title: Text(
        '${snapshot.data[index]["seq_pergunta"]}' +
            " - " +
            '${snapshot.data[index]["descr_pergunta"]}',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      ),
      onTap: () {
        usuarioAtual.index_perguntas = index;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => sps_questionario_ch_item_screen_resposta(
              snapshot.data[index]["codigo_empresa"],
              snapshot.data[index]["codigo_programacao"],
              snapshot.data[index]["registro_colaborador"],
              snapshot.data[index]["identificacao_utilizador"],
              snapshot.data[index]["codigo_grupo"],
              snapshot.data[index]["codigo_checklist"],
              this.widget._descr_programacao,
              snapshot.data[index]["sincronizado"],
              snapshot.data[index]["status_aprovacao"],
              this.widget._filtro,
              this.widget._filtroDescrProgramacao,
              "",
              snapshot.data[index]["sessao_checklist"],
              0,
              this.widget._tipo_questionario,
              snapshot.data[index]["item_checklist"],
            ),
          ),
        );
      },
    );
  }

  tratar_posicionar_lista(index) {
    SchedulerBinding.instance.addPostFrameCallback(
      (_) {
        posicionaLista(index);
      },
    );
    return Text("");
  }
}
