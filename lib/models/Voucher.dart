import 'dart:convert';

import 'package:biomaapp/models/pacientes.dart';
import 'package:biomaapp/models/procedimento.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:biomaapp/utils/constants.dart';

class Voucher with ChangeNotifier {
  String id;
  String code;
  List<Procedimento> product;
  Usuario logistaCPF;
  List<Usuario> representante;
  List<Usuario> clientes;
  String dataValidade;
  String observacao;
  String status;

  Voucher({
    required this.id,
    required this.code,
    required this.product,
    required this.logistaCPF,
    required this.representante,
    required this.clientes,
    required this.dataValidade,
    required this.observacao,
    required this.status,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Voucher &&
          runtimeType == other.runtimeType &&
          code == other.code;

  @override
  int get hashCode => code.hashCode;

  @override
  String toString() {
    return code;
  }

  Map<String, dynamic> toJson() {
    return {
      // 'id': id.toString(),
      //  'code': code.toString(),
      'product': product.map((p) => p.toJson()).toList(),
      'logistaCPF': logistaCPF.toJson(),
      'representante': representante.map((r) => r.toJson()).toList(),
      'clientes': clientes.map((c) => c.toJson()).toList(),
      'dataValidade': dataValidade.toString(),
      'observacao': observacao.toString(),
      'status': status.toString(),
    };
  }

  factory Voucher.fromJson(Map<String, dynamic> json) {
    return Voucher(
      id: json['id'],
      code: json['code'],
      product: List<Procedimento>.from(
          json['product'].map((item) => Procedimento.fromJson(item))),
      logistaCPF: Usuario.fromJson(json['logistaCPF']),
      representante: List<Usuario>.from(
          json['representante'].map((item) => Usuario.fromJson(item))),
      clientes: List<Usuario>.from(
          json['clientes'].map((item) => Usuario.fromJson(item))),
      dataValidade: json['dataValidade'],
      observacao: json['observacao'],
      status: json['status'],
    );
  }
}
