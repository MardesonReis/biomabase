import 'package:biomaapp/components/custom_app_bar.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/fidelimax.dart';
import 'package:biomaapp/models/medicos.dart';
import 'package:biomaapp/utils/app_routes.dart';
import 'package:biomaapp/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DadosInfor extends StatefulWidget {
  const DadosInfor({Key? key}) : super(key: key);

  @override
  State<DadosInfor> createState() => _DadosInforState();
}

class _DadosInforState extends State<DadosInfor> {
  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    Fidelimax fidelimax = auth.fidelimax;
    return Row(
      children: [
        Expanded(
          child: buildInfo("Sexo", fidelimax.sexo,
              Icon(fidelimax.sexo == 'Masculino' ? Icons.male : Icons.female)),
        ),
        Expanded(
          child: buildInfo(
              "Telefone", fidelimax.telefone, Icon(Icons.settings_cell_sharp)),
        ),
        Expanded(
          child: buildInfo(
              "Data de Nascimento",
              DateFormat('dd/MM/yyyy')
                  .format(DateTime.parse(fidelimax.dataNascimento)),
              Icon(Icons.cake_outlined)),
        ),
      ],
    );
  }
}
