import 'dart:convert';

import 'package:biomaapp/components/app_drawer.dart';
import 'package:biomaapp/components/custom_app_bar.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/Clips.dart';
import 'package:biomaapp/screens/appointment/meusAgendamentos.dart';
import 'package:biomaapp/screens/doctors/doctors_screen.dart';
import 'package:biomaapp/screens/home/home_screen.dart';
import 'package:biomaapp/screens/pedidos/indicacoes_screen.dart';
import 'package:biomaapp/screens/profile/profile_screen.dart';
import 'package:biomaapp/screens/servicos/ServicosScreen.dart';
import 'package:biomaapp/screens/servicos/componets/localizacaoScreen.dart';
import 'package:biomaapp/screens/servicos/componets/menuCalendario.dart';
import 'package:biomaapp/screens/servicos/componets/menuEspecialistas.dart';
import 'package:biomaapp/screens/servicos/componets/menuProcedimentos.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:biomaapp/utils/constants.dart';

class Paginas with ChangeNotifier {
  int selectedPage = 0;
  List<Map<String, Object>> pages = [
    // {
    //   'desc': 'Home',
    //   'page': HomePage(),
    //   'Ico': Icons.home,
    // },

    {
      'desc': 'Localização',
      'page': LocalizacaoScreen(),
      'Ico': Icons.location_on,
    },
    {
      'desc': 'Especialistas',
      'page': MenuEspecialista(),
      'Ico': Icons.medical_information,
    },
    {
      'desc': 'Procedimentos',
      'page': MenuProcedimentos(),

      //  'page': ServicosScreen(),
      'Ico': Icons.insert_chart_outlined_outlined,
    },
    //{'desc': 'Indicações', 'page': IndicacoesScreen(), 'Ico': Icons.share},
    {
      'desc': 'Agenda',
      'page': MenuCalendario(),

      //'page': MyAppointmentScreen(),
      'Ico': Icons.calendar_month
    },
  ];

  Future<void> addPageHome(Map<String, StatefulWidget> page) async {
    pages.add(page);

    notifyListeners();
  }

  Future<void> selecionarPaginaHome(String page) async {
    var p = pages.where((element) => element['desc'] == page).toList();

    selectedPage = pages.indexOf(p.first);

    notifyListeners();
  }
}
