import 'package:biomaapp/models/cart_item.dart';
import 'package:flutter/material.dart';

class Extrato with ChangeNotifier {
  final String? credito;
  final String? debito;
  final String? premio_nome;
  final String? premio_identificador;
  final String? voucher;
  final String? voucher_resgatado;
  final String data_pontuacao;
  final String? data_expiracao;
  final String? verificador;
  final String? tipo_compra;
  final String? loja;
  final String? tipo_pontuacao;

  Extrato({
    required this.credito,
    required this.debito,
    required this.premio_nome,
    required this.premio_identificador,
    required this.voucher,
    required this.voucher_resgatado,
    required this.data_pontuacao,
    required this.data_expiracao,
    required this.verificador,
    required this.tipo_compra,
    required this.loja,
    required this.tipo_pontuacao,
  });
}
