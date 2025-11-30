import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'bot_swarm.dart';

/// Listens to Firestore debug_control/community document to remotely control
/// the 100-bot demo swarm without requiring any user gesture or visible UI.
class DebugControlStore extends ChangeNotifier {
  final FirebaseFirestore _firestore;
  final BotSwarm _botSwarm;

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _sub;

  bool _demoBotSwarmEnabled = false;
  bool get demoBotSwarmEnabled => _demoBotSwarmEnabled;

  DebugControlStore({
    required FirebaseFirestore firestore,
    required BotSwarm botSwarm,
  })  : _firestore = firestore,
        _botSwarm = botSwarm;

  /// Call once when Community module is initialized.
  /// Starts listening to debug_control/community.demoBotSwarmEnabled field.
  void startListening() {
    if (_sub != null) return; // already listening

    final docRef = _firestore.collection('debug_control').doc('community');

    _sub = docRef.snapshots().listen((snapshot) {
      final data = snapshot.data();
      final enabled = (data?['demoBotSwarmEnabled'] as bool?) ?? false;
      _applyDemoBotSwarmFlag(enabled);
    }, onError: (error) {
      // Silent error - log only, never surface to UI
      debugPrint('DebugControlStore: Error listening to Firestore: $error');
    });
  }

  void _applyDemoBotSwarmFlag(bool enabled) {
    if (_demoBotSwarmEnabled == enabled) return;

    _demoBotSwarmEnabled = enabled;
    notifyListeners();

    if (enabled) {
      _botSwarm.startDemoBotSwarm();
    } else {
      _botSwarm.stopDemoBotSwarm();
    }
  }

  /// Optional helper to manually toggle from in-app debug console.
  /// Writes to Firestore, which triggers the listener above.
  Future<void> setDemoBotSwarmEnabled(bool enabled) async {
    try {
      await _firestore
          .collection('debug_control')
          .doc('community')
          .set({'demoBotSwarmEnabled': enabled}, SetOptions(merge: true));
    } catch (e) {
      // Silent error - log only, never surface to UI
      debugPrint('DebugControlStore: Error setting flag: $e');
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
