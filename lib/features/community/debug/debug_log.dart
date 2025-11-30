import 'package:flutter/foundation.dart';

/// A singleton that stores live logs from scoring, ML predictor,
/// diversity, explore–exploit, and bot activity.
/// UI will listen to this ValueNotifier to show a real-time feed.
class DebugLog {
  DebugLog._();
  static final DebugLog instance = DebugLog._();

  final ValueNotifier<List<String>> logs = ValueNotifier([]);

  void add(String message) {
    final time = DateTime.now().toIso8601String();
    logs.value = [
      "[$time] $message",
      ...logs.value,
    ];
  }

  void clear() {
    logs.value = [];
  }
}
