import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:biomaapp/utils/constants.dart';

class RedeBioma with ChangeNotifier {
  final String id;
  final String parceiro;
  final String titulo;
  final String subtitulo;
  final String destaque;
  final String img_promo;
  final String img_logo;
  final String link;
  final String descricao;
  final String instrucoes;
  final String m_instrucoes;
  final String termos;
  final String whatsapp;

  RedeBioma({
    required this.id,
    required this.parceiro,
    required this.titulo,
    required this.subtitulo,
    required this.destaque,
    required this.img_promo,
    required this.img_logo,
    required this.link,
    required this.descricao,
    required this.instrucoes,
    required this.m_instrucoes,
    required this.termos,
    required this.whatsapp,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RedeBioma &&
          runtimeType == other.runtimeType &&
          descricao == other.id;

  @override
  int get hashCode => descricao.hashCode;

  @override
  String toString() {
    return descricao;
  }
}
