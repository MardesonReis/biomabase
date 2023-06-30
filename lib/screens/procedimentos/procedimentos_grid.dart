import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/convenios.dart';
import 'package:biomaapp/models/data_list.dart';
import 'package:biomaapp/models/especialidade.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/grupos.dart';
import 'package:biomaapp/models/medicos.dart';
import 'package:biomaapp/models/procedimento.dart';
import 'package:biomaapp/models/procedimento_list.dart';
import 'package:biomaapp/models/regras_list.dart';
import 'package:biomaapp/models/subEspecialidade.dart';
import 'package:biomaapp/models/unidade.dart';
import 'package:biomaapp/screens/procedimentos/procedimento_grid_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProcedimentoGrid extends StatefulWidget {
  Medicos doctor;
  VoidCallback press;
  String FilterString;
  ProcedimentoGrid(this.doctor, this.FilterString, this.press);
  @override
  State<ProcedimentoGrid> createState() => _ProcedimentoGridState();
}

class _ProcedimentoGridState extends State<ProcedimentoGrid> {
  ScrollController listScrollController = ScrollController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    //  debugPrint(ProcedimentosFiltrado.length.toString());

    RegrasList dt = Provider.of(context, listen: false);
    Auth auth = Provider.of(context);
    Set<String> UnidadesInclusoIncluso = Set();
    Set<String> ConveniosInclusoIncluso = Set();
    Set<String> EspecialidadesInclusoIncluso = Set();
    Set<String> SubEspecialidadesInclusoIncluso = Set();
    Set<String> ProcedimentosInclusoIncluso = Set();
    Set<String> GruposInclusoIncluso = Set();
    List<Unidade> unidadeslist = [];
    List<Especialidade> especialidadeslist = [];
    List<SubEspecialidade> subespecialidadeslist = [];
    List<Grupo> gruposlist = [];
    List<Convenios> convenioslist = [];
    List<Procedimento> ProcedimentosFiltrado = [];
    
    Set<String> convenios = Set();
    filtrosAtivos filtros = auth.filtrosativos;
    var filtrarUnidade = filtros.unidades.isNotEmpty;
    var filtrarConvenio = filtros.convenios.isNotEmpty;
    var filtrarEspecialidade = filtros.especialidades.isNotEmpty;
    var filtrarGrupos = filtros.grupos.isNotEmpty;
    var filtrarSubEspecialidade = filtros.subespecialidades.isNotEmpty;
    var filtrarMedicos = filtros.medicos.isNotEmpty;

    final dados = dt.dados;

    dados.retainWhere((element) {
      return element.cod_profissional == widget.doctor.cod_profissional;
    });
    dados.retainWhere((element) {
      return filtrarUnidade
          ? filtros.unidades.contains(Unidade(
              cod_unidade: element.cod_unidade,
              des_unidade: element.des_unidade))
          : true;
    });

    dados.retainWhere((element) {
      return filtrarConvenio
          ? filtros.convenios.contains(Convenios(
              cod_convenio: element.cod_convenio,
              desc_convenio: element.desc_convenio))
          : true;
    });
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
    dados.retainWhere((element) {
      return element.des_profissional
          .toLowerCase()
          .contains(widget.FilterString.toLowerCase());
    });
    dados.retainWhere((element) {
      return filtrarGrupos
          ? filtros.grupos.contains(Grupo(descricao: element.grupo))
          : true;
    });
    dados.map((e) {
      if (!ProcedimentosInclusoIncluso.contains(
          e.cod_procedimentos + ' - ' + e.cod_convenio)) {
        ProcedimentosInclusoIncluso.add(
            e.cod_procedimentos + ' - ' + e.cod_convenio);

        Procedimento p = Procedimento();
        p.convenio = Convenios(
            cod_convenio: e.cod_convenio, desc_convenio: e.desc_convenio);

        p.cod_procedimentos = e.cod_procedimentos;
        p.valor_sugerido = double.parse(e.valor_sugerido);
        p.orientacoes = e.orientacoes;
        p.des_procedimentos = e.des_procedimentos;
        p.valor = double.parse(e.valor);
        p.grupo = e.grupo;
        p.frequencia = e.frequencia;
        p.quantidade = e.tabop_quantidade;
        p.especialidade.codespecialidade = e.cod_especialidade;
        p.especialidade.descricao = e.des_especialidade;
        p.cod_tratamento = e.cod_tratamento;
        p.des_tratamento = e.tipo_tratamento;

        ProcedimentosFiltrado.add(p);
      }
      if (!UnidadesInclusoIncluso.contains(e.cod_unidade)) {
        UnidadesInclusoIncluso.add(e.cod_unidade);
        unidadeslist.add(
            Unidade(cod_unidade: e.cod_unidade, des_unidade: e.des_unidade));
      }

      if (!ConveniosInclusoIncluso.contains(e.cod_convenio)) {
        ConveniosInclusoIncluso.add(e.cod_convenio);

        convenioslist.add(Convenios(
            cod_convenio: e.cod_convenio, desc_convenio: e.desc_convenio));
      }
      if (!GruposInclusoIncluso.contains(e.grupo)) {
        GruposInclusoIncluso.add(e.grupo);

        gruposlist.add(Grupo(descricao: e.grupo));
      }
      if (!EspecialidadesInclusoIncluso.contains(e.cod_especialidade)) {
        EspecialidadesInclusoIncluso.add(e.cod_especialidade);

        especialidadeslist.add(Especialidade(
            codespecialidade: e.cod_especialidade,
            descricao: e.des_especialidade,
            ativo: 'S'));
      }
      if (!SubEspecialidadesInclusoIncluso.contains(e.sub_especialidade)) {
        SubEspecialidadesInclusoIncluso.add(e.sub_especialidade);

        subespecialidadeslist
            .add(SubEspecialidade(descricao: e.sub_especialidade));
      }
    }).toList();

    ProcedimentosFiltrado.sort((a, b) => int.parse(b.frequencia.toString())
        .compareTo(int.parse(a.frequencia.toString())));
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Column(
            children: [
              SizedBox(
                child: GridView.builder(
                    controller: listScrollController,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          MediaQuery.of(context).orientation.name == 'portrait'
                              ? 1
                              : 4,
                      childAspectRatio: 2.77,
                      crossAxisSpacing: defaultPadding,
                      mainAxisSpacing: defaultPadding,
                      mainAxisExtent: 150,
                    ),
                    itemCount: ProcedimentosFiltrado.length,
                    itemBuilder: (BuildContext ctx, index) {
                      return ProcedimentosFiltrado.length > 0
                          ? Container(
                              child: ProcedimentoGridItem(
                                  widget.doctor, ProcedimentosFiltrado[index],
                                  () {
                                setState(() {
                                  widget.press.call();
                                });
                              }),
                            )
                          : Text(
                              'Não há procedimentos para os filtros selecionados');
                    }),
              ),
            ],
          );
  }
}
