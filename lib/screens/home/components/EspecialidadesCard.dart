import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/Clips.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/especialidade.dart';
import 'package:biomaapp/models/especialidades_list.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/regras_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class EspecialidadesCard extends StatefulWidget {
  EspecialidadesCard({
    Key? key,
    required this.esp,
    required this.press,
  }) : super(key: key);

  final Especialidade esp;
  final VoidCallback press;
  VoidCallback fun = () {};

  @override
  State<EspecialidadesCard> createState() => _EspecialidadesCardState();
}

class _EspecialidadesCardState extends State<EspecialidadesCard> {
  @override
  Widget build(BuildContext context) {
    EspecialidadesList especialidades = Provider.of(context, listen: false);
    RegrasList dt = Provider.of(context, listen: false);
    Auth auth = Provider.of(context);
    filtrosAtivos filtros = auth.filtrosativos;

    widget.fun = () {
      setState(() {
        dt.limparDados();
        filtros.LimparEspecialidades();
        filtros.especialidades.contains(widget.esp)
            ? filtros.removerEspacialidades(widget.esp)
            : filtros.addEspacialidades(widget.esp);
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
          height: 90,
          width: 90,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: filtros.especialidades.contains(widget.esp)
                  ? Color.fromARGB(255, 73, 108, 223)
                  : Color.fromARGB(255, 191, 197, 238)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/icons/' + widget.esp.descricao + '.svg'),
              SizedBox(height: defaultPadding / 2),
              Text(
                widget.esp.descricao.capitalize(),
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
