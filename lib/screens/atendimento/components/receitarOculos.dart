import 'package:flutter/material.dart';

class PrescricaoDeOculos {
  String? olho;
  double? esferico;
  double? cilindro;
  double? eixo;
  String? observacao;

  PrescricaoDeOculos({
    this.olho,
    this.esferico,
    this.cilindro,
    this.eixo,
    this.observacao,
  });
}

class GlassesPrescriptionForm extends StatefulWidget {
  @override
  _GlassesPrescriptionFormState createState() =>
      _GlassesPrescriptionFormState();
}

class _GlassesPrescriptionFormState extends State<GlassesPrescriptionForm> {
  List<PrescricaoDeOculos> _prescricoes = [];
  final _formKey = GlobalKey<FormState>();

  void _showFormDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double? esferico;
        double? cilindro;
        double? eixo;
        String? observacao;
        String? _selectedOlho;

        return StatefulBuilder(
          builder: (context, thisState) {
            return AlertDialog(
              title: Text('Adicionar Prescrição'),
              content: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Olho:'),
                          PopupMenuButton<String>(
                            itemBuilder: (context) =>
                                ['Direito', 'Esquerdo'].map((olho) {
                              return PopupMenuItem<String>(
                                value: olho,
                                child: Text(olho),
                              );
                            }).toList(),
                            onSelected: (olho) {
                              thisState(() {
                                _selectedOlho = olho;
                              });
                            },
                            child: Text(_selectedOlho ?? 'Selecione'),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Esférico'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Digite o valor do esférico';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          esferico = double.tryParse(value);
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Cilindro'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Digite o valor do cilindro';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          cilindro = double.tryParse(value);
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Eixo'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Digite o valor do eixo';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          eixo = double.tryParse(value);
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Observação'),
                        maxLines: 3,
                        onChanged: (value) {
                          observacao = value;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancelar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Adicionar'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      PrescricaoDeOculos prescricao = PrescricaoDeOculos(
                        olho: _selectedOlho,
                        esferico: esferico,
                        cilindro: cilindro,
                        eixo: eixo,
                        observacao: observacao,
                      );

                      setState(() {
                        _prescricoes.add(prescricao);
                        _selectedOlho = null;
                      });

                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Receita de Óculos'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DataTable(
              columns: [
                DataColumn(label: Text('Olho')),
                DataColumn(label: Text('Esférico')),
                DataColumn(label: Text('Cilindro')),
                DataColumn(label: Text('Eixo')),
                DataColumn(label: Text('Observação')),
              ],
              rows: _prescricoes.map((prescricao) {
                return DataRow(cells: [
                  DataCell(Text(prescricao.olho ?? '')),
                  DataCell(Text(prescricao.esferico?.toString() ?? '')),
                  DataCell(Text(prescricao.cilindro?.toString() ?? '')),
                  DataCell(Text(prescricao.eixo?.toString() ?? '')),
                  DataCell(Text(prescricao.observacao ?? '')),
                ]);
              }).toList(),
            ),
            SizedBox(height: 16),
            TextButton(
              child: Text('Adicionar Prescrição'),
              onPressed: () {
                _showFormDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: GlassesPrescriptionForm(),
  ));
}
