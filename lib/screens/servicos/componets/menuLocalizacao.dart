import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/screens/doctors/components/doctor_details_screen.dart';
import 'package:biomaapp/screens/procedimentos/procedimentos_screen_view.dart';
import 'package:biomaapp/screens/servicos/componets/especialistasScreen.dart';
import 'package:biomaapp/screens/servicos/componets/localizacao.dart';
import 'package:biomaapp/screens/servicos/componets/procedimentosScreen.dart';
import 'package:biomaapp/screens/servicos/componets/unidadesScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuLocalizacao extends StatefulWidget {
  const MenuLocalizacao({Key? key}) : super(key: key);

  @override
  State<MenuLocalizacao> createState() => _MenuLocalizacaoState();
}

class _MenuLocalizacaoState extends State<MenuLocalizacao> {
  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    filtrosAtivos filtros = auth.filtrosativos;
    return Localizacao(press: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UnidadesScreen(),
        ),
      ).then((value) => {
            setState(() {}),
          });

      setState(() {});
    });
  }
}
