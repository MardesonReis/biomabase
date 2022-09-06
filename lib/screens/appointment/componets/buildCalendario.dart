import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/screens/appointment/componets/calendario.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class BuildCalendario extends StatefulWidget {
  VoidCallback press;
  VoidCallback refreshPage;

  BuildCalendario({Key? key, required this.press, required this.refreshPage})
      : super(key: key);

  @override
  State<BuildCalendario> createState() => _BuildCalendarioState();
}

class _BuildCalendarioState extends State<BuildCalendario> {
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
              visible: filtros.dias.isNotEmpty && filtros.horarios.isNotEmpty,
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
          ],
        ),
      ),
      body: Column(
        children: [
          Text(
            'Selecione uma data e horário',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          if (filtros.medicos.isNotEmpty && filtros.procedimentos.isNotEmpty)
            CalendarioView(press: () {
              setState(() {
                widget.refreshPage.call();
              });
            }),
          if (filtros.medicos.isEmpty || filtros.procedimentos.isEmpty)
            Card(
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      'As abas anteriores são obrigatória',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    if (filtros.medicos.isEmpty)
                      Text(
                        'Informe o especialista',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    if (filtros.procedimentos.isEmpty)
                      Text(
                        'Informe o procedimento',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    if (filtros.unidades.isEmpty)
                      Text(
                        'Informe o local de atendimento',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                  ],
                ),
              ),
            )
        ],
      ),
    );

    ;
  }
}
