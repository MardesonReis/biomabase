import 'dart:async';

import 'package:biomaapp/models/AgendaMedico.dart';
import 'package:biomaapp/models/Fila.dart';
import 'package:biomaapp/models/convenios.dart';
import 'package:biomaapp/models/especialidade.dart';
import 'package:biomaapp/models/formapagamento.dart';
import 'package:biomaapp/models/grupos.dart';
import 'package:biomaapp/models/medicos.dart';
import 'package:biomaapp/models/pacientes.dart';
import 'package:biomaapp/models/pacientes.dart';
import 'package:biomaapp/models/procedimento.dart';
import 'package:biomaapp/models/subEspecialidade.dart';
import 'package:biomaapp/models/unidade.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'Clips.dart';
import 'package:flutter/material.dart';

class filtrosAtivos with ChangeNotifier {
  List<Usuario> usuarios = [];
  List<Fila> fila = [];
  List<Medicos> medicos = [];
  List<Especialidade> especialidades = [];
  List<SubEspecialidade> subespecialidades = [];
  List<Convenios> convenios = [];
  List<Unidade> unidades = [];
  List<Clips> agenda = [];
  List<Grupo> grupos = [];
  List<Procedimento> procedimentos = [];
  List<Clips> meses = [];
  List<Clips> dias = [];
  List<Clips> horarios = [];
  List<Clips> olho = [];
  List<FormaPagamento> FormaPg = [];
  List<Map<String, Object>> servicos_page = [];
  List<AgendaMedico> hora_extra = [];
  late GoogleMapController googleMapController;

  List<Map<String, Object>> tipoFila = [];
  List<String> passo = [];
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

  int BuscarFiltrosAtivos() {
    //notifyListeners();
    return unidades.length +
        convenios.length +
        medicos.length +
        especialidades.length +
        subespecialidades.length +
        grupos.length +
        procedimentos.length;
  }

  Future<void> LimparTodosFiltros() async {
    unidades.clear();
    convenios.clear();
    especialidades.clear();
    procedimentos.clear();
    subespecialidades.clear();
    grupos.clear();
    agenda.clear();
    olho.clear();
    usuarios.clear();
    medicos.clear();
    meses.clear();
    dias.clear();
    horarios.clear();
    notifyListeners();
  }

  Future<void> addUsuarios(Usuario user) async {
    usuarios.add(user);

    notifyListeners();
  }

  Future<void> RemoverUsuario(Usuario user) async {
    await usuarios.remove(user);

    notifyListeners();
  }

  Future<void> LimparUsuarios() async {
    usuarios.clear();
    usuarios = [];

    notifyListeners();
  }

  Future<void> addFormaPg(FormaPagamento pg) async {
    FormaPg.add(pg);

    notifyListeners();
  }

  Future<void> RemoverFormaPg(FormaPagamento pg) async {
    await FormaPg.remove(pg);

    notifyListeners();
  }

  Future<void> LimparFormaPg() async {
    FormaPg.clear();
    FormaPg = [];

    notifyListeners();
  }

  Future<void> addPasso(String page) async {
    passo.add(page);

    notifyListeners();
  }

  Future<void> RemoverPasso(String page) async {
    await passo.remove(page);

    notifyListeners();
  }

  Future<void> LimparPasso() async {
    passo.clear();
    passo = [];

    notifyListeners();
  }

  Future<void> addsServicosPage(Map<String, Object> page) async {
    servicos_page.add(page);

    notifyListeners();
  }

  Future<void> RemoverServicosPage(Map<String, Object> page) async {
    await servicos_page.remove(page);

    notifyListeners();
  }

  Future<void> LimparServicosPage() async {
    servicos_page.clear();
    servicos_page = [];

    notifyListeners();
  }

  Future<void> addstipoFila(Map<String, Object> page) async {
    tipoFila.add(page);

    notifyListeners();
  }

  Future<void> RemoverTipoFila(Map<String, Object> page) async {
    await tipoFila.remove(page);

    notifyListeners();
  }

  Future<void> LimparTipoFila() async {
    tipoFila.clear();
    tipoFila = [];

    notifyListeners();
  }

  Future<void> addOlho(Clips olho) async {
    LimparOlho();
    this.olho.add(olho);

    notifyListeners();
  }

  Future<void> removerOlho(Clips olho) async {
    await this.olho.remove(olho);

    notifyListeners();
  }

