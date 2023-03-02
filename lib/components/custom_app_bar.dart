import 'package:biomaapp/components/ProgressIndicatorBioma.dart';
import 'package:biomaapp/models/Clips.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/fidelimax.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/paginas.dart';
import 'package:biomaapp/models/regras_list.dart';
import 'package:biomaapp/screens/home/components/menu_bar_filtros.dart';
import 'package:biomaapp/screens/home/components/opcoesProcedimentosGrupos.dart';
import 'package:biomaapp/screens/pedidos/orders_page.dart';
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
  bool _isLogin = true;
  @override
  void initState() {
    if (!mounted) return;

    super.initState();
    var regraList = Provider.of<RegrasList>(
      context,
      listen: false,
    );
    var auth = Provider.of<Auth>(
      context,
      listen: false,
    );

    auth.atualizaAcesso(context, () {
      setState(() {});
    }).then((value) {
      setState(() {
        _isLogin = false;
      });
    });

    //13978829304

    // regraList.carrgardados(context, all: false, Onpress: () {});
  }

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    Fidelimax fidelimax = auth.fidelimax;
    filtrosAtivos filtros = auth.filtrosativos;

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
      // flexibleSpace: Container(
      //   decoration: BoxDecoration(
      //     gradient: LinearGradient(
      //       colors: [
      //         Color.fromRGBO(149, 111, 253, 0.9),
      //         Color.fromRGBO(21, 219, 226, 0.9),
      //       ],
      //       begin: Alignment.topLeft,
      //       end: Alignment.bottomRight,
      //     ),
      //   ),
      // ),
      // leading: Padding(
      //   padding: const EdgeInsets.all(4.0),
      //   child: new Image.asset('assets/imagens/biomaLogo.png'),
      // ),

      iconTheme: const IconThemeData(
        //size: 40, //change size on your need
        color: destColor, //change color on your need
      ),

      backgroundColor: Colors.transparent,
      elevation: 0.0,
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
            if (auth.isAuth)
              Badge(
                child: IconButton(
                  tooltip: 'Bions',
                  onPressed: () {
                    setState(() {
                      Navigator.of(context).pushNamed(
                        AppRoutes.EXTRATO_FIDELIMAX,
                        //    arguments: auth.fidelimax,
                      );
                      //   show.call();
                    });
                  },
                  icon: Image.asset('assets/icons/bions.png'),
                ),
                // showBadge: filtros.FiltrosAtivos > 0,
                toAnimate: true,
                shape: BadgeShape.square,
                //   ignorePointer: true,
                badgeColor: Colors.yellow,
                borderRadius: BorderRadius.circular(100),
                position: BadgePosition.topEnd(top: 10, end: -18),
                badgeContent: InkWell(
                  onTap: () {
                    setState(() {
                      Navigator.of(context).pushNamed(
                        AppRoutes.EXTRATO_FIDELIMAX,
                        //    arguments: auth.fidelimax,
                      );
                      //   show.call();
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(1),
                    child: Text(
                      auth.fidelimax.saldo.toString(),
                      style: TextStyle(fontSize: 8),
                    ),
                  ),
                ),
              ),
            SizedBox(
              width: 10,
            ),
            Badge(
              child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 25,
                  child: IconButton(
                      tooltip: 'Cesta de Solicitações',
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrdersPage(Clips(
                                  titulo: 'Solicitar',
                                  subtitulo: '',
                                  keyId: 'S')),
                            )).then((value) {
                          setState(() {});
                        });
                      },
                      icon: Icon(
                        Icons.hub_sharp,
                        size: 25,
                        color: destColor,
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
