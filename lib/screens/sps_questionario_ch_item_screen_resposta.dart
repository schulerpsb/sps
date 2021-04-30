import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:sps/components/centered_message.dart';
import 'package:sps/components/progress.dart';
import 'package:sps/dao/sps_dao_questionario_class.dart';
import 'package:sps/dao/sps_dao_questionario_item_class.dart';
import 'package:sps/models/sps_erro_conexao_class.dart';
import 'package:sps/models/sps_login.dart';
import 'package:sps/models/sps_questionario_item_ch.dart';
import 'package:sps/models/sps_questionario_utils.dart';
import 'package:sps/models/sps_usuario_class.dart';
import 'package:sps/screens/sps_drawer_screen.dart';
import 'package:sps/screens/sps_questionario_ch_item_screen.dart';
import 'package:sps/screens/sps_questionario_comentarios_screen.dart';
import 'package:sps/screens/sps_questionario_midia_screen.dart';
import 'package:sps/screens/sps_questionario_ch_lista_screen.dart';
import 'package:badges/badges.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class sps_questionario_ch_item_screen_resposta extends StatefulWidget {
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
  int _item_checklist;

  final sps_usuario usuarioAtual;

  sps_questionario_ch_item_screen_resposta(
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
      this._item_checklist,
      {this.usuarioAtual = null});

  @override
  _sps_questionario_ch_item_screen_resposta createState() =>
      _sps_questionario_ch_item_screen_resposta(
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
        this._item_checklist,
      );
}

