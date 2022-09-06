import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/fidelimax.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/paginas.dart';
import 'package:biomaapp/screens/home/components/menu_bar_filtros.dart';
import 'package:biomaapp/screens/home/components/opcoesProcedimentosGrupos.dart';
import 'package:biomaapp/screens/procedimentos/filtroProcedimentos.dart';
import 'package:biomaapp/screens/search/search_screen.dart';
import 'package:biomaapp/utils/app_routes.dart';
import 'package:biomaapp/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:user_profile_avatar/user_profile_avatar.dart';
import 'package:badges/badges.dart';

import '../constants.dart';

class CustomAppBar extends StatefulWidget {
  CustomAppBar(
    this.text,
    this.title,
    this.press,
    this.actions,
  );

  final String text, title;
  List<Widget> actions;
  VoidCallback press;
  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    Fidelimax fidelimax = auth.fidelimax;
    filtrosAtivos filtros = auth.filtrosativos;
    filtros.BuscarFiltrosAtivos();
    Paginas pages = auth.paginas;

    var show = () {
      var show = showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return BottomSheet(
            onClosing: () {
              setState(() {
                pages.selecionarPaginaHome('Serviços');

                Navigator.of(context).pushReplacementNamed(
                  AppRoutes.AUTH_OR_HOME,
                );
                widget.press.call();
              });
            },
            builder: (BuildContext context) {
              bool b = false;
              return StatefulBuilder(
                  builder: (BuildContext context, setState) => Container(
                        height: MediaQuery.of(context).size.height * 0.7,
                        color: Color.fromARGB(255, 243, 246, 248),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              FiltrosProcedimentos(),
                            ],
                          ),
                        ),
                      ));
            },
          );
        },
      )
          .whenComplete(() => setState(() {
                pages.selecionarPaginaHome('Serviços');
                Navigator.of(context).pushReplacementNamed(
                  AppRoutes.AUTH_OR_HOME,
                );
                widget.press.call();
              }))
          .then((value) => setState(() {
                //widget.press.call();
              }));
    };

    return AppBar(
      title: Text.rich(
        TextSpan(
          text: widget.text,
          style: TextStyle(fontSize: 12),
          children: [
            TextSpan(
              text: widget.title,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ],
        ),
      ),
      actions: <Widget>[
            Badge(
              child: CircleAvatar(
                  backgroundColor: primaryColor,
                  radius: 25,
                  child: IconButton(
                      tooltip: 'Filtros Ativos',
                      onPressed: () {
                        setState(() {
                          show.call();
                        });
                      },
                      icon: Icon(
                        Icons.search,
                        size: 25,
                        color: Colors.black,
                      ))),
              showBadge: filtros.FiltrosAtivos > 0,
              toAnimate: true,
              shape: BadgeShape.square,
              //   ignorePointer: true,
              badgeColor: redColor,
              borderRadius: BorderRadius.circular(100),
              position: BadgePosition.topEnd(top: 2, end: -10),
              badgeContent: Padding(
                padding: const EdgeInsets.all(1),
                child: Text(filtros.FiltrosAtivos.toString()),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Badge(
              child: CircleAvatar(
                  backgroundColor: primaryColor,
                  radius: 25,
                  child: IconButton(
                      tooltip: 'Fila de desejos',
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed(
                          AppRoutes.ORDERS,
                        );
                      },
                      icon: Icon(
                        Icons.list,
                        size: 25,
                        color: Colors.black,
                      ))),
              showBadge: filtros.fila.isNotEmpty,
              toAnimate: true,
              shape: BadgeShape.square,
              //   ignorePointer: true,
              badgeColor: redColor,
              borderRadius: BorderRadius.circular(100),
              position: BadgePosition.topEnd(top: 2, end: -10),
              badgeContent: Padding(
                padding: const EdgeInsets.all(1),
                child: Text(filtros.fila.length.toString()),
              ),
            ),
            SizedBox(
              width: 10,
            ),
          ] +
          widget.actions,
    );
  }
}
