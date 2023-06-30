import 'package:biomaapp/models/Rateio.dart';
import 'package:biomaapp/models/unidade.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:biomaapp/utils/constants.dart';

class Regra with ChangeNotifier {
  final String r_id;
  final String r_cpf_parceiro;
  final String r_des_parceiro;
  final String r_cod_profissional;
  final String r_cpf_profissional;
  final String r_des_profissional;
  final String r_crm_profissional;
  final String r_sub_especialidade;
  final String r_cod_especialidade;
  final String r_des_especialidade;
  final String r_grupo;
  final String r_cod_unidade;
  final String r_des_unidade;
  final String r_cod_convenio;
  final String r_desc_convenio;
  final String r_cod_procedimentos;
  final String r_des_procedimentos;
  final String r_cod_tratamento;
  final String r_tipo_tratamento;
  final String r_tabop_quantidade;
  final String r_frequencia;
  final String r_valor_base;
  final String r_valor_sugerido;
  final String r_orientacoes;
  final String r_like_regra;
  final String r_termos_buscas;
  final String r_informe_aproximado;
  final String r_status;
  final String r_validade;
  final String r_data_criacao;
  final String r_hora_criacao;
  final List<Rateio> rateios;

  Regra({
    required this.r_id,
    required this.r_cpf_parceiro,
    required this.r_des_parceiro,
    required this.r_cod_profissional,
    required this.r_cpf_profissional,
    required this.r_des_profissional,
    required this.r_crm_profissional,
    required this.r_sub_especialidade,
    required this.r_cod_especialidade,
    required this.r_des_especialidade,
    required this.r_grupo,
    required this.r_cod_unidade,
    required this.r_des_unidade,
    required this.r_cod_convenio,
    required this.r_desc_convenio,
    required this.r_cod_procedimentos,
    required this.r_des_procedimentos,
    required this.r_cod_tratamento,
    required this.r_tipo_tratamento,
    required this.r_tabop_quantidade,
    required this.r_frequencia,
    required this.r_valor_base,
    required this.r_valor_sugerido,
    required this.r_orientacoes,
    required this.r_like_regra,
    required this.r_termos_buscas,
    required this.r_informe_aproximado,
    required this.r_status,
    required this.r_validade,
    required this.r_data_criacao,
    required this.r_hora_criacao,
    required this.rateios,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Regra && runtimeType == other.runtimeType && r_id == other.r_id;

  @override
  int get hashCode => r_id.hashCode;

  @override
  String toString() {
    return r_id;
  }
}
