// Copyright 2025 The Flutter Authors.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import 'app/chat_screen.dart';
import 'debug/scenarios.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Configure logging for the app.
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    debugPrint('${record.level.name}: ${record.time}: ${record.message}');
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(seedColor: Colors.blue);
    return MaterialApp(
      title: 'Simple Chat Controller',
      theme: ThemeData(colorScheme: colorScheme),
      darkTheme: ThemeData(
        colorScheme: colorScheme.copyWith(brightness: Brightness.dark),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum _Screens { front, back }

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final _screen = ValueNotifier<_Screens>(_Screens.front);
  late final _tabController = TabController(length: 2, vsync: this);

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mirror'),
          actions: [_Switcher(_screen)],
        ),
        body: ValueListenableBuilder(
          valueListenable: _screen,
          builder: (context, value, child) {
            switch (value) {
              case _Screens.front:
                return const ChatScreen();
              case _Screens.back:
                return const DebugScreen();
            }
          },
        ),
      ),
    );
  }
}

class _Switcher extends StatelessWidget {
  const _Switcher(this.screen);

  final ValueNotifier<_Screens> screen;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: screen,
      builder: (context, value, child) {
        return SegmentedButton<_Screens>(
          showSelectedIcon: false,
          emptySelectionAllowed: false,
          multiSelectionEnabled: false,

          segments: [
            const ButtonSegment<_Screens>(
              value: _Screens.front,
              label: Text('Front'),
            ),
            const ButtonSegment<_Screens>(
              value: _Screens.back,
              label: Text('Back'),
            ),
          ],
          selected: {value},
          onSelectionChanged: (value) {
            screen.value = value.first;
          },
        );
      },
    );
  }
}
