import 'package:biomaapp/components/ProgressIndicatorBioma.dart';
import 'package:biomaapp/components/monoBino.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/Clips.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/convenios.dart';
import 'package:biomaapp/models/convenios_list.dart';
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
  var _isLoading = true;
  Convenios ConvenioSelecionado =
      Convenios(cod_convenio: '40', desc_convenio: 'REDE BIOCLINICA');
  @override
  void initState() {
    Auth auth = Provider.of<Auth>(
      context,
      listen: false,
    );
    ConveniosList conveniosList = Provider.of<ConveniosList>(
      context,
      listen: false,
    );
    conveniosList.items.isEmpty
        ? conveniosList.loadConvenios('').then((value) {
            setState(() {
              ConvenioSelecionado = conveniosList.items
                  .where((element) => element.cod_convenio == '40')
                  .toList()
                  .first;

              auth.filtrosativos.convenios.add(ConvenioSelecionado);
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
    ConveniosList convenioslist = Provider.of(context);
    filtrosAtivos filtros = auth.filtrosativos;

    List<Convenios> convenios = convenioslist.items;

    auth.filtrosativos.convenios.isEmpty
        ? () {
            setState(() {
              auth.filtrosativos.convenios.add(ConvenioSelecionado);
            });
          }.call()
        : true;

    return _isLoading
        ? Container(width: 50, child: ProgressIndicatorBioma())
        : PopupMenuButton<Convenios>(
            initialValue: ConvenioSelecionado,
            child: Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ConvenioSelecionado.desc_convenio == 'REDE BIOCLINICA'
                        ? Text('PARTICULAR')
                        : Text(ConvenioSelecionado.desc_convenio),
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
                    child: Column(
                      children: [
                        choice.desc_convenio == 'REDE BIOCLINICA'
                            ? Text('PARTICULAR')
                            : Text(choice.desc_convenio),
                      ],
                    ),
                  ),
                );
              }).toList();
            },
          );
  }
}
