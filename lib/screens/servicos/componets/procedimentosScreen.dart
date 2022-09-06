import 'package:biomaapp/components/section_title.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/agendamentos_list.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/convenios.dart';
import 'package:biomaapp/models/data_list.dart';
import 'package:biomaapp/models/especialidade.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/grupos.dart';
import 'package:biomaapp/models/paginas.dart';
import 'package:biomaapp/models/procedimento.dart';
import 'package:biomaapp/models/subEspecialidade.dart';
import 'package:biomaapp/models/unidade.dart';

import 'package:biomaapp/screens/doctors/doctors_screen.dart';
import 'package:biomaapp/screens/especialidades/components/popMenuConvenios.dart';
import 'package:biomaapp/screens/especialidades/components/popMenuEspecialidades.dart';
import 'package:biomaapp/screens/especialidades/components/popMenuGrupo.dart';
import 'package:biomaapp/screens/especialidades/components/popMenuSubEspecialidades.dart';
import 'package:biomaapp/screens/especialidades/components/popMenuUnidades.dart';
import 'package:biomaapp/screens/procedimentos/procedimentosCircle.dart';
import 'package:biomaapp/screens/procedimentos/procedimentos_infor.dart';
import 'package:biomaapp/screens/procedimentos/procedimentos_screen_view.dart';
import 'package:biomaapp/screens/servicos/componets/filtroAtivosScren.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProcedimentosScreen extends StatefulWidget {
  final VoidCallback press;

  ProcedimentosScreen({Key? key, required this.press}) : super(key: key);

  @override
  State<ProcedimentosScreen> createState() => _ProcedimentosScreenState();
}

class _ProcedimentosScreenState extends State<ProcedimentosScreen> {
  bool _isLoading = false;
  final textEditingController = TextEditingController();
  TextEditingController txtQuery = new TextEditingController();
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    Auth auth = Provider.of<Auth>(
      context,
      listen: false,
    );
    AgendamentosList dados = Provider.of<AgendamentosList>(
      context,
      listen: false,
    );
    dados.items.isEmpty
        ? dados
            .loadAgendamentos(auth.fidelimax.cpf.toString())
            .then((value) => setState(() {
                  _isLoading = false;
                }))
        : setState(() {
            _isLoading = false;
          });
  }

  @override
  Widget build(BuildContext context) {
    DataList dt = Provider.of(context, listen: false);
    AgendamentosList historico = Provider.of(context);

    Auth auth = Provider.of(context);
    Paginas pages = auth.paginas;

    filtrosAtivos filtros = auth.filtrosativos;
    Set<String> EspecialidadesInclusas = Set();
    Set<String> ProcedimentosInclusoIncluso = Set();
    Set<String> UltimoProcedimentosInclusoIncluso = Set();

    mockResults = auth.filtrosativos.medicos;
    List<Procedimento> HistoricoProcedimentos = [];
    List<Procedimento> procedimentos = [];

    var filtrarUnidade = filtros.unidades.isNotEmpty;
    var filtrarConvenio = filtros.convenios.isNotEmpty;
    var filtrarEspecialidade = filtros.especialidades.isNotEmpty;
    var filtrarGrupos = filtros.grupos.isNotEmpty;
    var filtrarSubEspecialidade = filtros.subespecialidades.isNotEmpty;
    final dados = dt.items;

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
      return element.des_procedimentos
          .toLowerCase()
          .contains(txtQuery.text.toLowerCase());
    });
    dados.retainWhere((element) {
      return filtrarGrupos
          ? filtros.grupos.contains(Grupo(descricao: element.grupo))
          : true;
    });

    dados.map((e) {
      Procedimento p = Procedimento();

      p.cod_procedimentos = e.cod_procedimentos;
      p.des_procedimentos = e.des_procedimentos;
      p.valor = double.parse(e.valor);
      p.grupo = e.grupo;
      p.frequencia = e.frequencia;
      p.quantidade = e.tabop_quantidade;
      p.especialidade.codespecialidade = e.cod_especialidade;
      p.especialidade.descricao = e.des_especialidade;
      p.cod_tratamento = e.cod_tratamento;
      p.des_tratamento = e.tipo_tratamento;

      if (!ProcedimentosInclusoIncluso.contains(e.cod_procedimentos)) {
        ProcedimentosInclusoIncluso.add(e.cod_procedimentos);

        procedimentos.add(p);
      }
      historico.items.map((element) {
        if (element.cod_procedimento == p.cod_procedimentos) {
          if (!UltimoProcedimentosInclusoIncluso.contains(
              element.cod_procedimento)) {
            UltimoProcedimentosInclusoIncluso.add(element.cod_procedimento);
            HistoricoProcedimentos.add(p);
          }
        }
      }).toList();
    }).toList();
    procedimentos
        .sort((a, b) => a.des_procedimentos.compareTo(b.des_procedimentos));

    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Container(
            //  height: MediaQuery.of(context).size.height - 200,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        PopMenuConvenios(() {
                          setState(() {});
                        }),
                        PopMenuEspecialidade(() {
                          setState(() {});
                        }),
                        PopMenuSubEspecialidades(() {
                          setState(() {});
                        }),
                        PopMenuGrupo(() {
                          setState(() {});
                        }),
                        PopoMenuUnidades(() {
                          setState(() {});
                        })
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: txtQuery,
                      onChanged: (String) {
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        hintText: "Buscar",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        prefixIcon: Icon(Icons.search),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            txtQuery.text = '';
                            setState(() {
                              mockResults.clear();
                              //buscarQuery(txtQuery.text);
                            });
                            widget.press.call();
                          },
                        ),
                      ),
                    ),
                  ),
                  FiltroAtivosScren(press: () {
                    setState(() {
                      widget.press.call();
                    });
                  }),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SectionTitle(
                      title: "Últimos Procedimentos",
                      pressOnSeeAll: () {},
                      OnSeeAll: false,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      child: Row(
                        children: List.generate(
                          HistoricoProcedimentos.length,
                          (index) => ProcedimentosCircle(
                              procedimento: HistoricoProcedimentos[index],
                              press: () {
                                setState(() {
                                  filtros.LimparProcedimentos();
                                  filtros.AddProcedimentos(
                                      HistoricoProcedimentos[index]);
                                });
                                widget.press.call();
                              }),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SectionTitle(
                      title: "Todos os Procedimentos",
                      pressOnSeeAll: () {},
                      OnSeeAll: false,
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: List.generate(
                        procedimentos.length,
                        (index) => ProcedimentosInfor(
                          procedimento: procedimentos[index],
                          press: () {
                            setState(() {
                              filtros.LimparProcedimentos();
                              filtros.AddProcedimentos(procedimentos[index]);
                            });
                            widget.press.call();
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                  ),
                ],
              ),
            ),
          );
  }
}
