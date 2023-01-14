import 'package:biomaapp/models/Rateio.dart';
import 'package:biomaapp/models/unidade.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:biomaapp/utils/constants.dart';

class Regra with ChangeNotifier {
  final String id_regra;

  final String cpf_parceiro;
  final String des_parceiro;

  final String cpf_medico;
  final String des_medico;

  final String cod_procedimento;
  final String des_procedimento;

  final String cod_convenio;
  final String des_convenio;

  final String cod_unidade;
  final String des_unidade;

  final String valor_base;
  final String valor_sugerido;
  final String orientacoes;
  final String status;
  final String data_criacao;
  final String hora_criacao;
  final List<Rateio> rateios;

  Regra({
    required this.id_regra,
    required this.cpf_parceiro,
    required this.des_parceiro,
    required this.cpf_medico,
    required this.des_medico,
    required this.valor_base,
    required this.cod_procedimento,
    required this.des_procedimento,
    required this.cod_convenio,
    required this.des_convenio,
    required this.cod_unidade,
    required this.des_unidade,
    required this.orientacoes,
    required this.valor_sugerido,
    required this.status,
    required this.data_criacao,
    required this.hora_criacao,
    required this.rateios,
  });
}
