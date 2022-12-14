import 'dart:math';

import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/Clips.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/convenios.dart';
import 'package:biomaapp/models/data.dart';
import 'package:biomaapp/models/data_list.dart';
import 'package:biomaapp/models/especialidade.dart';
import 'package:biomaapp/models/extrato_list.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/grupos.dart';
import 'package:biomaapp/models/medicos.dart';
import 'package:biomaapp/models/medicos_list.dart';
import 'package:biomaapp/models/paginas.dart';
import 'package:biomaapp/models/procedimento_list.dart';
import 'package:biomaapp/models/subEspecialidade.dart';
import 'package:biomaapp/models/unidade.dart';
import 'package:biomaapp/models/unidade.dart';
import 'package:biomaapp/models/unidades_list.dart';
import 'package:biomaapp/screens/search/components/menu_bar_convenios.dart';
import 'package:biomaapp/screens/search/components/menu_bar_especialidades.dart';
import 'package:biomaapp/screens/search/components/menu_bar_grupos.dart';
import 'package:biomaapp/screens/search/components/menu_bar_subespecialidade.dart';
import 'package:biomaapp/screens/search/components/menu_bar_unidades.dart';
import 'package:biomaapp/utils/app_routes.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FiltrosProcedimentos extends StatefulWidget {
  const FiltrosProcedimentos({Key? key}) : super(key: key);

  @override
  _FiltrosProcedimentosState createState() => _FiltrosProcedimentosState();
}

class _FiltrosProcedimentosState extends State<FiltrosProcedimentos> {
  bool _isLoading = true;
  bool i = false;
  String _unidade = '';

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
  Set<String> UnidadesInclusoIncluso = Set();
  Set<String> ConveniosInclusoIncluso = Set();
  Set<String> EspecialidadesInclusoIncluso = Set();
  Set<String> SubEspecialidadesInclusoIncluso = Set();
  Set<String> GruposInclusoIncluso = Set();
  List<Unidade> unidadeslist = [];
  List<Especialidade> especialidadeslist = [];
  List<SubEspecialidade> subespecialidadeslist = [];
  List<Grupo> gruposlist = [];
  List<Convenios> convenioslist = [];

  Set<String> gruposIncluso = Set();
  Set<String> unidadesIncluso = Set();
  Set<String> ConvenioIncluso = Set();
  Set<String> especialidadesIncluso = Set();
  int _currentFocusedIndex = 0;
// Define the fixed height for an item
  final double _height = 60;

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
    unlist.items.isEmpty
        ? unlist.loadUnidades('').then((value) {
            setState(() {
              _isLoading = false;
            });
          })
        : setState(() {
            _isLoading = false;
          });
    ;
  }

  @override
  Widget build(BuildContext context) {
    DataList Data = Provider.of(context, listen: false);
    Auth auth = Provider.of(context);
    UnidadesList unidadesDados = Provider.of(context);

    filtrosAtivos filtros = auth.filtrosativos;
    filtros.BuscarFiltrosAtivos();
    Paginas pages = auth.paginas;

    // print(Data.items.length);
    //unidadeslist = unidadesDados.items;
    Data.items
        .map((e) => unidadesDados.items.where((element) {
              if (element.cod_unidade.contains(e.cod_unidade)) {
                if (!UnidadesInclusoIncluso.contains(element.cod_unidade)) {
                  UnidadesInclusoIncluso.add(element.cod_unidade);

                  setState(() {
                    unidadeslist.add(element);
                  });
                }
                return true;
              } else {
                return false;
              }
            }).toList())
        .toList();
    Data.items.map((e) async {
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

    especialidadeslist.sort((a, b) => a.descricao.compareTo(b.descricao));
    unidadeslist.sort((a, b) => a.des_unidade.compareTo(b.des_unidade));
    convenioslist.sort((a, b) => a.desc_convenio.compareTo(b.desc_convenio));
    gruposlist.sort((a, b) => a.descricao.compareTo(b.descricao));
    subespecialidadeslist.sort((a, b) => a.descricao.compareTo(b.descricao));

    return SafeArea(
      maintainBottomViewPadding: true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(),
          Center(
            child: Text(
              'Filtrar especialistas por:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Card(
            elevation: 8,
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Locais de Atendimento?',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      MenuBarUnidades(unidadeslist, () {
                        setState(() {});
                      }),
                    ],
                  ),
          ),
          Card(
            elevation: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Especialidade: ',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                MenuBarEspecialidades(especialidadeslist, () {
                  setState(() {});
                }),
              ],
            ),
          ),
          Card(
            elevation: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Subespecialidade: ',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                MenuBarSubEspecialidades(subespecialidadeslist, () {
                  setState(() {});
                }),
              ],
            ),
          ),
          Card(
            elevation: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Conv??nios: ',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                MenuBarConvenios(convenioslist, () {
                  setState(() {});
                }),
              ],
            ),
          ),
          Card(
            elevation: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Tipo de Procedimentos:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                MenuBarGrupos(gruposlist, () {
                  setState(() {});
                }),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              filtros.FiltrosAtivos > 0
                  ? ElevatedButton(
                      onPressed: () => setState(() {
                        filtros.LimparTodosFiltros();
                        Navigator.of(context).pushReplacementNamed(
                          AppRoutes.AUTH_OR_HOME,
                        );
                      }),
                      child: const Text('Limpar Filtros'),
                    )
                  : Text(''),
              Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        Navigator.of(context).pushReplacementNamed(
                          AppRoutes.AUTH_OR_HOME,
                        );
                      });
                    },
                    child: Text('Filtrar')),
              ),
            ],
          )
        ],
      ),
    );
  }
}
