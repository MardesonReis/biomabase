import 'package:biomaapp/components/rating.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/data_list.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/medicos.dart';
import 'package:biomaapp/models/regras_list.dart';
import 'package:biomaapp/models/unidade.dart';
import 'package:biomaapp/screens/appointment/appointment_screen.dart';
import 'package:biomaapp/screens/doctors/components/doctor_details_screen.dart';
import 'package:biomaapp/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../models/RecommendDoctor.dart';

class RecommendDoctorCard extends StatefulWidget {
  const RecommendDoctorCard({
    Key? key,
    required this.doctor,
  }) : super(key: key);

  final Medicos doctor;

  @override
  State<RecommendDoctorCard> createState() => _RecommendDoctorCardState();
}

class _RecommendDoctorCardState extends State<RecommendDoctorCard> {
  @override
  Widget build(BuildContext context) {
    RegrasList dt = Provider.of(context, listen: false);
    //  final ImageLoadingBuilder? loadingBuilder;

    Auth auth = Provider.of(context);
    filtrosAtivos filtros = auth.filtrosativos;
    Set<String> MedicosInclusos = Set();

    Set<String> unidadesInclusoIncluso = Set();

    var ulist =
        dt.dados.where((element) => element.crm == widget.doctor.crm).toList();
    List<Unidade> unidadeslist = [];
    ulist.map((e) {
      if (!unidadesInclusoIncluso.contains(e.cod_unidade)) {
        unidadesInclusoIncluso.add(e.cod_unidade);
        unidadeslist.add(
            Unidade(cod_unidade: e.cod_unidade, des_unidade: e.des_unidade));
      } else {
        return false;
      }
    }).toList();
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DoctorDetailsScreen(
            doctor: widget.doctor,
            press: () {
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
                    setState(() {}),
                  });
            },
          ),
        ),
      ).then((value) => {
            setState(() {}),
          }),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: const BorderRadius.all(Radius.circular(defaultPadding)),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius:
                const BorderRadius.all(Radius.circular(defaultPadding)),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Dr(a) " +
                              widget.doctor.des_profissional.capitalize(),
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                        Text(
                          widget.doctor.subespecialidade.capitalize(),
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: defaultPadding / 2),
                      child: Rating(score: 5),
                    ),
                    Text(
                      "Limite de Idade",
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                    Text(
                      ' ' +
                          widget.doctor.idademin +
                          ' á ' +
                          widget.doctor.idademax,
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
                Expanded(child: buildImgDoctor(widget.doctor, context)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
