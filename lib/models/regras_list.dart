import 'dart:convert';

import 'package:biomaapp/constants.dart';
import 'package:biomaapp/models/auth.dart';
import 'package:biomaapp/models/convenios.dart';
import 'package:biomaapp/models/data.dart';
import 'package:biomaapp/models/especialidade.dart';
import 'package:biomaapp/models/medicos.dart';
import 'package:biomaapp/models/procedimento.dart';
import 'package:biomaapp/models/regras.dart';
import 'package:biomaapp/models/unidade.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:biomaapp/utils/constants.dart';
import 'package:provider/provider.dart';

class RegrasList with ChangeNotifier {
  final String _token;
  final String _userId;
  String like = 'Consulta';

  late bool seemore = false;
  late bool isLoading = false;
  late bool limit = false;
  Set<int> offset = Set();
  List<Regra> _items = [];
  List<Data> _dados = [];
  List<Regra> get items => [..._items];
  List<Data> get dados => [..._dados];

  // print(result.toList());
  RegrasList([
    this._token = '',
    this._userId = '',
    this._items = const [],
    this._dados = const [],
  ]) {
    // CarregaBanco();
  }

  int get itemsCount {
    return items.length;
  }

  limparDados() {
    this._items.clear();
    this._dados.clear();
    this.offset.clear();
    this.limit = false;
  }

  Future<void> buscar(BuildContext context) async {
    final ini = items.length;
    if (this.like.isEmpty) return;
    if (this.offset.contains(ini)) return;

    if (!this.offset.contains(ini)) {
      await this.Regras(context).then((value) {
        if (ini == items.length) {
          this.limit = true;
          notifyListeners();
        }
      });
    }
  }

