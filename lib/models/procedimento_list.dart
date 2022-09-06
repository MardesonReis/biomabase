import 'dart:convert';

import 'package:biomaapp/models/Clips.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/grupos.dart';
import 'package:biomaapp/models/unidade.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:biomaapp/exceptions/http_exception.dart';
import 'package:biomaapp/utils/constants.dart';
import 'package:biomaapp/models/procedimento.dart';

class ProcedimentoList with ChangeNotifier {
  final String _token;
  final String _userId;
  List<Procedimento> _items = [];
  List<Procedimento> get items => [..._items];
  List<Clips> _grupos = [];
  List<Clips> get grupos => [..._grupos];
  List<Clips> _especialidades = [];
  List<Clips> get especialidades => [..._especialidades];

  List<Clips> _convenios = [];
  List<Clips> get convenios => [..._convenios];

  List<Clips> _unidades = [];
  List<Clips> get unidades => [..._unidades];

  // print(result.toList());
  ProcedimentoList([
    this._token = '',
    this._userId = '',
    this._items = const [],
  ]);

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadProcedimentos(String unidade) async {
    debugPrint('${Constants.PROCEDIMENTO_BASE_URL}/' +
        unidade +
        '/0/0' +
        Constants.AUT_BASE);
    final response = await http.get(
      Uri.parse('${Constants.PROCEDIMENTO_BASE_URL}/' +
          unidade +
          '/0/0' +
          Constants.AUT_BASE),
    );
    if (response.body == 'null') return;

    final data = jsonDecode(response.body);
    List proced = jsonDecode(response.body)['dados'];

    await proced.map(
      (item) {
        debugPrint(item['cod_procedimento'].toString());
        // debugPrint(double.parse(item['frequencia']).toString());

        Procedimento p = Procedimento();
        p.cod_procedimentos = item['cod_procedimento'].toString();
        p.des_procedimentos = item['descricaounificada'].toString().isEmpty
            ? item['descricao']
            : item['descricaounificada'].toString();

        p.valor = item['valor'];
        p.grupo = item['grupo'].toString() +
            ' - ' +
            item['tipo_tratamento'].toString();

        p.frequencia = item['frequencia'].toString();
        p.quantidade = item['tabop_quantidade'].toString();
        this._items.add(p);
      },
    ).toList();

//    for (var item in data['dados']) {}
    Set<String> gruposIncluso = Set();
    Set<String> unidadesIncluso = Set();
    Set<String> ConvenioIncluso = Set();
    Set<String> especialidadesIncluso = Set();

    _items.sort((a, b) =>
        double.parse(b.frequencia).compareTo(double.parse(a.frequencia)));
    _convenios.sort((a, b) =>
        double.parse(b.subtitulo).compareTo(double.parse(a.subtitulo)));
    _especialidades.sort((a, b) =>
        double.parse(b.subtitulo).compareTo(double.parse(a.subtitulo)));
    _unidades.sort((a, b) =>
        double.parse(b.subtitulo).compareTo(double.parse(a.subtitulo)));
    _grupos.sort((a, b) =>
        double.parse(b.subtitulo).compareTo(double.parse(a.subtitulo)));

    notifyListeners();
  }
}
