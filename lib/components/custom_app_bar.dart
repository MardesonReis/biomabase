import 'package:biomaapp/components/ProgressIndicatorBioma.dart';
import 'package:biomaapp/models/Clips.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/fidelimax.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/paginas.dart';
import 'package:biomaapp/models/regras_list.dart';
import 'package:biomaapp/screens/auth/auth_or_home_page.dart';
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
import 'package:badges/badges.dart' as bdg;

import '../constants.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
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
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
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

      iconTheme: IconThemeData(
          size: 32, //change size on your need
          color: destColor,

          //change color on your need
          shadows: [
            Shadow(blurRadius: 3.0, color: Colors.grey, offset: Offset.zero)
          ]),

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
              BuildButton('Bions', () {
                setState(() {
                  Navigator.of(context).pushNamed(
                    AppRoutes.EXTRATO_FIDELIMAX,
                    //    arguments: auth.fidelimax,
                  );
                  //   show.call();
                });
              },
                  Image.asset(
                    'assets/icons/bions.png',
                    scale: 32,
                  ),
                  auth.fidelimax.saldo.toString(),
                  showBadge: true),
            if (auth.isAuth)
              BuildButton('Cesta de Solicitações', () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrdersPage(Clips(
                          titulo: 'Solicitar', subtitulo: '', keyId: 'S')),
                    )).then((value) {
                  setState(() {});
                });
              },
                  Icon(
                    Icons.shopping_cart,
                    size: 32,
                    color: destColor,
                  ),
                  filtros.fila.length.toString(),
                  showBadge: filtros.fila.isNotEmpty),
          ] +
          widget.actions +
          [],
    );
  }
}

Widget BuildButton(String tooltip, VoidCallback press, Widget Icon, String text,
    {bool showBadge = false}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: bdg.Badge(
      child: Container(
        child: IconButton(
          splashRadius: 32,
          tooltip: tooltip,
          onPressed: () {
            press.call();
          },
          icon: Container(
              decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                BoxShadow(
                  color: Colors.grey[300]!,
                  blurRadius: 3.0,
                ),
              ]),
              child: Icon),
        ),
      ),
      showBadge: showBadge,
      toAnimate: true,
      shape: bdg.BadgeShape.square,
      //   ignorePointer: true,
      badgeColor: Colors.yellow,
      borderRadius: BorderRadius.circular(100),
      position: bdg.BadgePosition.topEnd(top: 10, end: -18),
      badgeContent: InkWell(
        onTap: () {
          press.call();
        },
        child: Padding(
          padding: const EdgeInsets.all(1),
          child: Text(
            text,
            style: TextStyle(fontSize: 8),
          ),
        ),
      ),
    ),
  );
}
