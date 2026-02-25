import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

abstract class UiSchema<T extends UiElement> {
  final Schema schema;

  UiSchema({required this.schema});

  T parse(Object? json, DataModel dataModel);
}

/// Item definition constructed by AI, based on provided [UiSchema].
abstract class UiElement {
  UiElement();
}
