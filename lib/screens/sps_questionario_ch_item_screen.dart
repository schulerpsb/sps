import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sps/components/centered_message.dart';
import 'package:sps/components/progress.dart';
import 'package:sps/dao/sps_dao_questionario_class.dart';
import 'package:sps/dao/sps_dao_questionario_item_class.dart';
import 'file:///C:/Mobile/sps/lib/http/sps_http_verificar_conexao_class.dart';
import 'package:sps/http/sps_http_questionario_class.dart';
import 'package:sps/http/sps_http_questionario_item_class.dart';
import 'package:sps/models/sps_erro_conexao_class.dart';
import 'package:sps/models/sps_login.dart';
import 'package:sps/models/sps_questionario_item_ch.dart';
import 'package:sps/models/sps_usuario_class.dart';
import 'package:sps/screens/sps_drawer_screen.dart';
import 'package:sps/screens/sps_questionario_comentarios_screen.dart';
import 'package:sps/screens/sps_questionario_cq_comentarios_screen.dart';
import 'package:sps/screens/sps_questionario_midia_screen.dart';
import 'package:sps/screens/sps_questionario_ch_lista_screen.dart';

class sps_questionario_ch_item_screen extends StatefulWidget {
  final String _codigo_empresa;
  final int _codigo_programacao;
  final String _registro_colaborador;
  final String _identificacao_utilizador;
  final String _codigo_grupo;
  final int _codigo_checklist;
  final String _descr_programacao;
  final String _sincronizado;
  final String _status_aprovacao;
  final String _filtro;
  final String _filtroDescrProgramacao;

  final sps_usuario usuarioAtual;

  String _acao = "PROXIMO";
  String _sessao_checklist = "";

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
      );
}

