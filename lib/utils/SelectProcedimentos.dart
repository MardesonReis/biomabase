import 'package:biomaapp/components/ProgressIndicatorBioma.dart';
import 'package:biomaapp/components/app_drawer.dart';
import 'package:biomaapp/components/custom_app_bar.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/regras_list.dart';
import 'package:biomaapp/screens/appointment/appointment_screen.dart';
import 'package:biomaapp/screens/doctors/components/doctor_details_screen.dart';
import 'package:biomaapp/screens/procedimentos/procedimentos_screen_view.dart';
import 'package:biomaapp/screens/servicos/componets/FiltrosScreen.dart';
import 'package:biomaapp/screens/servicos/componets/especialistasScreen.dart';
import 'package:biomaapp/screens/servicos/componets/filtroAtivosScren.dart';
import 'package:biomaapp/screens/servicos/componets/procedimentosScreen.dart';
import 'package:biomaapp/screens/servicos/componets/searchScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectProcedimentos extends StatefulWidget {
  VoidCallback press;
  bool multe = false;
  SelectProcedimentos({Key? key, required this.press, this.multe = false})
      : super(key: key);

  @override
  State<SelectProcedimentos> createState() => _SelectProcedimentosState();
}

class _SelectProcedimentosState extends State<SelectProcedimentos> {
  bool filterViewer = false;
  iniciarBusca() {
    var dt = Provider.of<RegrasList>(
      context,
      listen: false,
    );
    if (dt.limit) {
      return false;
    }
    setState(() {
      setState(() {
        dt.isLoading = true;
        dt.seemore = true;
      });
      dt.buscar(context).then((value) {
        setState(() {
          dt.seemore = false;

          dt.isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    filtrosAtivos filtros = auth.filtrosativos;
    RegrasList dt = Provider.of(context);

    return Scaffold(
      //drawer: AppDrawer(),
      //  extendBodyBehindAppBar: true,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(tela(context).height * (0.35)),
          child: Container(
            child: Column(
              children: [
                CustomAppBar('Buscar\n', 'Procedimentos', () {}, []),
                filtrosScreen(press: () {
                  filtros.medicos.clear();
                  dt.limparDados();
                  iniciarBusca();
                }),
                FiltroAtivosScren(press: () {
                  setState(() {
                    dt.limparDados();

                    iniciarBusca();
                  });
                }),
                searchScreen(press: () {
                  setState(() {
                    setState(() {});
                  });
                }),
              ],
            ),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Wrap(
        children: [
          if (dt.seemore == true || dt.isLoading == true)
            Padding(
                padding: EdgeInsets.all(10),
                child: Container(child: ProgressIndicatorBioma())),
        ],
      ),
      body: ProcedimentosScreen(
        press: () {
          widget.press.call();
          setState(() {});
        },
      ),
    );
  }
}
