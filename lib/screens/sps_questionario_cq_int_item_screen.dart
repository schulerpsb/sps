import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:sps/components/centered_message.dart';
import 'package:sps/components/progress.dart';
import 'package:sps/dao/sps_dao_questionario_class.dart';
import 'package:sps/dao/sps_dao_questionario_item_class.dart';
import 'package:sps/models/sps_erro_conexao_class.dart';
import 'package:sps/models/sps_login.dart';
import 'package:sps/models/sps_questionario_item_cq.dart';
import 'package:sps/models/sps_questionario_utils.dart';
import 'package:sps/screens/sps_drawer_screen.dart';
import 'package:sps/screens/sps_questionario_cq_comentarios_screen.dart';
import 'package:sps/screens/sps_questionario_midia_screen.dart';
import 'package:sps/screens/sps_questionario_cq_lista_screen.dart';
import 'package:badges/badges.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class sps_questionario_cq_int_item_screen extends StatefulWidget {
  final String _codigo_empresa;
  final int _codigo_programacao;
  final String _registro_colaborador;
  final String _identificacao_utilizador;
  final String _codigo_grupo;
  final int _codigo_checklist;
  final String _descr_programacao;
  final String _codigo_pedido;
  final String _item_pedido;
  final String _codigo_material;
  String _referencia_parceiro;
  final String _nome_fornecedor;
  final int _qtde_pedido;
  final String _codigo_projeto;
  final String _sincronizado;
  final String _status_aprovacao;
  final String _origemUsuario;
  final String _filtro;
  int _indexLista;
  final String _filtroReferenciaProjeto;

  sps_questionario_cq_int_item_screen(
      this._codigo_empresa,
      this._codigo_programacao,
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
      this._filtroReferenciaProjeto);

  @override
  _sps_questionario_cq_int_item_screen createState() =>
      _sps_questionario_cq_int_item_screen(
          this._codigo_empresa,
          this._codigo_programacao,
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
          this._filtroReferenciaProjeto);
}

