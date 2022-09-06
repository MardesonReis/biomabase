import 'package:biomaapp/components/custom_app_bar.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/medicos.dart';
import 'package:biomaapp/utils/app_routes.dart';
import 'package:biomaapp/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MeuBioma extends StatefulWidget {
  const MeuBioma({Key? key}) : super(key: key);

  @override
  State<MeuBioma> createState() => _MeuBiomaState();
}

class _MeuBiomaState extends State<MeuBioma> {
  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: () => Navigator.of(context).pushNamed(
              AppRoutes.EXTRATO_FIDELIMAX,
              //    arguments: auth.fidelimax,
            ),
            child: buildIndicadores("Bions", auth.fidelimax.saldo.toString()),
          ),
          InkWell(
            onTap: () => {},
            child: buildIndicadores("Amigos", '0'),
          ),
          InkWell(
            onTap: () => Navigator.of(context).pushNamed(
              AppRoutes.EXTRATO_FIDELIMAX,
              //    arguments: auth.fidelimax,
            ),
            child: buildIndicadores("Indicadores", '0'),
          ),
        ],
      ),
    );
  }
}
