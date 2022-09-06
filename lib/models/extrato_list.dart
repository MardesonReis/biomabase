import 'dart:convert';
import 'dart:math';

import 'package:biomaapp/models/extrato.dart';
import 'package:biomaapp/models/fidelimax.dart';
import 'package:biomaapp/models/grupos.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:biomaapp/exceptions/http_exception.dart';
import 'package:biomaapp/utils/constants.dart';
import 'package:biomaapp/models/procedimento.dart';

class EstratoList with ChangeNotifier {
  final String _token;
  final String _userId;
  List<Extrato> _items = [];
  Fidelimax? fidelimax = Fidelimax();
  List<Extrato> get items => [..._items];

  // print(result.toList());
  EstratoList([
    this._token = '',
    this._userId = '',
    this._items = const [],
    this.fidelimax,
  ]);

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadExtrato() async {
    _items.clear();
    await this.fidelimax?.ExtratoConsumidor();
    this._items = this.fidelimax?.extrato ?? _items;

    notifyListeners();
  }
}
