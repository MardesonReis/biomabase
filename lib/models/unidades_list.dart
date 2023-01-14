import 'dart:convert';
import 'dart:math';

import 'package:biomaapp/models/medicos.dart';
import 'package:biomaapp/models/unidade.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:biomaapp/exceptions/http_exception.dart';
import 'package:biomaapp/utils/constants.dart';
import 'package:biomaapp/models/pacientes.dart';
import 'package:biomaapp/models/unidade.dart';

class UnidadesList with ChangeNotifier {
  final String _token;
  final String _userId;
  List<Unidade> _items = [];
  List<Unidade> get items => [..._items];

  // print(result.toList());
  UnidadesList([
    this._token = '',
    this._userId = '',
    this._items = const [],
  ]);

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadUnidades(String unidadeId) async {
    //debugPrint(cpf);
    _items.clear();
    var link = '${Constants.UNIDADES_BASE_URL}/' +
        unidadeId +
        '/0' +
        Constants.AUT_BASE;

    final response = await http.get(
      Uri.parse(link),
    );
    debugPrint(link);

    if (response.body == 'null') return;

    var data = jsonDecode(response.body);
    List unidades = jsonDecode(response.body)['dados'];
    await unidades.map((item) {
      Unidade u = Unidade(
          cod_unidade: item['codunidades'].toString(),
          des_unidade: item['unidades'].toString());

      u.contato = item['contato'].toString();
      u.logo = item['logo'].toString();
      u.ativo = item['ativo'].toString();
      u.nomecompleto = item['nomecompleto'].toString();
      u.logradouro = item['logradouro'].toString();
      u.numero = item['numero'].toString();
      u.complemento = item['complemento'].toString();
      u.municipio = item['municipio'].toString();
      u.uf = item['uf'].toString();
      u.cep = item['cep'].toString();
      u.codibge = item['codibge'].toString();
      u.cnpj = item['cnpj'].toString();
      u.bairro = item['bairro'].toString();
      u.novidades = item['novidades'].toString();
      u.cnes = item['cnes'].toString();

      _items.add(u);
    }).toList();

    _items.map((e) async {
      var link = '${Constants.LOCALIZACAO_BASE_URL}' +
          e.cod_unidade +
          '' +
          Constants.AUT_BASE;
      final response = await http.get(
        Uri.parse(link),
      );
      if (response.body == 'null') return;

      var data = jsonDecode(response.body);
      var id = _items.indexOf(e);
      List localizacoes = await jsonDecode(response.body)['dados'];
      await localizacoes.map((item) async {
        e.latitude = double.parse(item['latitude']);
        e.longitude = double.parse(item['longitude']);
      }).toList();
      if (_items[id].cod_unidade.isNotEmpty) {
        _items[id] = e;
      }
    }).toList();

    //notifyListeners();
    return;
  }
}
