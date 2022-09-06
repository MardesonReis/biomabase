import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/screens/doctors/components/doctor_details_screen.dart';
import 'package:biomaapp/screens/procedimentos/procedimentos_screen_view.dart';
import 'package:biomaapp/screens/servicos/componets/calendarioScren.dart';
import 'package:biomaapp/screens/servicos/componets/especialistasScreen.dart';
import 'package:biomaapp/screens/servicos/componets/localizacao.dart';
import 'package:biomaapp/screens/servicos/componets/procedimentosScreen.dart';
import 'package:biomaapp/screens/servicos/componets/unidadesScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuCalendario extends StatefulWidget {
  const MenuCalendario({Key? key}) : super(key: key);

  @override
  State<MenuCalendario> createState() => _MenuCalendarioState();
}

class _MenuCalendarioState extends State<MenuCalendario> {
  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    filtrosAtivos filtros = auth.filtrosativos;
    return CalendarioScren(press: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DoctorDetailsScreen(
            doctor: filtros.medicos.first,
            press: () {
              //   if (!mounted) return;
              setState(() {
                //    _refreshPage();
              });
            },
          ),
        ),
      ).then((value) => {
            setState(() {
              //    _refreshPage();
            }),
          });
    }, refreshPage: () {
      setState(() {
        //  _refreshPage();
      });
    });
  }
}
