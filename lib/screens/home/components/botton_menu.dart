import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/paginas.dart';
import 'package:biomaapp/screens/auth/auth_or_home_page.dart';
import 'package:biomaapp/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';

class BottonMenu extends StatefulWidget {
  const BottonMenu({Key? key}) : super(key: key);

  @override
  State<BottonMenu> createState() => _BottonMenuState();
}

class _BottonMenuState extends State<BottonMenu> {
  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    filtrosAtivos filtros = auth.filtrosativos;

    var pages = auth.paginas.pages;

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
            IconData Ico = pages[index]['Ico'] as IconData;

            return GButton(
              icon: Ico,
              text: desc,
            );
          }).toList(),
          onTabChange: (pageNum) {
            setState(() {
              auth.paginas
                  .selecionarPaginaHome(pages[pageNum]['desc'].toString());
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
        ),
      ),
    );
  }
}
