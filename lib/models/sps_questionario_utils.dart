import 'package:flutter/material.dart';
import 'package:sps/dao/sps_dao_questionario_item_class.dart';

class spsQuestionarioUtils {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

  Future<String> atualizar_status_resposta(
      String wcodigoEmpresa,
      int wcodigoProgramacao,
      String wregistroColaborador,
      String widentificacaoUtilizador,
      int witemChecklist) async {
    var _wsincronizado = "";

    //wregistroColaborador = "";
    //widentificacaoUtilizador = "";

    final SpsDaoQuestionarioItem objQuestionarioItemDao =
        SpsDaoQuestionarioItem();

    //Ler dados do SQlite (Checklist Item - chave parcial 1)
    final List<Map<String, dynamic>> result =
        await objQuestionarioItemDao.select_chave_parcial_1(
            wcodigoEmpresa,
            wcodigoProgramacao,
            wregistroColaborador,
            widentificacaoUtilizador,
            witemChecklist);

    //Analisar status da resposta
    String _wstatusResposta;

    //Analisar resposta CQ
    if (result[0]["tipo_resposta"] == "RESPOSTA CQ") {
      _wstatusResposta = "PREENCHIDA";
    }

    //Analisar resposta fixa
    if (result[0]["tipo_resposta"] == "RESPOSTA FIXA") {
      if (result[0]["tipo_resposta_fixa"] == "TEXTO") {
        if (result[0]["resp_texto"] == "" || result[0]["resp_texto"] == null) {
          _wstatusResposta = "PENDENTE";
        } else {
          _wstatusResposta = "PREENCHIDA";
        }
      }
      if (result[0]["tipo_resposta_fixa"] == "NUMERO") {
        if (int.parse(result[0]["resp_numero"].toString(),
                onError: (e) => null) ==
            null) {
          _wstatusResposta = "PENDENTE";
        } else {
          _wstatusResposta = "PREENCHIDA";
        }
      }
      if (result[0]["tipo_resposta_fixa"] == "DATA") {
        if (result[0]["resp_data"] == "" || result[0]["resp_data"] == null) {
          _wstatusResposta = "PENDENTE";
        } else {
          _wstatusResposta = "PREENCHIDA";
        }
      }
      if (result[0]["tipo_resposta_fixa"] == "HORA") {
        if (result[0]["resp_hora"] == "" || result[0]["resp_hora"] == null) {
          _wstatusResposta = "PENDENTE";
        } else {
          _wstatusResposta = "PREENCHIDA";
        }
      }
    }

    //Analisar resposta sim/não
    if (result[0]["tipo_resposta"] == "RESPOSTA SIM/NÃO") {
      if (result[0]["resp_simnao"] == "" || result[0]["resp_simnao"] == null) {
        _wstatusResposta = "PENDENTE";
      } else {
        _wstatusResposta = "PREENCHIDA";
      }
    }

    //Analisar resposta por escala
    if (result[0]["tipo_resposta"] == "RESPOSTA POR ESCALA") {
      if (result[0]["resp_escala"] == "" || result[0]["resp_escala"] == null) {
        _wstatusResposta = "PENDENTE";
      } else {
        _wstatusResposta = "PREENCHIDA";
      }
    }

    //Analisar resposta multipla
    if (result[0]["tipo_resposta"] == "RESPOSTA MULTIPLA") {
      //Ler dados do SQlite (Checklist Item - chave parcial 2)
      final List<Map<String, dynamic>> result_resp_multipla =
          await objQuestionarioItemDao.select_chave_parcial_2(
              wcodigoEmpresa,
              wcodigoProgramacao,
              wregistroColaborador,
              widentificacaoUtilizador,
              witemChecklist);
      if (result_resp_multipla.length == 0) {
        _wstatusResposta = "PENDENTE";
      } else {
        _wstatusResposta = "PREENCHIDA";
        result_resp_multipla.forEach(
          (element) {
            if (element['obrigatorio_texto_adicional'] == "SIM" &&
                (element['texto_adicional'].toString() == "" ||
                    element['texto_adicional'].toString() == "null" ||
                    element['texto_adicional'].toString() == null)) {
              _wstatusResposta = "PENDENTE";
            }
          },
        );
      }
    }

    //Analisar comentário
    if (result[0]["comentarios"] == "OBRIGATORIO") {
      if (result[0]["descr_comentarios"] == "" ||
          result[0]["descr_comentarios"] == null) {
        _wstatusResposta = "PENDENTE";
      }
    }
    if (result[0]["comentario_resposta_nao"] == "OBRIGATORIO") {
      if (result[0]["resp_simnao"] == "NÃO") {
        if (result[0]["descr_comentarios"] == "" ||
            result[0]["descr_comentarios"] == null) {
          _wstatusResposta = "PENDENTE";
        }
      }
    }
    if (result[0]["comentario_escala"] != null &&
        result[0]["resp_escala"] != null) {
      if (result[0]["resp_escala"] < result[0]["comentario_escala"]) {
        if (result[0]["descr_comentarios"] == "" ||
            result[0]["descr_comentarios"] == null) {
          _wstatusResposta = "PENDENTE";
        }
      }
    }

    //Analisa mídia
    if (result[0]["midia"] == "OBRIGATORIO") {
      if (result[0]["qtde_anexos"] == 0) {
        _wstatusResposta = "PENDENTE";
      }
    }

    //Não se aplica
    if (result[0]["resp_nao_se_aplica"] == "SIM"  || result[0]["resp_cq"] == "NÃO SE APLICA") {
      _wstatusResposta = "PREENCHIDA";
    }

    if (_wstatusResposta != result[0]["status_resposta"]) {
      _wsincronizado = "N";

      //Gravar SQlite
      final SpsDaoQuestionarioItem objQuestionarioItemDao =
          SpsDaoQuestionarioItem();
      final int resultupdate =
          await objQuestionarioItemDao.update_status_resposta(
              wcodigoEmpresa,
              wcodigoProgramacao,
              wregistroColaborador,
              widentificacaoUtilizador,
              witemChecklist,
              _wstatusResposta,
              _wsincronizado);
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