class _sps_questionario_ch_item_screen_resposta
    extends State<sps_questionario_ch_item_screen_resposta> {
  //Carregar Itens
  final SpsQuestionarioItem_ch_item spsQuestionarioItem_ch_item =
      SpsQuestionarioItem_ch_item();

  final SpsLogin spslogin = SpsLogin();

  _sps_questionario_ch_item_screen_resposta(
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
    _tipo_questionario,
    _item_checklist,
  );

  var _singleValue = List();

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  var tabConteudo = new List.generate(100, (_) => new List(4));
  var tabRespMultipla = new List.generate(100, (_) => new List(100));
  var tabTextoAdicional = new List.generate(100, (_) => new List(100));

  String _exibirSalvar = "SIM";
  var _wrespEscala;
  var _wrespSimNao;
  var _wrespNaoSeAplica;

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
                  var _salvar_pendente = false;
                  tabConteudo.forEach(
                    (element) async {
                      if (element[1] != null) {
                        _salvar_pendente = true;
                      }
                    },
                  );
                  if (_salvar_pendente == true) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("SPS App"),
                          content: Text(
                              "Você ainda não salvou o questionário, deseja realmente descartar?"),
                          actions: [
                            FlatButton(
                              child: Text("Não (Retornar ao questionário)"),
                              onPressed: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              },
                            ),
                            FlatButton(
                              child: Text("Sim (Descartar)"),
                              onPressed: () {
                                //Recarregar tela
                                Navigator.pop;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        sps_questionario_ch_item_screen(
                                            this.widget._codigo_empresa,
                                            this.widget._codigo_programacao,
                                            this.widget._registro_colaborador,
                                            this
                                                .widget
                                                ._identificacao_utilizador,
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
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else {
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
                            this.widget._filtroDescrProgramacao,
                            "RECARREGAR",
                            this.widget._sessao_checklist,
                            this.widget._indexLista,
                            this.widget._tipo_questionario),
                      ),
                    );
                  }
                },
              );
            },
          ),
        ),
        endDrawer: sps_drawer(spslogin: spslogin),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: spsQuestionarioItem_ch_item.listarQuestionarioItem_ch_item(
              this.widget._codigo_empresa,
              this.widget._codigo_programacao,
              this.widget._registro_colaborador,
              this.widget._identificacao_utilizador,
              this.widget._codigo_grupo,
              this.widget._codigo_checklist,
              this.widget._acao,
              this.widget._sessao_checklist,
              this.widget._item_checklist),
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
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
                          ],
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 5, left: 0, right: 0, bottom: 0),
                            child: SingleChildScrollView(
                              child: Card(
                                color: Colors.white60,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 0, left: 5, right: 5, bottom: 0),
                                  child: Column(
                                    children: [
                                      //Tratar descrição da pergunta
                                      descricao_pergunta(snapshot, 1),

                                      //Tratar montagem do questionario
                                      montar_questionario(context, snapshot),

                                      //Tratar não se aplica
                                      tratar_nao_se_aplica(context, snapshot),

                                      Row(
                                        children: [
                                          //Tratar mídias
                                          tratar_midias(context, snapshot),

                                          //Tratar comentarios
                                          tratar_comentarios(context, snapshot),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(5, 3, 5, 0),
                        ),
                        //Tratar botão SALVAR
                        Container(
                          width: 130,
                          height: 50,
                          padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                          child: Row(
                            children: [
                              RaisedButton.icon(
                                onPressed: () {
                                  _exibirSalvar == "SIM"
                                      ? _gravar_resposta(
                                          this.widget._codigo_empresa,
                                          this.widget._codigo_programacao,
                                          this.widget._registro_colaborador,
                                          this.widget._identificacao_utilizador,
                                        )
                                      : "";
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                label: Text(
                                  'SALVAR',
                                  style: TextStyle(color: Colors.white),
                                ),
                                icon: Icon(
                                  Icons.save,
                                  color: Colors.white,
                                ),
                                textColor: Colors.white,
                                splashColor:
                                    _exibirSalvar == "" ? null : Colors.red,
                                color: _exibirSalvar == ""
                                    ? Colors.grey
                                    : Colors.blue,
                              ),
                            ],
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
      AsyncSnapshot<List<Map<String, dynamic>>> snapshot, tamanho) {
    return ListTile(
      trailing: snapshot.data[0]["status_resposta"] == "PREENCHIDA"
          ? Icon(Icons.check, color: Colors.green, size: 40)
          : null,
      title: Text(
          '${snapshot.data[0]["seq_pergunta"]}' +
              " - " +
              '${snapshot.data[0]["descr_pergunta"]}',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
    );
  }

  montar_questionario(BuildContext context,
      AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
    int index = 0;

    //Identificar item_checklist na tabela de memoria
    tabConteudo[snapshot.data[index]["item_checklist"]][0] =
        snapshot.data[index]["item_checklist"];

    //Verificar se conteudo esta como "não se aplica"
    if (tabConteudo[snapshot.data[index]["item_checklist"]][1] == null) {
      if (snapshot.data[index]["resp_nao_se_aplica"].toString() == "SIM") {
        tabConteudo[snapshot.data[index]["item_checklist"]][3] =
            "NÃO SE APLICA";
      } else {
        tabConteudo[snapshot.data[index]["item_checklist"]][3] = "";
      }
    }

    //Tratar resposta fixa
    if (snapshot.data[index]["tipo_resposta"] == "RESPOSTA FIXA") {
      //Tratar resposta fixa (TEXTO/NUMERO/DATA/HORA)
      if (snapshot.data[index]["tipo_resposta_fixa"].toString() == "TEXTO" ||
          snapshot.data[index]["tipo_resposta_fixa"].toString() == "NUMERO" ||
          snapshot.data[index]["tipo_resposta_fixa"].toString() == "DATA" ||
          snapshot.data[index]["tipo_resposta_fixa"].toString() == "HORA") {
        TextEditingController _resposta = TextEditingController();
        if (snapshot.data[index]["tipo_resposta_fixa"].toString() == "TEXTO") {
          if (tabConteudo[snapshot.data[index]["item_checklist"]][2] == null) {
            _resposta.text = snapshot.data[index]["resp_texto"];
          } else {
            _resposta.text =
                tabConteudo[snapshot.data[index]["item_checklist"]][2];
          }
        }
        if (snapshot.data[index]["tipo_resposta_fixa"].toString() == "NUMERO") {
          if (tabConteudo[snapshot.data[index]["item_checklist"]][2] == null) {
            _resposta.text = snapshot.data[index]["resp_numero"]
                .toString()
                .replaceAll("null", "");
          } else {
            _resposta.text =
                tabConteudo[snapshot.data[index]["item_checklist"]][2];
          }
        }
        if (snapshot.data[index]["tipo_resposta_fixa"].toString() == "DATA") {
          _resposta.text = snapshot.data[index]["resp_data"];
        }
        if (snapshot.data[index]["tipo_resposta_fixa"].toString() == "HORA") {
          _resposta.text = snapshot.data[index]["resp_hora"];
        }
        //Ajustar tamanho do campo
        int _linhas;
        if (snapshot.data[index]["tipo_resposta_fixa"].toString() == "TEXTO" ||
            snapshot.data[index]["tipo_resposta_fixa"].toString() == "NUMERO") {
          _linhas =
              (snapshot.data[index]["tamanho_resposta_fixa"] / 30).toInt();
          if (_linhas < 1) {
            _linhas = 1;
          }
        }
        //Construir campo texto/numero
        if (snapshot.data[index]["tipo_resposta_fixa"].toString() == "TEXTO" ||
            snapshot.data[index]["tipo_resposta_fixa"].toString() == "NUMERO") {
          return TextField(
            controller: _resposta,
            maxLines: _linhas,
            inputFormatters: [
              LengthLimitingTextInputFormatter(
                  snapshot.data[index]["tamanho_resposta_fixa"]),
            ],
            textInputAction: TextInputAction.go,
            keyboardType: snapshot.data[index]["tipo_resposta_fixa"] == "TEXTO"
                ? TextInputType.text
                : TextInputType.number,
            onChanged: (novoTexto) => {
              tabConteudo[snapshot.data[index]["item_checklist"]][1] =
                  snapshot.data[index]["tipo_resposta_fixa"].toString(),
              tabConteudo[snapshot.data[index]["item_checklist"]][2] =
                  novoTexto,
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: new OutlineInputBorder(
                  borderSide: new BorderSide(color: Colors.teal)),
              contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              hintText: snapshot.data[index]["tipo_resposta_fixa"] == "TEXTO"
                  ? snapshot.data[index]["sugestao_resposta"]
                  : "",
            ),
          );
        } else {
          //Construir campo data
          if (snapshot.data[index]["tipo_resposta_fixa"].toString() == "DATA") {
            return Column(
              children: <Widget>[
                DateTimeField(
                  controller: TextEditingController(
                      text: snapshot.data[index]["resp_data"].toString()),
                  format: DateFormat("dd/MM/yyyy"),
                  onShowPicker: (context, currentValue) async {
                    final date = await showDatePicker(
                      context: context,
                      //locale: Locale("pt"),
                      firstDate: DateTime(1900),
                      initialDate: currentValue ??
                              snapshot.data[index]["resp_data"].toString() != ""
                          ? DateTime(
                              int.parse(snapshot.data[index]["resp_data"]
                                  .toString()
                                  .substring(0, 4)),
                              int.parse(snapshot.data[index]["resp_data"]
                                  .toString()
                                  .substring(5, 7)),
                              int.parse(snapshot.data[index]["resp_data"]
                                  .toString()
                                  .substring(8, 10)))
                          : DateTime.now(),
                      lastDate: DateTime(2100),
                      cancelText: "",
                      builder: (BuildContext context, Widget child) {
                        return MediaQuery(
                          data: MediaQuery.of(context),
                          child: child,
                        );
                      },
                    );
                    return date;
                  },
                  onChanged: (dt) {
                    try {
                      tabConteudo[snapshot.data[index]["item_checklist"]][1] =
                          snapshot.data[index]["tipo_resposta_fixa"];
                      tabConteudo[snapshot.data[index]["item_checklist"]][2] =
                          dt.toString().substring(0, 10);
                    } catch (e) {
                      tabConteudo[snapshot.data[index]["item_checklist"]][1] =
                          snapshot.data[index]["tipo_resposta_fixa"];
                      tabConteudo[snapshot.data[index]["item_checklist"]][2] =
                          "";
                    }
                  },
                ),
              ],
            );
          } else {
            //Construir campo hora
            if (snapshot.data[index]["tipo_resposta_fixa"].toString() ==
                "HORA") {
              final format = DateFormat("HH:mm");
              return Column(
                children: <Widget>[
                  DateTimeField(
                    controller: TextEditingController(
                        text: snapshot.data[index]["resp_hora"] != ""
                            ? snapshot.data[index]["resp_hora"].substring(0, 5)
                            : ""),
                    format: format,
                    onShowPicker: (context, currentValue) async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(
                            currentValue ?? DateTime.now()),
                        cancelText: "",
                        builder: (BuildContext context, Widget child) {
                          return MediaQuery(
                            data: MediaQuery.of(context)
                                .copyWith(alwaysUse24HourFormat: true),
                            child: child,
                          );
                        },
                      );
                      return DateTimeField.convert(time);
                    },
                    onChanged: (hr) {
                      try {
                        tabConteudo[snapshot.data[index]["item_checklist"]][1] =
                            snapshot.data[index]["tipo_resposta_fixa"];
                        tabConteudo[snapshot.data[index]["item_checklist"]][2] =
                            hr.toString().substring(11, 19);
                      } catch (e) {
                        tabConteudo[snapshot.data[index]["item_checklist"]][1] =
                            snapshot.data[index]["tipo_resposta_fixa"];
                        tabConteudo[snapshot.data[index]["item_checklist"]][2] =
                            "";
                      }
                    },
                  ),
                ],
              );
            } else {
              return TextField();
            }
          }
        }
      } else {
        return TextField();
      }
    } else {
      //Tratar resposta sim/não
      if (snapshot.data[index]["tipo_resposta"] == "RESPOSTA SIM/NÃO") {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              children: <Widget>[
                Row(
                  children: [
                    Text("     "),
                    Container(
                      child: CustomRadioWidget(
                        height: 20,
                        value: "SIM",
                        groupValue: _wrespSimNao == null
                            ? snapshot.data[index]["resp_simnao"]
                            : _wrespSimNao,
                        onChanged: (val) => {
                          tabConteudo[snapshot.data[index]["item_checklist"]]
                              [1] = "RESPOSTA SIM/NÃO",
                          tabConteudo[snapshot.data[index]["item_checklist"]]
                              [2] = "SIM",
                          setState(
                            () {
                              _wrespSimNao = val;
                            },
                          )
                        },
                      ),
                    ),
                    //Icon(Icons.check_box,color: Colors.green, size: 40),
                    Image.asset('images/positivo.png',
                        fit: BoxFit.contain, height: 40),
                    Text("          "),
                    Container(
                      child: CustomRadioWidget(
                        height: 20,
                        value: "NÃO",
                        groupValue: _wrespSimNao == null
                            ? snapshot.data[index]["resp_simnao"]
                            : _wrespSimNao,
                        onChanged: (val) => {
                          tabConteudo[snapshot.data[index]["item_checklist"]]
                              [1] = "RESPOSTA SIM/NÃO",
                          tabConteudo[snapshot.data[index]["item_checklist"]]
                              [2] = "NÃO",
                          setState(
                            () {
                              _wrespSimNao = val;
                            },
                          )
                        },
                      ),
                    ),
                    //Icon(Icons.check_box_outlined,color: Colors.red, size: 40),
                    Image.asset('images/negativo.png',
                        fit: BoxFit.contain, height: 40),
                  ],
                )
              ],
            );
          },
        );
      } else {
        //Tratar resposta por escala (resposta livre)
        if (snapshot.data[index]["tipo_resposta"] == "RESPOSTA POR ESCALA" &&
            int.parse(snapshot.data[index]["intervalo_escala"].toString(),
                    onError: (e) => 0) ==
                0) {
          double _currentSliderValue;
          if (snapshot.data[index]["resp_escala"] == null) {
            _currentSliderValue = 0;
          } else {
            _currentSliderValue =
                (snapshot.data[index]["resp_escala"] as num).toDouble();
          }
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                children: <Widget>[
                  Column(
                    children: [
                      Text(
                        snapshot.data[index]["descr_escala"],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            child: Text(
                                snapshot.data[index]["inicio_escala"]
                                    .toString(),
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                          ),
                          Container(
                            width: 300,
                            child: Slider(
                              value: _currentSliderValue,
                              min:
                                  (snapshot.data[index]["inicio_escala"] as num)
                                      .toDouble(),
                              max: (snapshot.data[index]["fim_escala"] as num)
                                  .toDouble(),
                              divisions:
                                  snapshot.data[index]["fim_escala"].round(),
                              label: _currentSliderValue.toString(),
                              onChanged: (val) {
                                _currentSliderValue = val;
                                tabConteudo[snapshot.data[index]
                                        ["item_checklist"]][1] =
                                    "RESPOSTA POR ESCALA";
                                tabConteudo[snapshot.data[index]
                                        ["item_checklist"]][2] =
                                    val.round().toString();
                                setState(
                                  () {
                                    _currentSliderValue =
                                        val.round().toDouble();
                                  },
                                );
                              },
                            ),
                          ),
                          Container(
                            child: Text(
                                snapshot.data[index]["fim_escala"].toString(),
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(_currentSliderValue.toString().replaceAll(".0", ""),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              );
            },
          );
        } else {
          //Tratar resposta por escala (com intervalo)
          if (snapshot.data[index]["tipo_resposta"] == "RESPOSTA POR ESCALA" &&
              int.parse(snapshot.data[index]["intervalo_escala"].toString(),
                      onError: (e) => 0) !=
                  0) {
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                //Preparar opções
                List<Widget> _listaOpcoes = [];
                //sentido - escala maior para meno
                if (snapshot.data[index]["inicio_escala"] <
                    snapshot.data[index]["fim_escala"]) {
                  var _ocorrencia = snapshot.data[index]["inicio_escala"];
                  while (_ocorrencia <= snapshot.data[index]["fim_escala"]) {
                    _listaOpcoes.add(
                      Column(
                        children: [
                          Row(
                            children: [
                              CustomRadioWidget(
                                height: 20,
                                value: _ocorrencia,
                                groupValue: _wrespEscala == null
                                    ? snapshot.data[index]["resp_escala"]
                                    : _wrespEscala,
                                onChanged: (val) => {
                                  tabConteudo[snapshot.data[index]
                                          ["item_checklist"]][1] =
                                      "RESPOSTA POR ESCALA",
                                  tabConteudo[snapshot.data[index]
                                      ["item_checklist"]][2] = val.toString(),
                                  setState(
                                    () {
                                      _wrespEscala = val;
                                    },
                                  )
                                },
                              ),
                              Text(_ocorrencia.toString(),
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    );
                    _ocorrencia =
                        _ocorrencia + snapshot.data[index]["intervalo_escala"];
                  }
                }
                //sentido - escala menor para maior
                if (snapshot.data[index]["inicio_escala"] >
                    snapshot.data[index]["fim_escala"]) {
                  var _ocorrencia = snapshot.data[index]["inicio_escala"];
                  while (_ocorrencia >= snapshot.data[index]["fim_escala"]) {
                    _listaOpcoes.add(
                      Column(
                        children: [
                          Row(
                            children: [
                              CustomRadioWidget(
                                height: 20,
                                value: _ocorrencia,
                                groupValue: _wrespEscala == null
                                    ? snapshot.data[index]["resp_escala"]
                                    : _wrespEscala,
                                onChanged: (val) => {
                                  tabConteudo[snapshot.data[index]
                                          ["item_checklist"]][1] =
                                      "RESPOSTA POR ESCALA",
                                  tabConteudo[snapshot.data[index]
                                      ["item_checklist"]][2] = val.toString(),
                                  setState(
                                    () {
                                      _wrespEscala = val;
                                    },
                                  )
                                },
                              ),
                              Text(_ocorrencia.toString(),
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    );
                    _ocorrencia =
                        _ocorrencia - snapshot.data[index]["intervalo_escala"];
                  }
                }

                //Exibir opções
                return Column(
                  children: <Widget>[
                    Column(
                      children: [
                        Text(
                          snapshot.data[index]["descr_escala"],
                        ),
                      ],
                    ),
                    Column(children: _listaOpcoes),
                  ],
                );
              },
            );
          } else {
            //Tratar resposta Multipla
            if (snapshot.data[index]["tipo_resposta"] == "RESPOSTA MULTIPLA") {
              var windex_inicial = index;
              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  List<Widget> _listaRespMultipla = [];
                  var witem_checklist_ant =
                      snapshot.data[index]["item_checklist"];
                  var wparar = false;
                  var windex_inicio = index;
                  var wqtde_texto_adicional = 0;
                  while (snapshot.data[index]["item_checklist"] ==
                          witem_checklist_ant &&
                      wparar == false) {
                    if (snapshot.data[index]["tamanho_texto_adicional"]
                                .toString() !=
                            null &&
                        snapshot.data[index]["tamanho_texto_adicional"]
                                .toString() !=
                            "null" &&
                        snapshot.data[index]["tamanho_texto_adicional"]
                                .toString() !=
                            "" &&
                        snapshot.data[index]["tamanho_texto_adicional"] != 0) {
                      wqtde_texto_adicional = wqtde_texto_adicional + 1;
                    }
                    if (snapshot.data.length - 1 == index) {
                      wparar = true;
                    } else {
                      index = index + 1;
                    }
                  }

                  int witens = index - windex_inicio;
                  if (wparar == true) {
                    witens = index - windex_inicio + 1;
                  }
                  double wtamanho = witens * 65.toDouble();
                  wtamanho = wtamanho + (wqtde_texto_adicional * 60.toDouble());

                  _listaRespMultipla.add(
                    Transform.scale(
                      scale: .85,
                      child: Container(
                        //color: Colors.green, // Cinza
                        height: wtamanho,
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: ListView.builder(
                          itemCount: witens,
                          itemBuilder: (BuildContext context, int indexList) {
                            indexList = indexList + windex_inicio;
                            return new Card(
                              child: new Column(
                                children: <Widget>[
                                  new CheckboxListTile(
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    title: Text(
                                        snapshot.data[indexList]
                                            ["descr_sub_tpresposta"],
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal)),
                                    value: tabRespMultipla[
                                                    snapshot.data[indexList]
                                                        ["item_checklist"]][
                                                snapshot.data[indexList]
                                                    ["subcodigo_tpresposta"]] ==
                                            null
                                        ? snapshot.data[indexList]
                                                    ["subcodigo_tpresposta"] ==
                                                snapshot.data[indexList]
                                                    ["subcodigo_resposta"]
                                            ? true
                                            : false
                                        : tabRespMultipla[snapshot.data[indexList]["item_checklist"]]
                                                        [snapshot.data[indexList]["subcodigo_tpresposta"]]
                                                    .toString() ==
                                                "true"
                                            ? true
                                            : false,
                                    onChanged: (val) => {
                                      tabConteudo[snapshot.data[indexList]
                                              ["item_checklist"]][1] =
                                          "RESPOSTA MULTIPLA",
                                      tabRespMultipla[snapshot.data[indexList]
                                              ["item_checklist"]][
                                          snapshot.data[indexList]
                                              ["subcodigo_tpresposta"]] = val,
                                      setState(
                                        () {
                                          //_wrespMultipla[snapshot.data[indexList]["item_checklist"]] [snapshot.data[indexList]["subcodigo_tpresposta"]] = val;
                                          index = windex_inicial;
                                        },
                                      )
                                    },
                                  ),
                                  textoAdicionalRespostaMultipla(
                                      snapshot, indexList),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );

                  return Column(
                    children: <Widget>[
                      Column(children: _listaRespMultipla),
                    ],
                  );
                },
              );
            } else {
              return TextField();
            }
          }
        }
      }
    }
  }

  Padding textoAdicionalRespostaMultipla(
      AsyncSnapshot<List<Map<String, dynamic>>> snapshot, int indexList) {
    if (snapshot.data[indexList]["tamanho_texto_adicional"] != null) {
      TextEditingController _textoAdicional = TextEditingController();
      if (tabTextoAdicional[snapshot.data[indexList]["item_checklist"]]
                      [snapshot.data[indexList]["subcodigo_tpresposta"]]
                  .toString() ==
              "null" ||
          tabTextoAdicional[snapshot.data[indexList]["item_checklist"]]
                      [snapshot.data[indexList]["subcodigo_tpresposta"]]
                  .toString() ==
              null) {
        tabTextoAdicional[snapshot.data[indexList]["item_checklist"]]
                [snapshot.data[indexList]["subcodigo_tpresposta"]] =
            snapshot.data[indexList]["texto_adicional"];
      }

      _textoAdicional.text =
          tabTextoAdicional[snapshot.data[indexList]["item_checklist"]]
              [snapshot.data[indexList]["subcodigo_tpresposta"]];
      return Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        child: TextField(
          controller: _textoAdicional,
          maxLines: 2,
          inputFormatters: [
            LengthLimitingTextInputFormatter(
                snapshot.data[indexList]["tamanho_texto_adicional"]),
          ],
          textInputAction: TextInputAction.go,
          keyboardType: TextInputType.text,
          onChanged: (novoTexto) => {
            tabConteudo[snapshot.data[indexList]["item_checklist"]][1] =
                "RESPOSTA MULTIPLA",
            tabRespMultipla[snapshot.data[indexList]["item_checklist"]]
                [snapshot.data[indexList]["subcodigo_tpresposta"]] = true,
            //_textoAdicional.text = novoTexto,
            tabTextoAdicional[snapshot.data[indexList]["item_checklist"]]
                [snapshot.data[indexList]["subcodigo_tpresposta"]] = novoTexto,
            print(
                "adriano=>tabTextoAdicional[snapshot.data[indexList][item_checklist]]=>" +
                    tabTextoAdicional[snapshot.data[indexList]
                            ["item_checklist"]]
                        .toString()),
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white60,
            border: new OutlineInputBorder(
                borderSide: new BorderSide(color: Colors.teal)),
            contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(0.0),
      );
    }
  }

  // Padding textoAdicionalRespostaMultiplaAlerta(
  //     AsyncSnapshot<List<Map<String, dynamic>>> snapshot, int indexList) {
  //   if (snapshot.data[indexList]["tamanho_texto_adicional"] != null) {
  //     return Padding(
  //       padding: const EdgeInsets.fromLTRB(10, 0, 0, 2),
  //       child: Text(
  //         "Clique em OK após digitar",
  //         style: TextStyle(fontSize: 10, color: Colors.blue),
  //       ),
  //     );
  //   } else {
  //     return Padding(
  //       padding: const EdgeInsets.all(0.0),
  //     );
  //   }
  // }

  tratar_nao_se_aplica(BuildContext context,
      AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Align(
          alignment: Alignment.centerLeft,
          child: CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            title: Text("Não se aplica",
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold)),
            value: _wrespNaoSeAplica == null
                ? snapshot.data[0]["resp_nao_se_aplica"].toString() == "" ||
                        snapshot.data[0]["resp_nao_se_aplica"] == null
                    ? false
                    : true
                : _wrespNaoSeAplica,
            onChanged: (val) {
              if (val == true) {
                if (tabConteudo[snapshot.data[0]["item_checklist"]][1] ==
                    null) {
                  tabConteudo[snapshot.data[0]["item_checklist"]][1] =
                      "NÃO SE APLICA";
                }
                tabConteudo[snapshot.data[0]["item_checklist"]][3] =
                    "NÃO SE APLICA";
              } else {
                if (tabConteudo[snapshot.data[0]["item_checklist"]][1] ==
                    null) {
                  tabConteudo[snapshot.data[0]["item_checklist"]][1] =
                      "NÃO SE APLICA";
                }
                tabConteudo[snapshot.data[0]["item_checklist"]][3] = "";
              }
              setState(
                () {
                  _wrespNaoSeAplica = val;
                },
              );
            },
          ),
        );
      },
    );
  }

  _gravar_resposta(
    _wcodigoEmpresa,
    _wcodigoProgramacao,
    _wregistroColaborador,
    _widentificacaoUtilizador,
  ) async {
    var _wsincronizado = "N";
    var _witemChecklist;
    var _wrespTexto;
    var _wrespNumero;
    var _wrespData;
    var _wrespHora;
    var _wrespSimnao;
    var _wrespEscala;
    var _wsubcodigoTpresposta;
    var _wsubcodigoResposta;
    var _wtextoAdicional;

    await Future.forEach(
      tabConteudo,
      (element) async {
        if (element[1] != null) {
          _witemChecklist = element[0];
          _wsubcodigoTpresposta = 0;

          //Limpar variaveis
          _wrespTexto = "";
          _wrespNumero = null;
          _wrespData = "";
          _wrespHora = "";
          _wrespSimnao = "";
          _wrespEscala = null;
          _wsubcodigoResposta = null;
          _wtextoAdicional = "";

          if (element[3] != "NÃO SE APLICA") {
            //Carregar variaveis
            if (element[1] == "TEXTO") {
              _wrespTexto = element[2];
            }
            if (element[1] == "NUMERO") {
              _wrespNumero = element[2];
            }
            if (element[1] == "DATA") {
              _wrespData = element[2];
            }
            if (element[1] == "HORA") {
              _wrespHora = element[2];
            }
            if (element[1] == "RESPOSTA SIM/NÃO") {
              _wrespSimnao = element[2];
            }
            if (element[1] == "RESPOSTA POR ESCALA") {
              _wrespEscala = element[2];
            }
          }

          if (element[1] == "RESPOSTA MULTIPLA") {
            int windex = 0;
            while (windex < 100) {
              if (tabRespMultipla[_witemChecklist][windex] != null) {
                _wsubcodigoTpresposta = windex;

                if (element[3] != "NÃO SE APLICA") {
                  if (tabRespMultipla[_witemChecklist][windex] == true) {
                    _wsubcodigoResposta = windex;
                  } else {
                    _wsubcodigoResposta = null;
                  }
                  if (tabTextoAdicional[_witemChecklist][windex] == null ||
                      tabRespMultipla[_witemChecklist][windex] == false) {
                    _wtextoAdicional = "";
                  } else {
                    _wtextoAdicional =
                        tabTextoAdicional[_witemChecklist][windex];
                  }
                } else {
                  _wsubcodigoResposta = null;
                  _wtextoAdicional = "";
                }

                //Gravar SQlite (Respostas)
                final SpsDaoQuestionarioItem objQuestionarioItemDao =
                    SpsDaoQuestionarioItem();
                final int resultupdate =
                    await objQuestionarioItemDao.update_resposta(
                        _wcodigoEmpresa,
                        _wcodigoProgramacao,
                        _wregistroColaborador,
                        _widentificacaoUtilizador,
                        _witemChecklist,
                        _wrespTexto,
                        _wrespNumero,
                        _wrespData,
                        _wrespHora,
                        _wrespSimnao,
                        _wrespEscala,
                        _wsubcodigoTpresposta,
                        _wsubcodigoResposta,
                        _wtextoAdicional,
                        _wsincronizado);
              }
              windex = windex + 1;
            }
            ;
          } else {
            final SpsDaoQuestionarioItem objQuestionarioItemDao =
                SpsDaoQuestionarioItem();
            final int resultupdate =
                await objQuestionarioItemDao.update_resposta(
                    _wcodigoEmpresa,
                    _wcodigoProgramacao,
                    _wregistroColaborador,
                    _widentificacaoUtilizador,
                    _witemChecklist,
                    _wrespTexto,
                    _wrespNumero,
                    _wrespData,
                    _wrespHora,
                    _wrespSimnao,
                    _wrespEscala,
                    _wsubcodigoTpresposta,
                    _wsubcodigoResposta,
                    _wtextoAdicional,
                    _wsincronizado);
          }

          if (element[1] == "RESPOSTA MULTIPLA") {
            if (element[3] != "NÃO SE APLICA") {
              //Gravar SQlite (Respostas)
              final SpsDaoQuestionarioItem objQuestionarioItemDao =
                  SpsDaoQuestionarioItem();
              final int resultupdate =
                  await objQuestionarioItemDao.update_resposta_nao_se_aplica_2(
                      _wcodigoEmpresa,
                      _wcodigoProgramacao,
                      _wregistroColaborador,
                      _widentificacaoUtilizador,
                      _witemChecklist,
                      "",
                      _wsincronizado);
            }
          } else {
            if (element[1] == "NÃO SE APLICA" ||
                element[3] == "NÃO SE APLICA") {
              //Gravar SQlite (Respostas)
              final SpsDaoQuestionarioItem objQuestionarioItemDao =
                  SpsDaoQuestionarioItem();
              final int resultupdate =
                  await objQuestionarioItemDao.update_resposta_nao_se_aplica(
                      _wcodigoEmpresa,
                      _wcodigoProgramacao,
                      _wregistroColaborador,
                      _widentificacaoUtilizador,
                      _witemChecklist,
                      element[3] == "NÃO SE APLICA" ? "SIM" : "",
                      _wsincronizado);
            }
          }

          //Atualizar status da resposta
          spsQuestionarioUtils objspsQuestionarioUtils =
              new spsQuestionarioUtils();
          await objspsQuestionarioUtils.atualizar_status_resposta(
              _wcodigoEmpresa,
              _wcodigoProgramacao,
              _wregistroColaborador,
              _widentificacaoUtilizador,
              _witemChecklist);
        }
      },
    );

    //Analisar e Atualizar Status da Lista (cabecalho) em função do status da resposta
    final SpsDaoQuestionario objQuestionarioDao = SpsDaoQuestionario();
    final int resultupdateLista =
        await objQuestionarioDao.update_lista_status_resposta(
            _wcodigoEmpresa,
            _wcodigoProgramacao,
            _wregistroColaborador,
            _widentificacaoUtilizador);

    //Limpar matriz
    tabConteudo.clear();
    tabConteudo = new List.generate(100, (_) => new List(4));
    tabRespMultipla.clear();
    tabRespMultipla = new List.generate(100, (_) => new List(99));
    tabTextoAdicional.clear();
    tabTextoAdicional = new List.generate(100, (_) => new List(99));

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
            this.widget._filtroDescrProgramacao,
            "RECARREGAR",
            this.widget._sessao_checklist,
            this.widget._indexLista,
            this.widget._tipo_questionario),
      ),
    );
  }

  tratar_midias(BuildContext context,
      AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
    if (snapshot.data[0]["midia"] == "SIM" ||
        snapshot.data[0]["midia"] == "OBRIGATORIO") {
      return IconButton(
        icon: Badge(
          badgeContent: Text(snapshot.data[0]["anexos"].toString(),
              style: TextStyle(color: Colors.white, fontSize: 8)),
          showBadge: snapshot.data[0]["anexos"] > 0 ? true : false,
          badgeColor: Color(0xFF004077),
          child: Icon(Icons.collections, size: 30),
        ),
        color: snapshot.data[0]["anexos"] > 0 ? Colors.blue : Colors.black,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => sps_questionario_midia_screen(
                      snapshot.data[0]["codigo_empresa"],
                      snapshot.data[0]["codigo_programacao"],
                      snapshot.data[0]["item_checklist"],
                      snapshot.data[0]["descr_comentarios"],
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
                      null,
                      null,
                      this.widget._sincronizado,
                      snapshot.data[0]["status_aprovacao"],
                      null,
                      this.widget._filtro,
                      0,
                      this.widget._filtroDescrProgramacao,
                      snapshot.data[0]["imagens"].toString(),
                      snapshot.data[0]["videos"].toString(),
                      snapshot.data[0]["outros"].toString(),
                      "RECARREGAR",
                    )),
          );
        },
      );
    } else {
      return Text("");
    }
  }

  tratar_comentarios(BuildContext context,
      AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
    if (snapshot.data[0]["comentarios"] == "SIM" ||
        snapshot.data[0]["comentarios"] == "OBRIGATORIO" ||
        ((snapshot.data[0]["comentario_resposta_nao"] == "SIM" ||
                snapshot.data[0]["comentario_resposta_nao"] == "OBRIGATORIO") &&
            snapshot.data[0]["resp_simnao"] == "NÃO") ||
        (snapshot.data[0]["comentario_escala"] != null &&
            int.parse(snapshot.data[0]["resp_escala"].toString(),
                    onError: (e) => 0) <
                snapshot.data[0]["comentario_escala"])) {
      return IconButton(
        icon: Icon(Icons.comment, size: 30),
        color: snapshot.data[0]["descr_comentarios"] == "" ||
                snapshot.data[0]["descr_comentarios"] == null
            ? Colors.black
            : Colors.blue,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => sps_questionario_comentarios_screen(
                  snapshot.data[0]["codigo_empresa"],
                  snapshot.data[0]["codigo_programacao"],
                  snapshot.data[0]["item_checklist"],
                  snapshot.data[0]["descr_comentarios"],
                  this.widget._registro_colaborador,
                  this.widget._identificacao_utilizador,
                  this.widget._codigo_grupo,
                  this.widget._codigo_checklist,
                  this.widget._descr_programacao,
                  this.widget._sincronizado,
                  snapshot.data[0]["status_aprovacao"],
                  null,
                  this.widget._filtro,
                  this.widget._filtroDescrProgramacao,
                  this.widget._sessao_checklist,
                  0,
                  this.widget._tipo_questionario),
            ),
          );
        },
      );
    } else {
      return Text("");
    }
  }
}
