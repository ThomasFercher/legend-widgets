class LegendSearchable {
  final List<LegendSearchableField> fields;

  LegendSearchable({
    required this.fields,
  });
}

abstract class LegendSearchableField {
  final dynamic value;

  LegendSearchableField(this.value);
}

class LegendSearchableString extends LegendSearchableField {
  final String value;
  LegendSearchableString(this.value) : super(value);
}

class LegendSearchableNumber extends LegendSearchableField {
  final num value;
  LegendSearchableNumber(this.value) : super(value);
}

enum Searchable {
  TEXT,
  VALUE,
}
