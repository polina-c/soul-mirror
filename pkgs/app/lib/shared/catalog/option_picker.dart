import 'package:flutter/foundation.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

import '../genui/schema.dart';

@immutable
final class OptionDef extends ElementDef {
  OptionDef({required this.label, required this.value});

  final String label;
  final String value;
}

@immutable
final class OptionSchema extends ElementSchema<OptionDef> {
  OptionSchema() : super(schema: _schema);

  static final _schema = S.object(
    properties: {
      'label': S.string(description: 'The text to display for this option.'),
      'value': S.string(
        description: 'The stable value associated with this option.',
      ),
    },
    required: ['label', 'value'],
  );

  @override
  OptionDef parse(Object? json) {
    final map = json as Map<String, Object?>;
    return OptionDef(
      label: map['label'] as String,
      value: map['value'] as String,
    );
  }

  JsonMap? create(String label, String value) {
    return {'label': label, 'value': value};
  }
}

@immutable
final class OptionsSchema extends ElementSchema<OptionsDef> {
  OptionsSchema() : super(schema: _schema);

  static final _schema = S.list(items: OptionSchema().schema);

  @override
  OptionsDef parse(Object? json) {
    final list = json as List<Object?>;
    return OptionsDef(
      options: list.map((e) => OptionSchema().parse(e)).toList(),
    );
  }
}

@immutable
final class OptionsDef extends ElementDef {
  OptionsDef({required this.options});

  final List<OptionDef> options;
}

@immutable
sealed class OptionPickerDef extends ElementDef {
  OptionPickerDef({required this.options});

  final List<OptionDef> options;
}

@immutable
final class SingleOptionPickerDef extends OptionPickerDef {
  SingleOptionPickerDef({required super.options, this.selection});

  final String? selection;
}

@immutable
final class MultipleOptionPickerDef extends OptionPickerDef {
  MultipleOptionPickerDef({
    required super.options,
    required this.selections,
    this.maxSelections,
  });

  final List<String> selections;
  final int? maxSelections;
}
