import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/Voucher.dart';
import 'package:biomaapp/models/voucher_list.dart';
import 'package:biomaapp/screens/vouches/VoucherBuild.dart';
import 'package:biomaapp/screens/vouches/VoucherPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:biomaapp/utils/constants.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

class ListVoucheViwer extends StatefulWidget {
  List<Voucher> vouchers;
  bool salvar;
  ListVoucheViwer({Key? key, required this.vouchers, required this.salvar})
      : super(key: key);

  @override
  State<ListVoucheViwer> createState() => _ListVoucheViwerState();
}

class _ListVoucheViwerState extends State<ListVoucheViwer> {
  bool isloading = true;
  List<Voucher> vouchers_salvos = [];
  List<Voucher> vouchers_erro = [];
  void initState() {
    var GestorDeVoucher = Provider.of<VoucherList>(
      context,
      listen: false,
    );
    if (widget.salvar == true) {
      enviarVoucher(GestorDeVoucher).then((value) {
        setState(() {
          isloading = false;
        });
      });
    } else {
      setState(() {
        vouchers_salvos = widget.vouchers;
        isloading = false;
      });
    }

    super.initState();
  }

  Future<void> enviarVoucher(VoucherList GestorDeVoucher) async {
    bool isloading = true;
    await widget.vouchers.map((e) async {
      Voucher new_voucher = await GestorDeVoucher.enviarVoucher(e);
      if (new_voucher.id.isNotEmpty) {
        setState(() {
          vouchers_salvos.add(new_voucher);
        });
      } else {
        new_voucher = e;
        vouchers_erro.add(new_voucher);
      }
    }).toList();
    if (vouchers_erro.isNotEmpty)
      AlertShowDialog(
          'Erro ao salvar',
          Column(children: vouchers_erro.map((e) => Text(e.id)).toList()),
          context);

    setState(() {
      bool isloading = false;
    });
  }

  Future<void> viewPDF(VoucherList GestorDeVoucher) async {
    pdfDocument = await GestorDeVoucher.generateVouchersPdf(vouchers_salvos);

    if (pdfDocument != null) {
      Printing.layoutPdf(
        format:
            PdfPageFormat(PdfPageFormat.a4.width, PdfPageFormat.a4.height / 4),
        // dynamicLayout: true,
        usePrinterSettings: true,
        onLayout: (PdfPageFormat format) async => pdfDocument!.save(),
      );
      // Share.shareFiles([AquivoName], text: AquivoName);
    }
  }

  Future<void> SherePDF(VoucherList GestorDeVoucher) async {
    pdfDocument = await GestorDeVoucher.generateVouchersPdf(vouchers_salvos);

    if (pdfDocument != null) {
      // final directory = await getApplicationDocumentsDirectory();
      // String AquivoName =
      //     directory.path + "_Vouches_BIOMA_" + UniqueKey().toString() + ".pdf";
      // final file = File(AquivoName);
      // await file.writeAsBytes(await pdfDocument!.save());
      Printing.sharePdf(bytes: await pdfDocument!.save());
      // Share.shareFiles([AquivoName], text: AquivoName);
    }
  }

  @override
  Widget build(BuildContext context) {
    VoucherList GestorDeVoucher = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              setState(() {
                isloading = true;
              });
              Navigator.of(context)
                  .push(new MaterialPageRoute<Null>(
                      builder: (BuildContext context) {
                        bool isloading = false;
                        return VouchersPage();
                      },
                      fullscreenDialog: true))
                  .then((value) {
                setState(() {});
              });
            },
            icon: Icon(Icons.keyboard_backspace_rounded)),
        iconTheme: IconThemeData(color: destColor),
        title: Text(
          'Vouchers Gerados:',
          style: TextStyle(fontSize: 18),
        ),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  isloading = true;
                });
                viewPDF(GestorDeVoucher).then((value) {
                  setState(() {
                    isloading = false;
                  });
                });
              },
              icon: Icon(Icons.picture_as_pdf)),
          IconButton(
              onPressed: () {
                setState(() {
                  isloading = true;
                });
                SherePDF(GestorDeVoucher).then((value) {
                  setState(() {
                    isloading = false;
                  });
                });
              },
              icon: Icon(Icons.share_outlined)),
        ],
      ),
      body: isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              shrinkWrap: true,
              itemCount: vouchers_salvos.length,
              itemBuilder: (context, index) {
                return VoucheBuild(vouche: vouchers_salvos[index]);
              },
            ),
    );
  }
}
