import 'dart:convert';
import 'dart:math';

import 'package:biomaapp/models/convenios.dart';
import 'package:biomaapp/models/especialidade.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:biomaapp/exceptions/http_exception.dart';
import 'package:biomaapp/utils/constants.dart';
import 'package:biomaapp/models/pacientes.dart';

class ConveniosList with ChangeNotifier {
  final String _token;
  final String _userId;
  List<Convenios> _items = [];
  List<Convenios> get items => [..._items];

  // print(result.toList());
  ConveniosList([
    this._token = '',
    this._userId = '',
    this._items = const [],
  ]);

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadConvenios(String cod_convenio) async {
    //debugPrint(cpf);

    _items.clear();
    debugPrint(
        '${Constants.CONVENIOS_BASE_URL}/' + cod_convenio + Constants.AUT_BASE);
    final response = await http.get(
      Uri.parse('${Constants.CONVENIOS_BASE_URL}/' +
          cod_convenio +
          Constants.AUT_BASE),
    );
    if (response.body == 'null') return;
    //debugPrint(response.body);
    final data = jsonDecode(response.body);
    List ESPECIALIDADE = jsonDecode(response.body)['dados'];

    ESPECIALIDADE.map(
      (item) {
        //    debugPrint('Carregando especialidade: ${item['especialidade']}');
        _items.add(Convenios(
          cod_convenio: item['codconvenio'].toString(),
          desc_convenio: item['descricao'].toString(),
        ));
      },
    ).toList();

    notifyListeners();
    return;
  }
}
