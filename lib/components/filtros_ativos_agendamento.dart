import 'package:biomaapp/components/infor_unidade.dart';
import 'package:biomaapp/components/monoBino.dart';
import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/filtrosAtivos.dart';
import 'package:biomaapp/models/medicos.dart';
import 'package:biomaapp/models/procedimento.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FiltrosAtivosAgendamento extends StatefulWidget {
  Medicos doctor;
  Procedimento procedimentos;
  VoidCallback press;
  FiltrosAtivosAgendamento(
      {Key? key,
      required this.doctor,
      required this.procedimentos,
      required this.press})
      : super(key: key);

  @override
  State<FiltrosAtivosAgendamento> createState() =>
      _FiltrosAtivosAgendamentoState();
}

class _FiltrosAtivosAgendamentoState extends State<FiltrosAtivosAgendamento> {
  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    bool _isLoading = false;

    filtrosAtivos filtros = auth.filtrosativos;

    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Container(
            child: Column(
              children: [
                ListTile(
                  title: Text(
                      widget.procedimentos.des_procedimentos.capitalize(),
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  trailing: Text('R\$ ' + widget.procedimentos.valor.toString(),
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  onTap: () async {},
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: widget.doctor.especialidade.codespecialidade == '1'
                      ? Text(
                          olhoDescritivo[widget.procedimentos.olho] as String)
                      : SizedBox(),
                ),
                Column(
                  children: [
                    filtros.unidades.isNotEmpty
                        ? InforUnidade(
                            filtros.unidades.first,
                            () {
                              setState(() {});
                            },
                          )
                        : Text('')
                  ],
                ),
              ],
            ),
          );
  }
}
