import 'dart:convert';
import 'dart:math';

import 'package:biomaapp/models/convenios.dart';
import 'package:biomaapp/models/data.dart';
import 'package:biomaapp/models/medicos.dart';
import 'package:biomaapp/models/pacientes.dart';
import 'package:biomaapp/models/procedimento.dart';
import 'package:biomaapp/models/unidade.dart';
import 'package:biomaapp/screens/vouches/PdfImageWidget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:biomaapp/exceptions/http_exception.dart';
import 'package:biomaapp/utils/constants.dart';
import 'package:biomaapp/models/Voucher.dart';
import 'dart:io';
import 'package:biomaapp/screens/vouches/PdfPageBuilder.dart';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pdf;
import 'package:pdf/pdf.dart';
//import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

class VoucherList with ChangeNotifier {
  final String _token;
  final String _userId;
  List<Voucher> _items = [];
  List<Voucher> get items => [..._items];

  // print(result.toList());
  VoucherList([
    this._token = '',
    this._userId = '',
    this._items = const [],
  ]);

  int get itemsCount {
    return items.length;
  }

  limparDados() {
    this._items.clear();
    notifyListeners();
  }

  Future<void> enviarVoucher(Voucher voucher) async {
    final url = Constants.BIOMA_API +
        'vouches/salvar/' +
        Constants.AUT_BASE; // Substitua pela URL da sua API
    print(url);
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(voucher.toJson()),
      );

      if (response.statusCode == 200) {
        // Sucesso na requisição
        Map<String, dynamic> responseBody = jsonDecode(response.body)['dados'];
        Voucher v = new Voucher.fromJson(responseBody);
        print(v.toString());

        print(v.product.first.des_procedimentos);
        print(v.product.first.valor);
        print('Voucher enviado com sucesso!');
      } else {
        // Erro na requisição
        print(
            'Erro ao enviar o voucher. Código de status: ${response.statusCode}');
      }
    } catch (error) {
      // Erro ao fazer a requisição
      print('Erro ao enviar o voucher: $error');
    }
  }

  Future<void> loadDados(String codprofissional, String medicoLike,
      String cpf_profissional, String cod_unidade, String procedimento) async {
    //debugPrint(cpf);

    //_items.clear();
    var link = '${Constants.DATA_BASE_URL}' +
        codprofissional +
        '/' +
        medicoLike +
        '/' +
        cpf_profissional +
        '/' +
        cod_unidade +
        '/' +
        procedimento +
        Constants.AUT_BASE;
    debugPrint(link);

    final response = await http.get(
      Uri.parse(link),
    );
    if (response.body == 'null') return;
    List listmedicos = jsonDecode(response.body)['dados'];
    //Set<String> medicosInclusoIncluso = Set();

    await listmedicos.map(
      (item) {
        var data = Data(
          id_regra: '',
          orientacoes: '',
          valor_sugerido: '',
          crm: item['crm'].toString(),
          cpf: item['cpf'].toString(),
          cod_profissional: item['cod_profissional'].toString(),
          des_profissional: item['des_profissional'].toString(),
          cod_especialidade: item['cod_especialidade'].toString(),
          des_especialidade: item['des_especialidade'].toString(),
          grupo: item['grupo'].toString(),
          idade_mim: item['idade_mim'].toString(),
          idade_max: item['idade_max'].toString(),
          sub_especialidade: item['sub_especialidade'].toString(),
          cod_unidade: item['cod_unidade'].toString(),
          des_unidade: item['des_unidade'].toString(),
          cod_convenio: item['cod_convenio'].toString(),
          desc_convenio: item['desc_convenio'].toString(),
          cod_procedimentos: item['cod_procedimentos'].toString(),
          des_procedimentos: item['des_procedimentos'].toString(),
          cod_tratamento: item['cod_tratamento'].toString(),
          tipo_tratamento: item['tipo_tratamento'].toString(),
          tabop_quantidade: item['tabop_quantidade'].toString(),
          valor: item['valor'].toString(),
          frequencia: item['frequencia'].toString(),
          textBusca: '',
        );
        if (!_items.contains(data)) {
          //_items.add(data);
        }
      },
    ).toList();

    // items.sort((a, b) => a.des_profissional.compareTo(b.des_profissional));

    notifyListeners();
  }

  List<Voucher> generateAutomaticVouchers({
    required int quantity,
    required List<Procedimento> product,
    required Usuario logistaCPF,
    required List<Usuario> representante,
    required List<Usuario> clientes,
    required String dataValidade,
    required String observacao,
    required String status,
  }) {
    return generateVouchers(
        quantity: quantity,
        product: product,
        logistaCPF: logistaCPF,
        representante: representante,
        clientes: clientes,
        dataValidade: dataValidade,
        observacao: observacao,
        status: status);
  }

  void shareVoucherWithSalesRepresentative(
      Voucher voucher, String salesRepresentative) {
    print('Voucher ${voucher.code} compartilhado com $salesRepresentative');
  }

  void distributeVoucherToBuyer(Voucher voucher, String buyer) {
    print('Voucher ${voucher.code} distribuído para $buyer');
  }

  Future<pdf.Document> generateVouchersPdf(List<Voucher> vouchers) async {
    pdf.Document pdfDocument = pdf.Document();
    final pdf.Image img_parceiro = await ImageToPdfConverter.getImageFromUrl(
        'https://bioma.app.br/imagens/redebioma/logomanootica.png');
    final pdf.Image img_bioma = await ImageToPdfConverter.getImageFromUrl(
        'https://bioma.app.br/imagens/redebioma/bioma_logo.png');
    for (Voucher voucher in vouchers) {
      pdfDocument
          .addPage(PdfPageBuilder.buildPage(voucher, img_bioma, img_parceiro));
    }

    return pdfDocument;
  }

  void shareVouchersOnWhatsApp(List<Voucher> vouchers) {
    //String voucherCodes = vouchers.map((voucher) => voucher.code).join('\n');
    // Share.share(voucherCodes, subject: 'Vouchers');
    Share.shareFiles(['example.pdf'], text: 'Great picture');
  }

  List<Voucher> generateVouchers({
    required int quantity,
    required List<Procedimento> product,
    required Usuario logistaCPF,
    required List<Usuario> representante,
    required List<Usuario> clientes,
    required String dataValidade,
    required String observacao,
    required String status,
  }) {
    List<Voucher> vouchers = [];

    for (int i = 0; i < quantity; i++) {
      String voucherId = UniqueKey().toString();
      String voucherCode = generateUniqueCode();
      Voucher voucher = Voucher(
          id: voucherId,
          code: voucherCode,
          product: product,
          logistaCPF: logistaCPF,
          representante: representante,
          clientes: clientes,
          dataValidade: dataValidade,
          observacao: observacao,
          status: status);
      vouchers.add(voucher);
    }

    return vouchers;
  }

  String generateUniqueCode() {
    // Implemente uma lógica para gerar um código único
    // Pode ser um código aleatório, baseado em algum algoritmo específico, etc.
    return UniqueKey().toString();
  }
}
