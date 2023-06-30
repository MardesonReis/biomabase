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

    return filtros.BuscarFiltrosAtivos() < 1
        ? SizedBox()
        : Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Filtros Ativos',
                        style: TextStyle(fontSize: 10),
                      ),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              filtros.LimparTodosFiltros();
                              widget.press.call();
                            });
                          },
                          icon: Icon(
                            Icons.delete,
                            color: redColor,
                          ))
                    ],
                  ),
                  Wrap(
                      spacing: 1,
                      children: filtros.convenios.map((e) {
                        return ChoiceChip(
                          selectedColor: destColor,
                          label: textResp(
                            e.desc_convenio.capitalize(),
                          ),
                          selected: filtros.convenios.contains(e),
                          onSelected: (selected) async {
                            var conf = await AlertShowDialog('Remover Filtro: ',
                                Text('Convênios: ' + e.desc_convenio), context);
                            if (conf == true) {
                              // ignore: curly_braces_in_flow_control_structures
                              setState(() {
                                filtros.convenios.contains(e)
                                    ? filtros.LimparConvenios()
                                    : filtros.addConvenios(e);
                                widget.press.call();
                              });
                            }
                            widget.press.call();
                          },
                        );
                      }).toList()),
                  Wrap(
                      spacing: 1,
                      children: filtros.medicos.map((e) {
                        return ChoiceChip(
                          selectedColor: destColor,
                          label: textResp(e.des_profissional.capitalize()),
                          selected: filtros.medicos.contains(e),
                          onSelected: (selected) async {
                            var conf = await AlertShowDialog(
                                'Remover Filtro: ',
                                Text('Especialista: ' + e.des_profissional),
                                context);
                            if (conf == true) {
                              // ignore: curly_braces_in_flow_control_structures
                              setState(() {
                                filtros.medicos.contains(e)
                                    ? filtros.removerMedico(e)
                                    : filtros.addMedicos(e);
                                widget.press.call();
                              });
                            }
                            widget.press.call();
                          },
                        );
                      }).toList()),
                  Wrap(
                      spacing: 1,
                      children: filtros.unidades.map((e) {
                        return ChoiceChip(
                          selectedColor: destColor,
                          label: textResp(
                            e.des_unidade.capitalize() +
                                ' - ' +
                                e.bairro.capitalize(),
                          ),
                          selected: filtros.unidades.contains(e),
                          onSelected: (selected) async {
                            var conf = await AlertShowDialog(
                                'Remover Filtro: ',
                                Text('Local de Atendimento: ' + e.des_unidade),
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
                            widget.press.call();
                          },
                        );
                      }).toList()),
                  Wrap(
                      spacing: 1,
                      children: filtros.especialidades.map((e) {
                        return ChoiceChip(
                          selectedColor: destColor,
                          label: textResp(
                            e.descricao.capitalize(),
                          ),
                          selected: filtros.especialidades.contains(e),
                          onSelected: (selected) async {
                            var conf = await AlertShowDialog('Remover Filtro: ',
                                Text('Especialidade: ' + e.descricao), context);
                            if (conf == true) {
                              // ignore: curly_braces_in_flow_control_structures
                              setState(() async {
                                filtros.especialidades.contains(e)
                                    ? await filtros.removerEspacialidades(e)
                                    : filtros.addEspacialidades(e);
                                widget.press.call();
                              });
                            }
                            widget.press.call();
                          },
                        );
                      }).toList()),
                  Wrap(
                      spacing: 1,
                      children: filtros.subespecialidades.map((e) {
                        return ChoiceChip(
                          selectedColor: destColor,
                          label: textResp(
                            e.descricao.capitalize(),
                          ),
                          selected: filtros.subespecialidades.contains(e),
                          onSelected: (selected) async {
                            var conf = await AlertShowDialog(
                                'Remover Filtro: ',
                                Text('Subespecialidade: ' + e.descricao),
                                context);
                            if (conf == true) {
                              // ignore: curly_braces_in_flow_control_structures
                              setState(() async {
                                filtros.subespecialidades.contains(e)
                                    ? await filtros.removerSubEspacialidades(e)
                                    : filtros.addSubEspacialidades(e);
                                widget.press.call();
                              });
                            }
                            widget.press.call();
                          },
                        );
                      }).toList()),
                  Wrap(
                      spacing: 1,
                      children: filtros.grupos.map((e) {
                        return ChoiceChip(
                          selectedColor: destColor,
                          label: textResp(
                            e.descricao.capitalize(),
                          ),
                          selected: filtros.grupos.contains(e),
                          onSelected: (selected) async {
                            var conf = await AlertShowDialog(
                                'Remover Filtro: ',
                                Text('Subespecialidade: ' + e.descricao),
                                context);
                            if (conf == true) {
                              // ignore: curly_braces_in_flow_control_structures
                              setState(() async {
                                filtros.grupos.contains(e)
                                    ? await filtros.removerGrupos(e)
                                    : filtros.addGrupos(e);
                                widget.press.call();
                              });
                            }
                            widget.press.call();
                          },
                        );
                      }).toList()),
                  Wrap(
                      spacing: 1,
                      children: filtros.procedimentos.map((e) {
                        return ChoiceChip(
                          selectedColor: destColor,
                          label: textResp(
                            e.des_procedimentos.capitalize(),
                          ),
                          selected: filtros.procedimentos.contains(e),
                          onSelected: (selected) async {
                            var conf = await AlertShowDialog(
                                'Remover Filtro: ',
                                Text('Procedimento: ' + e.des_procedimentos),
                                context);
                            if (conf == true) {
                              // ignore: curly_braces_in_flow_control_structures
                              setState(() async {
                                filtros.procedimentos.contains(e)
                                    ? await filtros.removerProcedimento(e)
                                    : filtros.AddProcedimentos(e);
                                widget.press.call();
                              });
                            }
                            widget.press.call();
                          },
                        );
                      }).toList()),
                ]),
              ),
            ),
          );
  }
}
