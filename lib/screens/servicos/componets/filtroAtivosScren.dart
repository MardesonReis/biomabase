import 'package:badges/badges.dart';
import 'package:biomaapp/components/section_title.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/convenios.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/procedimento.dart';
import 'package:biomaapp/screens/doctors/components/Doctor_Circle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class FiltroAtivosScren extends StatefulWidget {
  VoidCallback press;

  FiltroAtivosScren({Key? key, required this.press}) : super(key: key);

  @override
  State<FiltroAtivosScren> createState() => _FiltroAtivosScrenState();
}

class _FiltroAtivosScrenState extends State<FiltroAtivosScren> {
  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    filtrosAtivos filtros = auth.filtrosativos;

    return filtros.FiltrosAtivos < 1
        ? SizedBox()
        : Wrap(
            spacing: 1,
            direction: Axis.horizontal,
            runSpacing: 1,
            alignment: WrapAlignment.center,
            children: [
                Text(
                  'Filtros Ativos',
                  style: TextStyle(fontSize: 10),
                ),
                Row(),
                Wrap(
                    spacing: 1,
                    children: filtros.convenios.map((e) {
                      return ChoiceChip(
                        label: Text(
                          e.desc_convenio.capitalize(),
                          style: TextStyle(fontSize: 10),
                        ),
                        selected: filtros.convenios.contains(e),
                        onSelected: (selected) async {
                          var conf = await AlertShowDialog('Remover Filtro: ',
                              'Convênios: ' + e.desc_convenio, context);
                          if (conf == true) {
                            // ignore: curly_braces_in_flow_control_structures
                            setState(() {
                              filtros.convenios.contains(e)
                                  ? filtros.removerConvenios(e)
                                  : filtros.addConvenios(e);
                              widget.press.call();
                            });
                          }
                        },
                      );
                    }).toList()),
                Wrap(
                    spacing: 1,
                    children: filtros.medicos.map((e) {
                      return ChoiceChip(
                        label: Text(
                          e.des_profissional.capitalize(),
                          style: TextStyle(fontSize: 10),
                        ),
                        selected: filtros.medicos.contains(e),
                        onSelected: (selected) async {
                          var conf = await AlertShowDialog('Remover Filtro: ',
                              'Especialista: ' + e.des_profissional, context);
                          if (conf == true) {
                            // ignore: curly_braces_in_flow_control_structures
                            setState(() {
                              filtros.medicos.contains(e)
                                  ? filtros.removerMedico(e)
                                  : filtros.addMedicos(e);
                              widget.press.call();
                            });
                          }
                        },
                      );
                    }).toList()),
                Wrap(
                    spacing: 1,
                    children: filtros.unidades.map((e) {
                      return ChoiceChip(
                        label: Text(
                          e.des_unidade.capitalize() +
                              ' - ' +
                              e.bairro.capitalize(),
                          style: TextStyle(fontSize: 10),
                        ),
                        selected: filtros.unidades.contains(e),
                        onSelected: (selected) async {
                          var conf = await AlertShowDialog(
                              'Remover Filtro: ',
                              'Local de Atendimento: ' + e.des_unidade,
                              context);
                          if (conf == true) {
                            // ignore: curly_braces_in_flow_control_structures
                            setState(() {
                              filtros.unidades.contains(e)
                                  ? filtros.removerUnidades(e)
                                  : filtros.addunidades(e);
                              widget.press.call();
                            });
                          }
                        },
                      );
                    }).toList()),
                Wrap(
                    spacing: 1,
                    children: filtros.especialidades.map((e) {
                      return ChoiceChip(
                        label: Text(
                          e.descricao.capitalize(),
                          style: TextStyle(fontSize: 10),
                        ),
                        selected: filtros.especialidades.contains(e),
                        onSelected: (selected) async {
                          var conf = await AlertShowDialog('Remover Filtro: ',
                              'Especialidade: ' + e.descricao, context);
                          if (conf == true) {
                            // ignore: curly_braces_in_flow_control_structures
                            setState(() async {
                              filtros.especialidades.contains(e)
                                  ? await filtros.removerEspacialidades(e)
                                  : filtros.addEspacialidades(e);
                              widget.press.call();
                            });
                          }
                        },
                      );
                    }).toList()),
                Wrap(
                    spacing: 1,
                    children: filtros.subespecialidades.map((e) {
                      return ChoiceChip(
                        label: Text(
                          e.descricao.capitalize(),
                          style: TextStyle(fontSize: 10),
                        ),
                        selected: filtros.subespecialidades.contains(e),
                        onSelected: (selected) async {
                          var conf = await AlertShowDialog('Remover Filtro: ',
                              'Subespecialidade: ' + e.descricao, context);
                          if (conf == true) {
                            // ignore: curly_braces_in_flow_control_structures
                            setState(() async {
                              filtros.subespecialidades.contains(e)
                                  ? await filtros.removerSubEspacialidades(e)
                                  : filtros.addSubEspacialidades(e);
                              widget.press.call();
                            });
                          }
                        },
                      );
                    }).toList()),
                Wrap(
                    spacing: 1,
                    children: filtros.grupos.map((e) {
                      return ChoiceChip(
                        label: Text(
                          e.descricao.capitalize(),
                          style: TextStyle(fontSize: 10),
                        ),
                        selected: filtros.grupos.contains(e),
                        onSelected: (selected) async {
                          var conf = await AlertShowDialog('Remover Filtro: ',
                              'Subespecialidade: ' + e.descricao, context);
                          if (conf == true) {
                            // ignore: curly_braces_in_flow_control_structures
                            setState(() async {
                              filtros.grupos.contains(e)
                                  ? await filtros.removerGrupos(e)
                                  : filtros.addGrupos(e);
                              widget.press.call();
                            });
                          }
                        },
                      );
                    }).toList()),
                Wrap(
                    spacing: 1,
                    children: filtros.procedimentos.map((e) {
                      return ChoiceChip(
                        label: Text(
                          e.des_procedimentos.capitalize(),
                          style: TextStyle(fontSize: 10),
                        ),
                        selected: filtros.procedimentos.contains(e),
                        onSelected: (selected) async {
                          var conf = await AlertShowDialog('Remover Filtro: ',
                              'Procedimento: ' + e.des_procedimentos, context);
                          if (conf == true) {
                            // ignore: curly_braces_in_flow_control_structures
                            setState(() async {
                              filtros.procedimentos.contains(e)
                                  ? await filtros.removerProcedimento(e)
                                  : filtros.AddProcedimentos(e);
                              widget.press.call();
                            });
                          }
                        },
                      );
                    }).toList()),
              ]);
  }
}
