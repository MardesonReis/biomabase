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

  Future<Voucher> enviarVoucher(Voucher voucher) async {
    Voucher voucher_salvo;
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
      print(response.body);
      if (response.statusCode == 200) {
        // Sucesso na requisição

        //voucher_salvo = List<Voucher>.from(jsonDecode(response.body)['dados'].map((item) => Voucher.fromJson(item))).toList();

        Map<String, dynamic> responseBody =
            jsonDecode(response.body)['dados'][0];

        voucher_salvo = new Voucher.fromJson(responseBody);
      } else {
        // Erro na requisição
        voucher_salvo = Voucher.erro();
        print(
            'Erro ao enviar o voucher. Código de status: ${response.statusCode}');
      }
    } catch (error) {
      // Erro ao fazer a requisição
      voucher_salvo = Voucher.erro();
      print('Erro ao enviar o voucher: $error');
    }
    return voucher_salvo;
  }

  Future<void> loadDados(Usuario user) async {
    this._items.clear();
    final url = Constants.BIOMA_API +
        'vouches/listar/' +
        Constants.AUT_BASE; // Substitua pela URL da sua API
    print(url);
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()),
      );
      print(response.body);
      if (response.statusCode == 200) {
        // Sucesso na requisição

        this._items = List<Voucher>.from(jsonDecode(response.body)['dados']
            .map((item) => Voucher.fromJson(item))).toList();
      } else {
        // Erro na requisição
        print(
            'Erro ao enviar o voucher. Código de status: ${response.statusCode}');
      }
    } catch (error) {
      // Erro ao fazer a requisição
      print('Erro ao enviar o voucher: $error');
    }
    // items.sort((a, b) => a.des_profissional.compareTo(b.des_profissional));

    notifyListeners();
  }

  List<Voucher> generateAutomaticVouchers({
    required int quantity,
    required List<Unidade> locais,
    required List<Procedimento> servicos,
    required List<Usuario> logista,
    required List<Usuario> representantes,
    required List<Usuario> clientes,
    required String dataValidade,
    required String observacao,
    required String status,
  }) {
    return generateVouchers(
        quantity: quantity,
        locais: locais,
        servicos: servicos,
        logista: logista,
        representantes: representantes,
        clientes: clientes,
        dataValidade: dataValidade,
        observacao: observacao,
        status: status);
  }

  void shareVoucherWithSalesRepresentative(
      Voucher voucher, String salesRepresentative) {
    print('Voucher ${voucher.id} compartilhado com $salesRepresentative');
  }

  void distributeVoucherToBuyer(Voucher voucher, String buyer) {
    print('Voucher ${voucher.id} distribuído para $buyer');
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
    required List<Procedimento> servicos,
    required List<Unidade> locais,
    required List<Usuario> logista,
    required List<Usuario> representantes,
    required List<Usuario> clientes,
    required String dataValidade,
    required String observacao,
    required String status,
  }) {
    List<Voucher> vouchers = [];
    String voucherCode = generateUniqueCode();
    for (int i = 0; i < quantity; i++) {
      String voucherId = UniqueKey().toString();
      Voucher voucher = Voucher(
          id: voucherId,
          code: voucherCode,
          servicos: servicos,
          locais: locais,
          logista: logista,
          representantes: representantes,
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
    return UniqueKey().toString().replaceAll('[', '').replaceAll(']', '');
  }
}
