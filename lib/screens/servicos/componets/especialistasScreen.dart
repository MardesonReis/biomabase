import 'package:biomaapp/components/app_drawer.dart';
import 'package:biomaapp/components/custom_app_bar.dart';
import 'package:biomaapp/components/section_title.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/agendamentos_list.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/convenios.dart';
import 'package:biomaapp/models/data.dart';
import 'package:biomaapp/models/data_list.dart';
import 'package:biomaapp/models/especialidade.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/grupos.dart';
import 'package:biomaapp/models/medicos.dart';
import 'package:biomaapp/models/paginas.dart';
import 'package:biomaapp/models/regras_list.dart';
import 'package:biomaapp/models/subEspecialidade.dart';
import 'package:biomaapp/models/unidade.dart';
import 'package:biomaapp/screens/auth/auth_or_home_page.dart';
import 'package:biomaapp/screens/doctors/components/Doctor_Circle.dart';
import 'package:biomaapp/screens/doctors/components/docotor_card.dart';
import 'package:biomaapp/screens/doctors/components/doctor_details_screen.dart';
import 'package:biomaapp/screens/doctors/components/doctor_infor.dart';
import 'package:biomaapp/screens/doctors/doctors_screen.dart';
import 'package:biomaapp/screens/especialidades/components/popMenuConvenios.dart';
import 'package:biomaapp/screens/especialidades/components/popMenuEspecialidades.dart';
import 'package:biomaapp/screens/especialidades/components/popMenuGrupo.dart';
import 'package:biomaapp/screens/especialidades/components/popMenuSubEspecialidades.dart';
import 'package:biomaapp/screens/especialidades/components/popMenuUnidades.dart';
import 'package:biomaapp/screens/home/components/card_especialidades.dart';
import 'package:biomaapp/screens/servicos/componets/filtroAtivosScren.dart';
import 'package:biomaapp/utils/app_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class EspecialistasScreenn extends StatefulWidget {
  VoidCallback press;
  VoidCallback refreshPage;

  EspecialistasScreenn(
      {Key? key, required this.press, required this.refreshPage})
      : super(key: key);

  @override
  State<EspecialistasScreenn> createState() => _EspecialistasScreenState();
}

class _EspecialistasScreenState extends State<EspecialistasScreenn> {
  bool _isLoading = true;
  final textEditingController = TextEditingController();
  TextEditingController txtQuery = new TextEditingController();
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    if (!mounted) return;
    Auth auth = Provider.of<Auth>(
      context,
      listen: false,
    );

    AgendamentosList dados = Provider.of<AgendamentosList>(
      context,
      listen: false,
    );
    var RegraList = Provider.of<RegrasList>(
      context,
      listen: false,
    );
    //13978829304

    RegraList.carrgardados(context, Onpress: () {
      dados.items.isEmpty
          ? dados
              .loadAgendamentos(auth.fidelimax.cpf.toString(), '0', '0', '')
              .then((value) => setState(() {
                    _isLoading = false;
                  }))
          : setState(() {
              _isLoading = false;
            });
    }).then((value) => setState(() {
          _isLoading = false;
        }));
  }

  @override
  Widget build(BuildContext context) {
    RegrasList dt = Provider.of(context, listen: false);
    AgendamentosList historico = Provider.of(context);

    Auth auth = Provider.of(context);
    Paginas pages = auth.paginas;

    filtrosAtivos filtros = auth.filtrosativos;
    Set<String> MedicosInclusos = Set();
    Set<String> UltimosMedicosInclusos = Set();
    Set<String> EspecialidadesInclusas = Set();

    mockResults = auth.filtrosativos.medicos;
    List<Data> m = [];
    List<Medicos> medicos = [];
    List<Medicos> ultimosMedicos = [];
    List<Especialidade> especialidades = [];
    var filtrarUnidade = filtros.unidades.isNotEmpty;
    var filtrarConvenio = filtros.convenios.isNotEmpty;
    var filtrarEspecialidade = filtros.especialidades.isNotEmpty;
    var filtrarGrupos = filtros.grupos.isNotEmpty;
    var filtrarSubEspecialidade = filtros.subespecialidades.isNotEmpty;
    var filtrarMedicos = filtros.medicos.isNotEmpty;
    var filtrarProcedimento = filtros.procedimentos.isNotEmpty;

    final dados = dt.dados;
    if (filtrarProcedimento) {
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
          .contains(txtQuery.text.toLowerCase());
    });
    dados.retainWhere((element) {
      return filtrarGrupos
          ? filtros.grupos.contains(Grupo(descricao: element.grupo))
          : true;
    });

    dados.map((e) {
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

      historico.items.map((element) {
        if (element.cod_profissional == med.cod_profissional) {
          if (!UltimosMedicosInclusos.contains(e.cod_profissional)) {
            UltimosMedicosInclusos.add(e.cod_profissional);
            ultimosMedicos.add(med);
          }
        }
      }).toList();

      if (!MedicosInclusos.contains(e.cod_profissional)) {
        MedicosInclusos.add(e.cod_profissional);
        medicos.add(med);
      }

      if (!EspecialidadesInclusas.contains(e.cod_especialidade)) {
        EspecialidadesInclusas.add(e.cod_especialidade);
        especialidades.add(Especialidade(
            codespecialidade: e.cod_especialidade,
            descricao: e.des_especialidade,
            ativo: 'S'));
      }
    }).toList();
    medicos.sort((a, b) => a.des_profissional.compareTo(b.des_profissional));
    especialidades.sort((a, b) => a.descricao.compareTo(b.descricao));

    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Padding(
            padding:
                const EdgeInsets.only(top: 100, bottom: 1, left: 1, right: 1),
            child: Container(
              //  height: MediaQuery.of(context).size.height - 200,
              child: RefreshIndicator(
                onRefresh: () async {
                  var regraList = Provider.of<RegrasList>(
                    context,
                    listen: false,
                  );
                  //13978829304
                  await regraList.carrgardados(context, all: true, Onpress: () {
                    setState(() {
                      _isLoading = false;
                    });
                  });
                },
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
                              },
                            ),
                          ),
                        ),
                      ),
                      FiltroAtivosScren(press: () {
                        setState(() {
                          widget.refreshPage.call();
                        });
                      }),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SectionTitle(
                          title: "Últimos Especialistas",
                          pressOnSeeAll: () {},
                          OnSeeAll: false,
                        ),
                      ),
                      if (ultimosMedicos.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: BouncingScrollPhysics(),
                            child: Row(
                              children: List.generate(
                                ultimosMedicos.length,
                                (i) => DoctorInforCicle(
                                    doctor: ultimosMedicos[i],
                                    press: () {
                                      setState(() {
                                        filtros.LimparMedicos();
                                        filtros.addMedicos(ultimosMedicos[i]);

                                        widget.press.call();
                                      });
                                    }),
                              ),
                            ),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SectionTitle(
                          title: "Todos os Especialistas",
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
                      if (medicos.isNotEmpty)
                        SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            children: List.generate(
                              medicos.length,
                              (i) => DoctorInfor(
                                doctor: medicos[i],
                                press: () async {
                                  setState(() {
                                    filtros.LimparMedicos();
                                    filtros.addMedicos(medicos[i]);
                                    widget.press.call();
                                  });
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
            ),
          );
  }
}
