import 'package:biomaapp/components/app_drawer.dart';
import 'package:biomaapp/components/custom_app_bar.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/screens/doctors/components/doctor_details_screen.dart';
import 'package:biomaapp/screens/procedimentos/procedimentos_screen_view.dart';
import 'package:biomaapp/screens/servicos/componets/especialistasScreen.dart';
import 'package:biomaapp/screens/servicos/componets/procedimentosScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuProcedimentos extends StatefulWidget {
  const MenuProcedimentos({Key? key}) : super(key: key);

  @override
  State<MenuProcedimentos> createState() => _MenuProcedimentosState();
}

class _MenuProcedimentosState extends State<MenuProcedimentos> {
  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    filtrosAtivos filtros = auth.filtrosativos;
    return Scaffold(
      drawer: AppDrawer(),
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: CustomAppBar('Buscar\n', 'Procedimentos', () {}, [])),
      body: ProcedimentosScreen(
        press: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProcedimentosScrennViwer(
                procedimentos: filtros.procedimentos.first,
                press: () {},
              ),
            ),
          );
        },
      ),
    );
  }
}
