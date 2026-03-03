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
final class OptionData extends ComponentData {
  OptionData({required this.label, required this.value});

  final String label;
  final String value;
}

@immutable
final class OptionDecoder extends ComponentDecoder<OptionData> {
  OptionDecoder() : super(schema: _schema);

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
  OptionData parse(Object? json, DataModel dataModel) {
    final map = json as Map<String, Object?>;
    return OptionData(
      label: map['label'] as String,
      value: map['value'] as String,
    );
  }

  JsonMap? create(String label, String value) {
    return {'label': label, 'value': value};
  }
}

@immutable
final class OptionsDecoder extends ComponentDecoder<OptionsData> {
  OptionsDecoder() : super(schema: _schema);

  static final _schema = S.list(items: OptionDecoder().schema);

  @override
  OptionsData parse(Object? json, DataModel dataModel) {
    final list = json as List<Object?>;
    return OptionsData(
      options: list.map((e) => OptionDecoder().parse(e, dataModel)).toList(),
    );
  }
}

@immutable
final class OptionsData extends ComponentData {
  OptionsData({required this.options});

  final List<OptionData> options;
}

@immutable
sealed class OptionPickerData extends ComponentData {
  OptionPickerData({required this.options});

  final List<OptionData> options;
}

@immutable
final class OptionsPickerDecoder extends ComponentDecoder<OptionPickerData> {
  OptionsPickerDecoder() : super(schema: _schema);

  static final _schema = throw UnimplementedError();

  @override
  OptionPickerData parse(Object? json, DataModel dataModel) {
    final map = json as Map<String, Object?>;
    if (map['variant'] == 'multipleSelection') {
      return MultipleOptionPickerData(
        options: OptionsDecoder().parse(json['options'], dataModel).options,
        selections: dataModel.listNotifier(ValueRef(json['selection'])),
      );
    } else {
      return SingleOptionPickerData(
        options: OptionsDecoder().parse(json['options'], dataModel).options,
        selection: dataModel.valueNotifier(ValueRef(json['selection'])),
      );
    }
  }
}

@immutable
final class SingleOptionPickerData extends OptionPickerData {
  SingleOptionPickerData({required super.options, required this.selection});

  final ValueNotifier<String?> selection;
}

@immutable
final class MultipleOptionPickerData extends OptionPickerData {
  MultipleOptionPickerData({
    required super.options,
    required this.selections,
    this.maxSelections,
  });

  final ListNotifier<List<String>> selections;
  final int? maxSelections;
}
