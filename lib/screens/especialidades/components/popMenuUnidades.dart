import 'package:biomaapp/components/monoBino.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/Clips.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/data_list.dart';
import 'package:biomaapp/models/especialidade.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/procedimento.dart';
import 'package:biomaapp/models/unidade.dart';
import 'package:biomaapp/models/unidades_list.dart';
import 'package:biomaapp/screens/home/components/acordionExemplo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PopoMenuUnidades extends StatefulWidget {
  final VoidCallback press;
  PopoMenuUnidades(this.press);
  @override
  State<PopoMenuUnidades> createState() => _PopoMenuUnidadesState();
}

class _PopoMenuUnidadesState extends State<PopoMenuUnidades> {
  ScrollController OlhoScrollController = ScrollController();
  bool _isLoading = false;

  Unidade Unidades_selecionada =
      Unidade(cod_unidade: '00', des_unidade: 'Unidades');
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
    var verifprocedimento = false;
    Auth auth = Provider.of(context);
    filtrosAtivos filtros = auth.filtrosativos;
    DataList dt = Provider.of(context, listen: false);
    UnidadesList DataUnidades = Provider.of(context);
    Set<String> UnidadesIncluso = Set();

    Set<String> MedicosInclusos = Set();
    Set<String> EspecialidadesInclusas = Set();

    mockResults = auth.filtrosativos.medicos;

    List<Especialidade> especialidades = [];
    var filtrarUnidade = filtros.unidades.isNotEmpty;
    var filtrarConvenio = filtros.convenios.isNotEmpty;
    var filtrarEspecialidade = filtros.especialidades.isNotEmpty;
    var filtrarGrupos = filtros.grupos.isNotEmpty;
    var filtrarSubEspecialidade = filtros.subespecialidades.isNotEmpty;
    final dados = dt.items;
    List<Unidade> unidades = [];

    dados
        .map((e) => DataUnidades.items.where((element) {
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

    unidades.sort((a, b) => a.des_unidade.compareTo(b.des_unidade));

    Unidade uniPadrao = Unidade(cod_unidade: '00', des_unidade: 'Unidades');
    unidades.contains(uniPadrao)
        ? false
        : setState(() {
            unidades.add(uniPadrao);
          });
    bildeUnidadeinf(Unidade u) {
      return u.des_unidade.capitalize() +
          ' \n' +
          u.bairro.capitalize() +
          ' - ' +
          u.municipio.capitalize();
    }

    var uniatual = filtros.unidades.isNotEmpty
        ? filtros.unidades.first
        : Unidades_selecionada;

    filtros.unidades.isEmpty ? Unidades_selecionada = uniPadrao : true;
    return unidades.isEmpty
        ? CircularProgressIndicator()
        : PopupMenuButton<Unidade>(
            initialValue: filtros.unidades.isNotEmpty
                ? filtros.unidades.first
                : Unidades_selecionada,
            child: Card(
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(uniatual.cod_unidade != '00'
                            ? (bildeUnidadeinf(uniatual))
                            : uniatual.des_unidade),
                        Icon(
                          Icons.expand_more_outlined,
                          color: primaryColor,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            onSelected: (value) {
              setState(() {
                filtros.LimparEspecialidades();
                filtros.LimparSubEspecialidades();
                filtros.LimparGrupos();
                filtros.LimparUnidade();
                if (value.cod_unidade != '00') {
                  filtros.addunidades(value);
                }
                Unidades_selecionada = value;
                widget.press.call();
              });
            },
            itemBuilder: (BuildContext context) {
              return unidades.map((Unidade choice) {
                return PopupMenuItem<Unidade>(
                  value: choice,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(choice.cod_unidade != '00'
                        ? (bildeUnidadeinf(choice))
                        : choice.des_unidade),
                  ),
                );
              }).toList();
            },
          );
  }
}
