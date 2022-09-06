import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/Clips.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/convenios.dart';
import 'package:biomaapp/models/especialidade.dart';
import 'package:biomaapp/models/especialidades_list.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ConveniosCard extends StatefulWidget {
  ConveniosCard({
    Key? key,
    required this.conv,
    required this.press,
  }) : super(key: key);

  final Convenios conv;
  final VoidCallback press;
  VoidCallback fun = () {};

  @override
  State<ConveniosCard> createState() => _ConveniosCardState();
}

class _ConveniosCardState extends State<ConveniosCard> {
  @override
  Widget build(BuildContext context) {
    EspecialidadesList especialidades = Provider.of(context, listen: false);
    Auth auth = Provider.of(context);
    filtrosAtivos filtros = auth.filtrosativos;

    widget.fun = () {
      setState(() {
        filtros.convenios.contains(widget.conv)
            ? filtros.removerConvenios(widget.conv)
            : filtros.addConvenios(widget.conv);
      });
      widget.press.call();
    };
    return Padding(
      padding: const EdgeInsets.only(left: defaultPadding),
      child: InkWell(
        onTap: widget.fun,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: Container(
          padding: EdgeInsets.all(defaultPadding / 2),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: filtros.convenios.contains(widget.conv)
                  ? Color.fromARGB(255, 73, 108, 223)
                  : Color.fromARGB(255, 191, 197, 238)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.conv.desc_convenio.capitalize(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
