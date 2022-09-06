import 'package:biomaapp/screens/home/components/opcoesProcedimentosGrupos.dart';
import 'package:biomaapp/screens/home/components/opcoesUnidades.dart';

import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class MenuBarFiltros extends StatefulWidget {
  const MenuBarFiltros({Key? key}) : super(key: key);

  @override
  _MenuBarFiltrosState createState() => _MenuBarFiltrosState();
}

class _MenuBarFiltrosState extends State<MenuBarFiltros> {
  final List<List<Widget>> _pgs = [
    [
      Text(
        'Pacientes',
      ),
      Icon(Icons.person)
    ],
    [opcoesUnidades(), Text('Especialistas'), Icon(Icons.person)],
    [opcoesUnidades(), Text('Unidades'), Icon(Icons.person)],
    [OpcoesProcedimentosGrupos(), Text('Procedimentos'), Icon(Icons.person)],
  ];
  int _selectedPage = 0;
  final AutoScrollController controller = AutoScrollController();

  int _currentFocusedIndex = 0;
// Define the fixed height for an item
  final double _height = 60;

  // Define the function that scroll to an item
  void _scrollToIndex(int index) {
    controller.animateTo(_height * index,
        duration: const Duration(seconds: 1), curve: Curves.slowMiddle);
  }

  var nome;
  var wig;
  var ico;
  var selected = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.all(1),
                  padding: EdgeInsets.all(1),
                  alignment: Alignment.topCenter,
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    padding: EdgeInsets.all(1),
                    controller: controller,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (_, i) {
                      var wig = _pgs[i][0];
                      var nome = _pgs[i][1];
                      var ico = _pgs[i][2];

                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Color.fromARGB(255, 255, 255, 255)),
                          color: selected == i
                              ? Color.fromARGB(255, 138, 200, 248)
                              : Color.fromARGB(146, 179, 180, 218),
                        ),
                        alignment: Alignment.topCenter,
                        width: 120,
                        clipBehavior: Clip.none,
                        child: ListTile(
                          key: Key(i.toString()),
                          title: Center(
                            child: Text(nome.toString().split('"')[1],
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(fontWeight: FontWeight.w900)),
                          ),
                          onTap: () {
                            setState(() {
                              _scrollToIndex(i);

                              _selectedPage = i;
                              selected = i;
                            });
                          },
                        ),
                      );
                    },
                    itemCount: _pgs.length,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _pgs[_selectedPage][0],
            ],
          ),
        ),
      ],
    );
  }
}
