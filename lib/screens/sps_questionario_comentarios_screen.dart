import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sps/dao/sps_dao_questionario_item_class.dart';
import 'file:///C:/Mobile/sps/lib/http/sps_http_verificar_conexao_class.dart';
import 'package:sps/http/sps_http_questionario_item_class.dart';
import 'package:sps/models/sps_login.dart';
import 'package:sps/models/sps_questionario_item_cq.dart';
import 'package:sps/models/sps_questionario_utils.dart';
import 'package:sps/models/sps_usuario_class.dart';
import 'package:sps/screens/sps_drawer_screen.dart';
import 'package:sps/screens/sps_questionario_ch_item_screen.dart';
import 'package:sps/screens/sps_questionario_cq_ext_item_screen.dart';
import 'package:intl/intl.dart';
import 'Dart:io';
import 'package:sps/screens/sps_questionario_cq_int_item_screen.dart';

class sps_questionario_comentarios_screen extends StatefulWidget {
  final String _codigo_empresa;
  final int _codigo_programacao;
  final int _item_checklist;
  String _descr_comentarios;
  final String _registro_colaborador;
  final String _identificacao_utilizador;
  final String _codigo_grupo;
  final int _codigo_checklist;
  final String _descr_programacao;
  final String _sincronizado;
  final String _status_aprovacao;
  final String _origemUsuario;
  final String _filtro;
  final String _filtroDescrProgramacao;
  final String _sessao_checklist;
  final int _indexLista;
  final String _tipo_questionario;

  sps_questionario_comentarios_screen(
      this._codigo_empresa,
      this._codigo_programacao,
      this._item_checklist,
      this._descr_comentarios,
      this._registro_colaborador,
      this._identificacao_utilizador,
      this._codigo_grupo,
      this._codigo_checklist,
      this._descr_programacao,
      this._sincronizado,
      this._status_aprovacao,
      this._origemUsuario,
      this._filtro,
      this._filtroDescrProgramacao,
      this._sessao_checklist,
      this._indexLista,
      this._tipo_questionario);

  @override
  _sps_questionario_comentarios_screen createState() =>
      _sps_questionario_comentarios_screen(
          this._codigo_empresa,
          this._codigo_programacao,
          this._item_checklist,
          this._descr_comentarios,
          this._registro_colaborador,
          this._identificacao_utilizador,
          this._codigo_grupo,
          this._codigo_checklist,
          this._descr_programacao,
          this._sincronizado,
          this._status_aprovacao,
          this._origemUsuario,
          this._filtro,
          this._filtroDescrProgramacao,
          this._sessao_checklist,
          this._indexLista,
          this._tipo_questionario);
}

class _sps_questionario_comentarios_screen
    extends State<sps_questionario_comentarios_screen> {
  final SpsQuestionarioItem spsQuestionarioItem = SpsQuestionarioItem();

  final SpsLogin spslogin = SpsLogin();
  GlobalKey<ScaffoldState> _key = GlobalKey();

  _sps_questionario_comentarios_screen(
      _codigo_empresa,
      _codigo_programacao,
      _item_checklist,
      _descr_comentarios,
      _registro_colaborador,
      _identificacao_utilizador,
      _codigo_grupo,
      _codigo_checklist,
      _descr_programacao,
      _sincronizado,
      _status_aprovacao,
      _origemUsuario,
      _filtro,
      _filtroDescrProgramacao,
      _sessao_checklist,
      _indexLista,
      _tipo_questionario);

  @override
  Widget build(BuildContext context) {
    debugPrint("TELA => SPS_QUESTIONARIO_COMENTARIOS_SCREEN");
    TextEditingController _novoComentario = TextEditingController();

    _novoComentario.text = this.widget._descr_comentarios;

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
                        builder: (context) => sps_questionario_ch_item_screen(
                            this.widget._codigo_empresa,
                            this.widget._codigo_programacao,
                            this.widget._registro_colaborador,
                            this.widget._identificacao_utilizador,
                            this.widget._codigo_grupo,
                            this.widget._codigo_checklist,
                            this.widget._descr_programacao,
                            this.widget._sincronizado,
                            this.widget._status_aprovacao,
                            this.widget._filtro,
                            this.widget._filtroDescrProgramacao,
                            "RECARREGAR",
                            this.widget._sessao_checklist,
                            this.widget._indexLista,
                            this.widget._tipo_questionario)),
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
                    top: 5, left: 10, right: 10, bottom: 10),
                child: Column(
                  children: <Widget>[
                    Text("Adicionar comentários",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15)),
                    Card(
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
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: FloatingActionButton(
                        onPressed: () => _gravar_comentario(
                            this.widget._codigo_empresa,
                            this.widget._codigo_programacao,
                            this.widget._registro_colaborador,
                            this.widget._identificacao_utilizador,
                            this.widget._item_checklist,
                            _novoComentario.text),
                        child: const Icon(Icons.add),
                      ),
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
      _wcodigoEmpresa,
      _wcodigoProgramacao,
      _wregistroColaborador,
      _widentificacaoUtilizador,
      _witemChecklist,
      _wdescrComentarios) async {
    var _wsincronizado = "";

    //Verificar se existe conexão
    final SpsVerificarConexao ObjVerificarConexao = SpsVerificarConexao();
    final bool result = await ObjVerificarConexao.verificar_conexao();
    if (result == true) {
      //Gravar PostgreSQL (API REST)
      final SpsHttpQuestionarioItem objQuestionarioItemHttp =
          SpsHttpQuestionarioItem();
      final retorno = await objQuestionarioItemHttp.QuestionarioSaveComentario(
          null,
          _wcodigoEmpresa,
          _wcodigoProgramacao.toString(),
          _wregistroColaborador,
          _widentificacaoUtilizador,
          _witemChecklist.toString(),
          _wdescrComentarios,
          usuarioAtual.tipo == "INTERNO" || usuarioAtual.tipo == "COLIGADA"
              ? usuarioAtual.registro_usuario
              : usuarioAtual.codigo_usuario);
      if (retorno == true) {
        _wsincronizado = "";
        debugPrint("registro gravado PostgreSQL");
      } else {
        _wsincronizado = "N";
        debugPrint("ERRO => registro não gravado PostgreSQL");
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
        _wregistroColaborador,
        _widentificacaoUtilizador,
        _witemChecklist,
        _wdescrComentarios);
    this.widget._descr_comentarios = _wdescrComentarios;

    //Atualizar status da resposta
    spsQuestionarioUtils objspsQuestionarioUtils = new spsQuestionarioUtils();
    await objspsQuestionarioUtils.atualizar_status_resposta(
        _wcodigoEmpresa,
        _wcodigoProgramacao,
        _wregistroColaborador,
        _widentificacaoUtilizador,
        _witemChecklist);

    //Retornar para tela de itens do questionário
    Navigator.pop;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => sps_questionario_ch_item_screen(
            this.widget._codigo_empresa,
            this.widget._codigo_programacao,
            this.widget._registro_colaborador,
            this.widget._identificacao_utilizador,
            this.widget._codigo_grupo,
            this.widget._codigo_checklist,
            this.widget._descr_programacao,
            this.widget._sincronizado,
            this.widget._status_aprovacao,
            this.widget._filtro,
            this.widget._filtroDescrProgramacao,
            "RECARREGAR",
            this.widget._sessao_checklist,
            this.widget._indexLista,
            this.widget._tipo_questionario),
      ),
    );
  }
}
