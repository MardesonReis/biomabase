import 'package:biomaapp/components/custom_app_bar.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/screens/doctors/components/doctor_infor.dart';
import 'package:biomaapp/screens/servicos/componets/especialistasScreen.dart';
import 'package:biomaapp/screens/user/components/user_card.dart';
import 'package:biomaapp/screens/user/components/user_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BuildUsuario extends StatefulWidget {
  VoidCallback press;
  VoidCallback refreshPage;

  BuildUsuario({Key? key, required this.press, required this.refreshPage})
      : super(key: key);

  @override
  State<BuildUsuario> createState() => _BuildUsuarioState();
}

class _BuildUsuarioState extends State<BuildUsuario> {
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
              visible: filtros.procedimentos.isNotEmpty
                  ? filtros.procedimentos.first.especialidade
                                  .codespecialidade !=
                              '1' &&
                          filtros.usuarios.isNotEmpty == ''
                      ? filtros.usuarios.isNotEmpty
                      : filtros.procedimentos.first.olho != ''
                          ? filtros.usuarios.isNotEmpty
                          : false
                  : false,
              child: FloatingActionButton.extended(
                onPressed: () {
                  widget.press.call();
                },
                label: Text('Continuar'),
                backgroundColor: primaryColor,
              ),
            ),
            Visibility(
              visible: filtros.usuarios.isEmpty,
              child: FloatingActionButton.extended(
                onPressed: () {
                  setState(() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserScreen(),
                      ),
                    ).then((value) => {
                          setState(() {
                            widget.refreshPage.call();
                          }),
                        });
                  });

                  widget.press.call();
                },
                label: Text('Clique para informar Usuário'),
                backgroundColor: primaryColor,
                icon: Icon(Icons.navigate_next),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Selecione um usuário',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          filtros.usuarios.isNotEmpty
              ? UserCard(
                  user: filtros.usuarios.first,
                  press: () {
                    setState(() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserScreen(),
                        ),
                      ).then((value) => {
                            setState(() {
                              widget.refreshPage.call();
                            }),
                          });
                    });
                  })
              : SizedBox(),
        ],
      ),
    );
  }
}
