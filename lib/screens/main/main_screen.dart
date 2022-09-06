import 'package:biomaapp/components/app_drawer.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/data_list.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/paginas.dart';

import 'package:biomaapp/screens/home/components/botton_menu.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();

    var auth = Provider.of<Auth>(
      context,
      listen: false,
    );
    var dados = Provider.of<DataList>(
      context,
      listen: false,
    );

    dados.items.isEmpty
        ? dados.loadDados('').then((value) => setState(() {
              _isLoading = false;
            }))
        : setState(() {
            _isLoading = false;
          });
  }

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    filtrosAtivos filtros = auth.filtrosativos;

    Paginas pages = auth.paginas;

    var pages_home = pages.pages;

    var body = pages.pages[pages.selectedPage]['page'] as Widget;

    return Scaffold(
      body: _isLoading ? Center(child: CircularProgressIndicator()) : body,
      bottomNavigationBar: BottonMenu(),
      drawer: AppDrawer(),
    );
  }
}
