import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/Fila.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/medicos.dart';
import 'package:biomaapp/models/medicos_list.dart';
import 'package:biomaapp/models/procedimento.dart';
import 'package:biomaapp/screens/appointment/componets/agendar.dart';
import 'package:biomaapp/screens/appointment/componets/indicar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AgendarIndicar extends StatefulWidget {
  Medicos doctor;
  Procedimento procedimentos;
  Map<String, Object> menu = {};
  final VoidCallback press;
  AgendarIndicar(
      {Key? key,
      required this.doctor,
      required this.procedimentos,
      required this.press})
      : super(key: key);

  @override
  State<AgendarIndicar> createState() => _AgendarIndicarState();
}

class _AgendarIndicarState extends State<AgendarIndicar> {
  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    filtrosAtivos filtros = auth.filtrosativos;
    List<Map<String, Object>> pages = [
      {
        'desc': 'Agendar',
        'acao': 'Quero Fazer um agendamento',
        'status': 'A',
        'page': Agendar(
          doctor: widget.doctor,
          procedimentos: widget.procedimentos,
          press: () {},
        ),
        'Ico': Icons.calendar_month,
      },
      {
        'desc': 'Indicar',
        'acao': 'Quero Fazer uma Indicação',
        'status': 'S',
        'page': Indicar(
          doctor: widget.doctor,
          procedimentos: widget.procedimentos,
          press: () {},
        ),
        'Ico': Icons.share,
      },
    ];
    if (filtros.tipoFila.isEmpty) {
      filtros.addstipoFila(pages[0]);
    }

    if (filtros.tipoFila.isNotEmpty) {
      widget.menu == filtros.tipoFila.first;
    }
    return Scaffold(
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
            pages.length,
            (index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton.extended(
                    onPressed: () {
                      setState(() {
                        widget.menu = pages[index];
                        filtros.LimparTipoFila();
                        filtros.addstipoFila(pages[index]);
                      });
                      widget.press.call();
                    },
                    label: Text(pages[index]['acao'].toString()),
                    backgroundColor: primaryColor,
                    icon: Icon(pages[index]['Ico'] as IconData),
                  ),
                )),
      ),
      body: SizedBox(),
    );
  }
}