  Future<List<Regra>> Regras(BuildContext context) async {
    // Map parans = {"cpf": this.cpf, "skip": 0, "take": 50};
    // _items.clear();
    //_dados.clear();
    Auth auth = Provider.of(context, listen: false);
    auth.fidelimax.cpf;

    var link = '';
    var cpf = Master.contains(auth.fidelimax.cpf.trim())
        ? '0'
        : auth.fidelimax.cpf.trim();
    cpf = cpf.trim().isEmpty ? '0' : auth.fidelimax.cpf.trim();
    var medico = auth.filtrosativos.medicos.isNotEmpty
        ? auth.filtrosativos.medicos.first.cod_profissional
        : '0';
    var convenio = auth.filtrosativos.convenios.isNotEmpty
        ? auth.filtrosativos.convenios.first.cod_convenio
        : '40';
    var especialidade = auth.filtrosativos.especialidades.isNotEmpty
        ? auth.filtrosativos.especialidades.first.cod_especialidade
        : '0';
    var unidade = auth.filtrosativos.unidades.isNotEmpty
        ? auth.filtrosativos.unidades.first.cod_unidade
        : '0';
    link = Constants.REGRAS_BASE_URL +
        'listar/' +
        cpf +
        '/' +
        medico +
        '/' +
        convenio +
        '/' +
        especialidade +
        '/' +
        unidade +
        '/' +
        Constants.AUT_BASE;
    if (this.like.trim().isEmpty) {
      this.like = 'Consulta';
      notifyListeners();
    }
    link = link + '&like=' + this.like.trim();
    link = link + '&offset=' + (this.items.length).toString();
    this.offset.add(_items.length);
    //  items.sort((a, b) => a.des_profissional.compareTo(b.des_profissional));

    var response;
    print(link);

    try {
      response = await http.post(Uri.parse(link),
          headers: {
            "Content-Type": "application/x-www-form-urlencoded",
            'Charset': 'utf-8'
          },
          // body: param,
          encoding: Encoding.getByName("utf-8"));
      try {
        var total = jsonDecode(response.body)['total'];
        if (total - 1 <= 0 && this._dados.isNotEmpty) {
          this.limit = true;
        }

        List agendamentolist = await jsonDecode(response.body)['dados'] ?? [];
        if (agendamentolist.first['id_regra'].toString() == '') return [];
        await agendamentolist.map(
          (item) {
            var regra = Regra(
                r_id: item['r_id'].toString(),
                r_cpf_parceiro: item['r_cpf_parceiro'].toString(),
                r_des_parceiro: item['r_des_parceiro'].toString(),
                r_cod_profissional: item['r_cod_profissional'].toString(),
                r_cpf_profissional: item['r_cpf_profissional'].toString(),
                r_des_profissional: item['r_des_profissional'].toString(),
                r_crm_profissional: item['r_crm_profissional'].toString(),
                r_sub_especialidade: item['r_sub_especialidade'].toString(),
                r_cod_especialidade: item['r_cod_especialidade'].toString(),
                r_des_especialidade: item['r_des_especialidade'].toString(),
                r_grupo: item['r_grupo'].toString(),
                r_cod_unidade: item['r_cod_unidade'].toString(),
                r_des_unidade: item['r_des_unidade'].toString(),
                r_cod_convenio: item['r_cod_convenio'].toString(),
                r_desc_convenio: item['r_desc_convenio'].toString(),
                r_cod_procedimentos: item['r_cod_procedimentos'].toString(),
                r_des_procedimentos: item['r_des_procedimentos'].toString(),
                r_cod_tratamento: item['r_cod_tratamento'].toString(),
                r_tipo_tratamento: item['r_tipo_tratamento'].toString(),
                r_tabop_quantidade: item['r_tabop_quantidade'].toString(),
                r_frequencia: item['r_frequencia'].toString(),
                r_valor_base: item['r_valor_base'].toString(),
                r_valor_sugerido: item['r_valor_sugerido'].toString(),
                r_orientacoes: item['r_orientacoes'].toString(),
                r_like_regra: item['r_like_regra'].toString(),
                r_termos_buscas: item['r_termos_buscas'].toString(),
                r_informe_aproximado: item['r_informe_aproximado'].toString(),
                r_status: item['r_status'].toString(),
                r_validade: item['r_validade'].toString(),
                r_data_criacao: item['r_data_criacao'].toString(),
                r_hora_criacao: item['r_hora_criacao'].toString(),
                rateios: []);
            var data = Data(
              id_regra: item['r_id'].toString(),
              valor_sugerido: item['r_valor_sugerido'].toString(),
              orientacoes: item['r_orientacoes'].toString(),
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
              textBusca: item['text_like'].toString(),
            );
            var temItens = this
                ._items
                .where((element) => element.r_id == item['r_id'].toString())
                .toList()
                .isEmpty;
            var temDados = this
                ._dados
                .where((element) => element.id_regra == item['r_id'].toString())
                .toList()
                .isEmpty;

            if (temItens) {
              this._items.add(regra);
              notifyListeners();
            }

            if (temDados) {
              this._dados.add(data);
              notifyListeners();
            }
          },
        ).toList();
      } catch (e) {
        print(e.toString());
      }
    } catch (e) {
      print(e.toString());
    }

    notifyListeners();
    return _items;
  }

  Future<String> Remover(String idRegra) async {
    // Map parans = {"cpf": this.cpf, "skip": 0, "take": 50};
    _items.clear();
    var id = '';
    var link =
        Constants.REGRAS_BASE_URL + 'remover/' + idRegra + Constants.AUT_BASE;

    var response;

    try {
      response = await http.post(Uri.parse(link),
          headers: {
            "Content-Type": "application/x-www-form-urlencoded",
            'Charset': 'utf-8'
          },
          // body: param,
          encoding: Encoding.getByName("utf-8"));
      print(response.body);
      List agendamentolist = await jsonDecode(response.body)['dados'] ?? [];
      if (agendamentolist.first['r_id'].toString() == '') return '';
      await agendamentolist.map(
        (item) {
          id = item['r_id'].toString();
          //  _items.add(Fila());
          //     item['crm'].toString(),
        },
      ).toList();
    } catch (e) {
      print(e.toString());
      id = '';
    }

    return id;

    //  items.sort((a, b) => a.des_profissional.compareTo(b.des_profissional));

    //notifyListeners();
  }

