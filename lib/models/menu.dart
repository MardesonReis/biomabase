import 'dart:convert';

import 'package:biomaapp/models/unidade.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:biomaapp/utils/constants.dart';

class Menu with ChangeNotifier {
  late String desc;
  late Widget page;
  late IconData Ico;
  late bool Status;

  Menu();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Menu && runtimeType == other.runtimeType && desc == other.desc;

  @override
  int get hashCode => desc.hashCode;

  @override
  String toString() {
    return desc;
  }
}
