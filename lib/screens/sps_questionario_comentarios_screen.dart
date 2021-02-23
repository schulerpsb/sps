import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sps/dao/sps_dao_questionario_item_class.dart';
import 'file:///C:/Mobile/sps/lib/http/sps_http_verificar_conexao_class.dart';
import 'package:sps/http/sps_http_questionario_item_class.dart';
import 'package:sps/models/sps_login.dart';
import 'package:sps/models/sps_questionario_item_cq.dart';
import 'package:sps/models/sps_usuario_class.dart';
import 'package:sps/screens/sps_drawer_screen.dart';
import 'package:sps/screens/sps_questionario_cq_ext_item_screen.dart';
import 'package:intl/intl.dart';
import 'Dart:io';
import 'package:sps/screens/sps_questionario_cq_int_item_screen.dart';

class sps_questionario_cq_comentarios_screen extends StatefulWidget {
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
  final int _item_pedido;
  final String _codigo_material;
  final String _referencia_parceiro;
  final String _codigo_projeto;
  final String _sincronizado;
  final String _status_aprovacao;
  final String _origemUsuario;
  final String _filtro;
  final String _filtroReferenciaProjeto;

  sps_questionario_cq_comentarios_screen(
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
      this._filtroReferenciaProjeto);

  @override
  _sps_questionario_cq_comentarios_screen createState() =>
      _sps_questionario_cq_comentarios_screen(
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
          this._filtroReferenciaProjeto);
}

