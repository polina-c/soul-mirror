import 'package:flutter/widgets.dart';
import 'package:genui/genui.dart';

import 'schema.dart';

/// An update of the data model.
abstract class DataModelUpdate {}

class ComponentAddress {
  final String surfaceId;
  final String componentId;

  ComponentAddress({required this.surfaceId, required this.componentId});
}

typedef ComponentBuilder = Widget Function(ComponentAddress id);

class ComponentContext<C extends ComponentController> {
  final C controller;
  final ComponentBuilder childBuilder;

  ComponentContext({required this.controller, required this.childBuilder});
}

/// Controller of a component.
///
/// Handles data processing and state management.
abstract class ComponentController<D extends UiElement> {
  final DataModel dataModel;
  final ComponentAddress address;
  final D def;

  ComponentController({
    required this.dataModel,
    required this.address,
    required this.def,
  });

  /// Saves input to the data model.
  ///
  /// Save input every time the user changes the input, so that it is picked up
  /// when:
  /// - It is time to communicate input to AI.
  /// - When this component is re-rendered.
  ///
  /// [T] should be serializable.
  void saveInput<T>(String path, T? input) => throw UnimplementedError();

  /// Loads input from the data model.
  ///
  /// Widgets, that collect user input, should load the collected data
  /// in `init`, to pick up input, collected by previous renders of the widget.
  ///
  /// [T] should be serializable.
  T? loadInput<T>(String path) => throw UnimplementedError();

  /// Stream of updates of the data model.
  ///
  /// Subscribe to this stream if the component implementation
  /// depends on the changes in other places of application.
  /// This subscription is not needed for simple cases.
  ///
  /// If an update is triggered by [saveInput] or [action] of this instance,
  /// the stream will emit the update.
  Stream<DataModelUpdate> get updates => throw UnimplementedError();

  /// Returns state of the component.
  ///
  /// State of the component is data, that is not user input,
  /// but should persist between renders. For example, scroll position.
  ///
  /// If the state object does not exist, it will be created with [builder].
  T state<T>(T Function() builder) => throw UnimplementedError();

  /// Triggers an action.
  void action(String actionId) => throw UnimplementedError();

  WidgetBuilder childBuilder(String componentId) => throw UnimplementedError();

  void dispose() => throw UnimplementedError();
}
