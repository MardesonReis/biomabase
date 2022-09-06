import 'package:biomaapp/components/monoBino.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/Clips.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/convenios.dart';
import 'package:biomaapp/models/data_list.dart';
import 'package:biomaapp/models/especialidade.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/procedimento.dart';
import 'package:biomaapp/models/subEspecialidade.dart';
import 'package:biomaapp/screens/home/components/acordionExemplo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PopMenuEspecialidade extends StatefulWidget {
  final VoidCallback press;
  PopMenuEspecialidade(this.press);
  @override
  State<PopMenuEspecialidade> createState() => _PopMenuEspecialidadeState();
}

class _PopMenuEspecialidadeState extends State<PopMenuEspecialidade> {
  ScrollController OlhoScrollController = ScrollController();

  Especialidade especialidadeSelecionado = Especialidade(
      codespecialidade: '00', descricao: 'Especialidades', ativo: '');

  @override
  Widget build(BuildContext context) {
    var verifprocedimento = false;
    Auth auth = Provider.of(context);
    filtrosAtivos filtros = auth.filtrosativos;
    DataList dt = Provider.of(context, listen: false);

    Set<String> MedicosInclusos = Set();
    Set<String> EspecialidadesInclusas = Set();

    mockResults = auth.filtrosativos.medicos;

    List<Especialidade> especialidades = [];
    var filtrarUnidade = filtros.unidades.isNotEmpty;
    var filtrarConvenio = filtros.convenios.isNotEmpty;
    var filtrarEspecialidade = filtros.especialidades.isNotEmpty;
    var filtrarGrupos = filtros.grupos.isNotEmpty;
    var filtrarSubEspecialidade = filtros.subespecialidades.isNotEmpty;
    var filtrarConvenios = filtros.convenios.isNotEmpty;
    final dados = dt.items;
    dados.retainWhere((element) {
      return filtrarConvenios
          ? filtros.convenios.contains(Convenios(
              cod_convenio: element.cod_convenio,
              desc_convenio: element.desc_convenio))
          : true;
    });
    dados.retainWhere((element) {
      return filtrarSubEspecialidade
          ? filtros.subespecialidades
              .contains(SubEspecialidade(descricao: element.sub_especialidade))
          : true;
    });

    dados.map((e) {
      if (!EspecialidadesInclusas.contains(e.cod_especialidade)) {
        EspecialidadesInclusas.add(e.cod_especialidade);
        especialidades.add(Especialidade(
            codespecialidade: e.cod_especialidade,
            descricao: e.des_especialidade,
            ativo: 'S'));
      }
    }).toList();
    especialidades.sort((a, b) => a.descricao.compareTo(b.descricao));

    Especialidade allEsp = Especialidade(
        codespecialidade: '00', descricao: 'Especialidades', ativo: '');
    especialidades.contains(allEsp)
        ? false
        : setState(() {
            especialidades.add(allEsp);
          });
    filtros.especialidades.isEmpty ? especialidadeSelecionado = allEsp : true;

    return especialidades.isEmpty
        ? CircularProgressIndicator()
        : PopupMenuButton<Especialidade>(
            initialValue: filtros.especialidades.isNotEmpty
                ? filtros.especialidades.first
                : especialidadeSelecionado,
            child: Card(
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(filtros.especialidades.isNotEmpty
                        ? filtros.especialidades.first.descricao
                        : especialidadeSelecionado.descricao),
                    Icon(
                      Icons.expand_more_outlined,
                      color: primaryColor,
                    )
                  ],
                ),
              ),
            ),
            onSelected: (value) {
              setState(() async {
                await filtros.LimparEspecialidades();
                await filtros.LimparSubEspecialidades();
                await filtros.LimparGrupos();
                if (value.codespecialidade != '00') {
                  await filtros.addEspacialidades(value);
                }
                especialidadeSelecionado = value;
                widget.press.call();
              });
            },
            itemBuilder: (BuildContext context) {
              return especialidades.map((Especialidade choice) {
                return PopupMenuItem<Especialidade>(
                  value: choice,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(choice.descricao),
                  ),
                );
              }).toList();
            },
          );
  }
}