class _sps_questionario_cq_comentarios_screen
    extends State<sps_questionario_cq_comentarios_screen> {
  final SpsQuestionarioItem spsQuestionarioItem =
      SpsQuestionarioItem();

  final SpsLogin spslogin = SpsLogin();
  GlobalKey<ScaffoldState> _key = GlobalKey();

  _sps_questionario_cq_comentarios_screen(
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
      _filtroReferenciaProjeto);

  //Executar Scrolling automático
  ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _controller
            .animateTo(_controller.position.maxScrollExtent,
                duration: Duration(seconds: 1), curve: Curves.ease)
            .then(
              (value) async {},
            );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("TELA => SPS_QUESTIONARIO_CQ_COMENTARIOS_SCREEN");
    TextEditingController _novoComentario = TextEditingController();

    return WillPopScope(
      onWillPop: () {
        return new Future(() => false);
      },
      child: Scaffold(
        backgroundColor: Color(0xFFe9eef7), // Cinza Azulado
        appBar: AppBar(
          backgroundColor: Color(0xFF004077),
          title: Text(
            'COMENTÁRIOS',
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
                        builder: (context) =>
                            this.widget._origemUsuario == "EXTERNO"
                                ? sps_questionario_cq_ext_item_screen(
                                    this.widget._codigo_empresa,
                                    this.widget._codigo_programacao,
                                    this.widget._registro_colaborador,
                                    this.widget._identificacao_utilizador,
                                    this.widget._codigo_grupo,
                                    this.widget._codigo_checklist,
                                    this.widget._descr_programacao,
                                    this.widget._codigo_pedido,
                                    this.widget._item_pedido,
                                    this.widget._codigo_material,
                                    this.widget._referencia_parceiro,
                                    this.widget._codigo_projeto,
                                    this.widget._sincronizado,
                                    this.widget._status_aprovacao,
                                    this.widget._origemUsuario,
                                    this.widget._filtro,
                                    this.widget._filtroReferenciaProjeto)
                                : sps_questionario_cq_int_item_screen(
                                    this.widget._codigo_empresa,
                                    this.widget._codigo_programacao,
                                    this.widget._registro_colaborador,
                                    this.widget._identificacao_utilizador,
                                    this.widget._codigo_grupo,
                                    this.widget._codigo_checklist,
                                    this.widget._descr_programacao,
                                    this.widget._codigo_pedido,
                                    this.widget._item_pedido,
                                    this.widget._codigo_material,
                                    this.widget._referencia_parceiro,
                                    this.widget._codigo_projeto,
                                    this.widget._sincronizado,
                                    this.widget._status_aprovacao,
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
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    top: 10, left: 10, right: 10, bottom: 10),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Text("Histórico dos comentários",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 10, left: 10, right: 10, bottom: 10),
                child: Container(
                  height:
                      this.widget._status_aprovacao == "PENDENTE" ? 320 : 500,
                  child: SingleChildScrollView(
                    controller: _controller,
                    child: Column(
                      children: <Widget>[
                        Card(
                          margin: new EdgeInsets.only(
                              left: 10.0, right: 10.0, top: 8.0, bottom: 5.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          elevation: 4.0,
                          color: Color(0xFFc7dcff),
                          child: new Container(
                            width: 400,
                            padding: new EdgeInsets.all(10),
                            child: Text(
                              ajustar_comentarios(
                                  this.widget._descr_comentarios),
                              style: new TextStyle(
                                fontSize: 13.0,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 5, left: 10, right: 10, bottom: 10),
                child: Column(
                  children: <Widget>[
                    this.widget._status_aprovacao == "PENDENTE"
                        ? Text("Adicionar comentários",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15))
                        : Text(""),
                    this.widget._status_aprovacao == "PENDENTE"
                        ? Card(
                            color: Colors.white,
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Column(
                                children: <Widget>[
                                  TextField(
                                    controller: _novoComentario,
                                    maxLines: 4,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Digite seu comentário'),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Text(""),
                    SizedBox(
                      height: 5.0,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: this.widget._status_aprovacao == "PENDENTE"
                          ? FloatingActionButton(
                              onPressed: () => this.widget._origemUsuario ==
                                      "EXTERNO"
                                  ? _gravar_comentario(
                                      "EXTERNO",
                                      this.widget._codigo_empresa,
                                      this.widget._codigo_programacao,
                                      this.widget._item_checklist,
                                      this.widget._descr_comentarios +
                                          "<b><font color=blue>" +
                                          sps_usuario().nome_usuario +
                                          " em " +
                                          obter_datahora() +
                                          "</font></b>||" +
                                          _novoComentario.text +
                                          "<br>||")
                                  : _gravar_comentario(
                                      "INTERNO",
                                      this.widget._codigo_empresa,
                                      this.widget._codigo_programacao,
                                      this.widget._item_checklist,
                                      this.widget._descr_comentarios +
                                          "<b><font color=green>[APROVADOR] " +
                                          sps_usuario().nome_usuario +
                                          " em " +
                                          obter_datahora() +
                                          "</font></b>||" +
                                          _novoComentario.text +
                                          "<br>||"),
                              child: const Icon(Icons.add),
                            )
                          : Text(""),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _gravar_comentario(
      _worigemUsuario,
      _wcodigoEmpresa,
      _wcodigoProgramacao,
      _witemChecklist,
      _wdescrComentarios) async {
    debugPrint('comentário => ' + _wdescrComentarios);

    var _wsincronizado = "";

    //Verificar se existe conexão
    final SpsVerificarConexao ObjVerificarConexao = SpsVerificarConexao();
    final bool result = await ObjVerificarConexao.verificar_conexao();
    if (result == true) {
      //Gravar PostgreSQL (API REST)
      final SpsHttpQuestionarioItem objQuestionarioItemHttp =
          SpsHttpQuestionarioItem();
      final retorno = await objQuestionarioItemHttp.QuestionarioSaveComentario(
          _worigemUsuario,
          _wcodigoEmpresa,
          _wcodigoProgramacao.toString(),
          null,
          null,
          _witemChecklist.toString(),
          _wdescrComentarios,
          usuarioAtual.tipo == "INTERNO" || usuarioAtual.tipo == "COLIGADA" ?usuarioAtual.registro_usuario :usuarioAtual.codigo_usuario); //substituir por variavel global do Fernando
      if (retorno == true) {
        _wsincronizado = "";
        debugPrint("registro gravado PostgreSQL: " +
            _wcodigoEmpresa.toString() +
            "/" +
            _wcodigoProgramacao.toString() +
            "/" +
            _witemChecklist.toString() +
            "/" +
            _wdescrComentarios.toString());
      } else {
        _wsincronizado = "N";
        debugPrint("ERRO => registro gravado PostgreSQL: " +
            _wcodigoEmpresa.toString() +
            "/" +
            _wcodigoProgramacao.toString() +
            "/" +
            _witemChecklist.toString() +
            "/" +
            _wdescrComentarios.toString());
      }
    } else {
      _wsincronizado = "N";
    }

    //Gravar SQlite
    final SpsDaoQuestionarioItem objQuestionarioDaoItem =
        SpsDaoQuestionarioItem();
    final int resultupdate = await objQuestionarioDaoItem.update_comentarios(
        _wcodigoEmpresa,
        _wcodigoProgramacao,
        null,
        null,
        _witemChecklist,
        _wdescrComentarios);
    this.widget._descr_comentarios = _wdescrComentarios;
    setState(() {});
  }

  String ajustar_comentarios(wcomentarios) {
    debugPrint(wcomentarios);
    return wcomentarios
        .replaceAll("</font></b>||", "\n")
        .replaceAll("<br>||", "\n\n")
        .replaceAll("<b><font color=blue>", "")
        .replaceAll("<b><font color=green>", "");
  }

  String obter_datahora() {
    final formatter = new NumberFormat("00");
    return formatter.format(DateTime.now().day) +
        "/" +
        formatter.format(DateTime.now().month) +
        "/" +
        formatter.format(DateTime.now().year) +
        " " +
        formatter.format(DateTime.now().hour) +
        ":" +
        formatter.format(DateTime.now().minute) +
        ":" +
        formatter.format(DateTime.now().second);
  }
}
