import 'package:flutter/material.dart';
import 'package:sps/dao/sps_dao_questionario_item_class.dart';
import 'package:sps/models/sps_questionario_item.dart';
import 'package:sps/screens/sps_questionario_cq_screen.dart';
import 'package:intl/intl.dart';

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
      this._sincronizado);

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
          this._sincronizado);
}

class _sps_questionario_cq_comentarios_screen
    extends State<sps_questionario_cq_comentarios_screen> {
  final SpsQuestionarioItem spsQuestionarioItem = SpsQuestionarioItem();

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
      _sincronizado);

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
                        builder: (context) => sps_questionario_cq_screen(
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
                            this.widget._sincronizado)),
                  );
                },
              );
            },
          ),
        ),
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
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 10, left: 10, right: 10, bottom: 10),
                child: Container(
                  height: 320,
                  child: SingleChildScrollView(
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
                                fontSize: 16.0,
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
                    Text("Adicionar comentários",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
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
                            this.widget._item_checklist,
                            this.widget._descr_comentarios +
                                "<b><font color=blue>" +
                                "#Usuário#" +
                                " em " +
                                obter_datahora() +
                                "</font></b>||" +
                                _novoComentario.text +
                                "<br>||"),
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

  _gravar_comentario(_wcodigoEmpresa, _wcodigoProgramacao, _witemChecklist,
      _wdescrComentarios) async {
    debugPrint('comentário => ' + _wdescrComentarios);
    final SpsDaoQuestionarioItem objQuestionarioDaoItem =
        SpsDaoQuestionarioItem();
    final int resultupdate = await objQuestionarioDaoItem.update_comentarios(
        _wcodigoEmpresa,
        _wcodigoProgramacao,
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

  String obter_datahora(){
    final formatter = new NumberFormat("00");
    return
    formatter.format(DateTime.now().day) +
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
