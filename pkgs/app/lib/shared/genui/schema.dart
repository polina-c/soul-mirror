import 'package:json_schema_builder/json_schema_builder.dart';

abstract class ElementSchema<T extends ElementDef> {
  final Schema schema;

  ElementSchema({required this.schema});

  T parse(Object? json);
}

/// Item definition constructed by AI, based on provided [ElementSchema].
abstract class ElementDef {
  ElementDef();
}
