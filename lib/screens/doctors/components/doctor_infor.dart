import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/medicos.dart';
import 'package:biomaapp/models/regras_list.dart';
import 'package:biomaapp/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DoctorInfor extends StatefulWidget {
  Medicos doctor;
  VoidCallback press;

  DoctorInfor({Key? key, required this.doctor, required this.press})
      : super(key: key);

  @override
  State<DoctorInfor> createState() => _DoctorInforState();
}

class _DoctorInforState extends State<DoctorInfor> {
  bool isError = false;

  @override
  Widget build(BuildContext context) {
    RegrasList dt = Provider.of(context);

    Auth auth = Provider.of(context);

    filtrosAtivos filtros = auth.filtrosativos;

    return Card(
      elevation: 8,
      child: ListTile(
        onTap: () {
          setState(() {
            filtros.LimparMedicos();
            filtros.addMedicos(widget.doctor);
            widget.press.call();
          });
        },
        leading: CircleAvatar(
          //   backgroundColor: primaryColor,
          //   foregroundColor: Colors.black,
          backgroundImage: NetworkImage(
            Constants.IMG_BASE_URL + 'medicos/' + widget.doctor.crm + '.png',
          ),
          radius: 25.0,
          onBackgroundImageError: (_, __) {
            setState(() {
              isError = true;
            });
          },
          child: isError == true
              ? Text(widget.doctor.des_profissional.isNotEmpty
                  ? widget.doctor.des_profissional[0]
                  : '')
              : SizedBox(),
        ),
        title: textResp('Dr(a) ' + widget.doctor.des_profissional),
        subtitle: textResp(widget.doctor.especialidade.des_especialidade),
      ),
    );
  }
}
