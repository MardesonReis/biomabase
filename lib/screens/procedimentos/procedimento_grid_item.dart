import 'dart:developer';

import 'package:biomaapp/components/monoBino.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/Clips.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/medicos.dart';
import 'package:biomaapp/models/procedimento.dart';
import 'package:biomaapp/screens/appointment/componets/indicar.dart';
import 'package:biomaapp/screens/appointment/appointment_screen.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/cart.dart';
import 'package:biomaapp/models/product.dart';
import 'package:biomaapp/utils/app_routes.dart';

class ProcedimentoGridItem extends StatefulWidget {
  Procedimento procedimentos;
  Medicos doctor;
  VoidCallback press;
  ProcedimentoGridItem(this.doctor, this.procedimentos, this.press);

  @override
  State<ProcedimentoGridItem> createState() => _ProcedimentoGridItemState();
}

class _ProcedimentoGridItemState extends State<ProcedimentoGridItem> {
  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    filtrosAtivos filtros = auth.filtrosativos;

    int _value = 0;

    return InkWell(
      onTap: () {
        setState(() {
          filtros.LimparProcedimentos();
          filtros.AddProcedimentos(widget.procedimentos);

          widget.press.call();
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AppointmentScreen(
              press: () {
                setState(() {});
              },
            ),
          ),
        ).then((value) => {
              setState(() {
                widget.press.call();
              }),
            });
      },
      child: Card(
        color: primaryColor,
        borderOnForeground: true,
        elevation: 8,
        child: SizedBox(
          child: GridTile(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    direction: Axis.vertical,
                    children: [
                      textResp(widget.procedimentos.des_procedimentos),
                      SizedBox(
                        height: 20,
                      ),
                      textResp(widget.procedimentos.convenio.desc_convenio),
                    ],
                  ),
                ),
                Divider(
                  height: 40,
                )
              ],
            ),
            footer: Container(
              child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: GridTileBar(
                    backgroundColor: Colors.white,
                    // leading: s,
                    title: Text(
                      'R\$ ' + widget.procedimentos.valor_sugerido.toString(),
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    trailing: Wrap(
                      children: [
                        textResp(widget.procedimentos.orientacoes),
                      ],
                    ),
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
