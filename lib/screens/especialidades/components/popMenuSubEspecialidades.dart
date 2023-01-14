import 'package:biomaapp/components/monoBino.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/Clips.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/data_list.dart';
import 'package:biomaapp/models/especialidade.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/procedimento.dart';
import 'package:biomaapp/models/regras_list.dart';
import 'package:biomaapp/models/subEspecialidade.dart';
import 'package:biomaapp/screens/home/components/acordionExemplo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PopMenuSubEspecialidades extends StatefulWidget {
  final VoidCallback press;
  PopMenuSubEspecialidades(this.press);
  @override
  State<PopMenuSubEspecialidades> createState() =>
      _PopMenuSubEspecialidadesState();
}

class _PopMenuSubEspecialidadesState extends State<PopMenuSubEspecialidades> {
  ScrollController OlhoScrollController = ScrollController();

  SubEspecialidade SubespecialidadeSelecionado =
      SubEspecialidade(descricao: 'Subespecialidade');

  @override
  Widget build(BuildContext context) {
    var verifprocedimento = false;
    Auth auth = Provider.of(context);
    filtrosAtivos filtros = auth.filtrosativos;
    RegrasList dt = Provider.of(context, listen: false);

    Set<String> MedicosInclusos = Set();
    Set<String> SubEspecialidadesInclusas = Set();

    mockResults = auth.filtrosativos.medicos;

    List<SubEspecialidade> subEspecialidades = [];
    var filtrarUnidade = filtros.unidades.isNotEmpty;
    var filtrarConvenio = filtros.convenios.isNotEmpty;
    var filtrarEspecialidade = filtros.especialidades.isNotEmpty;
    var filtrarGrupos = filtros.grupos.isNotEmpty;
    var filtrarSubEspecialidade = filtros.subespecialidades.isNotEmpty;
    final dados = dt.dados;
    dados.retainWhere((element) {
      return filtrarEspecialidade
          ? filtros.especialidades.contains(Especialidade(
              codespecialidade: element.cod_especialidade,
              descricao: element.des_especialidade,
              ativo: 'S'))
          : true;
    });
    dados.map((e) {
      if (!SubEspecialidadesInclusas.contains(e.sub_especialidade)) {
        SubEspecialidadesInclusas.add(e.sub_especialidade);
        subEspecialidades.add(SubEspecialidade(descricao: e.sub_especialidade));
      }
    }).toList();

    subEspecialidades.sort((a, b) => a.descricao.compareTo(b.descricao));

    SubEspecialidade allEsp = SubEspecialidade(descricao: 'Subespecialidade');
    subEspecialidades.contains(allEsp)
        ? false
        : setState(() {
            subEspecialidades.add(allEsp);
          });

    filtros.subespecialidades.isEmpty
        ? SubespecialidadeSelecionado = allEsp
        : true;

    return subEspecialidades.isEmpty
        ? CircularProgressIndicator()
        : PopupMenuButton<SubEspecialidade>(
            initialValue: filtros.subespecialidades.isNotEmpty
                ? filtros.subespecialidades.first
                : SubespecialidadeSelecionado,
            child: Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    filtros.subespecialidades.isNotEmpty
                        ? Text(filtros.subespecialidades.first.descricao)
                        : Text(SubespecialidadeSelecionado.descricao),
                    Icon(
                      Icons.expand_more_outlined,
                      color: primaryColor,
                    )
                  ],
                ),
              ),
            ),
            onSelected: (value) {
              setState(() {
                filtros.LimparSubEspecialidades();
                filtros.LimparGrupos();
                if (value.descricao != 'Subespecialidade')
                  filtros.addSubEspacialidades(value);
                SubespecialidadeSelecionado = value;
                widget.press.call();
              });
            },
            itemBuilder: (BuildContext context) {
              return subEspecialidades.map((SubEspecialidade choice) {
                return PopupMenuItem<SubEspecialidade>(
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
