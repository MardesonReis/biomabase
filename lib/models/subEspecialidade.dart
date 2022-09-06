import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:biomaapp/utils/constants.dart';

class SubEspecialidade with ChangeNotifier {
  final String descricao;

  SubEspecialidade({
    required this.descricao,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubEspecialidade &&
          runtimeType == other.runtimeType &&
          descricao == other.descricao;

  @override
  int get hashCode => descricao.hashCode;

  @override
  String toString() {
    return descricao;
  }
}
