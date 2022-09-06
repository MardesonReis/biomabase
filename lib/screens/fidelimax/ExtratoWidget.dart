import 'package:biomaapp/models/extrato.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExtratoWidget extends StatefulWidget {
  final Extrato extrato;
  const ExtratoWidget({
    Key? key,
    required this.extrato,
  }) : super(key: key);

  @override
  _ExtratoWidget createState() => _ExtratoWidget();
}

class _ExtratoWidget extends State<ExtratoWidget> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(
                ' ${widget.extrato.credito.toString()} Bions - ${widget.extrato.tipo_compra.toString()}'),
            subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm')
                  .format(DateTime.parse(widget.extrato.data_pontuacao)),
            ),
            trailing: IconButton(
              icon: Icon(Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 4,
              ),
              height: 30,
              child: ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Data da Expiração',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        DateFormat('dd/MM/yyyy hh:mm').format(DateTime.parse(
                            widget.extrato.data_expiracao.toString())),
                      )
                    ],
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}
