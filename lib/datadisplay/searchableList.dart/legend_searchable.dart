class LegendSearchable {
  final Map<Enum, dynamic> fields;

  LegendSearchable({
    required this.fields,
  });
}

enum Searchable {
  TEXT,
  VALUE,
}
