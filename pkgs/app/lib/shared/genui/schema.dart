import 'package:json_schema_builder/json_schema_builder.dart';

abstract class ItemSchema<T extends ItemDefinition> {
  final Schema schema;
  final String name;

  ItemSchema({required this.schema, required this.name});

  T parse(Map<String, dynamic> json);
}

/// Item definition constructed by AI, based on provided [ItemSchema].
abstract class ItemDefinition {
  ItemDefinition();
}
