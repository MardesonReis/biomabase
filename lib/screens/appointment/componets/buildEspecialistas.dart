import 'package:biomaapp/components/custom_app_bar.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/screens/doctors/components/doctor_infor.dart';
import 'package:biomaapp/screens/servicos/componets/especialistasScreen.dart';
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
                        setState(() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Scaffold(
                                  appBar: PreferredSize(
                                      preferredSize: Size.fromHeight(40),
                                      child: CustomAppBar(
                                          'Busque\n',
                                          'Locais de Especialistas',
                                          () {}, [])),
                                  //   drawer: AppDrawer(),
                                  body: EspecialistasScreen(
                                    refreshPage: () {
                                      widget.refreshPage.call();
                                    },
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
                  ],
                )
              : Center(
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Scaffold(
                                  appBar: PreferredSize(
                                      preferredSize: Size.fromHeight(40),
                                      child: CustomAppBar('Busque\n',
                                          'Locais de Atendimento', () {}, [])),
                                  //   drawer: AppDrawer(),
                                  body: EspecialistasScreen(refreshPage: () {
                                    setState(() {
                                      widget.refreshPage.call();
                                    });
                                  }, press: () {
                                    setState(() {
                                      //  _refreshPage();
                                      Navigator.pop(context);
                                    });
                                  })),
                            ),
                          ).then((value) => {
                                setState(() {
                                  widget.refreshPage.call();
                                }),
                              });
                        });
                      },
                      child: Text('Clique para informar um especialista')),
                )
        ],
      ),
    );
  }
}
