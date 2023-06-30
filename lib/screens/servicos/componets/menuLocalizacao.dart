import 'package:biomaapp/components/ProgressIndicatorBioma.dart';
import 'package:biomaapp/components/custom_app_bar.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/regras_list.dart';
import 'package:biomaapp/screens/doctors/components/doctor_details_screen.dart';
import 'package:biomaapp/screens/procedimentos/procedimentos_screen_view.dart';
import 'package:biomaapp/screens/servicos/componets/FiltrosScreen.dart';
import 'package:biomaapp/screens/servicos/componets/especialistasScreen.dart';
import 'package:biomaapp/screens/servicos/componets/filtroAtivosScren.dart';
import 'package:biomaapp/screens/servicos/componets/localizacao.dart';
import 'package:biomaapp/screens/servicos/componets/procedimentosScreen.dart';
import 'package:biomaapp/screens/servicos/componets/searchScreen.dart';
import 'package:biomaapp/screens/servicos/componets/unidadesScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuLocalizacao extends StatefulWidget {
  VoidCallback press;
  VoidCallback refreshPage;
  MenuLocalizacao({Key? key, required this.press, required this.refreshPage})
      : super(key: key);

  @override
  State<MenuLocalizacao> createState() => _MenuLocalizacaoState();
}

class _MenuLocalizacaoState extends State<MenuLocalizacao> {
  bool filterViewer = false;
  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    filtrosAtivos filtros = auth.filtrosativos;
    RegrasList dt = Provider.of(context);
    iniciarBusca() {
      if (dt.limit) {
        widget.refreshPage.call();
        return false;
      }
      setState(() {
        dt.isLoading = true;
        dt.seemore = true;

        dt.buscar(context).then((value) {
          setState(() {
            dt.seemore = false;

            dt.isLoading = false;
            widget.refreshPage.call();
          });
        });
      });
      widget.refreshPage.call();
    }

    var f = filterViewer ? 0.10 : 0.05;

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(tela(context).height * (0.35)),
          child: Container(
            child: Column(
              children: [
                CustomAppBar('Buscar\n', 'Locais de Atendimento', () {}, []),
                filtrosScreen(press: () {
                  //filtros.medicos.clear();
                  //dt.limparDados();
                  iniciarBusca();
                  widget.refreshPage.call();
                }),
                FiltroAtivosScren(press: () {
                  setState(() {
                    dt.limparDados();

                    iniciarBusca();
                  });
                }),
                searchScreen(press: () {
                  setState(() {
                    setState(() {
                      widget.refreshPage.call();
                    });
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
      body: Localizacao(press: () {
        setState(() {
          widget.press.call();
        });
      }, refreshPage: () {
        setState(() {
          widget.refreshPage.call();
        });
      }),
    );
  }
}
