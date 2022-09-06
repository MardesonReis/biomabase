class Category {
  final String icon, title;

  const Category({required this.icon, required this.title});
}

const List<Category> demo_categories = [
  Category(icon: "assets/icons/oftalmologista.svg", title: "Oftalmologista"),
  Category(icon: "assets/icons/Pediatrician.svg", title: "Pediatria"),
  Category(icon: "assets/icons/Neurosurgeon.svg", title: "Neurologista"),
  Category(icon: "assets/icons/Cardiologist.svg", title: "Cardiologista"),
  Category(icon: "assets/icons/Psychiatrist.svg", title: "Psiquiatra"),
];
