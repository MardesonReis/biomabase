import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/Voucher.dart';
import 'package:biomaapp/models/voucher_list.dart';
import 'package:biomaapp/screens/vouches/VoucherBuild.dart';
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
  ListVoucheViwer({Key? key, required this.vouchers}) : super(key: key);

  @override
  State<ListVoucheViwer> createState() => _ListVoucheViwerState();
}

class _ListVoucheViwerState extends State<ListVoucheViwer> {
  bool isloading = true;

  void initState() {
    var GestorDeVoucher = Provider.of<VoucherList>(
      context,
      listen: false,
    );
    enviarVoucher(GestorDeVoucher).then((value) {
      setState(() {
        isloading = false;
      });
    });
    super.initState();
  }

  Future<void> enviarVoucher(VoucherList GestorDeVoucher) async {
    await widget.vouchers.map((e) => GestorDeVoucher.enviarVoucher(e)).toList();
  }

  Future<void> viewPDF(VoucherList GestorDeVoucher) async {
    pdfDocument = await GestorDeVoucher.generateVouchersPdf(widget.vouchers);

    if (pdfDocument != null) {
      Printing.layoutPdf(
        format:
            PdfPageFormat(PdfPageFormat.a4.width, PdfPageFormat.a4.height / 4),
        dynamicLayout: true,
        usePrinterSettings: true,
        onLayout: (PdfPageFormat format) async => pdfDocument!.save(),
      );
      // Share.shareFiles([AquivoName], text: AquivoName);
    }
  }

  Future<void> SherePDF(VoucherList GestorDeVoucher) async {
    pdfDocument = await GestorDeVoucher.generateVouchersPdf(widget.vouchers);

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
          IconButton(
              onPressed: () {
                setState(() {
                  isloading = true;
                });
                enviarVoucher(GestorDeVoucher).then((value) {
                  setState(() {
                    isloading = false;
                  });
                });
              },
              icon: Icon(Icons.disc_full))
        ],
      ),
      body: isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              shrinkWrap: true,
              itemCount: widget.vouchers.length,
              itemBuilder: (context, index) {
                return VoucheBuild(vouche: widget.vouchers[index]);
              },
            ),
    );
  }
}
