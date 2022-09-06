import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/Clips.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/especialidade.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/subEspecialidade.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class MenuBarSubEspecialidades extends StatefulWidget {
  List<SubEspecialidade> subespecialidades;
  VoidCallback press;
  MenuBarSubEspecialidades(this.subespecialidades, this.press);
  @override
  State<MenuBarSubEspecialidades> createState() =>
      _MenuBarSubEspecialidadesState();
}

class _MenuBarSubEspecialidadesState extends State<MenuBarSubEspecialidades> {
  final AutoScrollController controllerSubespecialidades =
      AutoScrollController();
  int _selectedConvenios = 0;
  double _height = 50;

  void _scrollToIndexSubEspecialidades(int index) {
    controllerSubespecialidades.animateTo(_height * index,
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
        controller: controllerSubespecialidades,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, i) {
          return Padding(
            padding: const EdgeInsets.all(3),
            child: InkWell(
              onTap: () {
                setState(() {
                  _scrollToIndexSubEspecialidades(i);
                  //   filtros.LimparSubEspecialidades();
                  filtros.subespecialidades
                          .contains(widget.subespecialidades[i])
                      ? filtros
                          .removerSubEspacialidades(widget.subespecialidades[i])
                      : filtros
                          .addSubEspacialidades(widget.subespecialidades[i]);
                  widget.press.call();
                });
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: filtros.subespecialidades
                          .contains(widget.subespecialidades[i])
                      ? primaryColor
                      : Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(3),
                      child: Text(
                          widget.subespecialidades[i].descricao.capitalize(),
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
        itemCount: widget.subespecialidades.length,
      ),
    );
  }
}
