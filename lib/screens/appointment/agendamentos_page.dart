import 'package:biomaapp/components/ProgressIndicatorBioma.dart';
import 'package:biomaapp/components/agendamentos.dart';
import 'package:biomaapp/components/filtros_ativos_agendamento.dart';
import 'package:biomaapp/components/infor_unidade.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/agendamentos_list.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/especialidade.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/medicos.dart';
import 'package:biomaapp/models/pacientes.dart';
import 'package:biomaapp/models/procedimento.dart';
import 'package:biomaapp/models/unidade.dart';
import 'package:biomaapp/screens/appointment/appointment_screen.dart';
import 'package:biomaapp/screens/appointment/componets/agendamento_infor.dart';
import 'package:biomaapp/screens/appointment/componets/calendarioInfor.dart';
import 'package:biomaapp/screens/doctors/components/doctor_infor.dart';
import 'package:biomaapp/screens/procedimentos/procedimentos_infor.dart';
import 'package:biomaapp/screens/procedimentos/procedimentos_screen_view.dart';
import 'package:biomaapp/screens/user/components/user_card.dart';
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

  bool _isLoading = true;
  var i = 0;
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    AgendamentosList agendamentosList = Provider.of(context);

    filtrosAtivos filtros = auth.filtrosativos;
    Unidade unidade = Unidade(
      cod_unidade: widget.agendamento.cod_unidade,
      des_unidade: widget.agendamento.des_unidade,
    );

    Procedimento procedimento = Procedimento();
    procedimento.cod_procedimento = widget.agendamento.cod_procedimento;
    procedimento.des_procedimento = widget.agendamento.des_procedimento;
    procedimento.valor_sugerido = double.parse(widget.agendamento.valor);

    procedimento.especialidade = Especialidade(
        cod_especialidade: widget.agendamento.cod_especialidade,
        des_especialidade: widget.agendamento.des_especialidade,
        ativo: 'S');
    Medicos medico = Medicos(especialidade: procedimento.especialidade);
    medico.des_profissional = widget.agendamento.des_profissional;
    medico.cpf = widget.agendamento.cpf_profissional;
    medico.cod_profissional = widget.agendamento.cod_profissional;
    procedimento.EscolherOlho(widget.agendamento.olho);
    Usuario user = Usuario();
    user.nome = widget.agendamento.des_paciente;
    user.cpf = widget.agendamento.cpf_paciente;
    user.id = widget.agendamento.cod_paciente;
    return Scaffold(
      appBar: AppBar(
        title: Text('Procedimento ' +
            StatusAgenda[widget.agendamento.des_status_agenda]
                .toString()
                .capitalize()),
      ),
      body: SafeArea(
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
                        Text('Usuário',
                            style: Theme.of(context).textTheme.caption),
                        UserCard(user: user, press: () {}),
                      ],
                    ),
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
                            data: widget.agendamento.data_movimento,
                            Hora: widget.agendamento.hora_marcacao),
                      ],
                    ),
                  ),
                  procedimento.valor.toString().isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Procedimento',
                                  style: Theme.of(context).textTheme.caption),
                              ProcedimentosInfor(
                                procedimento: procedimento,
                                press: () {},
                                update: () {
                                  setState(() {});
                                },
                              ),
                            ],
                          ),
                        )
                      : Card(
                          child: ListTile(
                              title:
                                  Text(widget.agendamento.des_procedimento))),
                  medico.cod_profissional.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Especialistas',
                                  style: Theme.of(context).textTheme.caption),
                              DoctorInfor(
                                doctor: medico,
                                press: () {},
                              ),
                            ],
                          ),
                        )
                      : Center(child: ProgressIndicatorBioma()),
                  unidade.cod_unidade.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Locais de atendimento',
                                  style: Theme.of(context).textTheme.caption),
                              InforUnidade(unidade, () {}),
                            ],
                          ),
                        )
                      : Center(child: ProgressIndicatorBioma()),
                  if (widget.agendamento.des_status_agenda == 'P')
                    ElevatedButton(
                        onPressed: () {
                          agendamentosList.AtulizarStatus(
                                  widget.agendamento.cod_atendimento, 'V')
                              .then((value) => {
                                    if (value.des_status_agenda == 'V')
                                      {
                                        widget.agendamento = value,
                                        AlertShowDialog(
                                            '',
                                            Text('Confirmado com sucesso!'),
                                            context)
                                      }
                                    else
                                      {
                                        AlertShowDialog(
                                            '',
                                            Text('Erro na confirmação!'),
                                            context)
                                      }
                                  });

                          //   abrirUrl(url);
                        },
                        child: Text('Confirmar')),
                  if (widget.agendamento.des_status_agenda == 'D' ||
                      widget.agendamento.des_status_agenda == 'A')
                    ElevatedButton(
                        onPressed: () {
                          if (procedimento.cod_procedimento.isEmpty) {
                            showSnackBar(
                                Text('Agendamento indisponível'), context);
                            return;
                          }

                          filtros.LimparMedicos();
                          filtros.addMedicos(medico);
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
                        child: Text('Reagendar'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
