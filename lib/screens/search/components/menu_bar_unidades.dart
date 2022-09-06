import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/Clips.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/unidade.dart';
import 'package:biomaapp/models/unidade.dart';
import 'package:biomaapp/models/unidade.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class MenuBarUnidades extends StatefulWidget {
  List<Unidade> unidades;
  VoidCallback press;
  MenuBarUnidades(this.unidades, this.press);
  @override
  State<MenuBarUnidades> createState() => _MenuBarUnidadesState();
}

class _MenuBarUnidadesState extends State<MenuBarUnidades> {
  final AutoScrollController controllerConvenios = AutoScrollController();
  int _selectedConvenios = 0;
  double _height = 50;

  void _scrollToIndexUnidades(int index) {
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
      height: 60,
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
                _scrollToIndexUnidades(i);
                setState(() {
                  filtros.LimparUnidade();
                  filtros.unidades.contains(widget.unidades[i])
                      ? filtros.removerUnidades(widget.unidades[i])
                      : filtros.addunidades(widget.unidades[i]);
                });
                widget.press.call();
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: filtros.unidades.contains(widget.unidades[i])
                      ? primaryColor
                      : Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(3),
                      child: Text(
                          " " + widget.unidades[i].des_unidade.capitalize(),
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3),
                      child: Text(
                          widget.unidades[i].municipio.capitalize() +
                              ' - ' +
                              widget.unidades[i].bairro.capitalize(),
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
        itemCount: widget.unidades.length,
      ),
    );
  }
}
