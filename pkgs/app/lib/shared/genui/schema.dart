import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

import '../catalog/option_picker.dart';

abstract class ComponentDecoder<T extends Object> {
  final Schema schema;

  ComponentDecoder({required this.schema});

  T decode(Object? json, ComponentContext context);
}

class ComponentContext {
  ListNotifier<T> listNotifier<T>(ValueRef<List<T>> ref) =>
      throw UnimplementedError();

  ValueNotifier<T> valueNotifier<T>(ValueRef<T> ref) =>
      throw UnimplementedError();
}
