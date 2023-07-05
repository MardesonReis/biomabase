import 'dart:convert';

import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/convenios.dart';
import 'package:biomaapp/models/especialidade.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:biomaapp/utils/constants.dart';

class Procedimento with ChangeNotifier {
  Convenios convenio = Convenios(cod_convenio: '', desc_convenio: '');
  String cod_procedimento = '';
  String des_procedimento = '';
  String orientacoes = '';
  double valor = 0;
  double valor_sugerido = 0;
  double desconto = 0;
  String des_tratamento = '';
  String cod_tratamento = '';
  Especialidade especialidade =
      Especialidade(cod_especialidade: '', des_especialidade: '', ativo: '');
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
          cod_procedimento == other.cod_procedimento;

  @override
  int get hashCode => des_procedimento.hashCode;

  @override
  String toString() {
    return des_procedimento;
  }

  Future<void> EscolherOlho(String Olho) async {
    this.olho = Olho;
    notifyListeners();
  }

  String Descritivo() {
    if (especialidade.cod_especialidade == '1') {
      if (olho.isNotEmpty) {
        return ' ' + olhoDescritivo[olho].toString();
      } else {
        return ' ' + ManoBino[quantidade].toString();
      }
    } else {
      return '';
    }
  }

  double valorCalculado() {
    var qtd = olho == "A" && quantidade == '2' ? 2 : 1;
    if (desconto > 0) {
      return qtd * valor_sugerido - ((desconto / 100) * qtd * valor_sugerido);
    } else {
      return qtd * valor_sugerido;
    }
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
        pr.cod_procedimento = item['cod_procedimento'].toString();
        pr.des_procedimento = item['des_procedimento'].toString();

        pr.valor = double.parse(item['valor']);
        pr.grupo = item['grupo'].toString() +
            ' - ' +
            item['tipo_tratamento'].toString();
        pr.especialidade = Especialidade(
            cod_especialidade: item['cod_especialidade'].toString(),
            des_especialidade: item['des_especialidade'].toString(),
            ativo: 'S');
        pr.frequencia = item['frequencia'].toString();
        pr.quantidade = item['tabop_quantidade'].toString();
        pr.cod_tratamento = item['cod_tratamento'].toString();
      },
    ).toList();
    debugPrint(pr.des_procedimento);
    notifyListeners();

    return pr;
  }

  Map<String, dynamic> toJson() {
    return {
      'convenio': convenio.toJson(),
      'cod_procedimento': cod_procedimento.toString(),
      'des_procedimento': des_procedimento.toString(),
      'orientacoes': orientacoes.toString(),
      'valor': valor.toString(),
      'valor_sugerido': valor_sugerido.toString(),
      'desconto': desconto.toString(),
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
      ..cod_procedimento = json['cod_procedimento'].toString()
      ..des_procedimento = json['des_procedimento'].toString()
      ..orientacoes = json['orientacoes'].toString()
      ..valor = double.tryParse(json['valor'].toString()) ?? 0.0
      ..valor_sugerido =
          double.tryParse(json['valor_sugerido'].toString()) ?? 0.0
      ..desconto = double.tryParse(json['desconto'].toString()) ?? 0.0
      ..des_tratamento = json['des_tratamento'].toString()
      ..cod_tratamento = json['cod_tratamento'].toString()
      ..especialidade = Especialidade.fromJson(json['especialidade'])
      ..grupo = json['grupo'].toString()
      ..frequencia = json['frequencia'].toString()
      ..quantidade = json['quantidade'].toString()
      ..olho = json['olho'];
  }

  // Restante da implementação da classe Procedimento...
}
