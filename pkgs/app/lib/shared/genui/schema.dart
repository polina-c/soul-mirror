import 'package:json_schema_builder/json_schema_builder.dart';

abstract class ElementSchema<T extends ElementDef> {
  final Schema schema;
  final String name;

  ElementSchema({required this.schema, required this.name});

  T parse(Map<String, dynamic> json);
}

/// Item definition constructed by AI, based on provided [ElementSchema].
abstract class ElementDef {
  ElementDef();
}
