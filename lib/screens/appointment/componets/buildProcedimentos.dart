import 'package:biomaapp/components/ProgressIndicatorBioma.dart';
import 'package:biomaapp/components/app_drawer.dart';
import 'package:biomaapp/components/custom_app_bar.dart';
import 'package:biomaapp/components/monoBino.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/regras_list.dart';
import 'package:biomaapp/screens/procedimentos/procedimentos_infor.dart';
import 'package:biomaapp/screens/servicos/componets/FiltrosScreen.dart';
import 'package:biomaapp/screens/servicos/componets/filtroAtivosScren.dart';
import 'package:biomaapp/screens/servicos/componets/procedimentosScreen.dart';
import 'package:biomaapp/screens/servicos/componets/searchScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class BuildProcedimentos extends StatefulWidget {
  VoidCallback press;
  VoidCallback refreshPage;

  BuildProcedimentos({Key? key, required this.press, required this.refreshPage})
      : super(key: key);

  @override
  State<BuildProcedimentos> createState() => _BuildProcedimentosState();
}

class _BuildProcedimentosState extends State<BuildProcedimentos> {
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

    BuscarProcedimento() {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Scaffold(
                  //  drawer: AppDrawer(),
                  extendBodyBehindAppBar: true,
                  appBar: PreferredSize(
                      preferredSize:
                          Size.fromHeight(tela(context).height * (0.35)),
                      child: Container(
                        child: Column(
                          children: [
                            CustomAppBar(
                                'Buscar\n', 'Procedimentos', () {}, []),
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
                  body: ProcedimentosScreen(
                    press: () {
                      Navigator.pop(context);
                      widget.press.call();
                    },
                  ),
                )),
      ).then((value) => {
            setState(() {
              widget.refreshPage.call();
            }),
          });
    }

    return Scaffold(
      floatingActionButton: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Visibility(
                visible: (dt.seemore == true || dt.isLoading == true),
                child: Wrap(
                  children: [
                    if (dt.seemore == true || dt.isLoading == true)
                      Padding(
                          padding: EdgeInsets.all(10),
                          child: Container(child: ProgressIndicatorBioma())),
                  ],
                )),
            Visibility(
              visible: filtros.procedimentos.isNotEmpty &&
                  filtros.procedimentos.first.olho.isNotEmpty &&
                  filtros.procedimentos.first.especialidade.cod_especialidade ==
                      '1',
              child: FloatingActionButton.extended(
                onPressed: () {
                  setState(() {
                    widget.press.call();
                  });
                  widget.press.call();
                },
                label: Text('Continuar'),
                backgroundColor: primaryColor,
                icon: Icon(Icons.navigate_next),
              ),
            ),
            Visibility(
              visible: filtros.procedimentos.isNotEmpty &&
                  filtros.procedimentos.first.especialidade.cod_especialidade !=
                      '1',
              child: FloatingActionButton.extended(
                onPressed: () {
                  setState(() {
                    widget.press.call();
                  });
                  widget.press.call();
                },
                label: Text('Continuar'),
                backgroundColor: primaryColor,
                icon: Icon(Icons.navigate_next),
              ),
            ),
            Visibility(
              visible: filtros.procedimentos.isEmpty,
              child: FloatingActionButton.extended(
                onPressed: () {
                  setState(() {
                    BuscarProcedimento();
                  });
                  widget.press.call();
                },
                label: Text('Adicionar Procedimento'),
                backgroundColor: primaryColor,
                icon: Icon(Icons.navigate_next),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Text(
            'Selecione um procedimento',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          filtros.procedimentos.isNotEmpty
              ? Column(
                  children: [
                    Column(
                      children: [
                        ProcedimentosInfor(
                          procedimento: filtros.procedimentos.first,
                          press: () {
                            setState(() {});
                            BuscarProcedimento();
                          },
                          update: () {
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ],
                )
              : SizedBox()
        ],
      ),
    );
  }
}
