class HistoricoProcedimentos {
  final String name, speciality, institute, image;

  const HistoricoProcedimentos({
    required this.name,
    required this.speciality,
    required this.institute,
    required this.image,
  });
}

const List<HistoricoProcedimentos> demo_historico = [
  HistoricoProcedimentos(
    name: "Procedimentos Agendados",
    speciality: "4",
    institute: "Consulta em consultório",
    image: "assets/images/Salina_Zaman.png",
  ),
  HistoricoProcedimentos(
    name: "Procedimentos Realizados",
    speciality: "4",
    institute: "Consulta em consultório",
    image: "assets/images/Salina_Zaman.png",
  ),
  HistoricoProcedimentos(
    name: "Procedimentos Indicados",
    speciality: "4",
    institute: "Consulta em consultório",
    image: "assets/images/Salina_Zaman.png",
  ),
];
