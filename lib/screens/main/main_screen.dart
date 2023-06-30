import 'package:biomaapp/components/ProgressIndicatorBioma.dart';
import 'package:biomaapp/components/app_drawer.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/agendamentos_list.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/data_list.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/paginas.dart';
import 'package:biomaapp/models/regras.dart';
import 'package:biomaapp/models/regras_list.dart';
import 'package:biomaapp/models/unidades_list.dart';
import 'package:biomaapp/screens/auth/auth_page_fi.dart';

import 'package:biomaapp/screens/home/components/botton_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedPage = 0;
  bool _expanded = false;
  bool _isLoading = true;

  List<Regra> regras = [];
  @override
  void initState() {
    super.initState();

    var auth = Provider.of<Auth>(
      context,
      listen: false,
    );

    var regraList = Provider.of<RegrasList>(
      context,
      listen: false,
    );

    filtrosAtivos filtros = auth.filtrosativos;
    auth.atualizaAcesso(context, () {}).then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    filtrosAtivos filtros = auth.filtrosativos;

    Paginas pages = auth.paginas;
    var body;

    var pages_home = pages.pages;

    body = pages.pages[pages.selectedPage]['page'] as Widget;

    return Scaffold(
      body: _isLoading ? Center(child: ProgressIndicatorBioma()) : body,
      bottomNavigationBar: _isLoading ? SizedBox() : BottonMenu(),
      drawer: AppDrawer(),
    );
  }
}
