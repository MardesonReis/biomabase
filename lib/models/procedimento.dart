import 'dart:convert';

import 'package:biomaapp/models/convenios.dart';
import 'package:biomaapp/models/especialidade.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:biomaapp/utils/constants.dart';

class Procedimento with ChangeNotifier {
  Convenios convenio = Convenios(cod_convenio: '', desc_convenio: '');
  String cod_procedimentos = '';
  String des_procedimentos = '';
  String orientacoes = '';
  double valor = 0;
  double valor_sugerido = 0;
  String des_tratamento = '';
  String cod_tratamento = '';
  Especialidade especialidade =
      Especialidade(codespecialidade: '', descricao: '', ativo: '');
  String grupo = '';
  String frequencia = '';
  String quantidade = '';

  String olho = '';

  Procedimento();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Procedimento &&
          runtimeType == other.runtimeType &&
          cod_procedimentos == other.cod_procedimentos;

  @override
  int get hashCode => des_procedimentos.hashCode;

  @override
  String toString() {
    return des_procedimentos;
  }

  Future<void> EscolherOlho(String Olho) async {
    this.olho = Olho;
    notifyListeners();
  }

  Future<Procedimento> loadProcedimentosID(
      String codprofissional,
      String medicoLike,
      String cpf_profissional,
      String cod_unidade,
      String procedimento,
      String convenio) async {
    var pr = Procedimento();

    String link = '${Constants.DATA_BASE_URL}' +
        codprofissional +
        '/' +
        medicoLike +
        '/' +
        cpf_profissional +
        '/' +
        cod_unidade +
        '/' +
        procedimento +
        '/' +
        convenio +
        Constants.AUT_BASE;
    debugPrint(link);
    final response = await http.get(
      Uri.parse(link),
    );
    if (response.body == 'null') return pr;

    final data = jsonDecode(response.body);
    List proced = jsonDecode(response.body)['dados'];

    await proced.map(
      (item) {
        //   debugPrint('Carregando procedimento: ${item['descricao']}');
        // debugPrint(double.parse(item['frequencia']).toString());
        pr.valor_sugerido = double.parse(item['valor'].toString());
        pr.orientacoes = item['orientacoes'].toString();
        pr.cod_procedimentos = item['cod_procedimentos'].toString();
        pr.des_procedimentos = item['des_procedimentos'].toString();

        pr.valor = double.parse(item['valor']);
        pr.grupo = item['grupo'].toString() +
            ' - ' +
            item['tipo_tratamento'].toString();
        pr.especialidade = Especialidade(
            codespecialidade: item['cod_especialidade'].toString(),
            descricao: item['des_especialidade'].toString(),
            ativo: 'S');
        pr.frequencia = item['frequencia'].toString();
        pr.quantidade = item['tabop_quantidade'].toString();
        pr.cod_tratamento = item['cod_tratamento'].toString();
      },
    ).toList();
    debugPrint(pr.des_procedimentos);
    notifyListeners();

    return pr;
  }

  Map<String, dynamic> toJson() {
    return {
      'convenio': convenio.toJson(),
      'cod_procedimentos': cod_procedimentos.toString(),
      'des_procedimentos': des_procedimentos.toString(),
      'orientacoes': orientacoes.toString(),
      'valor': valor.toString(),
      'valor_sugerido': valor_sugerido.toString(),
      'des_tratamento': des_tratamento.toString(),
      'cod_tratamento': cod_tratamento.toString(),
      'especialidade': especialidade.toJson(),
      'grupo': grupo.toString(),
      'frequencia': frequencia.toString(),
      'quantidade': quantidade.toString(),
      'olho': olho.toString(),
    };
  }

  factory Procedimento.fromJson(Map<String, dynamic> json) {
    return Procedimento()
      ..convenio = Convenios.fromJson(json['convenio'])
      ..cod_procedimentos = json['cod_procedimentos']
      ..des_procedimentos = json['des_procedimentos']
      ..orientacoes = json['orientacoes']
      ..valor = json['valor']
      ..valor_sugerido = json['valor_sugerido']
      ..des_tratamento = json['des_tratamento']
      ..cod_tratamento = json['cod_tratamento']
      ..especialidade = Especialidade.fromJson(json['especialidade'])
      ..grupo = json['grupo']
      ..frequencia = json['frequencia']
      ..quantidade = json['quantidade']
      ..olho = json['olho'];
  }

  // Restante da implementação da classe Procedimento...
}
