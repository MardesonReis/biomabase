import 'dart:ui';

import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/paginas.dart';
import 'package:biomaapp/screens/auth/auth_or_home_page.dart';
import 'package:biomaapp/screens/home/home_screen.dart';
import 'package:biomaapp/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';

class BottonMenuMinhaSaude extends StatefulWidget {
  const BottonMenuMinhaSaude({Key? key}) : super(key: key);

  @override
  State<BottonMenuMinhaSaude> createState() => _BottonMenuMinhaSaudeState();
}

class _BottonMenuMinhaSaudeState extends State<BottonMenuMinhaSaude> {
  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    filtrosAtivos filtros = auth.filtrosativos;

    var pages = auth.BottonMinhaSaude!.pages;

    return Container(
      color: primaryColor,
      height: MediaQuery.of(context).size.height * 0.08,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(pages.length, (index) {
          String desc = pages[index]['desc'].toString();
          var page = pages[index]['page'];
          var Ico = pages[index]['Ico'].toString();

          return InkWell(
            onTap: () {
              setState(() {
                auth.paginas
                    .selecionarPaginaHome(pages[index]['desc'].toString());
              });
              Navigator.push(
                  context,
                  PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          AuthOrHomePage(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        const begin = Offset(0.0, 1.0);
                        const end = Offset.zero;
                        const curve = Curves.ease;

                        final tween = Tween(begin: begin, end: end);
                        final curvedAnimation = CurvedAnimation(
                          parent: animation,
                          curve: curve,
                        );

                        return SlideTransition(
                          position: tween.animate(curvedAnimation),
                          child: child,
                        );
                      }));
            },
            child: Container(
              color: auth.paginas.selectedPage == index
                  ? destColor[100]
                  : primaryColor,
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 15,
                      child: SvgPicture.asset(
                          // panelIcon 's Type:IconData
                          Ico,
                          height: 13.0,
                          width: 13.0,
                          allowDrawingOutsideViewBox: true,
                          //  color: Colors.red,
                          semanticsLabel: pages[index]['desc'].toString()),
                    ),
                    SizedBox(
                      height: 1,
                    ),
                    Text(
                      pages[index]['desc'].toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 10,
                          color: auth.paginas.selectedPage == index
                              ? primaryColor
                              : Colors.white),
                    )
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );

    return Container(
      padding: EdgeInsets.all(defaultPadding),
      color: primaryColor,
      child: SafeArea(
        child: GNav(
          backgroundColor: Colors.transparent,
          selectedIndex: auth.paginas.selectedPage,
          haptic: true,
          tabBorderRadius: 15,
          curve: Curves.ease,
          duration: Duration(milliseconds: 350),
          gap: 8,
          color: Colors.white,
          activeColor: primaryColor,
          iconSize: 24,
          tabBackgroundColor: Colors.white,
          padding: EdgeInsets.symmetric(
            horizontal: defaultPadding,
            vertical: defaultPadding / 2,
          ),
          tabs: List.generate(pages.length, (index) {
            String desc = pages[index]['desc'].toString();
            var page = pages[index]['page'];
            var Ico = pages[index]['Ico'];

            return GButton(
              icon: Ico as IconData,
              text: desc,
            );
          }).toList(),
          onTabChange: (pageNum) {
            setState(() {
              auth.paginas
                  .selecionarPaginaHome(pages[pageNum]['desc'].toString());
            });
          },
        ),
      ),
    );
  }
}
