import 'dart:developer';

import 'package:biomaapp/components/ProgressIndicatorBioma.dart';
import 'package:biomaapp/components/app_drawer.dart';
import 'package:biomaapp/components/custom_app_bar.dart';
import 'package:biomaapp/components/section_title.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/Clips.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/cart.dart';
import 'package:biomaapp/models/convenios.dart';
import 'package:biomaapp/models/data_list.dart';
import 'package:biomaapp/models/especialidade.dart';
import 'package:biomaapp/models/fidelimax.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/grupos.dart';
import 'package:biomaapp/models/medicos.dart';
import 'package:biomaapp/models/medicos_list.dart';
import 'package:biomaapp/models/pacientes.dart';
import 'package:biomaapp/models/perfilDeAtendimento.dart';
import 'package:biomaapp/models/procedimento.dart';
import 'package:biomaapp/models/regras.dart';
import 'package:biomaapp/models/regras_list.dart';
import 'package:biomaapp/models/subEspecialidade.dart';
import 'package:biomaapp/models/unidade.dart';
import 'package:biomaapp/models/unidades_list.dart';
import 'package:biomaapp/screens/appointment/componets/buildEspecialistas.dart';
import 'package:biomaapp/screens/fidelimax/card_fidelimax.dart';
import 'package:biomaapp/screens/home/components/meu_bioma.dart';
import 'package:biomaapp/screens/profile/componets/add_regra.dart';
import 'package:biomaapp/screens/profile/componets/confirma_regra.dart';
import 'package:biomaapp/screens/profile/componets/dadosPerfil.dart';
import 'package:biomaapp/screens/servicos/componets/especialistasScreen.dart';
import 'package:biomaapp/screens/settings/settings_screen.dart';
import 'package:biomaapp/screens/user/components/user_card.dart';
import 'package:biomaapp/utils/SelectUser.dart';
import 'package:biomaapp/utils/app_routes.dart';
import 'package:biomaapp/utils/constants.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart';
import 'package:flutter/services.dart';

class PermicoesScreen extends StatefulWidget {
  const PermicoesScreen({Key? key}) : super(key: key);

  @override
  State<PermicoesScreen> createState() => _PermicoesScreenState();
}

class _PermicoesScreenState extends State<PermicoesScreen> {
  bool _isLoading = true;
  bool _isLoadingPerfil = true;
  bool i = false;
  String _unidade = '';
  String _expanded_medico = '';
  String _expanded_unidade = '';
  String _expanded_conveio = '';

  int _selectedGrupo = 0;
  int _selectedEspecialidade = 0;
  int _selectedConvenios = 0;
  List<Clips> grupos = [
    //Clips(titulo: 'Consulta', subtitulo: 'Consulta', keyId: '')
  ];
  List<Clips> especialidades = [
    // Clips(titulo: 'Consulta', subtitulo: 'Consulta', keyId: '')
  ];
  final List<Clips> convenios = [
    // Clips(titulo: 'Consulta', subtitulo: 'Consulta', keyId: '')
  ];
  Set<String> EspecialidadesInclusoIncluso = Set();
  Set<String> SubEspecialidadesInclusoIncluso = Set();
  Set<String> GruposInclusoIncluso = Set();
  List<Especialidade> especialidadeslist = [];
  List<SubEspecialidade> subespecialidadeslist = [];
  List<Grupo> gruposlist = [];
  Set<String> MedicosInclusos = Set();
  List<Medicos> medicos = [];

  Set<String> gruposIncluso = Set();
  Set<String> unidadesIncluso = Set();
  Set<String> ConvenioIncluso = Set();
  Set<String> especialidadesIncluso = Set();
  int _currentFocusedIndex = 0;
  Clips menu_select =
      Clips(titulo: 'Perfil de Atendimento', subtitulo: '', keyId: 'P');

