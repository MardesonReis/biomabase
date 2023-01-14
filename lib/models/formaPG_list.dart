import 'dart:convert';

import 'package:biomaapp/models/formapagamento.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:biomaapp/models/cart.dart';
import 'package:biomaapp/models/cart_item.dart';
import 'package:biomaapp/models/order.dart';
import 'package:biomaapp/utils/constants.dart';

class FormaPgList with ChangeNotifier {
  final String _token;
  final String _userId;
  List<FormaPagamento> _items = [];

  FormaPgList([
    this._token = '',
    this._userId = '',
    this._items = const [],
  ]);

  List<FormaPagamento> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadFormasPg() async {
    _items.clear();
    final response = await http.get(
      Uri.parse(
          '${Constants.BIOMA_API}/formapagamento/listar/' + Constants.AUT_BASE),
    );
    if (response.body == 'null') return;
    List list = jsonDecode(response.body)['dados'];
    list.map((formaData) {
      _items.add(FormaPagamento(
          codforma: formaData['codforma'].toString(),
          formapgto: formaData['formapgto'].toString(),
          descricaotransacao: formaData['descricaotransacao'].toString(),
          negociacao: formaData['negociacao'].toString()));
    }).toList();

    _items = items.reversed.toList();
    notifyListeners();
  }
}
