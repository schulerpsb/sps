import 'package:flutter/material.dart';
import 'package:sps/models/sps_questionario_item.dart';

class sps_questionario_cq_comentarios_screen extends StatefulWidget {
  final String _codigo_empresa;
  final int _codigo_programacao;
  final int _item_checklist;
  final String _descr_comentarios;

  sps_questionario_cq_comentarios_screen(this._codigo_empresa,
      this._codigo_programacao, this._item_checklist, this._descr_comentarios);

  @override
  _sps_questionario_cq_comentarios_screen createState() =>
      _sps_questionario_cq_comentarios_screen(
          this._codigo_empresa,
          this._codigo_programacao,
          this._item_checklist,
          this._descr_comentarios);
}

class _sps_questionario_cq_comentarios_screen
    extends State<sps_questionario_cq_comentarios_screen> {
  final SpsQuestionarioItem spsQuestionarioItem = SpsQuestionarioItem();

  _sps_questionario_cq_comentarios_screen(_codigo_empresa, _codigo_programacao,
      _item_checklist, _descr_comentarios);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFe9eef7), // Cinza Azulado
      appBar: AppBar(
        backgroundColor: Color(0xFF004077),
        title: Text(
          'COMENTÁRIOS',
          style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
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
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
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
                            ajustar_comentarios(this.widget._descr_comentarios),
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
              child: Column(children: <Widget>[
                Text("Adicionar comentários",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                Card(
                  color: Colors.white,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      children: <Widget>[
                        TextField(
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
                    onPressed: () {},
                    child: const Icon(Icons.add),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  String ajustar_comentarios(wcomentarios) {
    return wcomentarios
        .replaceAll("</font></b>||", "\n")
        .replaceAll("<br>||", "\n\n")
        .replaceAll("<b><font color=blue>", "")
        .replaceAll("<b><font color=green>", "");
  }
}