  Future<String> addRegra(Regra regra) async {
    //debugPrint(cpf);
    var idRegra = '';

    Map<String, String> param = {
      'r_id': regra.r_id,
      'r_cpf_parceiro': regra.r_cpf_parceiro,
      'r_des_parceiro': regra.r_des_parceiro,
      'r_cod_profissional': regra.r_cod_profissional,
      'r_cpf_profissional': regra.r_cpf_profissional,
      'r_des_profissional': regra.r_des_profissional,
      'r_crm_profissional': regra.r_crm_profissional,
      'r_sub_especialidade': regra.r_sub_especialidade,
      'r_cod_especialidade': regra.r_cod_especialidade,
      'r_des_especialidade': regra.r_des_especialidade,
      'r_grupo': regra.r_grupo,
      'r_cod_unidade': regra.r_cod_unidade,
      'r_des_unidade': regra.r_des_unidade,
      'r_cod_convenio': regra.r_cod_convenio,
      'r_desc_convenio': regra.r_desc_convenio,
      'r_cod_procedimentos': regra.r_cod_procedimentos,
      'r_des_procedimentos': regra.r_des_procedimentos,
      'r_cod_tratamento': regra.r_cod_tratamento,
      'r_tipo_tratamento': regra.r_tipo_tratamento,
      'r_tabop_quantidade': regra.r_tabop_quantidade,
      'r_frequencia': regra.r_frequencia,
      'r_valor_base': regra.r_valor_base,
      'r_valor_sugerido': regra.r_valor_sugerido,
      'r_orientacoes': regra.r_orientacoes,
      'r_termos_buscas': regra.r_termos_buscas,
      'r_informe_aproximado': regra.r_informe_aproximado,
      'r_status': regra.r_status,
      'r_validade': regra.r_validade,
      'r_data_criacao': regra.r_data_criacao,
      'r_hora_criacao': regra.r_hora_criacao,
    };

    var link = Constants.REGRAS_BASE_URL + 'add/' + Constants.AUT_BASE;
    var response;
    print(param.toString());

    try {
      response = await http.post(Uri.parse(link),
          headers: {
            "Content-Type": "application/x-www-form-urlencoded",
            'Charset': 'utf-8'
          },
          body: param,
          encoding: Encoding.getByName("utf-8"));
      try {
        print(response.body);
        List agendamentolist = await jsonDecode(response.body)['dados'] ?? [];

        if (agendamentolist.first['r_id'].toString() == '') return '';
        await agendamentolist.map(
          (item) {
            idRegra = item['r_id'].toString();
            //  _items.add(Fila());
            //     item['crm'].toString(),
          },
        ).toList();
      } catch (e) {
        print(e.toString());
        idRegra = '';
      }
    } catch (e) {
      print(e.toString());
      idRegra = '';
    }

    return idRegra;
  }

  Future<bool> carrgardados(BuildContext context,
      {bool all = false, required VoidCallback Onpress}) async {
    if (this._dados.isEmpty || all == true) {
      this.limparDados();

      //await auth.fidelimax.ConsultaConsumidor(auth.fidelimax.cpf);
      // await auth.fidelimax.RetornaDadosCliente(auth.fidelimax.cpf);

      await this.Regras(context).then((value) {
        Onpress.call();
      });
    } else {
      Onpress.call();
    }

    return true;
  }

