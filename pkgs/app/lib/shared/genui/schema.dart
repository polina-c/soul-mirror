import 'package:json_schema_builder/json_schema_builder.dart';

abstract class UiElementSchema<T extends UiElement> {
  final Schema schema;

  UiElementSchema({required this.schema});

  T parse(Object? json);
}

/// Item definition constructed by AI, based on provided [UiElementSchema].
abstract class UiElement {
  UiElement();
}