  @override
  initState() {
    var auth = Provider.of<Auth>(
      context,
      listen: false,
    );

    var perfilDeAtendimento = Provider.of<PerfilDeAtendimento>(
      context,
      listen: false,
    );

    //13978829304
    var RegraList = Provider.of<RegrasList>(
      context,
      listen: false,
    );
    // auth.fidelimax.cpf = '13978829304';

    perfilDeAtendimento
        .listarPerdil(
            Master.contains(auth.fidelimax.cpf) ? '0' : auth.fidelimax.cpf)
        .then((value) {
      setState(() {
        _isLoadingPerfil = false;
      });
    });

    RegraList.Regras(context).then((value) {
      setState(() {
        _isLoading = false;
      });
    });
    var unlist = Provider.of<UnidadesList>(
      context,
      listen: false,
    );

    unlist.items.isEmpty
        ? unlist.loadUnidades('0').then((value) {
            setState(() {
              //     _isLoading = false;
            });
          })
        : setState(() {
            //   _isLoading = false;
          });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    PerfilDeAtendimento perfilDeAtendimento = Provider.of(context);
    RegrasList regrasList = Provider.of(context);

    List<Regra> regras = regrasList.items;
    Fidelimax fidelimax = auth.fidelimax;
    filtrosAtivos filtros = auth.filtrosativos;
    UnidadesList unidadesDados = Provider.of(context);
    var menu = [
      Clips(titulo: 'Perfil de Atendimento', subtitulo: '', keyId: 'P'),
      Clips(titulo: 'Regras Ativas', subtitulo: '', keyId: 'R'),
    ];

    perfilDeAtendimento.items.map((e) async {
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
    perfilDeAtendimento.items.map((e) {
      var especialidade = Especialidade(
          codespecialidade: e.cod_especialidade,
          descricao: e.des_especialidade,
          ativo: 'S');
      Medicos med = Medicos(especialidade: especialidade);
      med.cod_profissional = e.cod_profissional;
      med.des_profissional = e.des_profissional;
      med.crm = e.crm;
      med.cpf = e.cpf;
      med.idademin = e.idade_mim;
      med.idademax = e.idade_max;
      med.ativo = '1';
      med.subespecialidade = e.sub_especialidade;

      if (!MedicosInclusos.contains(e.cod_profissional)) {
        MedicosInclusos.add(e.cod_profissional);
        medicos.add(med);
      }
    }).toList();
    medicos.sort((a, b) => a.des_profissional.compareTo(b.des_profissional));
    especialidadeslist.sort((a, b) => a.descricao.compareTo(b.descricao));

    //convenioslist.sort((a, b) => a.desc_convenio.compareTo(b.desc_convenio));
    gruposlist.sort((a, b) => a.descricao.compareTo(b.descricao));
    subespecialidadeslist.sort((a, b) => a.descricao.compareTo(b.descricao));
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: CustomAppBar('Minhas \n', 'Permissões', () {}, [])),
      //  drawer: AppDrawer(),
      body: _isLoading && _isLoadingPerfil
          ? Center(
              child: ProgressIndicatorBioma(),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(defaultPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: defaultPadding),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () => Navigator.of(context).pushReplacementNamed(
                          AppRoutes.ImageUpload,
                        ),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          elevation: 8,
                          child: Padding(
                              padding: EdgeInsets.all(3),
                              child: CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(
                                    Constants.IMG_USUARIO +
                                        fidelimax.cpf +
                                        '.jpg'),
                              )),
                        ),
                      ),
                      SizedBox(width: defaultPadding),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fidelimax.nome,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          Text(
                            auth.email.toString(),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          Text(
                            auth.fidelimax.cpf.toString(),
                            style: TextStyle(
                              fontSize: 12,
                              color: textColor.withOpacity(0.62),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: defaultPadding),
                  Row(
                    children: List.generate(
                      menu.length,
                      (index) => InkWell(
                        onTap: () async {
                          if (menu[index].keyId == 'R') {
                            setState(() {
                              _isLoading = true;
                            });
                            await regrasList.Regras(context).then((value) {
                              setState(() {
                                _isLoading = false;
                              });
                            });
                          }

                          setState(() {
                            menu_select = menu[index];
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(3),
                          child: Text(menu[index].titulo,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: menu[index] == menu_select
                                      ? primaryColor
                                      : Colors.black)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: defaultPadding),
                  if (menu_select.keyId == 'R' && regras.isNotEmpty)
                    Wrap(
                      children: List.generate(
                          regras.length,
                          (index) => ListTile(
                              dense: true,
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  textResp('Procedimento: ' +
                                      regras[index].r_des_procedimentos +
                                      ' - R\$:  ' +
                                      regras[index].r_valor_sugerido),
                                  textResp('Especialista: ' +
                                      regras[index].r_des_profissional),
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text('Parceiro: ' +
                                      regras[index]
                                          .r_des_parceiro
                                          .capitalize() +
                                      " - " +
                                      regras[index]
                                          .r_cpf_parceiro
                                          .capitalize()),
                                  Text('Orientações: ' +
                                      regras[index].r_orientacoes),
                                ],
                              ),
                              leading: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 15,
                                    backgroundImage: NetworkImage(
                                        Constants.IMG_USUARIO +
                                            regras[index].r_cpf_profissional +
                                            '.jpg',
                                        scale: 20),
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                onPressed: () async {
                                  var a = await AlertShowDialog(
                                      'Atenção: ',
                                      Text('Confirma remoção da regra? '),
                                      context);

                                  if (a) {
                                    var id_regra = await regrasList.Remover(
                                        regras[index].r_id);
                                    if (id_regra != '') {
                                      AlertShowDialog(
                                          'Sucesso',
                                          Text('Removido com sucesso'),
                                          context);

                                      setState(() {
                                        _isLoading = true;
                                      });
                                      await regrasList.Regras(context);
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    } else {
                                      showSnackBar(
                                          Text('Não é possível remover'),
                                          context);
                                    }
                                    await regrasList.carrgardados(context,
                                        Onpress: () {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    });
                                  } else {
                                    //   Navigator.of(context).pop();
                                  }
                                },
                                icon: Icon(Icons.remove_circle_outline,
                                    color: redColor),
                              ))),
                    ),
                  SizedBox(height: defaultPadding),
                  if (perfilDeAtendimento.items.isEmpty || _isLoading)
                    ProgressIndicatorBioma(),
                  if (menu_select.keyId == 'P')
                    Column(
                      children: List.generate(medicos.length, (index) {
                        var medico = medicos[index];
                        List<Unidade> unidadeslist = [];
                        Set<String> UnidadesInclusoIncluso = Set();

                        perfilDeAtendimento.items.map((e) {
                          if (e.cod_profissional == medico.cod_profissional)
                            unidadesDados.items.where((element) {
                              if (element.cod_unidade.contains(e.cod_unidade)) {
                                if (!UnidadesInclusoIncluso.contains(
                                    element.cod_unidade)) {
                                  UnidadesInclusoIncluso.add(
                                      element.cod_unidade);

                                  setState(() {
                                    unidadeslist.add(element);
                                  });
                                }

                                return true;
                              } else {
                                return false;
                              }
                            }).toList();
                        }).toList();

                        unidadeslist.sort(
                            (a, b) => a.des_unidade.compareTo(b.des_unidade));
                        return ListTile(
                          dense: true,
                          key: Key(medico.cod_profissional),
                          title: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      textResp(medicos[index].des_profissional),
                                      Text(' - '),
                                      Text(unidadeslist.length.toString(),
                                          style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold)),
                                      Text(' - '),
                                      IconButton(
                                          icon: Icon(
                                            _expanded_medico ==
                                                    medico.cod_profissional
                                                ? Icons.expand_less
                                                : Icons.expand_more,
                                          ),
                                          onPressed: () {
                                            if (_expanded_medico !=
                                                medico.cod_profissional) {
                                              setState(() {
                                                _expanded_medico =
                                                    medico.cod_profissional;
                                              });
                                            } else {
                                              setState(() {
                                                _expanded_medico = '';
                                              });
                                            }
                                          })
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          subtitle: _expanded_medico != medico.cod_profissional
                              ? SizedBox()
                              : Column(
                                  children: List.generate(unidadeslist.length,
                                      (index) {
                                    final Set<String> ConveniosInclusoIncluso =
                                        Set();
                                    final List<Convenios> convenioslist = [];

                                    var dados = perfilDeAtendimento.items
                                        .where((element) =>
                                            element.cod_profissional ==
                                            medico.cod_profissional)
                                        .toList()
                                        .where((unidade) {
                                      if (!ConveniosInclusoIncluso.contains(
                                          unidade.cod_convenio)) {
                                        ConveniosInclusoIncluso.add(
                                            unidade.cod_convenio);

                                        convenioslist.add(Convenios(
                                            cod_convenio: unidade.cod_convenio,
                                            desc_convenio:
                                                unidade.desc_convenio));
                                      }

                                      return unidade.cod_unidade ==
                                          unidadeslist[index].cod_unidade;
                                    }).toList();
                                    var unidade = unidadeslist[index];
                                    return Wrap(
                                      children: [
                                        ListTile(
                                          dense: true,
                                          key: Key(
                                              unidadeslist[index].cod_unidade),
                                          title: Wrap(
                                            crossAxisAlignment:
                                                WrapCrossAlignment.center,
                                            children: [
                                              Wrap(
                                                children: [
                                                  textResp(unidadeslist[index]
                                                          .des_unidade +
                                                      " - " +
                                                      unidadeslist[index]
                                                          .bairro
                                                          .capitalize() +
                                                      " - " +
                                                      unidadeslist[index]
                                                          .municipio),
                                                  IconButton(
                                                      icon: Icon(
                                                        _expanded_unidade ==
                                                                unidade
                                                                    .cod_unidade
                                                            ? Icons.expand_less
                                                            : Icons.expand_more,
                                                      ),
                                                      onPressed: () {
                                                        if (_expanded_unidade !=
                                                            unidadeslist[index]
                                                                .cod_unidade) {
                                                          setState(() {
                                                            _expanded_unidade =
                                                                unidadeslist[
                                                                        index]
                                                                    .cod_unidade;
                                                          });
                                                        } else {
                                                          setState(() {
                                                            _expanded_unidade =
                                                                '';
                                                          });
                                                        }
                                                      })
                                                ],
                                              ),
                                            ],
                                          ),
                                          //  visualDensity: VisualDensity.compact,
                                          // horizontalTitleGap:MediaQuery.of(context).size.width,
                                          // trailing: ,
                                          subtitle:
                                              _expanded_unidade !=
                                                      unidade.cod_unidade
                                                  ? SizedBox()
                                                  : Wrap(
                                                      crossAxisAlignment:
                                                          WrapCrossAlignment
                                                              .center,
                                                      children: List.generate(
                                                          convenioslist.length,
                                                          (index) {
                                                        Set<String>
                                                            ProcedimentosInclusoIncluso =
                                                            Set();
                                                        List<Procedimento>
                                                            ProcedimentosFiltrado =
                                                            [];
                                                        var conveio =
                                                            convenioslist[
                                                                index];
                                                        perfilDeAtendimento
                                                            .items
                                                            .where((e) {
                                                          if (e.cod_unidade ==
                                                                  unidade
                                                                      .cod_unidade &&
                                                              e.cod_convenio ==
                                                                  conveio
                                                                      .cod_convenio &&
                                                              e.cod_profissional ==
                                                                  medico
                                                                      .cod_profissional) {
                                                            if (!ProcedimentosInclusoIncluso
                                                                .contains(e
                                                                    .cod_procedimentos)) {
                                                              ProcedimentosInclusoIncluso
                                                                  .add(e
                                                                      .cod_procedimentos);

                                                              Procedimento p =
                                                                  Procedimento();

                                                              p.cod_procedimentos =
                                                                  e.cod_procedimentos;
                                                              p.des_procedimentos =
                                                                  e.des_procedimentos;
                                                              p.orientacoes =
                                                                  e.orientacoes;
                                                              p.valor_sugerido =
                                                                  double.parse(
                                                                      e.valor);
                                                              p.valor =
                                                                  double.parse(
                                                                      e.valor);
                                                              p.grupo = e.grupo;
                                                              p.frequencia =
                                                                  e.frequencia;
                                                              p.quantidade = e
                                                                  .tabop_quantidade;
                                                              p.especialidade
                                                                      .codespecialidade =
                                                                  e.cod_especialidade;
                                                              p.especialidade
                                                                      .descricao =
                                                                  e.des_especialidade;
                                                              p.cod_tratamento =
                                                                  e.cod_tratamento;
                                                              p.des_tratamento =
                                                                  e.tipo_tratamento;

                                                              ProcedimentosFiltrado
                                                                  .add(p);
                                                            }
                                                          }
                                                          return e.cod_unidade ==
                                                                  unidade
                                                                      .cod_unidade &&
                                                              e.cod_convenio ==
                                                                  conveio
                                                                      .cod_convenio;
                                                        }).toList();
                                                        return ListTile(
                                                          dense: true,
                                                          key: Key(convenioslist[
                                                                  index]
                                                              .cod_convenio),
                                                          title: Wrap(
                                                              crossAxisAlignment:
                                                                  WrapCrossAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                    convenioslist[
                                                                            index]
                                                                        .desc_convenio
                                                                        .capitalize(),
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            11,
                                                                        fontWeight:
                                                                            FontWeight.bold)),
                                                                Text(' - '),
                                                                Text(
                                                                    ProcedimentosFiltrado
                                                                        .length
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            11,
                                                                        fontWeight:
                                                                            FontWeight.bold)),
                                                                Text(' - '),
                                                                IconButton(
                                                                    icon: Icon(
                                                                      _expanded_unidade == unidade.cod_unidade && _expanded_conveio == conveio.cod_convenio
                                                                          ? Icons
                                                                              .expand_less
                                                                          : Icons
                                                                              .expand_more,
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      setState(
                                                                          () {
                                                                        if (_expanded_conveio !=
                                                                            conveio.cod_convenio) {
                                                                          _expanded_conveio =
                                                                              conveio.cod_convenio;
                                                                        } else {
                                                                          _expanded_conveio =
                                                                              '';
                                                                        }
                                                                      });
                                                                    })
                                                              ]),
                                                          subtitle: _expanded_unidade !=
                                                                      unidade
                                                                          .cod_unidade ||
                                                                  _expanded_conveio !=
                                                                      conveio
                                                                          .cod_convenio
                                                              ? Container()
                                                              : Wrap(
                                                                  crossAxisAlignment:
                                                                      WrapCrossAlignment
                                                                          .center,
                                                                  children: List.generate(
                                                                      ProcedimentosFiltrado
                                                                          .length,
                                                                      (index) {
                                                                    var procedimento =
                                                                        ProcedimentosFiltrado[
                                                                            index];
                                                                    return ListTile(
                                                                        dense:
                                                                            true,
                                                                        key: Key(procedimento
                                                                            .cod_procedimentos),
                                                                        tileColor:
                                                                            primaryColor[int.parse(unidade.cod_unidade) *
                                                                                50],
                                                                        title:
                                                                            Wrap(
                                                                          crossAxisAlignment:
                                                                              WrapCrossAlignment.center,
                                                                          children: [
                                                                            Text(ProcedimentosFiltrado[index].cod_procedimentos.capitalize() + " - " + ProcedimentosFiltrado[index].des_procedimentos.capitalize() + " - R\$ " + ProcedimentosFiltrado[index].valor.toString(),
                                                                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                                                                          ],
                                                                        ),
                                                                        trailing: IconButton(
                                                                            icon: Icon(Icons.more_vert),
                                                                            onPressed: () {
                                                                              Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                  builder: (context) => ConfirmaRegra(
                                                                                    procedimento: procedimento,
                                                                                    unidade: unidade,
                                                                                    conveio: conveio,
                                                                                    medico: medico,
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            }));
                                                                  }),
                                                                ),
                                                        );
                                                      }),
                                                    ),
                                        ),
                                      ],
                                    );
                                  }),
                                ),
                        );
                      }),
                    ),
                  SizedBox(height: defaultPadding),
                ],
              ),
            ),
    );
  }
}

const InputDecoration inputDecoration = InputDecoration(
  filled: true,
  fillColor: Colors.white,
  border: OutlineInputBorder(borderSide: BorderSide.none),
  enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
  focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
);
