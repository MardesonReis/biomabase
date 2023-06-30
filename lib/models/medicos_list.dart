import 'dart:convert';
import 'dart:math';

import 'package:biomaapp/models/convenios.dart';
import 'package:biomaapp/models/especialidade.dart';
import 'package:biomaapp/models/medicos.dart';
import 'package:biomaapp/models/procedimento.dart';
import 'package:biomaapp/models/unidade.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:biomaapp/exceptions/http_exception.dart';
import 'package:biomaapp/utils/constants.dart';
import 'package:biomaapp/models/pacientes.dart';

class MedicosList with ChangeNotifier {
  final String _token;
  final String _userId;

  List<Medicos> _items = [];
  List<Medicos> get items => [..._items];

  List<Medicos> medicos = [];

  List<Unidade> unidades = [];

  List<Convenios> convenios = [];

  // print(result.toList());
  MedicosList([
    this._token = '',
    this._userId = '',
    this._items = const [],
  ]);

  int get itemsCount {
    return items.length;
  }
}
