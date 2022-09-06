import 'package:biomaapp/components/app_drawer.dart';

import 'package:biomaapp/screens/home/components/menu_bar_filtros.dart';

import 'package:biomaapp/screens/search/search_result_screen.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class BuscaRapida extends StatefulWidget {
  const BuscaRapida({Key? key}) : super(key: key);

  @override
  _BuscaRapidaState createState() => _BuscaRapidaState();
}

class _BuscaRapidaState extends State<BuscaRapida> {
// Define the fixed height for an item

  // Define the function that scroll to an item

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buscar Por'),
      ),
      body: Column(children: [
        MenuBarFiltros(),
      ]),
      //    bottomNavigationBar: Text('data'),
      drawer: AppDrawer(),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchResultScreen(),
            ),
          );
        },
        label: const Text('Buscar'),
        icon: const Icon(Icons.search),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
