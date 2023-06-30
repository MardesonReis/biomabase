import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/Voucher.dart';
import 'package:biomaapp/screens/vouches/PdfImageWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:pdf/widgets.dart' as pdf;
import 'package:pdf/pdf.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as pdfImage;

pdf.Document? pdfDocument;

class PdfPageBuilder {
  static pdf.Page buildPage(
      Voucher voucher, pdf.Image bioma, pdf.Image parceiro) {
    final pdfPage = pdf.Page(
      pageFormat: PdfPageFormat(
          PdfPageFormat.a4.width, PdfPageFormat.a4.height / 4,
          marginAll: 10),
      build: (pdf.Context context) {
        return pdf.Center(
            child: pdf.Column(
                crossAxisAlignment: pdf.CrossAxisAlignment.center,
                mainAxisAlignment: pdf.MainAxisAlignment.center,
                children: [
              pdf.Container(
                child: pdf.Row(children: [
                  pdf.Row(
                    children: [
                      pdf.Container(
                        color: PdfColor.fromHex('#1cb9c9'),
                        width: PdfPageFormat.a4.width * 0.7,
                        child: pdf.Column(
                          mainAxisAlignment: pdf.MainAxisAlignment.center,
                          crossAxisAlignment: pdf.CrossAxisAlignment.center,
                          children: [
                            pdf.SizedBox(height: 20),
                            pdf.Center(
                              child: pdf.Text(
                                'VOUCHER',
                                softWrap: true,
                                overflow: pdf.TextOverflow.span,
                                maxLines: null,
                                textScaleFactor: 2,
                                style: pdf.TextStyle(
                                  //  color: PdfColor.fromInt(2),
                                  fontWeight: pdf.FontWeight.bold,
                                ),
                              ),
                            ),
                            pdf.Column(
                                children: voucher.product
                                    .map((e) => pdf.Text(
                                          e.des_procedimentos,
                                          softWrap: true,
                                          overflow: pdf.TextOverflow.span,
                                          maxLines: null,
                                          textScaleFactor: 1.2,
                                          style: pdf.TextStyle(
                                            fontSize: 12,
                                            //  color: PdfColor.fromInt(2),
                                            fontWeight: pdf.FontWeight.bold,
                                          ),
                                        ))
                                    .toList()),
                            pdf.Container(
                              padding: pdf.EdgeInsets.all(2),
                              width: PdfPageFormat.a4.width * 0.8,
                              child: pdf.Padding(
                                padding: pdf.EdgeInsets.all(2),
                                child: pdf.Center(
                                  child: pdf.Text(
                                    voucher.observacao,
                                    softWrap: true,
                                    overflow: pdf.TextOverflow.span,
                                    maxLines: null,
                                    textScaleFactor: 1.0,
                                  ),
                                ),
                              ),
                            ),
                            pdf.SizedBox(height: 10),
                            pdf.Center(
                              child: pdf.Padding(
                                padding: pdf.EdgeInsets.all(3),
                                child: pdf.Row(
                                  mainAxisAlignment:
                                      pdf.MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      pdf.CrossAxisAlignment.center,
                                  children: [
                                    pdf.Text(
                                      'Data de Validade:',
                                      style: pdf.TextStyle(
                                        fontSize: 12,
                                        //  color: PdfColor.fromInt(2),
                                        fontWeight: pdf.FontWeight.bold,
                                      ),
                                    ),
                                    pdf.Text(
                                      voucher.dataValidade,
                                      style: pdf.TextStyle(
                                        fontSize: 12,
                                        //color: PdfColor.fromInt(2),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      pdf.Container(
                        width: PdfPageFormat.a4.width * 0.3,
                        child: pdf.Column(
                          children: [
                            //  pdf.SizedBox(height: 20),

                            parceiro,
                            pdf.SizedBox(height: 10),
                            bioma,
                          ],
                        ),
                      )
                    ],
                  ),
                ]),
              )
            ]));
        return pdf.Center(
          child: pdf.Text(
            'Exemplo de Página PDF',
            style: pdf.TextStyle(fontSize: 24),
          ),
        );
      },
    );
    return pdfPage;
  }
}
