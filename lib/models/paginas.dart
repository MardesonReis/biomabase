import 'dart:convert';

import 'package:biomaapp/models/Clips.dart';
import 'package:biomaapp/screens/appointment/my_appointment_screen.dart';
import 'package:biomaapp/screens/doctors/doctors_screen.dart';
import 'package:biomaapp/screens/home/home_screen.dart';
import 'package:biomaapp/screens/pedidos/indicacoes_screen.dart';
import 'package:biomaapp/screens/profile/profile_screen.dart';
import 'package:biomaapp/screens/servicos/ServicosScreen.dart';
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
      'desc': 'Home',
      'page': ServicosScreen(),
      'Ico': Icons.home,
    },
    {'desc': 'Indicações', 'page': IndicacoesScreen(), 'Ico': Icons.share},
    {
      'desc': 'Agendamentos',
      'page': MyAppointmentScreen(),
      'Ico': Icons.calendar_month
    },
    {
      'desc': 'Meu Perfil',
      'page': ProfileScreen(),
      'Ico': Icons.person,
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
