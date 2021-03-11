import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:sps/components/centered_message.dart';
import 'package:sps/components/progress.dart';
import 'package:sps/dao/sps_dao_questionario_item_class.dart';
import 'package:sps/models/sps_erro_conexao_class.dart';
import 'package:sps/models/sps_login.dart';
import 'package:sps/models/sps_questionario_item_ch.dart';
import 'package:sps/models/sps_questionario_utils.dart';
import 'package:sps/models/sps_usuario_class.dart';
import 'package:sps/screens/sps_drawer_screen.dart';
import 'package:sps/screens/sps_questionario_comentarios_screen.dart';
import 'package:sps/screens/sps_questionario_midia_screen.dart';
import 'package:sps/screens/sps_questionario_ch_lista_screen.dart';
import 'package:badges/badges.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
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

  //String _acao = "";
  //String _sessao_checklist = "";

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
  final SpsQuestionarioItem_ch spsQuestionarioItem_ch =
      SpsQuestionarioItem_ch();

  final SpsLogin spslogin = SpsLogin();

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

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  posicionaLista(indexLista) {
    itemScrollController.scrollTo(
        index: indexLista, duration: Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("TELA => SPS_QUESTIONARIO_CH_ITEM_SCREEN");

    if (this.widget._tipo_questionario == "PESQUISA") {
      if (sps_usuario().tipo == "INTERNO" || sps_usuario().tipo == "COLIGADA") {
        this.widget._registro_colaborador = sps_usuario().registro_usuario;
        this.widget._identificacao_utilizador = '';
      }else{
        this.widget._registro_colaborador = '';
        this.widget._identificacao_utilizador = sps_usuario().codigo_usuario;
      }
    }

    //print ("adriano => "+this.widget._registro_colaborador.toString());

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
                                      color: snapshot.data[0]
                                                  ["sessao_anterior"] !=
                                              0
                                          ? Colors.indigo
                                          : Colors.black12,
                                      onPressed: () {
                                        snapshot.data[0]["sessao_anterior"] != 0
                                            ? setState(
                                                () {
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
                              //controller: _controller,
                              padding: EdgeInsets.only(top: 5),
                              itemScrollController: itemScrollController,
                              itemPositionsListener: itemPositionsListener,
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  this.widget._sessao_checklist =
                                      snapshot.data[0]["sessao_checklist"];
                                }
                                if (snapshot.data[index]["sessao_checklist"] ==
                                    this.widget._sessao_checklist) {
                                  return Container(
                                    child: Card(
                                      color: Colors.white60,
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

                                            //Tratar montagem do questionario
                                            montar_questionario(
                                                context, snapshot, index),

                                            //Tratar não se aplica
                                            tratar_nao_se_aplica(
                                                context, snapshot, index),

                                            Row(
                                              children: [
                                                //Tratar mídias
                                                tratar_midias(
                                                    context, snapshot, index),

                                                //Tratar comentarios
                                                tratar_comentarios(
                                                    context, snapshot, index),
                                              ],
                                            ),

                                            tratar_posicionar_lista(index),
                                          ],
                                        ),
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
      AsyncSnapshot<List<Map<String, dynamic>>> snapshot, int index, tamanho) {
    return ListTile(
      trailing: snapshot.data[index]["status_resposta"] == "PREENCHIDA"
          ? Icon(Icons.check, color: Colors.green, size: 40)
          : null,
      title: Text(
          '${snapshot.data[index]["seq_pergunta"]}' +
              " - " +
              '${snapshot.data[index]["descr_pergunta"]}',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
    );
  }

  montar_questionario(BuildContext context,
      AsyncSnapshot<List<Map<String, dynamic>>> snapshot, int index) {
    //Tratar resposta fixa
    if (snapshot.data[index]["tipo_resposta"] == "RESPOSTA FIXA") {
      //Tratar resposta fixa (TEXTO/NUMERO/DATA/HORA)
      if (snapshot.data[index]["tipo_resposta_fixa"].toString() == "TEXTO" ||
          snapshot.data[index]["tipo_resposta_fixa"].toString() == "NUMERO" ||
          snapshot.data[index]["tipo_resposta_fixa"].toString() == "DATA" ||
          snapshot.data[index]["tipo_resposta_fixa"].toString() == "HORA") {
        TextEditingController _respTexto = TextEditingController();
        TextEditingController _respNumero = TextEditingController();
        TextEditingController _respData = TextEditingController();
        TextEditingController _respHora = TextEditingController();
        if (snapshot.data[index]["tipo_resposta_fixa"].toString() == "TEXTO") {
          _respTexto.text = snapshot.data[index]["resp_texto"];
        }
        if (snapshot.data[index]["tipo_resposta_fixa"].toString() == "NUMERO") {
          _respNumero.text = snapshot.data[index]["resp_numero"]
              .toString()
              .replaceAll("null", "");
        }
        if (snapshot.data[index]["tipo_resposta_fixa"].toString() == "DATA") {
          _respData.text = snapshot.data[index]["resp_data"];
        }
        if (snapshot.data[index]["tipo_resposta_fixa"].toString() == "HORA") {
          _respHora.text = snapshot.data[index]["resp_hora"];
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
            controller: snapshot.data[index]["tipo_resposta_fixa"] == "TEXTO"
                ? _respTexto
                : _respNumero,
            maxLines: _linhas,
            inputFormatters: [
              LengthLimitingTextInputFormatter(
                  snapshot.data[index]["tamanho_resposta_fixa"]),
            ],
            textInputAction: TextInputAction.go,
            keyboardType: snapshot.data[index]["tipo_resposta_fixa"] == "TEXTO"
                ? TextInputType.text
                : TextInputType.number,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: new OutlineInputBorder(
                  borderSide: new BorderSide(color: Colors.teal)),
              contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              hintText: snapshot.data[index]["tipo_resposta_fixa"] == "TEXTO"
                  ? snapshot.data[index]["sugestao_resposta"]
                  : "",
              suffixIcon: IconButton(
                onPressed: () => {
                  this.widget._acao = "RECARREGAR",
                  _gravar_resposta(
                      snapshot.data[index]["codigo_empresa"],
                      snapshot.data[index]["codigo_programacao"].toString(),
                      snapshot.data[index]["registro_colaborador"],
                      snapshot.data[index]["identificacao_utilizador"],
                      snapshot.data[index]["item_checklist"].toString(),
                      _respTexto.text,
                      _respNumero.text,
                      _respData.text,
                      _respHora.text,
                      snapshot.data[index]["resp_simnao"],
                      snapshot.data[index]["resp_escala"],
                      snapshot.data[index]["comentarios"],
                      snapshot.data[index]["descr_comentarios"],
                      "",
                      index),
                },
                icon: Icon(Icons.save),
              ),
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
                      locale: Locale("pt"),
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
                          data: MediaQuery.of(context)
                              .copyWith(alwaysUse24HourFormat: true),
                          child: child,
                        );
                      },
                    );
                    return date;
                  },
                  onChanged: (dt) {
                    try {
                      this.widget._acao = "RECARREGAR";
                      _gravar_resposta(
                          snapshot.data[index]["codigo_empresa"],
                          snapshot.data[index]["codigo_programacao"].toString(),
                          snapshot.data[index]["registro_colaborador"],
                          snapshot.data[index]["identificacao_utilizador"],
                          snapshot.data[index]["item_checklist"].toString(),
                          _respTexto.text,
                          _respNumero.text,
                          dt.toString().substring(0, 10),
                          _respHora.text,
                          snapshot.data[index]["resp_simnao"],
                          snapshot.data[index]["resp_escala"],
                          snapshot.data[index]["comentarios"],
                          snapshot.data[index]["descr_comentarios"],
                          "",
                          index);
                    } catch (e) {
                      this.widget._acao = "RECARREGAR";
                      _gravar_resposta(
                          snapshot.data[index]["codigo_empresa"],
                          snapshot.data[index]["codigo_programacao"].toString(),
                          snapshot.data[index]["registro_colaborador"],
                          snapshot.data[index]["identificacao_utilizador"],
                          snapshot.data[index]["item_checklist"].toString(),
                          _respTexto.text,
                          _respNumero.text,
                          "",
                          _respHora.text,
                          snapshot.data[index]["resp_simnao"],
                          snapshot.data[index]["resp_escala"],
                          snapshot.data[index]["comentarios"],
                          snapshot.data[index]["descr_comentarios"],
                          "",
                          index);
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
                        if (hr.toString().substring(11, 19) != "00:00:00") {
                          this.widget._acao = "RECARREGAR";
                          _gravar_resposta(
                              snapshot.data[index]["codigo_empresa"],
                              snapshot.data[index]["codigo_programacao"]
                                  .toString(),
                              snapshot.data[index]["registro_colaborador"],
                              snapshot.data[index]["identificacao_utilizador"],
                              snapshot.data[index]["item_checklist"].toString(),
                              _respTexto.text,
                              _respNumero.text,
                              _respData.text,
                              hr.toString().substring(11, 19),
                              snapshot.data[index]["resp_simnao"],
                              snapshot.data[index]["resp_escala"],
                              snapshot.data[index]["comentarios"],
                              snapshot.data[index]["descr_comentarios"],
                              "",
                              index);
                        }
                      } catch (e) {
                        this.widget._acao = "RECARREGAR";
                        _gravar_resposta(
                            snapshot.data[index]["codigo_empresa"],
                            snapshot.data[index]["codigo_programacao"]
                                .toString(),
                            snapshot.data[index]["registro_colaborador"],
                            snapshot.data[index]["identificacao_utilizador"],
                            snapshot.data[index]["item_checklist"].toString(),
                            _respTexto.text,
                            _respNumero.text,
                            _respData.text,
                            "",
                            snapshot.data[index]["resp_simnao"],
                            snapshot.data[index]["resp_escala"],
                            snapshot.data[index]["comentarios"],
                            snapshot.data[index]["descr_comentarios"],
                            "",
                            index);
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
        return Column(
          children: <Widget>[
            Column(
              children: [
                Row(
                  children: [
                    Text("     "),
                    Container(
                      child: CustomRadioWidget(
                        height: 20,
                        value: "SIM",
                        groupValue: snapshot.data[index]["resp_simnao"],
                        onChanged: (value) => {
                          this.widget._acao = "RECARREGAR",
                          _gravar_resposta(
                              snapshot.data[index]["codigo_empresa"],
                              snapshot.data[index]["codigo_programacao"]
                                  .toString(),
                              snapshot.data[index]["registro_colaborador"],
                              snapshot.data[index]["identificacao_utilizador"],
                              snapshot.data[index]["item_checklist"].toString(),
                              snapshot.data[index]["resp_texto"],
                              snapshot.data[index]["resp_numero"],
                              snapshot.data[index]["resp_data"],
                              snapshot.data[index]["resp_hora"],
                              "SIM",
                              snapshot.data[index]["resp_escala"],
                              snapshot.data[index]["comentarios"],
                              snapshot.data[index]["descr_comentarios"],
                              "",
                              index)
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
                        groupValue: snapshot.data[index]["resp_simnao"],
                        onChanged: (value) => {
                          this.widget._acao = "RECARREGAR",
                          _gravar_resposta(
                              snapshot.data[index]["codigo_empresa"],
                              snapshot.data[index]["codigo_programacao"]
                                  .toString(),
                              snapshot.data[index]["registro_colaborador"],
                              snapshot.data[index]["identificacao_utilizador"],
                              snapshot.data[index]["item_checklist"].toString(),
                              snapshot.data[index]["resp_texto"],
                              snapshot.data[index]["resp_numero"],
                              snapshot.data[index]["resp_data"],
                              snapshot.data[index]["resp_hora"],
                              "NÃO",
                              snapshot.data[index]["resp_escala"],
                              snapshot.data[index]["comentarios"],
                              snapshot.data[index]["descr_comentarios"],
                              "",
                              index)
                        },
                      ),
                    ),
                    //Icon(Icons.check_box_outlined,color: Colors.red, size: 40),
                    Image.asset('images/negativo.png',
                        fit: BoxFit.contain, height: 40),
                  ],
                )
              ],
            ),
          ],
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
                            snapshot.data[index]["inicio_escala"].toString(),
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        width: 350,
                        child: Slider(
                          value: _currentSliderValue,
                          min: (snapshot.data[index]["inicio_escala"] as num)
                              .toDouble(),
                          max: (snapshot.data[index]["fim_escala"] as num)
                              .toDouble(),
                          label: _currentSliderValue.toString(),
                          onChanged: (value) {
                            //_currentSliderValue = value;
                          },
                          onChangeEnd: (value) {
                            _currentSliderValue = value;
                            this.widget._acao = "RECARREGAR";
                            _gravar_resposta(
                                snapshot.data[index]["codigo_empresa"],
                                snapshot.data[index]["codigo_programacao"]
                                    .toString(),
                                snapshot.data[index]["registro_colaborador"],
                                snapshot.data[index]
                                    ["identificacao_utilizador"],
                                snapshot.data[index]["item_checklist"]
                                    .toString(),
                                snapshot.data[index]["resp_texto"],
                                snapshot.data[index]["resp_numero"],
                                snapshot.data[index]["resp_data"],
                                snapshot.data[index]["resp_hora"],
                                snapshot.data[index]["resp_simnao"],
                                value.round().toString(),
                                snapshot.data[index]["comentarios"],
                                snapshot.data[index]["descr_comentarios"],
                                "",
                                index);
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
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          );
        } else {
          //Tratar resposta por escala (com intervalo)
          if (snapshot.data[index]["tipo_resposta"] == "RESPOSTA POR ESCALA" &&
              int.parse(snapshot.data[index]["intervalo_escala"].toString(),
                      onError: (e) => 0) !=
                  0) {
            return Column(
              children: <Widget>[
                Column(
                  children: [
                    Text(
                      snapshot.data[index]["descr_escala"],
                    ),
                  ],
                ),
                Column(children: escala_opcoes(snapshot, index)),
              ],
            );
          } else {
            return TextField();
          }
        }
      }
    }
  }

  List<Widget> escala_opcoes(
      AsyncSnapshot<List<Map<String, dynamic>>> snapshot, int index) {
    List<Widget> _listaOpcoes = [];
    //sentido - escala maior para menor
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
                    groupValue: snapshot.data[index]["resp_escala"],
                    onChanged: (value) => {
                      this.widget._acao = "RECARREGAR",
                      _gravar_resposta(
                          snapshot.data[index]["codigo_empresa"],
                          snapshot.data[index]["codigo_programacao"].toString(),
                          snapshot.data[index]["registro_colaborador"],
                          snapshot.data[index]["identificacao_utilizador"],
                          snapshot.data[index]["item_checklist"].toString(),
                          snapshot.data[index]["resp_texto"],
                          snapshot.data[index]["resp_numero"],
                          snapshot.data[index]["resp_data"],
                          snapshot.data[index]["resp_hora"],
                          snapshot.data[index]["resp_simnao"],
                          value.toString(),
                          snapshot.data[index]["comentarios"],
                          snapshot.data[index]["descr_comentarios"],
                          "",
                          index)
                    },
                  ),
                  Text(_ocorrencia.toString(),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        );
        _ocorrencia = _ocorrencia + snapshot.data[index]["intervalo_escala"];
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
                    groupValue: snapshot.data[index]["resp_escala"],
                    onChanged: (value) => {
                      this.widget._acao = "RECARREGAR",
                      _gravar_resposta(
                          snapshot.data[index]["codigo_empresa"],
                          snapshot.data[index]["codigo_programacao"].toString(),
                          snapshot.data[index]["registro_colaborador"],
                          snapshot.data[index]["identificacao_utilizador"],
                          snapshot.data[index]["item_checklist"].toString(),
                          snapshot.data[index]["resp_texto"],
                          snapshot.data[index]["resp_numero"],
                          snapshot.data[index]["resp_data"],
                          snapshot.data[index]["resp_hora"],
                          snapshot.data[index]["resp_simnao"],
                          value.toString(),
                          snapshot.data[index]["comentarios"],
                          snapshot.data[index]["descr_comentarios"],
                          "",
                          index)
                    },
                  ),
                  Text(_ocorrencia.toString(),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        );
        _ocorrencia = _ocorrencia - snapshot.data[index]["intervalo_escala"];
      }
    }
    return _listaOpcoes;
  }

  tratar_nao_se_aplica(BuildContext context,
      AsyncSnapshot<List<Map<String, dynamic>>> snapshot, int index) {
    return Align(
      alignment: Alignment.centerLeft,
      child: CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        title: Text("Não se aplica",
            style: TextStyle(
                fontSize: 15, color: Colors.blue, fontWeight: FontWeight.bold)),
        value: snapshot.data[index]["resp_nao_se_aplica"].toString() == ""
            ? false
            : true,
        onChanged: (value) {
          this.widget._acao = "RECARREGAR";
          _gravar_resposta(
              snapshot.data[index]["codigo_empresa"],
              snapshot.data[index]["codigo_programacao"].toString(),
              snapshot.data[index]["registro_colaborador"],
              snapshot.data[index]["identificacao_utilizador"],
              snapshot.data[index]["item_checklist"].toString(),
              snapshot.data[index]["resp_texto"],
              snapshot.data[index]["resp_numero"],
              snapshot.data[index]["resp_data"],
              snapshot.data[index]["resp_hora"],
              snapshot.data[index]["resp_simnao"],
              snapshot.data[index]["resp_escala"],
              snapshot.data[index]["comentarios"],
              snapshot.data[index]["descr_comentarios"],
              value == true ? "SIM" : "",
              index);
        },
      ),
    );
  }

  tratar_posicionar_lista(index) {
    if (index == this.widget._indexLista) {
      SchedulerBinding.instance.addPostFrameCallback(
        (_) {
          itemScrollController.jumpTo(index: index);
          this.widget._indexLista = -1;
        },
      );
    }
    return Container();
  }

  _gravar_resposta(
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
      _wcomentarios,
      _wdescrComentarios,
      _wnaoSeAplica,
      _windexLista) async {
    var _wsincronizado = "";

    //Tratar "não se aplica"
    if (_wnaoSeAplica == "SIM") {
      _wrespTexto = "";
      _wrespNumero = null;
      _wrespData = "";
      _wrespHora = "";
      _wrespSimnao = "";
      _wrespEscala = null;
      _wdescrComentarios = "";
    }

//    //Verificar se existe conexão
//    final SpsVerificarConexao ObjVerificarConexao = SpsVerificarConexao();
//    final bool result = await ObjVerificarConexao.verificar_conexao();
//    if (result == true) {
//      //Gravar PostgreSQL (API REST)
//      final SpsHttpQuestionarioItem objQuestionarioItemHttp = SpsHttpQuestionarioItem();
//      final retorno = await objQuestionarioItemHttp.QuestionarioSaveResposta(
//          _wcodigoEmpresa,
//          _wcodigoProgramacao,
//          _wregistroColaborador,
//          _widentificacaoUtilizador,
//          _witemChecklist,
//          _wrespTexto,
//          _wrespNumero,
//          _wrespData.toString(),
//          _wrespHora,
//          _wrespSimnao,
//          _wrespEscala.toString(),
//          _wdescrComentarios,
//          _wnaoSeAplica,
//          usuarioAtual.tipo == "INTERNO" || usuarioAtual.tipo == "COLIGADA"
//              ? usuarioAtual.registro_usuario
//              : usuarioAtual.codigo_usuario);
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
    final int resultupdate = await objQuestionarioItemDao.update_resposta(
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
        _wnaoSeAplica,
        _wdescrComentarios,
        _wsincronizado);

    //Atualizar status da resposta
    spsQuestionarioUtils objspsQuestionarioUtils = new spsQuestionarioUtils();
    await objspsQuestionarioUtils.atualizar_status_resposta(
        _wcodigoEmpresa,
        int.parse(_wcodigoProgramacao),
        _wregistroColaborador,
        _widentificacaoUtilizador,
        int.parse(_witemChecklist));

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
            this.widget._acao,
            this.widget._sessao_checklist,
            _windexLista,
            this.widget._tipo_questionario),
      ),
    );
  }

  tratar_midias(BuildContext context,
      AsyncSnapshot<List<Map<String, dynamic>>> snapshot, int index) {
    if (snapshot.data[index]["midia"] == "SIM" ||
        snapshot.data[index]["midia"] == "OBRIGATORIO") {
      return IconButton(
        icon: Badge(
          badgeContent: Text(snapshot.data[index]["anexos"].toString(),
              style: TextStyle(color: Colors.white, fontSize: 8)),
          showBadge: snapshot.data[index]["anexos"] > 0 ? true : false,
          badgeColor: Color(0xFF004077),
          child: Icon(Icons.collections, size: 30),
        ),
        color: snapshot.data[index]["anexos"] > 0 ? Colors.blue : Colors.black,
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
                      index,
                      this.widget._filtroDescrProgramacao,
                      snapshot.data[index]["imagens"].toString(),
                      snapshot.data[index]["videos"].toString(),
                      snapshot.data[index]["outros"].toString(),
                      "RECARREGAR",
                      funCallback: ({int index_posicao_retorno, String acao}) {
                        setState(() {
                          this.widget._indexLista = index_posicao_retorno;
                        });
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
                                    this.widget._identificacao_utilizador,
                                    this.widget._codigo_grupo,
                                    this.widget._codigo_checklist,
                                    this.widget._descr_programacao,
                                    this.widget._sincronizado,
                                    this.widget._status_aprovacao,
                                    this.widget._filtro,
                                    this.widget._filtroDescrProgramacao,
                                    acao,
                                    this.widget._sessao_checklist,
                                    this.widget._indexLista,
                                    this.widget._tipo_questionario),
                          ),
                        );
                      },
                    )),
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
        snapshot.data[index]["comentarios"] == "OBRIGATORIO" ||
        ((snapshot.data[index]["comentario_resposta_nao"] == "SIM" ||
                snapshot.data[index]["comentario_resposta_nao"] ==
                    "OBRIGATORIO") &&
            snapshot.data[index]["resp_simnao"] == "NÃO") ||
        (snapshot.data[index]["comentario_escala"] != null &&
            int.parse(snapshot.data[index]["resp_escala"].toString(),
                    onError: (e) => 0) <
                snapshot.data[index]["comentario_escala"])) {
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
                this.widget._sessao_checklist,
                index,
                this.widget._tipo_questionario
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
