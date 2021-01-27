import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sps/components/centered_message.dart';
import 'package:sps/components/progress.dart';
import 'package:sps/dao/sps_dao_questionario_class.dart';
import 'package:sps/dao/sps_dao_questionario_item_class.dart';
import 'package:sps/http/sps_http_questionario_class.dart';
import 'package:sps/models/sps_questionario_item.dart';
import 'package:sps/screens/sps_questionario_cq_comentarios_screen.dart';
import 'package:sps/screens/sps_questionario_cq_midia_screen.dart';
import 'package:sps/screens/sps_questionario_screen.dart';

class sps_questionario_cq_screen extends StatefulWidget {
  final String _codigo_empresa;
  final int _codigo_programacao;
  final String _registro_colaborador;
  final String _identificacao_utilizador;
  final String _codigo_grupo;
  final int _codigo_checklist;
  final String _descr_programacao;
  final String _codigo_pedido;
  final int _item_pedido;
  final String _codigo_material;
  String _referencia_parceiro;
  final String _codigo_projeto;
  final String _sincronizado;

  sps_questionario_cq_screen(
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
      this._codigo_projeto,
      this._sincronizado);

  @override
  _sps_questionario_cq_screen createState() => _sps_questionario_cq_screen(
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
      this._codigo_projeto,
      this._sincronizado);
}

class _sps_questionario_cq_screen extends State<sps_questionario_cq_screen> {
  final SpsQuestionarioItem spsQuestionarioItem = SpsQuestionarioItem();

  _sps_questionario_cq_screen(
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
      _codigo_projeto,
      _sincronizado);

  var _singleValue = List();

