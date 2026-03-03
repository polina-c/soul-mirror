import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

abstract class ComponentDecoder<T extends ComponentData> {
  final Schema schema;

  ComponentDecoder({required this.schema});

  T parse(Object? json, DataModel dataModel);
}

/// Item definition constructed by AI, based on [ComponentDecoder.schema].
abstract class ComponentData {
  ComponentData();
}
