import 'package:biomaapp/components/custom_app_bar.dart';
import 'package:biomaapp/components/monoBino.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/screens/procedimentos/procedimentos_infor.dart';
import 'package:biomaapp/screens/servicos/componets/procedimentosScreen.dart';
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
  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    filtrosAtivos filtros = auth.filtrosativos;
    return Scaffold(
      floatingActionButton: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Visibility(
              visible: filtros.procedimentos.isNotEmpty &&
                  filtros.procedimentos.first.olho.isNotEmpty &&
                  filtros.procedimentos.first.especialidade.codespecialidade ==
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
                  filtros.procedimentos.first.especialidade.codespecialidade !=
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Scaffold(
                            appBar: PreferredSize(
                                preferredSize: Size.fromHeight(40),
                                child: CustomAppBar(
                                    'Busque\n', 'Procedimentos', () {}, [])),
                            //   drawer: AppDrawer(),
                            body: ProcedimentosScreen(press: () {
                              setState(() {
                                widget.press.call();
                              });
                            })),
                      ),
                    ).then((value) => {
                          setState(() {
                            widget.refreshPage.call();
                          }),
                        });
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
                            setState(() {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Scaffold(
                                      appBar: PreferredSize(
                                          preferredSize: Size.fromHeight(40),
                                          child: CustomAppBar('Busque\n',
                                              'Procedimentos', () {}, [])),
                                      //   drawer: AppDrawer(),
                                      body: ProcedimentosScreen(
                                        press: () {
                                          setState(() {
                                            Navigator.pop(context);
                                          });
                                        },
                                      )),
                                ),
                              ).then((value) => {
                                    setState(() {
                                      widget.refreshPage.call();
                                    }),
                                  });
                            });
                          },
                        ),
                        filtros.procedimentos.first.especialidade
                                    .codespecialidade ==
                                '1'
                            ? monoBino(filtros.procedimentos.first, () {
                                setState(() {
                                  widget.refreshPage.call();
                                });
                              })
                            : SizedBox(),
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
