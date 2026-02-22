import 'package:genui/genui.dart';

final appCatalog = Catalog(
  [
    BasicCatalogItems.button,
    BasicCatalogItems.card,
    BasicCatalogItems.checkBox,
    BasicCatalogItems.column,
    BasicCatalogItems.dateTimeInput,
    BasicCatalogItems.divider,
    BasicCatalogItems.icon,
    BasicCatalogItems.image,
    BasicCatalogItems.list,
    BasicCatalogItems.modal,
    BasicCatalogItems.choicePicker,
    BasicCatalogItems.row,
    BasicCatalogItems.slider,
    BasicCatalogItems.tabs,
    BasicCatalogItems.text,
    BasicCatalogItems.textField,
  ],
  functions: BasicCatalogItems.asCatalog().functions,
  catalogId: 'soul-mirror-catalog-id',
);
