import 'package:biomaapp/components/ProgressIndicatorBioma.dart';
import 'package:biomaapp/components/section_title.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/agendamentos_list.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/convenios.dart';
import 'package:biomaapp/models/data_list.dart';
import 'package:biomaapp/models/especialidade.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/grupos.dart';
import 'package:biomaapp/models/medicos.dart';
import 'package:biomaapp/models/paginas.dart';
import 'package:biomaapp/models/procedimento.dart';
import 'package:biomaapp/models/regras_list.dart';
import 'package:biomaapp/models/subEspecialidade.dart';
import 'package:biomaapp/models/unidade.dart';
import 'package:biomaapp/models/unidades_list.dart';
import 'package:biomaapp/screens/doctors/components/Doctor_Circle.dart';
import 'package:biomaapp/screens/doctors/components/doctor_details_screen.dart';

import 'package:biomaapp/screens/doctors/doctors_screen.dart';
import 'package:biomaapp/screens/especialidades/components/popMenuConvenios.dart';
import 'package:biomaapp/screens/especialidades/components/popMenuEspecialidades.dart';
import 'package:biomaapp/screens/especialidades/components/popMenuGrupo.dart';
import 'package:biomaapp/screens/especialidades/components/popMenuSubEspecialidades.dart';
import 'package:biomaapp/screens/especialidades/components/popMenuUnidades.dart';
import 'package:biomaapp/screens/procedimentos/procedimentosCircle.dart';
import 'package:biomaapp/screens/procedimentos/procedimentos_infor.dart';
import 'package:biomaapp/screens/procedimentos/procedimentos_screen_view.dart';
import 'package:biomaapp/screens/search/components/menu_bar_unidades.dart';
import 'package:biomaapp/screens/servicos/componets/FiltrosScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UnidadesScreen extends StatefulWidget {
  UnidadesScreen({Key? key}) : super(key: key);

  @override
  State<UnidadesScreen> createState() => _UnidadesScreenState();
}

class _UnidadesScreenState extends State<UnidadesScreen> {
  bool _isLoading = true;
  final textEditingController = TextEditingController();
  TextEditingController txtQuery = new TextEditingController();
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    Auth auth = Provider.of<Auth>(
      context,
      listen: false,
    );
    var unlist = Provider.of<UnidadesList>(
      context,
      listen: false,
    );

    auth.atualizaAcesso(context, () {
      setState(() {
        unlist.items.isEmpty
            ? unlist.loadUnidades('').then((value) {
                setState(() {
                  _isLoading = false;
                });
              })
            : setState(() {
                _isLoading = false;
              });
      });
    }).then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    RegrasList dt = Provider.of(context, listen: false);
    AgendamentosList historico = Provider.of(context);
    UnidadesList unidadeslist = Provider.of(context);
    final dadosunidades = unidadeslist.items;
    Auth auth = Provider.of(context);
    Paginas pages = auth.paginas;

    filtrosAtivos filtros = auth.filtrosativos;
    Set<String> EspecialidadesInclusas = Set();
    Set<String> ProcedimentosInclusoIncluso = Set();
    Set<String> MedicosInclusos = Set();
    Set<String> UnidadesIncluso = Set();

    mockResults = auth.filtrosativos.medicos;
    List<Procedimento> HistoricoProcedimentos = [];
    List<Procedimento> procedimentos = [];

    List<Medicos> medicos = [];
    List<Unidade> unidades = [];
    final dados = dt.dados;
    dados
        .map((e) => dadosunidades.where((element) {
              if (element.cod_unidade.contains(e.cod_unidade)) {
                if (!UnidadesIncluso.contains(element.cod_unidade)) {
                  UnidadesIncluso.add(element.cod_unidade);

                  setState(() {
                    unidades.add(element);
                  });
                }
                return true;
              } else {
                return false;
              }
            }).toList())
        .toList();

