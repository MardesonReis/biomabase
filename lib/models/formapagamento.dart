import 'dart:convert';

import 'package:biomaapp/models/procedimento.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:biomaapp/utils/constants.dart';

class FormaPagamento with ChangeNotifier {
  final String codforma;
  final String formapgto;
  final String descricaotransacao;
  final String negociacao;

  FormaPagamento(
      {required this.codforma,
      required this.formapgto,
      required this.descricaotransacao,
      required this.negociacao});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FormaPagamento &&
          runtimeType == other.runtimeType &&
          formapgto == other.formapgto;

  @override
  int get hashCode => formapgto.hashCode;

  @override
  String toString() {
    return formapgto;
  }
}