  Future<void> LimparOlho() async {
    this.olho.clear();
    // meses = [];

    notifyListeners();
  }

  Future<void> addMes(Clips mes) async {
    meses.add(mes);

    notifyListeners();
  }

  Future<void> removerMes(Clips mes) async {
    await meses.remove(mes);

    notifyListeners();
  }

  Future<void> LimparMeses() async {
    meses.clear();

    notifyListeners();
  }

  Future<void> addFila(Fila agenda) async {
    fila.add(agenda);

    notifyListeners();
  }

  Future<void> removerFila(Fila agenda) async {
    await fila.remove(agenda);

    notifyListeners();
  }

  Future<void> LimparFila() async {
    fila.clear();
    // meses = [];

    notifyListeners();
  }

  Future<void> addDias(Clips dia) async {
    dias.add(dia);

    notifyListeners();
  }

  Future<void> removerDia(Clips dia) async {
    await dias.remove(dia);

    notifyListeners();
  }

  Future<void> LimparDias() async {
    dias.clear();

    notifyListeners();
  }

  Future<void> addHorario(Clips horario) async {
    horarios.add(horario);

    notifyListeners();
  }

  Future<void> removerHorario(Clips horario) async {
    await horarios.remove(horario);

    notifyListeners();
  }

  Future<void> LimparHorario() async {
    horarios.clear();

    notifyListeners();
  }

  Future<void> LimparCalendario() async {
    meses.clear();
    dias.clear();
    horarios.clear();

    notifyListeners();
  }

  Future<void> removerMedico(Medicos medico) async {
    await medicos.remove(medico);

    notifyListeners();
  }

  Future<void> addEspacialidades(Especialidade especialidade) async {
    especialidades.add(especialidade);

    notifyListeners();
  }

  Future<void> addSubEspacialidades(SubEspecialidade subespecialidade) async {
    subespecialidades.add(subespecialidade);

    notifyListeners();
  }

  Future<void> addConvenios(Convenios convenio) async {
    convenios.add(convenio);

    notifyListeners();
  }

  Future<void> AddProcedimentos(Procedimento procedimento) async {
    procedimentos.add(procedimento);

    notifyListeners();
  }

  Future<void> AddMeses(Clips mes) async {
    meses.add(mes);

    notifyListeners();
  }

  Future<void> removerProcedimento(Procedimento procedimento) async {
    await procedimentos.remove(procedimento);

    notifyListeners();
  }

  Future<void> removerEspacialidades(Especialidade especialidade) async {
    await especialidades.remove(especialidade);

    notifyListeners();
  }

  Future<void> removerSubEspacialidades(
      SubEspecialidade subespecialidade) async {
    await subespecialidades.remove(subespecialidade);

    notifyListeners();
  }

  Future<void> removerConvenios(Convenios convenio) async {
    await convenios.remove(convenio);

    notifyListeners();
  }

  Future<void> addMedicos(Medicos medico) async {
    medicos.add(medico);

    notifyListeners();
  }

  Future<void> addGrupos(Grupo grupo) async {
    grupos.add(grupo);

    notifyListeners();
  }

  Future<void> addunidades(Unidade unidade) async {
    unidades.add(unidade);

    notifyListeners();
  }

  Future<void> SubstituirGrupos(List<Grupo> grupo) async {
    grupos = grupo;

    notifyListeners();
  }

  Future<void> SubstituirUnidades(List<Unidade> unidades) async {
    unidades = unidades;

    notifyListeners();
  }

  Future<void> LimparGrupos() async {
    grupos.clear();

    notifyListeners();
  }

  Future<void> LimparUnidade() async {
    unidades.clear();

    notifyListeners();
  }

  Future<void> removerGrupos(Grupo grupo) async {
    grupos.remove(grupo);

    notifyListeners();
  }

  Future<void> removerUnidades(Unidade unidade) async {
    unidades.remove(unidade);

    notifyListeners();
  }

  LimparEspecialidades() {
    especialidades.clear();
    especialidades = [];

    notifyListeners();
  }

  Future<void> LimparSubEspecialidades() async {
    subespecialidades.clear();

    notifyListeners();
  }

  Future<void> LimparMedicos() async {
    medicos.clear();

    notifyListeners();
  }

  Future<void> LimparProcedimentos() async {
    procedimentos.clear();

    notifyListeners();
  }

  Future<void> LimparConvenios() async {
    convenios.clear();

    notifyListeners();
  }
}
