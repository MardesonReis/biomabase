import 'package:biomaapp/models/AvailableDoctor.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/data_list.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/medicos.dart';
import 'package:biomaapp/models/unidade.dart';
import 'package:biomaapp/screens/doctors/components/doctor_details_screen.dart';
import 'package:biomaapp/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import 'rating.dart';

class AvailableDoctorCard extends StatefulWidget {
  const AvailableDoctorCard({
    Key? key,
    required this.medico,
  }) : super(key: key);

  final Medicos medico;

  @override
  State<AvailableDoctorCard> createState() => _AvailableDoctorCardState();
}

class _AvailableDoctorCardState extends State<AvailableDoctorCard> {
  @override
  Widget build(BuildContext context) {
    DataList Data = Provider.of(context, listen: false);
    //  final ImageLoadingBuilder? loadingBuilder;

    Auth auth = Provider.of(context);
    filtrosAtivos filtros = auth.filtrosativos;
    Set<String> MedicosInclusos = Set();

    Set<String> unidadesInclusoIncluso = Set();

    var ulist = Data.items
        .where((element) => element.crm == widget.medico.crm)
        .toList();
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
            doctor: widget.medico,
            press: () {
              setState(() {});
            },
          ),
        ),
      ).then((value) => {
            setState(() {}),
          }),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * (0.25),
        padding: EdgeInsets.all(defaultPadding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: SingleChildScrollView(
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dr(a) ' + widget.medico.des_profissional.capitalize(),
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  Text(
                    widget.medico.subespecialidade.capitalize(),
                    style: Theme.of(context).textTheme.caption,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: defaultPadding / 2),
                    child: Rating(score: 5),
                  ),
                  SizedBox(height: defaultPadding / 2),
                  Text(
                    "Locais de atendimento: ",
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  ...List.generate(
                    unidadeslist.length,
                    (index) => Text(
                      unidadeslist[index].des_unidade.capitalize(),
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ),
                  SizedBox(height: defaultPadding / 2),
                  Text(
                    "Limite de Idade",
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  Text(
                    ' ' +
                        widget.medico.idademin +
                        ' á ' +
                        widget.medico.idademax,
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
              Expanded(child: buildImgDoctor(widget.medico, context))
            ],
          ),
        ),
      ),
    );
  }
}
