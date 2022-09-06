import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/Clips.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/grupos.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class MenuBarGrupos extends StatefulWidget {
  List<Grupo> grupos;
  VoidCallback press;
  MenuBarGrupos(this.grupos, this.press);
  @override
  State<MenuBarGrupos> createState() => _MenuBarGruposState();
}

class _MenuBarGruposState extends State<MenuBarGrupos> {
  final AutoScrollController controllerConvenios = AutoScrollController();
  int _selectedConvenios = 0;
  double _height = 60;

  void _scrollToIndexGrupos(int index) {
    controllerConvenios.animateTo(_height * index,
        duration: const Duration(seconds: 1), curve: Curves.slowMiddle);
  }

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    filtrosAtivos filtros = auth.filtrosativos;
    return Container(
      margin: EdgeInsets.all(1),
      padding: EdgeInsets.all(1),
      alignment: Alignment.topCenter,
      height: 50,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        padding: EdgeInsets.all(1),
        controller: controllerConvenios,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, i) {
          return Padding(
            padding: const EdgeInsets.all(3),
            child: InkWell(
              onTap: () {
                _scrollToIndexGrupos(i);
                setState(() {
                  //filtros.LimparGrupos();
                  filtros.grupos.contains(widget.grupos[i])
                      ? filtros.removerGrupos(widget.grupos[i])
                      : filtros.addGrupos(widget.grupos[i]);
                  widget.press.call();
                });
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: filtros.grupos.contains(widget.grupos[i])
                      ? primaryColor
                      : Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(3),
                      child: Text(widget.grupos[i].descricao.capitalize(),
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: widget.grupos.length,
      ),
    );
  }
}
