import 'dart:convert';

import 'package:biomaapp/models/unidade.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:biomaapp/utils/constants.dart';

class Rateio with ChangeNotifier {
  final String id_rateio;
  final String id_regra;
  final String des_repasse;
  final String participacao;

  Rateio({
    required this.id_rateio,
    required this.id_regra,
    required this.des_repasse,
    required this.participacao,
  });
}
