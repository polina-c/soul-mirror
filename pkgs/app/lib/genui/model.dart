import 'package:json_schema_builder/json_schema_builder.dart';
import 'package:genui/genui.dart';

import 'schema.dart';

/// Stores state and user input of a catalog item.
abstract class ItemController {
  final DataModel dataModel;
  final String componentId;
  final String surfaceId;

  ItemController({
    required this.dataModel,
    required this.componentId,
    required this.surfaceId,
  });
}

/// Handles data processing and state management of a [GenUiItem].
abstract class GenUiItemController<T extends ItemSchema> {
  final ItemController controller;
  final T schema;

  GenUiItemController({required this.controller, required this.schema});
}

/// Implements rendering of a [GenUiItem].
abstract class GenUiItem<
  T extends ItemSchema,
  C extends GenUiItemController<T>
> {
  final C controller;

  GenUiItem({required this.controller});
}

class GenUiCatalog {
  final List<GenUiItem> items;

  GenUiCatalog({required this.items});
}
