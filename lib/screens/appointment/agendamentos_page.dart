import 'package:biomaapp/components/agendamentos.dart';
import 'package:biomaapp/components/filtros_ativos_agendamento.dart';
import 'package:biomaapp/components/infor_unidade.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/especialidade.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/medicos.dart';
import 'package:biomaapp/models/procedimento.dart';
import 'package:biomaapp/models/unidade.dart';
import 'package:biomaapp/screens/appointment/appointment_screen.dart';
import 'package:biomaapp/screens/appointment/componets/agendamento_infor.dart';
import 'package:biomaapp/screens/appointment/componets/calendarioInfor.dart';
import 'package:biomaapp/screens/doctors/components/doctor_infor.dart';
import 'package:biomaapp/screens/procedimentos/procedimentos_infor.dart';
import 'package:biomaapp/screens/procedimentos/procedimentos_screen_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AgendamentosPage extends StatefulWidget {
  Agendamentos agendamento;
  VoidCallback press;

  AgendamentosPage({Key? key, required this.agendamento, required this.press})
      : super(key: key);

  @override
  State<AgendamentosPage> createState() => _AgendamentosPageState();
}

class _AgendamentosPageState extends State<AgendamentosPage> {
  final textEditingController = TextEditingController();
  TextEditingController txtQuery = new TextEditingController();
  Medicos doctor = Medicos();
  Procedimento procedimento = Procedimento();

  bool _isLoading = true;
  var i = 0;
  @override
  initState() {
    super.initState();
    doctor.BuscarMedicoPorId(widget.agendamento.cod_profissional)
        .then((value) => setState(() {
              print(value.cod_profissional);
              this.doctor = value;
              i = i + 1;
              print(i.toString());
              if (i == 2) {
                setState(() {
                  _isLoading = false;
                });
              }
            }));

    procedimento
        .loadProcedimentosID(
            widget.agendamento.cod_unidade,
            widget.agendamento.cod_convenio,
            widget.agendamento.cod_procedimento,
            widget.agendamento.cod_especialidade)
        .then((value) => setState(() {
              print(value.valor);
              value.EscolherOlho(widget.agendamento.olho);
              value.especialidade = Especialidade(
                  codespecialidade: widget.agendamento.cod_especialidade,
                  descricao: widget.agendamento.des_especialidade,
                  ativo: 'S');
              this.procedimento = value;
              i = i + 1;
              print(i.toString());
              if (i == 2) {
                setState(() {
                  _isLoading = false;
                });
              }
            }));
  }

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);

    filtrosAtivos filtros = auth.filtrosativos;
    Unidade unidade = Unidade(
      cod_unidade: widget.agendamento.cod_unidade,
      des_unidade: widget.agendamento.des_unidade,
    );
    Medicos medicos = Medicos();
    medicos.cod_profissional = widget.agendamento.cod_profissional;
    medicos.des_profissional = widget.agendamento.des_profissional;

    return Scaffold(
      appBar: AppBar(
        title: Text('Procedimento ' +
            StatusProcedimentosAgendados[widget.agendamento.status]
                .toString()
                .capitalize()),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  //    padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Calendário',
                                  style: Theme.of(context).textTheme.caption),
                              CalendarioInfor(
                                  data: widget.agendamento.data_movimento,
                                  Hora: widget.agendamento.hora_marcacao),
                            ],
                          ),
                        ),
                        procedimento.cod_procedimentos.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text('Procedimento',
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption),
                                    ProcedimentosInfor(
                                      procedimento: procedimento,
                                      press: () {},
                                    ),
                                  ],
                                ),
                              )
                            : Center(child: CircularProgressIndicator()),
                        doctor.cod_profissional.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text('Especialistas',
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption),
                                    DoctorInfor(
                                      doctor: doctor,
                                      press: () {},
                                    ),
                                  ],
                                ),
                              )
                            : Center(child: CircularProgressIndicator()),
                        unidade.cod_unidade.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text('Locais de atendimento',
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption),
                                    InforUnidade(unidade, () {}),
                                  ],
                                ),
                              )
                            : Center(child: CircularProgressIndicator()),
                        widget.agendamento.status != 'A'
                            ? ElevatedButton(
                                onPressed: () {
                                  filtros.LimparMedicos();
                                  filtros.addMedicos(doctor);
                                  filtros.LimparProcedimentos();
                                  filtros.AddProcedimentos(procedimento);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AppointmentScreen(
                                        press: () {
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  ).then((value) => {
                                        setState(() {}),
                                      });
                                },
                                child: Text('Agendar'))
                            : ElevatedButton(
                                onPressed: () {
                                  var url =
                                      'http://bioinfo.net.br/GetResponse/response.php?id_mov=' +
                                          widget.agendamento.cod_atendimento;
                                  print(url);
                                  abrirUrl(url);
                                },
                                child: Text('Confirmar'))
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
