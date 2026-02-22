import 'package:json_schema_builder/json_schema_builder.dart';
import 'package:genui/genui.dart';

final _schema = S.object(
  properties: {
    'selections': A2uiSchemas.stringArrayReference(),
    'options': S.list(
      items: S.object(
        properties: {
          'label': A2uiSchemas.stringReference(),
          'value': S.string(),
        },
        required: ['label', 'value'],
      ),
    ),
    'maxAllowedSelections': S.integer(),
  },
  required: ['selections', 'options'],
);
