import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class LegendSearchable {
  final List<LegendSearchableField> fields;

  LegendSearchable({
    required this.fields,
  });
}

abstract class LegendSearchableFilter<T> {
  final T Function()? genValue;
  final int? singleField;
  final String? displayName;
  final List<int>? multipleFields;

  bool takeAll() {
    return singleField == null && multipleFields == null;
  }

  LegendSearchableFilter({
    this.singleField,
    this.multipleFields,
    this.genValue,
    this.displayName,
  });
}

class LegendSearchableFilterString extends LegendSearchableFilter<String> {
  final int? singleField;
  final List<int>? multipleFields;
  final bool ignoreCase;
  final String? displayName;

  LegendSearchableFilterString({
    this.singleField,
    this.multipleFields,
    this.ignoreCase = true,
    this.displayName,
  }) : super(
          singleField: singleField,
          multipleFields: multipleFields,
          genValue: () => "",
          displayName: displayName,
        );
}

class FilterCategoryData {
  final String value;
  final IconData? icon;

  FilterCategoryData({
    required this.value,
    this.icon,
  });
}

class LegendSearchableFilterCategory extends LegendSearchableFilter<String> {
  final int singleField;
  final String? displayName;
  final List<FilterCategoryData> categories;

  LegendSearchableFilterCategory({
    required this.singleField,
    this.displayName,
    required this.categories,
  }) : super(
          singleField: singleField,
          genValue: () => "",
          displayName: displayName,
        );
}

class LegendSearchableFilterRange extends LegendSearchableFilter<Tween<num>> {
  final int singleField;
  final Tween<num>? range;
  final String? displayName;

  LegendSearchableFilterRange({
    required this.singleField,
    this.displayName,
    this.range,
  }) : super(
          singleField: singleField,
          genValue: () => Tween<num>(begin: null, end: null),
          displayName: displayName,
        );
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

class LegendSearchableCategory extends LegendSearchableField {
  final String value;
  LegendSearchableCategory(this.value) : super(value);
}

enum Searchable {
  STRING,
  RANGE,
  CATEGORY,
}