  @override
  Widget build(BuildContext context) {
    debugPrint("TELA => SPS_QUESTIONARIO_CQ_SCREEN");
    return WillPopScope(
      onWillPop: () {
        return new Future(() => false);
      },
      child: Scaffold(
        backgroundColor: Color(0xFFe9eef7), // Cinza Azulado
        appBar: AppBar(
          backgroundColor: Color(0xFF004077),
          title: Text(
            'QUESTIONÁRIO',
            style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
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
                        builder: (context) => sps_questionario_screen()),
                  );
                },
              );
            },
          ),
        ),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: spsQuestionarioItem.listarQuestionarioItem(
              this.widget._codigo_empresa,
              this.widget._codigo_programacao,
              this.widget._codigo_grupo,
              this.widget._codigo_checklist),
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
                              "("+this.widget._codigo_programacao.toString()+") "+this.widget._descr_programacao +
                                  "\n\n" +
                                  "PEDIDO: " +
                                  this.widget._codigo_pedido +
                                  "/" +
                                  this.widget._item_pedido.toString() +
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
                              IconButton(
                                  icon: Icon(Icons.edit, size: 20),
                                  color: Colors.white,
                                  onPressed: () => _popup_referencia(
                                      this.widget._codigo_empresa,
                                      this.widget._codigo_programacao,
                                      this.widget._referencia_parceiro)),
                            ],
                          ),
                        ),
                      ),
                    ),

                    //Construir lista de opções
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.only(top: 5),
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          switch (snapshot.data[index]["resp_cq"]) {
                            case 'NÃO SE APLICA':
                              _singleValue.add("NÃO SE APLICA");
                              break;
                            case 'REJEITADO':
                              _singleValue.add("REJEITADO");
                              break;
                            case 'APROVADO PARCIAL':
                              _singleValue.add("APROVADO PARCIAL");
                              break;
                            case 'APROVADO':
                              _singleValue.add("APROVADO");
                              break;
                            default:
                              _singleValue.add("");
                              break;
                          }

                          //Tratar descrição da pergunta
                          return Card(
                            color: Colors.white,
                            child: Column(
                              children: <Widget>[
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
                                          fontSize: 20)),
                                  subtitle: Text(""),
                                ),

                                // Tratar Legenda das opções
                                Row(children: <Widget>[
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(5, 0, 0, 5)),
                                  IconButton(
                                      icon: Icon(Icons.info_outline, size: 20),
                                      color: Colors.red,
                                      onPressed: () => _popup_legenda(context)),
                                  Text(" "),

                                  // Tratar Opções
                                  Container(
                                    color: Color(0xFF9fbded),
                                    child: CustomRadioWidget(
                                      value: "NÃO SE APLICA",
                                      groupValue: _singleValue[index],
                                      onChanged: (value) => _gravar_opcao(
                                          '${snapshot.data[index]["codigo_empresa"]}',
                                          '${snapshot.data[index]["codigo_programacao"]}',
                                          '${snapshot.data[index]["registro_colaborador"]}',
                                          '${snapshot.data[index]["identificacao_utilizador"]}',
                                          '${snapshot.data[index]["item_checklist"]}',
                                          value,
                                          index),
                                    ),
                                  ),
                                  Text("     "),
                                  Container(
                                    color: Colors.red,
                                    child: CustomRadioWidget(
                                      value: "REJEITADO",
                                      groupValue: _singleValue[index],
                                      onChanged: (value) => _gravar_opcao(
                                          '${snapshot.data[index]["codigo_empresa"]}',
                                          '${snapshot.data[index]["codigo_programacao"]}',
                                          '${snapshot.data[index]["registro_colaborador"]}',
                                          '${snapshot.data[index]["identificacao_utilizador"]}',
                                          '${snapshot.data[index]["item_checklist"]}',
                                          value,
                                          index),
                                    ),
                                  ),
                                  Text("     "),
                                  Container(
                                    color: Colors.orange,
                                    child: CustomRadioWidget(
                                      value: "APROVADO PARCIAL",
                                      groupValue: _singleValue[index],
                                      onChanged: (value) => _gravar_opcao(
                                          '${snapshot.data[index]["codigo_empresa"]}',
                                          '${snapshot.data[index]["codigo_programacao"]}',
                                          '${snapshot.data[index]["registro_colaborador"]}',
                                          '${snapshot.data[index]["identificacao_utilizador"]}',
                                          '${snapshot.data[index]["item_checklist"]}',
                                          value,
                                          index),
                                    ),
                                  ),
                                  Text("     "),
                                  Container(
                                    color: Colors.green,
                                    child: CustomRadioWidget(
                                      value: "APROVADO",
                                      groupValue: _singleValue[index],
                                      onChanged: (value) => _gravar_opcao(
                                          '${snapshot.data[index]["codigo_empresa"]}',
                                          '${snapshot.data[index]["codigo_programacao"]}',
                                          '${snapshot.data[index]["registro_colaborador"]}',
                                          '${snapshot.data[index]["identificacao_utilizador"]}',
                                          '${snapshot.data[index]["item_checklist"]}',
                                          value,
                                          index),
                                    ),
                                  ),
                                  Text("     "),

                                  //Tratar Mídias
                                  IconButton(
                                    icon: Icon(Icons.collections, size: 30),
                                    color: Colors.black,
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                sps_questionario_cq_midia_screen()),
                                      );
                                    },
                                  ),

                                  //Tratar Comentários
                                  IconButton(
                                    icon: Icon(Icons.comment, size: 30),
                                    color: Colors.black,
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
                                            this.widget._sincronizado
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ]),

                                snapshot.data[index]["status_aprovacao"] ==
                                        "APROVADO"
                                    ? Text("\nAPROVADO PELO FOLLOW UP\n",
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold))
                                    : Text(""),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ]);
                } else {
                  return CenteredMessage(
                    'No transaction found!',
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

  _gravar_opcao(_wcodigoEmpresa, _wcodigoProgramacao, _wregistroColaborador,
      _widentificacaoUtilizador, _witemChecklist, _wrespCq, _windex) async {
    debugPrint('opcao => ' + _wrespCq);
    final SpsDaoQuestionarioItem objQuestionarioItemDao =
        SpsDaoQuestionarioItem();
    final int resultupdate = await objQuestionarioItemDao.update_opcao(
        _wcodigoEmpresa,
        _wcodigoProgramacao,
        _wregistroColaborador,
        _widentificacaoUtilizador,
        _witemChecklist,
        _wrespCq);
    setState(() {});
    _singleValue[_windex] = _wrespCq;
  }

  _popup_legenda(context) {
    Alert(
      context: context,
      title: "LEGENDA\n",
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            children: [
              Container(
                color: Color(0xFF9fbded),
                child: CustomRadioWidget(groupValue: 1),
              ),
              Text(" NÃO SE APLICA"),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Container(
                color: Colors.red,
                child: CustomRadioWidget(groupValue: 1),
              ),
              Text(" REJEITADO"),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Container(
                color: Colors.orange,
                child: CustomRadioWidget(groupValue: 1),
              ),
              Text(" APROVADO PARCIAL"),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Container(
                color: Colors.green,
                child: CustomRadioWidget(groupValue: 1),
              ),
              Text(" APROVADO"),
            ],
          ),
        ],
      ),
      buttons: [
        DialogButton(
            child: Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop())
      ],
    ).show();
  }

  _popup_referencia(_wcodigoEmpresa, _wcodigoProgramacao, _wnovaReferencia) {
    TextEditingController _popup_novaReferencia = TextEditingController();
    _popup_novaReferencia.text = _wnovaReferencia;
    Alert(
      context: context,
      title: "REFERÊNCIA DO FORNECEDOR\n",
      content: TextField(
        controller: _popup_novaReferencia,
        textInputAction: TextInputAction.go,
        keyboardType: TextInputType.numberWithOptions(),
        decoration: InputDecoration(hintText: "Informe sua referência"),
      ),
      buttons: [
        DialogButton(
            child: Text(
              "GRAVAR",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => _gravar_referencia(_wcodigoEmpresa,
                _wcodigoProgramacao, _popup_novaReferencia.text)),
      ],
    ).show();
  }

  _gravar_referencia(
      _wcodigoEmpresa, _wcodigoProgramacao, _wnovaReferencia) async {
    debugPrint('referencia => ' + _wnovaReferencia);

    var _wsincronizado = "";

    //Gravar PostgreSQL (API REST)
    final SpsHttpQuestionario objQuestionarioHttp = SpsHttpQuestionario();
    final retorno = await objQuestionarioHttp.QuestionarioSaveReferencia(
        _wcodigoEmpresa,
        _wcodigoProgramacao,
        _wnovaReferencia,
        '#usuario#'); //Verificar com Fernando
    if (retorno == true) {
      _wsincronizado = "";
      debugPrint("registro gravado PostgreSQL: " + _wcodigoEmpresa + "/" + _wcodigoProgramacao.toString() + "/" + _wnovaReferencia);
    } else {
      _wsincronizado = "N";
      debugPrint(
          "ERRO => registro gravado PostgreSQL: " + _wcodigoEmpresa + "/" + _wcodigoProgramacao.toString() + "/" + _wnovaReferencia);
    }

    //Gravar SQlite
    final SpsDaoQuestionario objQuestionarioDao = SpsDaoQuestionario();
    final int resultupdate = await objQuestionarioDao.update_referencia(
        _wcodigoEmpresa, _wcodigoProgramacao, _wnovaReferencia, _wsincronizado);

    Navigator.of(context, rootNavigator: true).pop();
    this.widget._referencia_parceiro = _wnovaReferencia;
    setState(() {});
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
