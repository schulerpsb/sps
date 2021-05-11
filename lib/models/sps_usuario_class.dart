class sps_usuario {
  static final sps_usuario _sps_usuario = new sps_usuario._internal();//  String codigo_usuario;

  String codigo_usuario;
  String nome_usuario;
  String telefone_usuario;
  String email_usuario;
  String cargo_usuario;
  String pais_usuario;
  String lingua_usuario;
  String senha_usuario;
  String status_usuario;
  String dt_validade_senha;
  String qtd_tentativas_senha;
  String codigo_planta;
  String dthratualizacao;
  String chave;
  String status_token;
  String dt_validade_usuario;
  String dt_reset_senha;
  String tipo;
  String registro_usuario;
  String mensagem;
  String document_root_folder;
  int id_isolate;
  String data_ultima_sincronizacao;
  int status_sincronizacao;
  int index_perguntas;
  int codigoValidacao;
  String dados_dispositivo;
  String tipo_dispositivo;
  String modelo_dispositivo;
  String versao_sistema_operacional;

  factory sps_usuario() {
    return _sps_usuario;
  }
  sps_usuario._internal();
}
final usuarioAtual = sps_usuario();