import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:biomaapp/utils/constants.dart';

class Grupo with ChangeNotifier {
  final String descricao;

  Grupo({
    required this.descricao,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Grupo &&
          runtimeType == other.runtimeType &&
          descricao == other.descricao;

  @override
  int get hashCode => descricao.hashCode;

  @override
  String toString() {
    return descricao;
  }
}
