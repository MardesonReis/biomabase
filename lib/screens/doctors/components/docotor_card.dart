import 'package:biomaapp/models/AvailableDoctor.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/convenios.dart';
import 'package:biomaapp/models/data_list.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/medicos.dart';
import 'package:biomaapp/models/medicos_list.dart';
import 'package:biomaapp/models/unidade.dart';
import 'package:biomaapp/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../../constants.dart';

class DoctorCard extends StatefulWidget {
  const DoctorCard({
    Key? key,
    required this.doctor,
    required this.press,
  }) : super(key: key);

  final Medicos doctor;
  final VoidCallback press;

  @override
  State<DoctorCard> createState() => _DoctorCardState();
}

class _DoctorCardState extends State<DoctorCard> {
  @override
  Widget build(BuildContext context) {
    DataList Data = Provider.of(context, listen: false);
    final AutoScrollController controllerUnidades = AutoScrollController();
    //  final ImageLoadingBuilder? loadingBuilder;

    Auth auth = Provider.of(context);
    filtrosAtivos filtros = auth.filtrosativos;
    Set<String> MedicosInclusos = Set();

    Set<String> unidadesInclusoIncluso = Set();

    var ulist = Data.items
        .where((element) => element.crm == widget.doctor.crm)
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
    //print(DadosMedicos.length);

    return GestureDetector(
      onTap: widget.press,
      child: Card(
        elevation: 8,
        child: Container(
          padding: EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dr(a) ' + widget.doctor.des_profissional.capitalize(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    Text(
                      widget.doctor.subespecialidade.capitalize(),
                      style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    Spacer(),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  child: buildImgDoctor(widget.doctor, context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
