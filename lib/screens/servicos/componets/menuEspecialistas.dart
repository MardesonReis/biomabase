import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/screens/doctors/components/doctor_details_screen.dart';
import 'package:biomaapp/screens/servicos/componets/especialistasScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuEspecialista extends StatefulWidget {
  MenuEspecialista({Key? key}) : super(key: key);

  @override
  State<MenuEspecialista> createState() => _MenuEspecialistaState();
}

class _MenuEspecialistaState extends State<MenuEspecialista> {
  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    filtrosAtivos filtros = auth.filtrosativos;
    return EspecialistasScreen(press: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DoctorDetailsScreen(
            doctor: filtros.medicos.first,
            press: () {
              //   if (!mounted) return;
              setState(() {});
            },
          ),
        ),
      ).then((value) => {
            setState(() {}),
          });
    }, refreshPage: () {
      // _refreshPage();
    });
  }
}
