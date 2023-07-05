import 'dart:convert';

import 'package:biomaapp/models/pacientes.dart';
import 'package:biomaapp/models/procedimento.dart';
import 'package:biomaapp/models/unidade.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:biomaapp/utils/constants.dart';

class Voucher with ChangeNotifier {
  String id;
  String code;
  List<Unidade> locais;
  List<Procedimento> servicos;
  List<Usuario> logista;
  List<Usuario> representantes;
  List<Usuario> clientes;
  String dataValidade;
  String observacao;
  String status;

  Voucher({
    required this.id,
    required this.code,
    required this.locais,
    required this.servicos,
    required this.logista,
    required this.representantes,
    required this.clientes,
    required this.dataValidade,
    required this.observacao,
    required this.status,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Voucher && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return id;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id.toString(),
      'code': code.toString(),
      'locais': locais.map((p) => p.toJson()).toList(),
      'servicos': servicos.map((p) => p.toJson()).toList(),
      'logista': logista.map((c) => c.toJson()).toList(),
      'representantes': representantes.map((r) => r.toJson()).toList(),
      'clientes': clientes.map((c) => c.toJson()).toList(),
      'dataValidade': dataValidade.toString(),
      'observacao': observacao.toString(),
      'status': status.toString(),
    };
  }

  factory Voucher.fromJson(Map<String, dynamic> json) {
    return Voucher(
      id: json['id'].toString(),
      code: json['code'].toString(),
      locais: List<Unidade>.from(
          json['locais'].map((item) => Unidade.fromJson(item))).toList(),
      servicos: List<Procedimento>.from(
          json['servicos'].map((item) => Procedimento.fromJson(item))),
      logista: List<Usuario>.from(
          json['logista'].map((item) => Usuario.fromJson(item))).toList(),
      representantes: List<Usuario>.from(
              json['representantes'].map((item) => Usuario.fromJson(item)))
          .toList(),
      clientes: [
        // List<Usuario>.from(
        //   json['clientes'].map((item) => Usuario.fromJson(item))).toList()
      ],
      dataValidade: json['datavalidade'].toString(),
      observacao: json['observacao'].toString(),
      status: json['status'].toString(),
    );
  }
  factory Voucher.erro() {
    return Voucher(
      id: '',
      code: '',
      locais: [],
      servicos: [],
      logista: [],
      representantes: [],
      clientes: [],
      dataValidade: '',
      observacao: '',
      status: '',
    );
  }
}
