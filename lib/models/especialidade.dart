import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:biomaapp/utils/constants.dart';

class Especialidade with ChangeNotifier {
  String codespecialidade;
  String descricao;
  String ativo;

  Especialidade(
      {required this.codespecialidade,
      required this.descricao,
      required this.ativo});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Especialidade &&
          runtimeType == other.runtimeType &&
          descricao == other.descricao;

  @override
  int get hashCode => descricao.hashCode;

  @override
  String toString() {
    return descricao;
  }
}
