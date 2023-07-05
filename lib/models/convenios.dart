import 'dart:convert';

import 'package:biomaapp/models/procedimento.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:biomaapp/utils/constants.dart';

class Convenios with ChangeNotifier {
  final String cod_convenio;
  final String desc_convenio;

  Convenios({required this.cod_convenio, required this.desc_convenio});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Convenios &&
          runtimeType == other.runtimeType &&
          desc_convenio == other.desc_convenio;

  @override
  int get hashCode => desc_convenio.hashCode;

  @override
  String toString() {
    return desc_convenio;
  }

  Map<String, dynamic> toJson() {
    return {
      'cod_convenio': cod_convenio.toString(),
      'desc_convenio': desc_convenio.toString(),
    };
  }

  factory Convenios.fromJson(Map<String, dynamic> json) {
    return Convenios(
      cod_convenio: json['cod_convenio'].toString(),
      desc_convenio: json['desc_convenio'].toString(),
    );
  }
}
