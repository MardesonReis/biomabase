import 'package:biomaapp/components/custom_app_bar.dart';
import 'package:biomaapp/components/infor_unidade.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/unidades_list.dart';
import 'package:biomaapp/screens/servicos/componets/localizacao.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class BuildLocalizacao extends StatefulWidget {
  VoidCallback press;
  VoidCallback refreshPage;

  BuildLocalizacao({Key? key, required this.press, required this.refreshPage})
      : super(key: key);

  @override
  State<BuildLocalizacao> createState() => _BuildLocalizacaoState();
}

class _BuildLocalizacaoState extends State<BuildLocalizacao> {
  bool _isLoadUnidades = true;

  @override
  void initState() {
    // if (!mounted) return;

    super.initState();

    var unlist = Provider.of<UnidadesList>(
      context,
      listen: false,
    );
    unlist.items.isEmpty
        ? unlist.loadUnidades('').then((value) {
            setState(() {
              _isLoadUnidades = false;
            });
          })
        : setState(() {
            _isLoadUnidades = false;
          });
  }

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    filtrosAtivos filtros = auth.filtrosativos;
    UnidadesList BaseUnidades = Provider.of(context);

    return _isLoadUnidades
        ? CircularProgressIndicator()
        : Scaffold(
            floatingActionButton: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Visibility(
                    visible: filtros.unidades.isEmpty,
                    child: FloatingActionButton.extended(
                      onPressed: () {
                        setState(() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Localizacao(
                                press: () {
                                  setState(() {
                                    Navigator.pop(context);
                                  });
                                },
                              ),
                            ),
                          ).then((value) => {
                                setState(() {
                                  widget.refreshPage.call();
                                }),
                              });
                        });
                      },
                      label: Text('Clique para informar'),
                      backgroundColor: primaryColor,
                      icon: Icon(Icons.location_on),
                    ),
                  ),
                  Visibility(
                    visible: filtros.unidades.isNotEmpty,
                    child: FloatingActionButton.extended(
                      onPressed: () {
                        setState(() {
                          widget.press.call();
                        });
                        widget.press.call();
                      },
                      label: Text('Continuar'),
                      backgroundColor: primaryColor,
                      icon: Icon(Icons.navigate_next),
                    ),
                  ),
                ],
              ),
            ),
            body: Column(
              children: [
                Center(
                  child: Text(
                    'Selecione um local para atendimento',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                filtros.unidades.isNotEmpty
                    ? Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InforUnidade(
                                filtros.unidades.isNotEmpty
                                    ? filtros.unidades.first
                                    : BaseUnidades.items.first,
                                () {
                                  setState(() {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Localizacao(
                                          press: () {
                                            setState(() {
                                              Navigator.pop(context);
                                            });
                                          },
                                        ),
                                      ),
                                    ).then((value) => {
                                          setState(() {
                                            widget.refreshPage.call();
                                          }),
                                        });
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      )
                    : SizedBox()
              ],
            ),
          );
  }
}
