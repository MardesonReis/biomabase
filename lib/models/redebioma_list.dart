import 'dart:convert';
import 'dart:math';

import 'package:biomaapp/models/indicacao.dart';
import 'package:biomaapp/models/medicos.dart';
import 'package:biomaapp/models/redebioma.dart';
import 'package:biomaapp/models/unidade.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:biomaapp/exceptions/http_exception.dart';
import 'package:biomaapp/utils/constants.dart';
import 'package:biomaapp/models/pacientes.dart';
import 'package:biomaapp/models/unidade.dart';

class RedeBiomaList with ChangeNotifier {
  final String _token;
  final String _userId;
  List<RedeBioma> _items = [];
  List<RedeBioma> get items => [..._items];

  // print(result.toList());
  RedeBiomaList([
    this._token = '',
    this._userId = '',
    this._items = const [],
  ]);

  int get itemsCount {
    return _items.length;
  }

  Future<List<RedeBioma>> ListarRede(String id) async {
    //debugPrint(cpf);
    _items.clear();
    var link = '${Constants.BIOMA_API}' +
        'redebioma/listar/' +
        id +
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
      RedeBioma i = RedeBioma(
          id: item['id'].toString(),
          parceiro: item['parceiro'].toString(),
          titulo: item['titulo'].toString(),
          subtitulo: item['subtitulo'].toString(),
          destaque: item['destaque'].toString(),
          img_promo: item['img_promo'].toString(),
          img_logo: item['img_logo'].toString(),
          link: item['link'].toString(),
          descricao: item['descricao'].toString(),
          instrucoes: item['instrucoes'].toString(),
          m_instrucoes: item['m_instrucoes'].toString(),
          termos: item['termos'].toString(),
          whatsapp: item['whatsapp'].toString());

      _items.add(i);
    }).toList();

    notifyListeners();
    return _items;
  }
}
