import 'dart:convert';

import 'package:biomaapp/models/especialidade.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:biomaapp/utils/constants.dart';

class Procedimento with ChangeNotifier {
  String cod_procedimentos = '';
  String des_procedimentos = '';
  double valor = 0;
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

  Future<Procedimento> loadProcedimentosID(String unidade, String convenios,
      String procedimentos, String especialidade) async {
    String link = '${Constants.PROCEDIMENTO_BASE_URL}/' +
        unidade +
        '/' +
        convenios +
        '/' +
        procedimentos +
        '/' +
        especialidade +
        Constants.AUT_BASE;
    debugPrint(link);
    final response = await http.get(
      Uri.parse(link),
    );
    if (response.body == 'null') return this;

    final data = jsonDecode(response.body);
    List proced = jsonDecode(response.body)['dados'];

    await proced.map(
      (item) {
        //   debugPrint('Carregando procedimento: ${item['descricao']}');
        // debugPrint(double.parse(item['frequencia']).toString());

        this.cod_procedimentos = item['cod_procedimento'].toString();
        this.des_procedimentos = item['descricaounificada'].toString().isEmpty
            ? item['descricao']
            : item['descricaounificada'].toString();

        this.valor = double.parse(item['valor']);
        this.grupo = item['grupo'].toString() +
            ' - ' +
            item['tipo_tratamento'].toString();
        this.especialidade = Especialidade(
            codespecialidade: item['cod_especialidade'].toString(),
            descricao: item['des_especialidade'].toString(),
            ativo: 'S');
        this.frequencia = item['frequencia'].toString();
        this.quantidade = item['tabop_quantidade'].toString();
        this.cod_tratamento = item['cod_tratamento'].toString();
      },
    ).toList();
    debugPrint(this.des_procedimentos);
    notifyListeners();
    return this;
  }
}
