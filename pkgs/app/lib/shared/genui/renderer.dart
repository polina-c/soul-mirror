import 'package:flutter/widgets.dart';
import 'package:genui/genui.dart';

import 'schema.dart';

/// An update of the data model.
abstract class DataModelUpdate {}

/// Controller of a component.
///
/// Handles data processing and state management.
abstract class ComponentController<D extends ElementDef> {
  final DataModel dataModel;
  final String componentId;
  final String surfaceId;
  final D def;

  ComponentController({
    required this.dataModel,
    required this.componentId,
    required this.surfaceId,
    required this.def,
  });

  /// Saves input to the data model.
  ///
  /// [T] should be serializable.
  void saveInput<T>(String path, T? input) => throw UnimplementedError();

  /// Loads input from the data model.
  ///
  /// [T] should be serializable.
  T? loadInput<T>(String path) => throw UnimplementedError();

  /// Stream of updates of the data model.
  ///
  /// If an update is triggered by [saveInput] or [action] of this instance,
  /// the stream will emit the update.
  Stream<DataModelUpdate> get updates => throw UnimplementedError();

  /// Returns state of the component.
  ///
  /// If it does not exist, it will be created with [builder].
  T state<T>(T Function() builder) => throw UnimplementedError();

  /// Triggers an action.
  void action(String actionId) => throw UnimplementedError();

  WidgetBuilder childBuilder(String componentId) => throw UnimplementedError();
}
