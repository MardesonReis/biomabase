import 'dart:async';

import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/Clips.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/procedimento.dart';
import 'package:biomaapp/models/unidade.dart';
import 'package:biomaapp/models/unidades_list.dart';
import 'package:biomaapp/screens/home/components/acordionExemplo.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class InforUnidade extends StatefulWidget {
  final Unidade unidade;
  final VoidCallback press;
  InforUnidade(this.unidade, this.press);
  @override
  State<InforUnidade> createState() => _InforUnidadeState();
}

class _InforUnidadeState extends State<InforUnidade> {
  bool _isLoading = true;
  Unidade Uninf = Unidade();

  @override
  void initState() {
    super.initState();

    UnidadesList ListUnidade = Provider.of<UnidadesList>(
      context,
      listen: false,
    );
    ListUnidade.items.isEmpty
        ? ListUnidade.loadUnidades('').then((value) {
            setState(() {
              _isLoading = false;
            });
          })
        : setState(() {
            _isLoading = false;
          });
  }

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    filtrosAtivos filtros = auth.filtrosativos;
    UnidadesList unidades = Provider.of(context);

    var unidade = unidades.items
        .where((element) => element.cod_unidade == widget.unidade.cod_unidade)
        .toList()
        .first;

    getDistance(unidade.latitude, unidade.longitude).then((value) {
      unidade.distancia = value;
    });

    //var unidade = widget.unidade;

    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Card(
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                  onTap: () {
                    setState(() {
                      widget.press.call();
                    });
                  },
                  leading: CircleAvatar(
                      //  backgroundColor: primaryColor,
                      // foregroundColor: Colors.black,
                      radius: 30,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          distanciaValida(unidade.distancia)
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      (unidade.distancia
                                          .toStringAsPrecision(2)),
                                      style: TextStyle(fontSize: 10),
                                    ),
                                    Text('Km', style: TextStyle(fontSize: 10)),
                                  ],
                                )
                              : Icon(
                                  Icons.location_on_sharp,
                                  size: 15,
                                  color: primaryColor,
                                )
                        ],
                      )),
                  title: Text(
                    unidade.des_unidade.capitalize(),
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  trailing: IconButton(
                      onPressed: () {
                        gotoLocation(unidade.latitude, unidade.longitude,
                            filtros.googleMapController);
                      },
                      icon: distanciaValida(unidade.distancia)
                          ? Icon(
                              Icons.navigation,
                              color: primaryColor,
                            )
                          : Icon(
                              Icons.navigation_outlined,
                            )),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        unidade.logradouro.capitalize() +
                            ',  ' +
                            unidade.numero.capitalize(),
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      Text(
                        unidade.bairro.capitalize() +
                            ',  ' +
                            unidade.municipio.capitalize(),
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ],
                  )
                  // trailing: Text(widget.procedimento.valor.toString()),
                  ),
            ),
          );
  }
}
