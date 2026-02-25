import 'package:flutter/foundation.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

import '../genui/schema.dart';

@immutable
final class OptionElement extends UiElement {
  OptionElement({required this.label, required this.value});

  final String label;
  final String value;
}

@immutable
final class OptionSchema extends UiElementSchema<OptionElement> {
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
  OptionElement parse(Object? json) {
    final map = json as Map<String, Object?>;
    return OptionElement(
      label: map['label'] as String,
      value: map['value'] as String,
    );
  }

  JsonMap? create(String label, String value) {
    return {'label': label, 'value': value};
  }
}

@immutable
final class OptionsSchema extends UiElementSchema<OptionsElement> {
  OptionsSchema() : super(schema: _schema);

  static final _schema = S.list(items: OptionSchema().schema);

  @override
  OptionsElement parse(Object? json) {
    final list = json as List<Object?>;
    return OptionsElement(
      options: list.map((e) => OptionSchema().parse(e)).toList(),
    );
  }
}

@immutable
final class OptionsElement extends UiElement {
  OptionsElement({required this.options});

  final List<OptionElement> options;
}

@immutable
sealed class OptionPickerElement extends UiElement {
  OptionPickerElement({required this.options});

  final List<OptionElement> options;
}

@immutable
final class SingleOptionPickerElement extends OptionPickerElement {
  SingleOptionPickerElement({required super.options, this.selection});

  final String? selection;
}

@immutable
final class MultipleOptionPickerElement extends OptionPickerElement {
  MultipleOptionPickerElement({
    required super.options,
    required this.selections,
    this.maxSelections,
  });

  final List<String> selections;
  final int? maxSelections;
}