  List<Medicos> returnMedicos(String cod_procedimento) {
    Set<String> MedicosInclusos = Set();
    List<Medicos> medicos = [];
    final dlista = this.dados;
    dlista.retainWhere((element) {
      return element.cod_procedimentos.contains(cod_procedimento);
    });
    dlista.map((e) {
      Medicos med = Medicos(
          especialidade: Especialidade(
              cod_especialidade: e.cod_especialidade,
              des_especialidade: e.des_especialidade,
              ativo: 'S'));
      med.cod_profissional = e.cod_profissional;
      med.des_profissional = e.des_profissional;
      med.crm = e.crm;
      med.cpf = e.cpf;
      med.idademin = e.idade_mim;
      med.idademax = e.idade_max;
      med.ativo = '1';
      med.subespecialidade = e.sub_especialidade;

      Unidade unidade = Unidade();
      unidade.cod_unidade = e.cod_unidade;
      unidade.des_unidade = e.des_unidade;

      if (!MedicosInclusos.contains(e.cod_profissional)) {
        MedicosInclusos.add(e.cod_profissional);
        medicos.add(med);
      }
    }).toList();
    return medicos;
  }

  List<Procedimento> returnProcedimentos(String cod_profissional) {
    final dlista = this.dados;
    Set<String> ProcedimentosInclusoIncluso = Set();
    List<Procedimento> Procedimentos = [];
    dlista.retainWhere((element) {
      return element.cod_profissional.contains(cod_profissional);
    });

    dlista.map((e) {
      Procedimento p = Procedimento();
      p.convenio = Convenios(
          cod_convenio: e.cod_convenio, desc_convenio: e.desc_convenio);

      p.cod_procedimento = e.cod_procedimentos;
      p.valor_sugerido = double.parse(e.valor_sugerido);
      p.orientacoes = e.orientacoes;
      p.des_procedimento = e.des_procedimentos;
      p.valor = double.parse(e.valor);
      p.grupo = e.grupo;
      p.frequencia = e.frequencia;
      p.quantidade = e.tabop_quantidade;
      p.especialidade.cod_especialidade = e.cod_especialidade;
      p.especialidade.des_especialidade = e.des_especialidade;
      p.cod_tratamento = e.cod_tratamento;
      p.des_tratamento = e.tipo_tratamento;

      var dist = e.cod_procedimentos + '-' + e.valor_sugerido;

      if (!ProcedimentosInclusoIncluso.contains(dist)) {
        ProcedimentosInclusoIncluso.add(dist);
        Procedimentos.add(p);
      }
    }).toList();
    return Procedimentos;
  }

  List<Unidade> returnUnidades(List<Unidade> DadosUnidades) {
    Set<String> UnidadesInclusos = Set();
    List<Unidade> unidades = [];
    final dlista = this.dados;
    dlista.retainWhere((element) {
      return element.cod_procedimentos.contains('');
    });
    dlista.map((e) {
      Unidade unidade = Unidade();
      unidade.cod_unidade = e.cod_unidade;
      unidade.des_unidade = e.des_unidade;
      if (DadosUnidades.isNotEmpty) {
        var u = DadosUnidades.where(
            (element) => element.cod_unidade == e.cod_unidade).toList().first;
        //  u.distancia = await getDistance(unidade.latitude, unidade.l atitude);
        var str = u.des_unidade +
            ' - ' +
            u.municipio +
            ' - ' +
            u.bairro +
            ' - ' +
            u.logradouro;

        if (!UnidadesInclusos.contains(u.cod_unidade)) {
          UnidadesInclusos.add(u.cod_unidade);
          unidades.add(u);
        }
      }
    }).toList();
    return unidades;
  }

  Future<void> loadMore(BuildContext context) async {
    if (this.offset.contains(items.length))
      return Future.delayed(Duration(seconds: 0), () {});
    if (this.like.isEmpty) return Future.delayed(Duration(seconds: 0), () {});
    if (this.items.length == 0) {
      this.limit == false;
      this.offset.clear();
      //notifyListeners();
    }
    if (this.limit == true) return Future.delayed(Duration(seconds: 0), () {});

    // notifyListeners();
    return Future.delayed(Duration(seconds: 1), () {
      this.buscar(context).then((value) {
        notifyListeners();
      });
    });
  }
}
