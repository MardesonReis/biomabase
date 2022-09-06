import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/screens/auth/auth_or_home_page.dart';
import 'package:biomaapp/screens/doctors/components/Doctor_Circle.dart';
import 'package:biomaapp/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';

class Filtro_Flutuantes extends StatefulWidget {
  const Filtro_Flutuantes({Key? key}) : super(key: key);

  @override
  State<Filtro_Flutuantes> createState() => _Filtro_FlutuantesState();
}

class _Filtro_FlutuantesState extends State<Filtro_Flutuantes> {
  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    filtrosAtivos filtros = auth.filtrosativos;
    var isError;
    return SpeedDial(
        children: filtros.medicos.map((e) {
      return SpeedDialChild(
        label: e.des_profissional.capitalize(),
        // visible: filtros.medicos.contains(e),
        child: CircleAvatar(
          //   backgroundColor: primaryColor,
          //   foregroundColor: Colors.black,
          backgroundImage: NetworkImage(
            Constants.IMG_BASE_URL + 'medicos/' + e.crm + '.png',
          ),
          radius: 25.0,
          onBackgroundImageError: (_, __) {
            setState(() {
              isError = true;
            });
          },
          child: isError == true ? Text(e.des_profissional[0]) : SizedBox(),
        ),
        onTap: () {
          var conf = AlertShowDialog('Remover Filtro: ',
              'Especialista: ' + e.des_profissional, context);
          if (conf == true) {
            // ignore: curly_braces_in_flow_control_structures
            setState(() {
              filtros.medicos.contains(e)
                  ? filtros.removerMedico(e)
                  : filtros.addMedicos(e);
              //widget.press.call();
            });
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AuthOrHomePage(),
              ),
            );
          }
        },
      );
    }).toList());
  }
}
