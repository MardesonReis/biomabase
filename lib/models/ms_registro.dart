import 'package:biomaapp/models/Clips.dart';
import 'package:biomaapp/models/convenios.dart';
import 'package:biomaapp/models/medicos.dart';
import 'package:biomaapp/models/pacientes.dart';
import 'package:biomaapp/models/procedimento.dart';
import 'package:biomaapp/models/unidade.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:biomaapp/utils/constants.dart';

class Ms_registro with ChangeNotifier {
  late String id;
  late String ms_id;
  late String ms_value;
  late String ms_value_agrupado;
  late String cpf_paciente;
  late String cpf_responsavel;
  late String obs;
  late DateTime data_registro;
  late String hora_registro;

  Ms_registro({
    required this.id,
    required this.ms_id,
    required this.ms_value,
    required this.ms_value_agrupado,
    required this.cpf_paciente,
    required this.cpf_responsavel,
    required this.obs,
    required this.data_registro,
    required this.hora_registro,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Ms_registro &&
          runtimeType == other.runtimeType &&
          id.toString() == other.id.toString();

  @override
  int get hashCode => id.toString().hashCode;

  @override
  String toString() {
    return id.toString() + '-' + ms_id.toString();
  }
}
