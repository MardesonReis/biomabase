import 'package:biomaapp/components/monoBino.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/Clips.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/convenios.dart';
import 'package:biomaapp/models/data_list.dart';
import 'package:biomaapp/models/especialidade.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/procedimento.dart';
import 'package:biomaapp/models/regras_list.dart';
import 'package:biomaapp/models/subEspecialidade.dart';
import 'package:biomaapp/screens/home/components/acordionExemplo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PopMenuConvenios extends StatefulWidget {
  final VoidCallback press;
  PopMenuConvenios(this.press);
  @override
  State<PopMenuConvenios> createState() => _PopMenuConveniosState();
}

class _PopMenuConveniosState extends State<PopMenuConvenios> {
  ScrollController OlhoScrollController = ScrollController();

  Convenios ConvenioSelecionado =
      Convenios(cod_convenio: '', desc_convenio: 'Convênios');
  @override
  Widget build(BuildContext context) {
    var verifprocedimento = false;
    Auth auth = Provider.of(context);
    filtrosAtivos filtros = auth.filtrosativos;
    RegrasList dt = Provider.of(context, listen: false);

    Set<String> conveniosInclusas = Set();
    Set<String> SubEspecialidadesInclusas = Set();

    List<Convenios> convenios = [];
    var filtrarUnidade = filtros.unidades.isNotEmpty;
    var filtrarConvenio = filtros.convenios.isNotEmpty;
    var filtrarEspecialidade = filtros.especialidades.isNotEmpty;
    var filtrarGrupos = filtros.grupos.isNotEmpty;
    var filtrarSubEspecialidade = filtros.subespecialidades.isNotEmpty;
    var filtrarConvenios = filtros.subespecialidades.isNotEmpty;
    var filtrarProcedimentos = filtros.procedimentos.isNotEmpty;
    var filtrarMedicos = filtros.medicos.isNotEmpty;
    final dados = dt.dados;
    if (filtrarProcedimentos) {
      dados.retainWhere((element) {
        return filtros.procedimentos
            .where((m) => m.cod_procedimentos == element.cod_procedimentos)
            .isNotEmpty;
      });
    }
    if (filtrarMedicos) {
      dados.retainWhere((element) {
        return filtros.medicos
            .where((m) => m.cod_profissional == element.cod_profissional)
            .isNotEmpty;
      });
    }
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
      if (!conveniosInclusas.contains(e.cod_convenio)) {
        conveniosInclusas.add(e.cod_convenio);
        convenios.add(Convenios(
            cod_convenio: e.cod_convenio, desc_convenio: e.desc_convenio));
      }
    }).toList();
    convenios.sort((a, b) => a.desc_convenio.compareTo(b.desc_convenio));
    var c = Convenios(cod_convenio: '', desc_convenio: 'Convênios');

    convenios.contains(c)
        ? false
        : setState(() {
            convenios.add(c);
          });

    filtros.convenios.isNotEmpty
        ? setState(
            () {
              ConvenioSelecionado = filtros.convenios.first;
            },
          )
        : setState(
            () {
              ConvenioSelecionado = convenios
                  .where((element) => element.cod_convenio != '')
                  .toList()
                  .first;
              filtros.convenios.add(ConvenioSelecionado);
            },
          );

    return PopupMenuButton<Convenios>(
      initialValue: ConvenioSelecionado,
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(ConvenioSelecionado.desc_convenio),
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
          filtros.LimparConvenios();
          if (value.cod_convenio != '') {
            filtros.addConvenios(value);
          }
          ConvenioSelecionado = value;
        });
        widget.press.call();
      },
      itemBuilder: (BuildContext context) {
        return convenios.map((Convenios choice) {
          return PopupMenuItem<Convenios>(
            value: choice,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(choice.desc_convenio),
            ),
          );
        }).toList();
      },
    );
  }
}
