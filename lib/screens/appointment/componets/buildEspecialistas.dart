import 'package:biomaapp/components/app_drawer.dart';
import 'package:biomaapp/components/custom_app_bar.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/regras_list.dart';
import 'package:biomaapp/screens/doctors/components/doctor_infor.dart';
import 'package:biomaapp/screens/servicos/componets/FiltrosScreen.dart';
import 'package:biomaapp/screens/servicos/componets/especialistasScreen.dart';
import 'package:biomaapp/screens/servicos/componets/filtroAtivosScren.dart';
import 'package:biomaapp/screens/servicos/componets/menuEspecialistas.dart';
import 'package:biomaapp/screens/servicos/componets/searchScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BuildEspecialistas extends StatefulWidget {
  VoidCallback press;
  VoidCallback refreshPage;

  BuildEspecialistas({Key? key, required this.press, required this.refreshPage})
      : super(key: key);

  @override
  State<BuildEspecialistas> createState() => _BuildEspecialistasState();
}

class _BuildEspecialistasState extends State<BuildEspecialistas> {
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
    RegrasList dt = Provider.of(context);
    filtrosAtivos filtros = auth.filtrosativos;

    BuscarEspecialista() {
      setState(() {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Scaffold(
                    extendBodyBehindAppBar: true,
                    appBar: PreferredSize(
                        preferredSize:
                            Size.fromHeight(tela(context).height * 0.35),
                        child: Column(
                          children: [
                            CustomAppBar(
                                'Buscar\n', 'Especialistas', () {}, []),
                            filtrosScreen(press: () {
                              //  filtros.medicos.clear();
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
                        )),
                    body: EspecialistasScreenn(refreshPage: () {
                      setState(() {
                        widget.refreshPage.call();
                      });
                    }, press: () {
                      setState(() {
                        //  _refreshPage();
                        Navigator.pop(context);
                      });
                    }),
                  )),
        ).then((value) => {
              setState(() {
                widget.refreshPage.call();
              }),
            });
      });
    }

    return Scaffold(
      floatingActionButton: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Visibility(
              visible: filtros.medicos.isNotEmpty,
              child: FloatingActionButton.extended(
                onPressed: () {
                  setState(() {
                    widget.press.call();
                  });
                },
                label: Text('Continuar'),
                backgroundColor: primaryColor,
                icon: Icon(Icons.navigate_next),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          filtros.medicos.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Selecione um especialista',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    DoctorInfor(
                      doctor: filtros.medicos.first,
                      press: () {
                        BuscarEspecialista();
                      },
                    ),
                  ],
                )
              : Center(
                  child: ElevatedButton(
                      onPressed: () {
                        BuscarEspecialista();
                      },
                      child: Text('Clique para informar um especialista')),
                )
        ],
      ),
    );
  }
}
