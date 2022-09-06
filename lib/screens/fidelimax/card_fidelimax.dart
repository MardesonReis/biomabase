import 'package:biomaapp/components/custom_app_bar.dart';
import 'package:biomaapp/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/fidelimax.dart';
import 'package:biomaapp/utils/app_routes.dart';

class CardFidelimax extends StatefulWidget {
  @override
  State<CardFidelimax> createState() => _CardFidelimaxState();
}

class _CardFidelimaxState extends State<CardFidelimax> {
  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    // auth.fidelimax.ConsultaConsumidor();
    return Column(
      children: [
        Card(
          elevation: 8,
          margin: EdgeInsets.all(3),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.amber,
                    child: Text(auth.fidelimax.saldo.toString()),
                  ),
                  title: Text('Bions'),
                  subtitle: Row(
                    children: [
                      Expanded(
                        child: buildAppointmentInfo("Indicações", '0'),
                      )
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    child: const Text('Extrato'),
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        AppRoutes.EXTRATO_FIDELIMAX,
                        //    arguments: auth.fidelimax,
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    child: const Text('Resgatar Pontos'),
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        AppRoutes.BuscaParceiro,
                        //    arguments: auth.fidelimax,
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