class _sps_questionario_ch_item_screen
    extends State<sps_questionario_ch_item_screen> {
  final SpsQuestionarioItem_ch spsQuestionarioItem_ch =
      SpsQuestionarioItem_ch();

  final SpsLogin spslogin = SpsLogin();
  GlobalKey<ScaffoldState> _key = GlobalKey();

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
      _filtroReferenciaProjeto);

  var _singleValue = List();

  @override
  Widget build(BuildContext context) {
    debugPrint("TELA => SPS_QUESTIONARIO_CH_ITEM_SCREEN");
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => sps_questionario_ch_lista_screen(
                            this.widget._filtro,
                            this.widget._filtroDescrProgramacao)),
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
              this.widget._codigo_grupo,
              this.widget._codigo_checklist,
              this.widget._acao,
              this.widget._sessao_checklist),
          builder: (context, snapshot) {
            _singleValue.clear();
            debugPrint(snapshot.data.toString());
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
                                      color: Colors.indigo,
                                      onPressed: () {
                                        setState(() {
                                          this.widget._acao = "ANTERIOR";
                                        });
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
                                      color: Colors.indigo,
                                      onPressed: () {
                                        setState(() {
                                          this.widget._acao = "PROXIMO";
                                        });
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
                            child: ListView.builder(
                              padding: EdgeInsets.only(top: 5),
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  this.widget._sessao_checklist =
                                      snapshot.data[0]["sessao_checklist"];
                                }
                                if (snapshot.data[index]["sessao_checklist"] ==
                                    this.widget._sessao_checklist) {
                                  return Card(
                                    color: Colors.white60,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 0, left: 5, right: 5, bottom: 0),
                                      child: Column(
                                        children: [
                                          //Tratar descrição da pergunta
                                          descricao_pergunta(snapshot, index),

                                          //Tratar montagem do questionario
                                          montar_questionario(
                                              context, snapshot, index),

                                          Row(children: [
                                            //Tratar mídias
                                            tratar_midias(
                                                context, snapshot, index),

                                            //Tratar comentarios
                                            tratar_comentarios(
                                                context, snapshot, index),
                                          ]),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
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
      AsyncSnapshot<List<Map<String, dynamic>>> snapshot, int index) {
    return ListTile(
      trailing: snapshot.data[index]["status_resposta"] == "PREENCHIDA"
          ? Icon(Icons.check, color: Colors.green, size: 40)
          : null,
      title: Text(
          '${snapshot.data[index]["seq_pergunta"]}' +
              " - " +
              '${snapshot.data[index]["descr_pergunta"]}',
          style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15)),
    );
  }

  montar_questionario(BuildContext context,
      AsyncSnapshot<List<Map<String, dynamic>>> snapshot, int index) {
    //Tratar resposta fixa
    if (snapshot.data[index]["tipo_resposta"] == "RESPOSTA FIXA") {
      //Tratar resposta fixa (texto)
      if (snapshot.data[index]["tipo_resposta_fixa"] == "TEXTO") {
        TextEditingController _respTexto = TextEditingController();
        _respTexto.text = snapshot.data[index]["resp_texto"];

        //Ajustar tamanho do campo
        int _linhas;
        _linhas = (snapshot.data[index]["tamanho_resposta_fixa"] / 30).toInt();
        if (_linhas < 1) {
          _linhas = 1;
        }
        //Construir campo
        return TextField(
          controller: _respTexto,
          maxLines: _linhas,
          inputFormatters: [
            LengthLimitingTextInputFormatter(
                snapshot.data[index]["tamanho_resposta_fixa"]),
          ],
          textInputAction: TextInputAction.go,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: new OutlineInputBorder(
                borderSide: new BorderSide(color: Colors.teal)),
            contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            hintText: snapshot.data[index]["sugestao_resposta"],
            suffixIcon: IconButton(
              onPressed: () => {
                _gravar_resposta(
                    snapshot.data[index]["codigo_empresa"],
                    snapshot.data[index]["codigo_programacao"].toString(),
                    snapshot.data[index]["registro_colaborador"],
                    snapshot.data[index]["identificacao_utilizador"],
                    snapshot.data[index]["item_checklist"].toString(),
                    _respTexto.text,
                    snapshot.data[index]["comentarios"],
                    snapshot.data[index]["descr_comentarios"],
                    index),
              },
              icon: Icon(Icons.save),
            ),
          ),
        );
      }
    }
  }

  _gravar_resposta(
      _wcodigoEmpresa,
      _wcodigoProgramacao,
      _wregistroColaborador,
      _widentificacaoUtilizador,
      _witemChecklist,
      _wrespTexto,
      _wcomentarios,
      _wdescr_comentarios,
      _windex) async {
    var _wsincronizado = "";

    //Analisar status da resposta
    String _wstatusResposta;
    if (_wrespTexto == "") {
      _wstatusResposta = "PENDENTE";
    } else {
      _wstatusResposta = "PREENCHIDA";
      if (_wcomentarios == "OBRIGATORIO") {
        if (_wdescr_comentarios == "") {
          _wstatusResposta = "PENDENTE";
        }
      }
      /*if (snapshot.data[index]["midia"] == "OBRIGATORIO") {
            if (snapshot.data[index]["qtde_midia"] == 0) {
              _statusResposta = "PENDENTE";
            }
          }*/
    }

    //Verificar se existe conexão
    final SpsVerificarConexao ObjVerificarConexao = SpsVerificarConexao();
    final bool result = await ObjVerificarConexao.verificar_conexao();
    if (result == true) {
      //Gravar PostgreSQL (API REST)
      final SpsHttpQuestionarioItem objQuestionarioItemHttp =
          SpsHttpQuestionarioItem();
      final retorno = await objQuestionarioItemHttp.QuestionarioSaveResposta(
          _wcodigoEmpresa,
          _wcodigoProgramacao,
          _wregistroColaborador,
          _widentificacaoUtilizador,
          _witemChecklist,
          _wrespTexto,
          _wstatusResposta,
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
    final SpsDaoQuestionarioItem objQuestionarioItemDao =
        SpsDaoQuestionarioItem();
    final int resultupdate = await objQuestionarioItemDao.update_resposta(
        _wcodigoEmpresa,
        _wcodigoProgramacao,
        _wregistroColaborador,
        _widentificacaoUtilizador,
        _witemChecklist,
        _wrespTexto,
        _wstatusResposta,
        _wsincronizado);

    //Recarregar tela
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
            this.widget._filtroDescrProgramacao),
      ),
    );
  }

  tratar_midias(BuildContext context,
      AsyncSnapshot<List<Map<String, dynamic>>> snapshot, int index) {
    if (snapshot.data[index]["midia"] == "SIM" ||
        snapshot.data[index]["midia"] == "OBRIGATORIO") {
      return IconButton(
        icon: Icon(Icons.collections, size: 30),
        color: Colors.black,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => sps_questionario_midia_screen(
                    snapshot.data[index]["codigo_empresa"],
                    snapshot.data[index]["codigo_programacao"],
                    snapshot.data[index]["item_checklist"],
                    snapshot.data[index]["descr_comentarios"],
                    this.widget._registro_colaborador,
                    this.widget._identificacao_utilizador,
                    this.widget._codigo_grupo,
                    this.widget._codigo_checklist,
                    this.widget._descr_programacao,
                    null,
                    null,
                    null,
                    null,
                    null,
                    this.widget._sincronizado,
                    snapshot.data[index]["status_aprovacao"],
                    null,
                    this.widget._filtro,
                    this.widget._filtroDescrProgramacao)),
          );
        },
      );
    } else {
      return Text("");
    }
  }

  tratar_comentarios(BuildContext context,
      AsyncSnapshot<List<Map<String, dynamic>>> snapshot, int index) {
    if (snapshot.data[index]["comentarios"] == "SIM" ||
        snapshot.data[index]["comentarios"] == "OBRIGATORIO") {
      return IconButton(
        icon: Icon(Icons.comment, size: 30),
        color: snapshot.data[index]["descr_comentarios"] == ""
            ? Colors.black
            : Colors.blue,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => sps_questionario_comentarios_screen(
                snapshot.data[index]["codigo_empresa"],
                snapshot.data[index]["codigo_programacao"],
                snapshot.data[index]["item_checklist"],
                snapshot.data[index]["descr_comentarios"],
                this.widget._registro_colaborador,
                this.widget._identificacao_utilizador,
                this.widget._codigo_grupo,
                this.widget._codigo_checklist,
                this.widget._descr_programacao,
                this.widget._sincronizado,
                snapshot.data[index]["status_aprovacao"],
                null,
                this.widget._filtro,
                this.widget._filtroDescrProgramacao,
              ),
            ),
          );
        },
      );
    } else {
      return Text("");
    }
  }
}

class CustomRadioWidget<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final ValueChanged<T> onChanged;
  final double width;
  final double height;

  CustomRadioWidget(
      {this.value,
      this.groupValue,
      this.onChanged,
      this.width = 28,
      this.height = 28});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: GestureDetector(
        onTap: () {
          onChanged(this.value);
        },
        child: Container(
          height: this.height,
          width: this.width,
          decoration: ShapeDecoration(
            shape: CircleBorder(),
            gradient: LinearGradient(
              colors: [
                Colors.black,
                Colors.black,
              ],
            ),
          ),
          child: Center(
            child: Container(
              height: this.height - 5,
              width: this.width - 5,
              decoration: ShapeDecoration(
                shape: CircleBorder(),
                gradient: LinearGradient(
                  colors: value == groupValue
                      ? [
                          Colors.black,
                          Colors.blue,
                        ]
                      : [
                          Theme.of(context).scaffoldBackgroundColor,
                          Theme.of(context).scaffoldBackgroundColor,
                        ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
