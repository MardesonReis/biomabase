import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/Voucher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:pdf/widgets.dart' as pdf;
import 'package:pdf/pdf.dart';
import 'package:qr_flutter/qr_flutter.dart' as dr;

pdf.Document? pdfDocument;

class VoucheBuild extends StatefulWidget {
  Voucher vouche;
  VoucheBuild({Key? key, required this.vouche}) : super(key: key);

  @override
  State<VoucheBuild> createState() => _VoucheBuildState();
}

class _VoucheBuildState extends State<VoucheBuild> {
  @override
  Widget build(BuildContext context) {
    var data = '';
    if (widget.vouche.dataValidade.toString() != 'null') {
      var dataInf = DateTime.parse(widget.vouche.dataValidade);

      data = dataInf.day.toString() +
          '/' +
          dataInf.month.toString() +
          '/' +
          dataInf.year.toString();
    }
    return Card(
      elevation: 8,
      shadowColor: primaryColor,
      child: Container(
        // width: 6 * MediaQuery.of(context).size.width / 15,
        //  height: MediaQuery.of(context).size.height,
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage('assets/imagens/voucher_image.png'),
        //     fit: BoxFit.contain,
        //   ),
        // ),
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Row(
            children: [
              Container(
                width: tela(context).width * 0.6,
                color: primaryColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    ListTile(
                      title: Center(
                        child: Text(
                          'VOUCHER',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: widget.vouche.servicos
                          .map((e) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 8,
                                        ),
                                        textResp(
                                            e.des_procedimento +
                                                ' - ' +
                                                e.desconto.toStringAsFixed(2) +
                                                '%',
                                            color: Colors.white,
                                            fontSize: 12,
                                            maxLines: 2),
                                        Container(
                                            color: destColor,
                                            child: SizedBox(
                                              width: 16,
                                              height: 8,
                                            )),
                                      ],
                                    ),
                                  ),
                                ],
                              ))
                          .toList(),
                    ),
                    if (data.toString().isNotEmpty)
                      ListTile(
                        title: Text(
                          widget.vouche.observacao,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Data de Validade:',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              data,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    SizedBox(height: 40),

                    SizedBox(height: 20),
                    Text(
                      'Código do Vouche:',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.vouche.id + '-' + widget.vouche.code,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    // SizedBox(height: 40),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     // generatePDF(context);
                    //   },
                    //   child: Text('Exportar em PDF'),
                    // ),
                    SizedBox(
                      height: 8,
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Container(
                width: tela(context).width * 0.2,
                child: Column(
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Image.network(
                          'https://bioma.app.br/imagens/redebioma/logomanootica.png',
                          height: tela(context).height * 0.08,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Image.asset(
                          'assets/imagens/biomaLogo.png',
                          height: tela(context).height * 0.08,
                        ),
                      ),
                    ),
                    Card(
                      child: dr.QrImageView(
                        data: widget.vouche.id + '-' + widget.vouche.code,
                        version: dr.QrVersions.auto,
                        size: tela(context).height * 0.08,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
