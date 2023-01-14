import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:biomaapp/utils/constants.dart';

class LDatas with ChangeNotifier {
  final String medico;
  final String data;
  final String unidade;
  final String especialidade;

  LDatas({
    required this.medico,
    required this.data,
    required this.unidade,
    required this.especialidade,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LDatas &&
          runtimeType == other.runtimeType &&
          data.toString() == other.data.toString();

  @override
  int get hashCode => data.toString().hashCode;

  @override
  String toString() {
    return data.toString();
  }
}
