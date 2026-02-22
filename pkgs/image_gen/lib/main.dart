import 'package:dartantic_ai/dartantic_ai.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: ElevatedButton(onPressed: generate, child: Text('Generate')),
        ),
      ),
    );
  }
}

void generate() async {
  // Create an agent with your preferred provider
  final agent = Agent.forProvider(GoogleProvider(apiKey: getApiKey()));

  // Generate text
  final result = await agent.send(
    'Explain quantum computing in simple terms',
    history: [ChatMessage.system('You are a helpful assistant.')],
  );
  print(result.output);

  // Use typed outputs with json_schema_builder
  final location = await agent.sendFor<TownAndCountry>(
    'The windy city in the US',
    outputSchema: S.object(
      properties: {'town': S.string(), 'country': S.string()},
      required: ['town', 'country'],
    ),
    outputFromJson: TownAndCountry.fromJson,
  );
  print('${location.output.town}, ${location.output.country}');
}

class TownAndCountry {
  final String town;
  final String country;

  TownAndCountry({required this.town, required this.country});

  factory TownAndCountry.fromJson(Map<String, Object?> json) => TownAndCountry(
    town: json['town'] as String,
    country: json['country'] as String,
  );
}
