import 'package:flutter/foundation.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

import '../genui/schema.dart';

typedef ListNotifier<T> = ValueNotifier<List<T>>;

class ValueRef<T extends Object?> {
  ValueRef(this.ref);

  final Object? ref;
}

extension on DataModel {
  ListNotifier<T> listNotifier<T>(ValueRef<List<T>> ref) =>
      throw UnimplementedError();

  ValueNotifier<T> valueNotifier<T>(ValueRef<T> ref) =>
      throw UnimplementedError();
}

@immutable
final class OptionElement extends UiElement {
  OptionElement({required this.label, required this.value});

  final String label;
  final String value;
}

@immutable
final class OptionSchema extends UiSchema<OptionElement> {
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
  OptionElement parse(Object? json, DataModel dataModel) {
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
final class OptionsSchema extends UiSchema<OptionsElement> {
  OptionsSchema() : super(schema: _schema);

  static final _schema = S.list(items: OptionSchema().schema);

  @override
  OptionsElement parse(Object? json, DataModel dataModel) {
    final list = json as List<Object?>;
    return OptionsElement(
      options: list.map((e) => OptionSchema().parse(e, dataModel)).toList(),
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
final class OptionsPickerSchema extends UiSchema<OptionPickerElement> {
  OptionsPickerSchema() : super(schema: _schema);

  static final _schema = throw UnimplementedError();

  @override
  OptionPickerElement parse(Object? json, DataModel dataModel) {
    final map = json as Map<String, Object?>;
    if (map['variant'] == 'multipleSelection') {
      return MultipleOptionPickerElement(
        options: OptionsSchema().parse(json['options'], dataModel).options,
        selections: dataModel.listNotifier(ValueRef(json['selection'])),
      );
    } else {
      return SingleOptionPickerElement(
        options: OptionsSchema().parse(json['options'], dataModel).options,
        selection: dataModel.valueNotifier(ValueRef(json['selection'])),
      );
    }
  }
}

@immutable
final class SingleOptionPickerElement extends OptionPickerElement {
  SingleOptionPickerElement({required super.options, required this.selection});

  final ValueNotifier<String?> selection;
}

@immutable
final class MultipleOptionPickerElement extends OptionPickerElement {
  MultipleOptionPickerElement({
    required super.options,
    required this.selections,
    this.maxSelections,
  });

  final ListNotifier<List<String>> selections;
  final int? maxSelections;
}