    var filtrarUnidade = filtros.unidades.isNotEmpty;
    var filtrarConvenio = filtros.convenios.isNotEmpty;
    var filtrarEspecialidade = filtros.especialidades.isNotEmpty;
    var filtrarGrupos = filtros.grupos.isNotEmpty;
    var filtrarSubEspecialidade = filtros.subespecialidades.isNotEmpty;

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
      return element.textBusca
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
      p.convenio = Convenios(
          cod_convenio: e.cod_convenio, desc_convenio: e.desc_convenio);

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

      Medicos med = Medicos();
      med.cod_profissional = e.cod_profissional;
      med.des_profissional = e.des_profissional;
      med.cod_especialidade = e.cod_especialidade;
      med.crm = e.crm;
      med.cpf = e.cpf;
      med.idademin = e.idade_mim;
      med.idademax = e.idade_max;
      med.ativo = '1';
      med.subespecialidade = e.sub_especialidade;

      Unidade unidade = Unidade();
      unidade.cod_unidade = e.cod_unidade;
      unidade.des_unidade = e.des_unidade;

      if (!ProcedimentosInclusoIncluso.contains(e.cod_procedimentos)) {
        ProcedimentosInclusoIncluso.add(e.cod_procedimentos);
        procedimentos.add(p);
      }
      if (!MedicosInclusos.contains(e.cod_profissional)) {
        MedicosInclusos.add(e.cod_profissional);
        medicos.add(med);
      }
      // if (!UnidadesIncluso.contains(e.cod_unidade)) {
      //   UnidadesIncluso.add(e.cod_unidade);
      //   unidades.add(unidade);
      // }
    }).toList();
    unidades.sort((a, b) => a.des_unidade.compareTo(b.des_unidade));

    var cod_unidade = '';
    if (filtros.unidades.isNotEmpty) {
      cod_unidade = filtros.unidades.first.cod_unidade;
    }
    if (filtros.unidades.isEmpty && unidades.isNotEmpty) {
      cod_unidade = unidades.first.cod_unidade;
    }

    return _isLoading
        ? Center(child: ProgressIndicatorBioma())
        : Scaffold(
            appBar: AppBar(
              title: Text(filtros.unidades.isNotEmpty
                  ? filtros.unidades.last.des_unidade +
                      ' - ' +
                      filtros.unidades.last.bairro.capitalize() +
                      ' - ' +
                      filtros.unidades.last.municipio.capitalize()
                  : ' '),
            ),
            body: Container(
              //  height: MediaQuery.of(context).size.height - 200,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.25,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: NetworkImage(
                              'https://biotvindoor.com/bioma/imagens/unidades/' +
                                  cod_unidade +
                                  '.jpg'),
                          fit: BoxFit.cover,
                        )),
                        child: Column(
                          children: [
                            filtrosScreen(press: () {
                              setState(() {});
                            })
                          ],
                        ),
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
                            },
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SectionTitle(
                        title: "Especialistas",
                        pressOnSeeAll: () {
                          setState(() {
                            pages.selecionarPaginaHome('Especialistas');
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DoctorsScreen(),
                            ),
                          );
                        },
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
                            medicos.length,
                            (index) => DoctorInforCicle(
                                doctor: medicos[index],
                                press: () {
                                  setState(() {
                                    filtros.LimparMedicos();
                                    filtros.addMedicos(medicos[index]);
                                  });

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DoctorDetailsScreen(
                                        doctor: medicos[index],
                                        press: () {
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  ).then((value) => {
                                        setState(() {}),
                                      });
                                }),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SectionTitle(
                        title: "Todos os Procedimentos",
                        pressOnSeeAll: () {
                          setState(() {
                            pages.selecionarPaginaHome('Especialistas');
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DoctorsScreen(),
                            ),
                          );
                        },
                        OnSeeAll: true,
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProcedimentosScrennViwer(
                                    procedimentos: procedimentos[index],
                                    press: () {
                                      setState(() {
                                        filtros.LimparProcedimentos();
                                        filtros.AddProcedimentos(
                                            procedimentos[index]);
                                      });
                                    },
                                  ),
                                ),
                              );
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
            ),
          );
  }
}
