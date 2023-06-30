import 'package:biomaapp/screens/saude/PageProgresso.dart';

import 'package:flutter/material.dart';

class BottonMenuMinhaSaudePages with ChangeNotifier {
  int selectedPage = 0;
  List<Map<String, Object>> pages = [
    {
      'desc': 'Progresso',
      'page': Progresses(),
      'Ico': Icons.drag_indicator,
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