class _sps_questionario_cq_int_item_screen
    extends State<sps_questionario_cq_int_item_screen> {
  final SpsQuestionarioItem spsQuestionarioItem = SpsQuestionarioItem();

  final SpsLogin spslogin = SpsLogin();
  GlobalKey<ScaffoldState> _key = GlobalKey();

  _sps_questionario_cq_int_item_screen(
      _codigo_empresa,
      _codigo_programacao,
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
      _filtroReferenciaProjeto);

  var _singleValue = List();
  Color _resp_cq_cor;

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  posicionaLista(indexLista) {
    itemScrollController.scrollTo(
        index: indexLista, duration: Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    print('Posicao lista==>' + this.widget._indexLista.toString());
    debugPrint("TELA => SPS_QUESTIONARIO_CQ_INT_ITEM_SCREEN");
    return WillPopScope(
      onWillPop: () {
        return new Future(() => false);
      },
      child: Scaffold(
        backgroundColor: Color(0xFFe9eef7), // Cinza Azulado
        appBar: AppBar(
          backgroundColor: Color(0xFF004077),
          title: Text(
            'APROVAÇÃO',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => sps_questionario_cq_lista_screen(
                            this.widget._origemUsuario,
                            this.widget._filtro,
                            this.widget._filtroReferenciaProjeto)),
                  );
                },
              );
            },
          ),
        ),
        endDrawer: sps_drawer(spslogin: spslogin),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: spsQuestionarioItem.listarQuestionarioItem(
              this.widget._origemUsuario,
              this.widget._codigo_empresa,
              this.widget._codigo_programacao,
              this.widget._codigo_grupo,
              this.widget._codigo_checklist,
              'PROXIMO',
              ''),
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
                    'Falha de conexão! \n\n(' + werror + ')',
                    icon: Icons.error,
                  );
                }
                if (erroConexao.msg_erro_conexao.toString() == "") {
                  if (snapshot.data.isNotEmpty) {
                    return Column(children: <Widget>[
                      //Tratar Cabeçalho
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 5, left: 3, right: 3, bottom: 0),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                              minWidth: double.infinity, maxHeight: 100),
                          child: Container(
                            padding: EdgeInsets.only(
                                top: 5, left: 5, right: 5, bottom: 5),
                            color: Color(0xFF494d4a), // Cinza
                            child: Text(
                                "(" +
                                    this.widget._codigo_programacao.toString() +
                                    ") " +
                                    this.widget._descr_programacao +
                                    "\n\n" +
                                    "PEDIDO: " +
                                    this.widget._codigo_pedido +
                                    " / " +
                                    this.widget._item_pedido +
                                    " (" +
                                    this.widget._codigo_material +
                                    ")\n" +
                                    "PROJETO: " +
                                    this.widget._codigo_projeto,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 0, left: 3, right: 3, bottom: 0),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                              minWidth: double.infinity, maxHeight: 100),
                          child: Container(
                            padding: EdgeInsets.only(
                                top: 0, left: 5, right: 5, bottom: 0),
                            color: Color(0xFF494d4a), // Cinza
                            child: Row(
                              children: <Widget>[
                                Text(
                                  "REFERÊNCIA: " +
                                      this.widget._referencia_parceiro,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      //Construir lista de opções
                      Expanded(
                        child: ScrollablePositionedList.builder(
                          itemScrollController: itemScrollController,
                          itemPositionsListener: itemPositionsListener,
                          padding: EdgeInsets.only(top: 5),
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            switch (snapshot.data[index]["status_aprovacao"]) {
                              case 'PENDENTE':
                                _singleValue.add("PENDENTE");
                                break;
                              case 'APROVADO':
                                _singleValue.add("APROVADO");
                                break;
                              default:
                                _singleValue.add("");
                                break;
                            }

                            //Definir cor do texto p/ resposta do questionarioa (resp_cq)
                            switch (snapshot.data[index]["resp_cq"]) {
                              case 'NÃO SE APLICA':
                                _resp_cq_cor = Color(0xFF9fbded);
                                break;
                              case 'REJEITADO':
                                _resp_cq_cor = Colors.red;
                                break;
                              case 'APROVADO PARCIAL':
                                _resp_cq_cor = Colors.orange;
                                break;
                              case 'APROVADO':
                                _resp_cq_cor = Colors.green;
                                break;
                              default:
                                _resp_cq_cor = Colors.white;
                                break;
                            }

                            return Card(
                              color: Colors.white,
                              child: Column(
                                children: <Widget>[
                                  //Tratar descrição da pergunta
                                  ListTile(
                                    trailing: snapshot.data[index]
                                                ["status_resposta"] ==
                                            "PREENCHIDA"
                                        ? Icon(Icons.check,
                                            color: Colors.green, size: 40)
                                        : null,
                                    title: Text(
                                        '${snapshot.data[index]["seq_pergunta"]}' +
                                            " - " +
                                            '${snapshot.data[index]["descr_pergunta"]}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 15)),
                                    subtitle: Text(""),
                                  ),

                                  // Tratar estatus da resposa do parceiro (resp_cq)
                                  Text("Resposta do parceiro: ",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                  Text(snapshot.data[index]["resp_cq"] + "\n",
                                      style: TextStyle(
                                          color: _resp_cq_cor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                  Row(
                                    children: <Widget>[
                                      // Tratar Opções
                                      Text("     "),
                                      (snapshot.data[index]["resp_cq"] ==
                                                      "NÃO SE APLICA" ||
                                                  snapshot.data[index]
                                                          ["resp_cq"] ==
                                                      "APROVADO") &&
                                              snapshot.data[index]
                                                      ["status_resposta"] ==
                                                  "PREENCHIDA"
                                          ? Container(
                                              color: Colors.orange,
                                              child: CustomRadioWidget(
                                                value: "PENDENTE",
                                                groupValue: _singleValue[index],
                                                onChanged: (value) => _gravar_aprovacao(
                                                    '${snapshot.data[index]["codigo_empresa"]}',
                                                    '${snapshot.data[index]["codigo_programacao"]}',
                                                    '${snapshot.data[index]["item_checklist"]}',
                                                    '${snapshot.data[index]["registro_aprovador"]}',
                                                    value,
                                                    index),
                                              ),
                                            )
                                          : Text(""),
                                      (snapshot.data[index]["resp_cq"] ==
                                                      "NÃO SE APLICA" ||
                                                  snapshot.data[index]
                                                          ["resp_cq"] ==
                                                      "APROVADO") &&
                                              snapshot.data[index]
                                                      ["status_resposta"] ==
                                                  "PREENCHIDA"
                                          ? Text(" PENDENTE",
                                              style: TextStyle(
                                                  color: Colors.orange,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold))
                                          : Text(""),
                                      Text("     "),
                                      (snapshot.data[index]["resp_cq"] ==
                                                      "NÃO SE APLICA" ||
                                                  snapshot.data[index]
                                                          ["resp_cq"] ==
                                                      "APROVADO") &&
                                              snapshot.data[index]
                                                      ["status_resposta"] ==
                                                  "PREENCHIDA"
                                          ? Container(
                                              color: Colors.green,
                                              child: CustomRadioWidget(
                                                value: "APROVADO",
                                                groupValue: _singleValue[index],
                                                onChanged: (value) => _gravar_aprovacao(
                                                    '${snapshot.data[index]["codigo_empresa"]}',
                                                    '${snapshot.data[index]["codigo_programacao"]}',
                                                    '${snapshot.data[index]["item_checklist"]}',
                                                    '${snapshot.data[index]["registro_aprovador"]}',
                                                    value,
                                                    index),
                                              ),
                                            )
                                          : Text(""),
                                      (snapshot.data[index]["resp_cq"] ==
                                                      "NÃO SE APLICA" ||
                                                  snapshot.data[index]
                                                          ["resp_cq"] ==
                                                      "APROVADO") &&
                                              snapshot.data[index]
                                                      ["status_resposta"] ==
                                                  "PREENCHIDA"
                                          ? Text(" APROVADO",
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold))
                                          : Text(""),
                                      Text("    "),

                                      //Tratar Mídias
                                      IconButton(
                                        icon: Badge(
                                          badgeContent: Text(
                                              snapshot.data[index]["anexos"]
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 8)),
                                          showBadge:
                                              snapshot.data[index]["anexos"] > 0
                                                  ? true
                                                  : false,
                                          badgeColor: Color(0xFF004077),
                                          child:
                                              Icon(Icons.collections, size: 30),
                                        ),
                                        color:
                                            snapshot.data[index]["anexos"] > 0
                                                ? Colors.blue
                                                : Colors.black,
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    sps_questionario_midia_screen(
                                                      snapshot.data[index]
                                                          ["codigo_empresa"],
                                                      snapshot.data[index][
                                                          "codigo_programacao"],
                                                      snapshot.data[index]
                                                          ["item_checklist"],
                                                      snapshot.data[index]
                                                          ["descr_comentarios"],
                                                      this
                                                          .widget
                                                          ._registro_colaborador,
                                                      this
                                                          .widget
                                                          ._identificacao_utilizador,
                                                      this.widget._codigo_grupo,
                                                      this
                                                          .widget
                                                          ._codigo_checklist,
                                                      this
                                                          .widget
                                                          ._descr_programacao,
                                                      this
                                                          .widget
                                                          ._codigo_pedido,
                                                      this.widget._item_pedido,
                                                      this
                                                          .widget
                                                          ._codigo_material,
                                                      this
                                                          .widget
                                                          ._referencia_parceiro,
                                                      this
                                                          .widget
                                                          ._nome_fornecedor,
                                                      this.widget._qtde_pedido,
                                                      this
                                                          .widget
                                                          ._codigo_projeto,
                                                      this.widget._sincronizado,
                                                      snapshot.data[index]
                                                          ["status_aprovacao"],
                                                      this
                                                          .widget
                                                          ._origemUsuario,
                                                      this.widget._filtro,
                                                      index,
                                                      this
                                                          .widget
                                                          ._filtroReferenciaProjeto,
                                                      snapshot.data[index]
                                                              ["imagens"]
                                                          .toString(),
                                                      snapshot.data[index]
                                                              ["videos"]
                                                          .toString(),
                                                      snapshot.data[index]
                                                              ["outros"]
                                                          .toString(),
                                                      "",
                                                      funCallback: (
                                                          {int
                                                              index_posicao_retorno,
                                                          String acao}) {
                                                        setState(() {
                                                          this
                                                                  .widget
                                                                  ._indexLista =
                                                              index_posicao_retorno;
                                                        });
                                                      },
                                                    )),
                                          );
                                        },
                                      ),

                                      //Tratar Comentários
                                      IconButton(
                                        icon: Icon(Icons.comment, size: 30),
                                        color: snapshot.data[index]
                                                        ["descr_comentarios"] ==
                                                    "" ||
                                                snapshot.data[index]
                                                        ["descr_comentarios"] ==
                                                    null
                                            ? Colors.black
                                            : Colors.blue,
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  sps_questionario_cq_comentarios_screen(
                                                snapshot.data[index]
                                                    ["codigo_empresa"],
                                                snapshot.data[index]
                                                    ["codigo_programacao"],
                                                snapshot.data[index]
                                                    ["item_checklist"],
                                                snapshot.data[index]
                                                    ["descr_comentarios"],
                                                this
                                                    .widget
                                                    ._registro_colaborador,
                                                this
                                                    .widget
                                                    ._identificacao_utilizador,
                                                this.widget._codigo_grupo,
                                                this.widget._codigo_checklist,
                                                this.widget._descr_programacao,
                                                this.widget._codigo_pedido,
                                                this.widget._item_pedido,
                                                this.widget._codigo_material,
                                                this
                                                    .widget
                                                    ._referencia_parceiro,
                                                this.widget._nome_fornecedor,
                                                this.widget._qtde_pedido,
                                                this.widget._codigo_projeto,
                                                this.widget._sincronizado,
                                                snapshot.data[index]
                                                    ["status_aprovacao"],
                                                this.widget._origemUsuario,
                                                "CONTROLE DE QUALIDADE",
                                                this.widget._filtro,
                                                index,
                                                this
                                                    .widget
                                                    ._filtroReferenciaProjeto,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  tratar_posicionar_lista(index),
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
    );
  }

  _gravar_aprovacao(_wcodigoEmpresa, _wcodigoProgramacao, _witemChecklist,
      _wregistroAprovador, _wstatusAprovacao, _windex) async {
    print('posicao      ==>' + _windex.toString());
    var _wsincronizado = "";

    //Verificar se existe conexão
//    final SpsVerificarConexao ObjVerificarConexao = SpsVerificarConexao();
//    final bool result = await ObjVerificarConexao.verificar_conexao();
//    if (result == true) {
//      //Gravar PostgreSQL (API REST)
//      final SpsHttpQuestionarioItem objQuestionarioItemHttp =
//          SpsHttpQuestionarioItem();
//      final retorno = await objQuestionarioItemHttp.QuestionarioSaveAprovacao(
//          _wcodigoEmpresa,
//          _wcodigoProgramacao,
//          _witemChecklist,
//          _wstatusAprovacao,
//          usuarioAtual.tipo == "INTERNO" || usuarioAtual.tipo == "COLIGADA" ?usuarioAtual.registro_usuario :usuarioAtual.codigo_usuario);
//      if (retorno == true) {
//        _wsincronizado = "";
//        debugPrint("registro gravado PostgreSQL");
//      } else {
//        _wsincronizado = "N";
//        debugPrint("ERRO => registro não gravado PostgreSQL");
//      }
//    } else {
//      _wsincronizado = "N";
//    }
    _wsincronizado = "N";
    //Gravar SQlite
    final SpsDaoQuestionarioItem objQuestionarioItemDao =
        SpsDaoQuestionarioItem();
    final int resultupdate = await objQuestionarioItemDao.update_aprovacao(
        _wcodigoEmpresa,
        _wcodigoProgramacao,
        _witemChecklist,
        _wstatusAprovacao,
        _wsincronizado);

    //Analisar e Atualizar Status da Lista (cabecalho) em função do status da aprovação
    final SpsDaoQuestionario objQuestionarioDao = SpsDaoQuestionario();
    final int resultupdateLista = await objQuestionarioDao
        .update_lista_status_aprovacao(_wcodigoEmpresa, _wcodigoProgramacao);

    //Atualizar status da resposta
    spsQuestionarioUtils objspsQuestionarioUtils = new spsQuestionarioUtils();
    await objspsQuestionarioUtils.atualizar_status_resposta(_wcodigoEmpresa,
        int.parse(_wcodigoProgramacao), "", "", int.parse(_witemChecklist));

    setState(() {});
    _singleValue[_windex] = _wstatusAprovacao;
    this.widget._indexLista = _windex;
  }

  tratar_posicionar_lista(index) {
    if (index == this.widget._indexLista) {
      SchedulerBinding.instance.addPostFrameCallback(
        (_) {
          posicionaLista(this.widget._indexLista);
        },
      );
    }
    return Text("");
  }
}
