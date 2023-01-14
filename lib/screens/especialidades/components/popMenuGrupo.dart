import 'package:biomaapp/components/monoBino.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/Clips.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/data_list.dart';
import 'package:biomaapp/models/especialidade.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/grupos.dart';
import 'package:biomaapp/models/procedimento.dart';
import 'package:biomaapp/models/regras_list.dart';
import 'package:biomaapp/models/subEspecialidade.dart';
import 'package:biomaapp/screens/home/components/acordionExemplo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PopMenuGrupo extends StatefulWidget {
  final VoidCallback press;
  PopMenuGrupo(this.press);
  @override
  State<PopMenuGrupo> createState() => _PopMenuGrupoState();
}

class _PopMenuGrupoState extends State<PopMenuGrupo> {
  ScrollController OlhoScrollController = ScrollController();

  Grupo GrupoSelecionado = Grupo(descricao: 'Grupo');

  @override
  Widget build(BuildContext context) {
    var verifprocedimento = false;
    Auth auth = Provider.of(context);
    filtrosAtivos filtros = auth.filtrosativos;
    RegrasList dt = Provider.of(context, listen: false);

    Set<String> MedicosInclusos = Set();
    Set<String> GrupoInclusos = Set();

    mockResults = auth.filtrosativos.medicos;

    List<Grupo> grupos = [];
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
    dados.retainWhere((element) {
      return filtrarSubEspecialidade
          ? filtros.subespecialidades
              .contains(SubEspecialidade(descricao: element.sub_especialidade))
          : true;
    });
    dados.map((e) {
      if (!GrupoInclusos.contains(e.grupo)) {
        GrupoInclusos.add(e.grupo);
        grupos.add(Grupo(descricao: e.grupo));
      }
    }).toList();

    grupos.sort((a, b) => a.descricao.compareTo(b.descricao));

    Grupo allEsp = Grupo(descricao: 'Grupo');
    grupos.contains(allEsp)
        ? false
        : setState(() {
            grupos.add(allEsp);
          });

    filtros.grupos.isEmpty ? GrupoSelecionado = allEsp : true;

    return grupos.isEmpty
        ? CircularProgressIndicator()
        : PopupMenuButton<Grupo>(
            initialValue: filtros.grupos.isNotEmpty
                ? filtros.grupos.first
                : GrupoSelecionado,
            child: Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    filtros.grupos.isNotEmpty
                        ? Text(filtros.grupos.first.descricao)
                        : Text(GrupoSelecionado.descricao),
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
                GrupoSelecionado = value;
                filtros.LimparGrupos();
                if (value.descricao != 'Grupo') filtros.addGrupos(value);
              });
              widget.press.call();
            },
            itemBuilder: (BuildContext context) {
              return grupos.map((Grupo choice) {
                return PopupMenuItem<Grupo>(
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
