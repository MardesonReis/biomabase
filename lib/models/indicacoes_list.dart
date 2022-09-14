import 'dart:convert';
import 'dart:math';

import 'package:biomaapp/models/indicacao.dart';
import 'package:biomaapp/models/medicos.dart';
import 'package:biomaapp/models/unidade.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:biomaapp/exceptions/http_exception.dart';
import 'package:biomaapp/utils/constants.dart';
import 'package:biomaapp/models/pacientes.dart';
import 'package:biomaapp/models/unidade.dart';

class IndicacoesList with ChangeNotifier {
  final String _token;
  final String _userId;
  List<Indicacao> _indicacoes = [];
  List<Indicacao> _items = [];
  List<Indicacao> get items => [..._items];
  List<Indicacao> get indicacoes => [..._indicacoes];

  // print(result.toList());
  IndicacoesList([
    this._token = '',
    this._userId = '',
    this._items = const [],
  ]);

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadIndicacoes(
      String autor, String IndicacaoID, String id_servico) async {
    //debugPrint(cpf);
    _indicacoes.clear();
    var link = '${Constants.FILA_BASE_URL}' +
        'loadIndicacoes/' +
        autor +
        '/' +
        IndicacaoID +
        '/' +
        id_servico +
        '/' +
        '' +
        Constants.AUT_BASE;
    print(link);
    final response = await http.get(
      Uri.parse(link),
    );
    if (response.body == 'null') return;
    var data = jsonDecode(response.body);
    List indicacoes = jsonDecode(response.body)['dados'];
    await indicacoes.map((item) {
      Indicacao i = Indicacao();

      i.id_indicacao = item['id_indicacao'];
      i.id_servico = item['id_servico'];
      i.descricao = item['descricao'];
      i.status = item['status'];
      i.data_criacao = item['data_criacao'];
      i.hora_criacao = item['hora_criacao'];
      i.autor = item['autor'];
      i.visivel = item['visivel'];
      i.cod_procedimento = item['cod_procedimento'];
      i.des_procedimento = item['des_procedimento'];
      i.cod_convenio = item['cod_convenio'];
      i.des_convenio = item['des_convenio'];
      i.cod_tratamento = item['cod_tratamento'];
      i.des_tratamento = item['des_tratamento'];
      i.cod_especialista = item['cod_especialista'];
      i.des_especialista = item['des_especialista'];
      i.cod_unidade = item['cod_unidade'];
      i.des_unidade = item['des_unidade'];
      i.cod_especialidade = item['cod_especialidade'];
      i.des_especialidade = item['des_especialidade'];
      i.valor = item['valor'];
      i.olho = item['olho'];
      i.quantidade = item['quantidade'];
      i.obs = item['obs'];
      i.data = item['data'];

      _indicacoes.add(i);
    }).toList();

    notifyListeners();
    return;
  }

  Future<List<Indicacao>> loadIndicacoesItens(
      String autor, String IndicacaoID, String id_servico) async {
    //debugPrint(cpf);
    _items.clear();
    var link = '${Constants.FILA_BASE_URL}' +
        'loadIndicacoes/' +
        autor +
        '/' +
        IndicacaoID +
        '/' +
        id_servico +
        '/' +
        '' +
        Constants.AUT_BASE;
    print(link);
    final response = await http.get(
      Uri.parse(link),
    );
    if (response.body == 'null') return [];
    // print(response.body);
    var data = jsonDecode(response.body);
    List indicacoes = jsonDecode(response.body)['dados'];
    await indicacoes.map((item) {
      Indicacao i = Indicacao();

      i.id_indicacao = item['id_indicacao'];
      i.id_servico = item['id_servico'];
      i.descricao = item['descricao'];
      i.status = item['status'];
      i.data_criacao = item['data_criacao'];
      i.hora_criacao = item['hora_criacao'];
      i.autor = item['autor'];
      i.visivel = item['visivel'];
      i.cod_procedimento = item['cod_procedimento'];
      i.des_procedimento = item['des_procedimento'];
      i.cod_convenio = item['cod_convenio'];
      i.des_convenio = item['des_convenio'];
      i.cod_tratamento = item['cod_tratamento'];
      i.des_tratamento = item['des_tratamento'];
      i.cod_especialista = item['cod_especialista'];
      i.des_especialista = item['des_especialista'];
      i.cod_unidade = item['cod_unidade'];
      i.des_unidade = item['des_unidade'];
      i.cod_especialidade = item['cod_especialidade'];
      i.des_especialidade = item['des_especialidade'];
      i.valor = item['valor'];
      i.olho = item['olho'];
      i.quantidade = item['quantidade'];
      i.obs = item['obs'];
      i.data = item['data'];

      _items.add(i);
    }).toList();

    notifyListeners();
    return _items;
  }
}
