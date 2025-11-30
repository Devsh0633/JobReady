import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'feed_debug_snapshot.dart';
import 'debug_log.dart';

/// Global store for scoring snapshots used by the debug console.
class ScoreDebugStore extends ChangeNotifier {
  ScoreDebugStore._();
  static final ScoreDebugStore instance = ScoreDebugStore._();

  final _firestore = FirebaseFirestore.instance;

  bool _isDebugStreamingEnabled = false;
  bool get isDebugStreamingEnabled => _isDebugStreamingEnabled;

  FeedDebugSnapshot? _lastSnapshot;
  FeedDebugSnapshot? get lastSnapshot => _lastSnapshot;

  void setDebugStreamingEnabled(bool enabled) {
    _isDebugStreamingEnabled = enabled;
    debugPrint("ScoreDebugStore: Streaming enabled for community feed");
    notifyListeners();
  }

  /// Automatically enable streaming when Community Feed is accessed.
  /// This is called from CommunityStore and does not require UI interaction.
  /// Safe to call multiple times - only enables once.
  void ensureStreamingForCommunityFeed() {
    if (_isDebugStreamingEnabled) return;
    _isDebugStreamingEnabled = true;
    // No notifyListeners() - this is background-only, no UI update needed
  }

  void pushFeedDebugSnapshot(FeedDebugSnapshot snapshot) {
    _lastSnapshot = snapshot;
    notifyListeners();

    if (!_isDebugStreamingEnabled) return;

    // 1) Log locally (for development)
    DebugLog.instance.add('Snapshot generated: ${snapshot.posts.length} posts');
    
    // 2) Send to backend
    _sendSnapshotToBackend(snapshot.toJson());
  }

  Future<void> _sendSnapshotToBackend(Map<String, dynamic> json) async {
    try {
      // Add server timestamp
      final data = Map<String, dynamic>.from(json);
      data['createdAt'] = FieldValue.serverTimestamp();

      await _firestore.collection('feed_debug_snapshots').add(data);
      DebugLog.instance.add('Snapshot sent to Firestore');
    } catch (e) {
      DebugLog.instance.add('Error sending snapshot: $e');
      debugPrint('FeedDebugSnapshotError: $e');
    }
  }
  
  void clear() {
    _lastSnapshot = null;
    notifyListeners();
  }
}
