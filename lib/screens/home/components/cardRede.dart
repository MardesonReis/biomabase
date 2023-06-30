import 'package:biomaapp/components/rating.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/data_list.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/medicos.dart';
import 'package:biomaapp/models/redebioma.dart';
import 'package:biomaapp/models/regras_list.dart';
import 'package:biomaapp/models/unidade.dart';
import 'package:biomaapp/screens/appointment/appointment_screen.dart';
import 'package:biomaapp/screens/doctors/components/doctor_details_screen.dart';
import 'package:biomaapp/screens/home/components/redebiomadetalhes.dart';
import 'package:biomaapp/utils/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../models/RecommendDoctor.dart';

class CardRede extends StatefulWidget {
  const CardRede({
    Key? key,
    required this.Redeitem,
  }) : super(key: key);

  final RedeBioma Redeitem;

  @override
  State<CardRede> createState() => _CardRedeState();
}

class _CardRedeState extends State<CardRede> {
  @override
  Widget build(BuildContext context) {
    RegrasList dt = Provider.of(context, listen: false);
    //  final ImageLoadingBuilder? loadingBuilder;

    Auth auth = Provider.of(context);

    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RedeBiomaDetalhes(Redeitem: widget.Redeitem),
        ),
      ).then((value) => {}),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ListTile(
                  dense: true,
                  title: Text(
                    widget.Redeitem.titulo,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: tela(context).width * 0.04),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.Redeitem.subtitulo,
                        style: TextStyle(fontSize: tela(context).width * 0.035),
                      ),
                      Container(
                        color: destColor,
                        child: Text(
                          widget.Redeitem.destaque,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: tela(context).width * 0.03),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: defaultPadding / 2),
                        child: Rating(score: 5),
                      ),
                    ],
                  ),
                  trailing: buildImg(
                      'https://bioma.app.br/imagens/redebioma/' +
                          widget.Redeitem.img_logo,
                      context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
