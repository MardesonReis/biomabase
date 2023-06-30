import 'package:biomaapp/components/ProgressIndicatorBioma.dart';
import 'package:biomaapp/components/monoBino.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/Clips.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/convenios.dart';
import 'package:biomaapp/models/data_list.dart';
import 'package:biomaapp/models/especialidade.dart';
import 'package:biomaapp/models/especialidades_list.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/procedimento.dart';
import 'package:biomaapp/models/regras_list.dart';
import 'package:biomaapp/models/subEspecialidade.dart';
import 'package:biomaapp/screens/home/components/acordionExemplo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PopMenuEspecialidade extends StatefulWidget {
  final VoidCallback press;
  PopMenuEspecialidade(this.press);
  @override
  State<PopMenuEspecialidade> createState() => _PopMenuEspecialidadeState();
}

class _PopMenuEspecialidadeState extends State<PopMenuEspecialidade> {
  var _isLoading = true;
  late Especialidade especialidadeSelecionado;
  @override
  void initState() {
    Auth auth = Provider.of<Auth>(
      context,
      listen: false,
    );
    EspecialidadesList conveniosList = Provider.of<EspecialidadesList>(
      context,
      listen: false,
    );
    conveniosList.items.isEmpty
        ? conveniosList.loadEspecialidade('').then((value) {
            setState(() {
              especialidadeSelecionado = conveniosList.items
                  .where((element) => element.codespecialidade == '1')
                  .toList()
                  .first;

              auth.filtrosativos.especialidades.add(especialidadeSelecionado);
              _isLoading = false;
            });
          })
        : setState(() {
            _isLoading = false;
          });
  }

  ScrollController OlhoScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    var verifprocedimento = false;
    Auth auth = Provider.of(context);
    EspecialidadesList especialidadeListe = Provider.of(context);
    filtrosAtivos filtros = auth.filtrosativos;

    Set<String> MedicosInclusos = Set();
    Set<String> EspecialidadesInclusas = Set();

    mockResults = auth.filtrosativos.medicos;

    List<Especialidade> especialidades = especialidadeListe.items;

    var filtrarEspecialidade = filtros.especialidades.isNotEmpty;

    Especialidade allEsp = Especialidade(
        codespecialidade: '00', descricao: 'Especialidades', ativo: '');
    especialidades.contains(allEsp)
        ? false
        : setState(() {
            especialidades.add(allEsp);
          });
    filtros.especialidades.isEmpty ? especialidadeSelecionado = allEsp : true;

    return _isLoading
        ? Container(width: 50, child: ProgressIndicatorBioma())
        : PopupMenuButton<Especialidade>(
            initialValue: filtros.especialidades.isNotEmpty
                ? filtros.especialidades.first
                : especialidadeSelecionado,
            child: Card(
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(filtros.especialidades.isNotEmpty
                        ? filtros.especialidades.first.descricao
                        : especialidadeSelecionado.descricao),
                    Icon(
                      Icons.expand_more_outlined,
                      color: primaryColor,
                    )
                  ],
                ),
              ),
            ),
            onSelected: (value) {
              setState(() async {
                await filtros.LimparEspecialidades();
                await filtros.LimparSubEspecialidades();
                await filtros.LimparGrupos();
                if (value.codespecialidade != '00') {
                  await filtros.addEspacialidades(value);
                }
                especialidadeSelecionado = value;
                widget.press.call();
              });
            },
            itemBuilder: (BuildContext context) {
              return especialidades.map((Especialidade choice) {
                return PopupMenuItem<Especialidade>(
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
