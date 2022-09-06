import 'package:biomaapp/models/Clips.dart';
import 'package:biomaapp/models/SearchDoctor.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/unidade.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:biomaapp/models/SearchDoctor.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';

class dialogUnidades extends StatefulWidget {
  dialogUnidades({
    Key? key,
    required this.info,
    required this.press,
  }) : super(key: key);

  final Unidade info;
  final Function press;

  @override
  State<dialogUnidades> createState() => _dialogUnidadesState();
}

class _dialogUnidadesState extends State<dialogUnidades> {
  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);

    filtrosAtivos filtros = auth.filtrosativos;

    return ListTile(
      dense: true,
      tileColor: filtros.unidades.contains(widget.info)
          ? Color.fromARGB(255, 207, 226, 241)
          : null,
      // autofocus: filtros.unidades.contains(clip),
      //selected: filtros.unidades.contains(clip),
      onTap: () => {
        setState(() {
          filtros.unidades.contains(widget.info)
              ? filtros.removerUnidades(widget.info)
              : filtros.addunidades(widget.info);
        }),
      },
      contentPadding: EdgeInsets.all(defaultPadding),
      leading: AspectRatio(
          aspectRatio: 0.85,
          child: CircleAvatar(
              child: Text(
            widget.info.des_unidade[0],
            style: Theme.of(context)
                .textTheme
                .caption!
                .copyWith(fontWeight: FontWeight.w900, fontSize: 20),
          ))),
      title: Row(
        children: [
          Text(
            widget.info.des_unidade,
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding / 4),
            child: Expanded(
              child: Row(
                children: [
                  Icon(Icons.wrong_location_outlined,
                      size: 15.0, color: Colors.blue),
                  Text(
                    ' Rua: ' +
                        (widget.info.des_unidade +
                                ', ' +
                                widget.info.des_unidade)
                            .capitalize(),
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              Icon(Icons.alarm, size: 15.0, color: Colors.blue),
              Text(
                ' 07:30 – 17:30',
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(fontWeight: FontWeight.w600),
              )
            ],
          ),
          Row(
            children: [
              Icon(Icons.call, size: 15.0, color: Colors.blue),
              Text(
                ' (85) 3033-2323',
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(fontWeight: FontWeight.w600),
              )
            ],
          ),
        ],
      ),
    );
  }
}
