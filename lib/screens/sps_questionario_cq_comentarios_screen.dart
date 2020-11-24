import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sps/components/centered_message.dart';
import 'package:sps/components/progress.dart';
import 'package:sps/models/sps_questionario_item.dart';
import 'package:sps/screens/sps_questionario_cq_midia_screen.dart';

class sps_questionario_cq_comentarios_screen extends StatefulWidget {
  final String _codigo_empresa;
  final int _codigo_programacao;
  final String _codigo_grupo;
  final int _codigo_checklist;

  sps_questionario_cq_comentarios_screen(this._codigo_empresa,
      this._codigo_programacao, this._codigo_grupo, this._codigo_checklist);

  @override
  _sps_questionario_cq_comentarios_screen createState() =>
      _sps_questionario_cq_comentarios_screen(this._codigo_empresa,
          this._codigo_programacao, this._codigo_grupo, this._codigo_checklist);
}

class _sps_questionario_cq_comentarios_screen
    extends State<sps_questionario_cq_comentarios_screen> {
  final SpsQuestionarioItem spsQuestionarioItem = SpsQuestionarioItem();

  _sps_questionario_cq_comentarios_screen(
      _codigo_empresa, _codigo_programacao, _codigo_grupo, _codigo_checklist);

  var _singleValue = List();

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: 'Enter a search term'),
            ),
          ],
        ),
      ),
    );
  }
}
