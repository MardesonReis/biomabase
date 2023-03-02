import 'package:biomaapp/components/filtros_ativos_agendamento.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/Clips.dart';
import 'package:biomaapp/models/Fila.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/screens/appointment/componets/calendarioInfor.dart';
import 'package:biomaapp/screens/doctors/components/doctor_infor.dart';
import 'package:biomaapp/screens/pedidos/components/agendar_list.dart';
import 'package:biomaapp/screens/pedidos/orders_page.dart';
import 'package:biomaapp/screens/procedimentos/procedimentos_infor.dart';
import 'package:biomaapp/screens/user/components/user_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ConfirmaInfor extends StatefulWidget {
  Fila fila;
  VoidCallback press;
  ConfirmaInfor({Key? key, required this.fila, required this.press})
      : super(key: key);

  @override
  State<ConfirmaInfor> createState() => _ConfirmaInforState();
}

class _ConfirmaInforState extends State<ConfirmaInfor> {
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
              visible: true,
              child: FloatingActionButton.extended(
                onPressed: () {
                  setState(() {
                    widget.fila.status = 'A';
                    filtros.addFila(widget.fila);
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AgendarList(
                        fila: [widget.fila],
                      ),
                    ),
                  ).then((value) => {
                        setState(() {
                          filtros.LimparTipoFila();
                          filtros.LimparTodosFiltros();
                          filtros.LimparCalendario();
                          widget.press.call();
                        }),
                      });
                  filtros.LimparTipoFila();
                  filtros.LimparTodosFiltros();
                  filtros.LimparCalendario();
                },
                label: Text('Agendar'),
                backgroundColor: primaryColor,
                icon: Icon(Icons.calendar_month),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Visibility(
              visible: false,
              child: FloatingActionButton.extended(
                onPressed: () {
                  setState(() {
                    widget.fila.status = 'A';
                    filtros.addFila(widget.fila);
                    filtros.LimparTipoFila();
                    filtros.LimparTodosFiltros();
                    filtros.LimparCalendario();
                    widget.press.call();
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrdersPage(Clips(
                          titulo: 'Agendamentos',
                          subtitulo: '',
                          keyId: widget.fila.status)),
                    ),
                  ).then((value) => {
                        setState(() {}),
                      });
                },
                label: Text('FIla de agendamento'),
                backgroundColor: primaryColor,
                icon: Icon(Icons.add),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Visibility(
              visible: true,
              child: FloatingActionButton.extended(
                onPressed: () {
                  setState(() {
                    widget.fila.status = 'S';
                    filtros.addFila(widget.fila);
                    filtros.LimparTipoFila();
                    filtros.LimparTodosFiltros();
                    filtros.LimparCalendario();
                    widget.press.call();
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrdersPage(Clips(
                          titulo: 'Solicitar',
                          subtitulo: '',
                          keyId: widget.fila.status)),
                    ),
                  ).then((value) => {
                        setState(() {}),
                      });
                },
                label: Text('FIla de Solicitações'),
                backgroundColor: primaryColor,
                icon: Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(title: Text('Confirme Informações')),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Especialista',
                    style: Theme.of(context).textTheme.caption),
              ),
              DoctorInfor(
                doctor: widget.fila.medico,
                press: () {},
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Calendário',
                        style: Theme.of(context).textTheme.caption),
                    CalendarioInfor(
                        data: widget.fila.data, Hora: widget.fila.horario),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Convênio',
                        style: Theme.of(context).textTheme.caption),
                    Card(
                      elevation: 8,
                      child: ListTile(
                        title: Text(
                            widget.fila.convenios.desc_convenio.capitalize()),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Procedimentos',
                        style: Theme.of(context).textTheme.caption),
                    SizedBox(
                      height: defaultPadding,
                    ),
                    ProcedimentosInfor(
                        procedimento: widget.fila.procedimento, press: () {}),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Usuário', style: Theme.of(context).textTheme.caption),
                    SizedBox(
                      height: defaultPadding,
                    ),
                    UserCard(user: widget.fila.indicado, press: () {}),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
