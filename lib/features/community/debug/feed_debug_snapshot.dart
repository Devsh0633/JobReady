class FeedDebugPostScore {
  final String postId;
  final String? title;
  final String industryTag;
  final double finalScore;
  final double ruleScore;
  final double mlScore;
  final double topicScore;
  final double industryScore;
  final double authorScore;
  final double engagementScore;
  final double freshnessScore;
  final double sessionScore;
  final double negativeScore;
  final double formatScore;
  final double reputationScore;
  final double proximityScore;
  final List<String> tags;
  final int rank;
  final String? reason; // short "why this post" explanation

  FeedDebugPostScore({
    required this.postId,
    required this.title,
    required this.industryTag,
    required this.finalScore,
    required this.ruleScore,
    required this.mlScore,
    required this.topicScore,
    required this.industryScore,
    required this.authorScore,
    required this.engagementScore,
    required this.freshnessScore,
    required this.sessionScore,
    required this.negativeScore,
    required this.formatScore,
    required this.reputationScore,
    required this.proximityScore,
    required this.tags,
    required this.rank,
    this.reason,
  });

  Map<String, dynamic> toJson() => {
    'postId': postId,
    'title': title,
    'industryTag': industryTag,
    'finalScore': finalScore,
    'ruleScore': ruleScore,
    'mlScore': mlScore,
    'topicScore': topicScore,
    'industryScore': industryScore,
    'authorScore': authorScore,
    'engagementScore': engagementScore,
    'freshnessScore': freshnessScore,
    'sessionScore': sessionScore,
    'negativeScore': negativeScore,
    'formatScore': formatScore,
    'reputationScore': reputationScore,
    'proximityScore': proximityScore,
    'tags': tags,
    'rank': rank,
    'reason': reason,
  };
}

class FeedDebugSnapshot {
  final String userId;
  final String? userDisplayName; // NEW: Human readable name
  final String personaId; // e.g. "real_user", "it_persona", etc.
  final String feedType;  // e.g. "for_you", "latest", "trending"
  final DateTime createdAt;
  final bool isColdStart;
  final List<FeedDebugPostScore> posts;
  final Map<String, dynamic> sessionSummary;

  FeedDebugSnapshot({
    required this.userId,
    this.userDisplayName,
    required this.personaId,
    required this.feedType,
    required this.createdAt,
    this.isColdStart = false,
    required this.posts,
    required this.sessionSummary,
  });

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'userDisplayName': userDisplayName,
    'personaId': personaId,
    'feedType': feedType,
    'createdAt': createdAt.toIso8601String(),
    'isColdStart': isColdStart,
    'posts': posts.map((p) => p.toJson()).toList(),
    'sessionSummary': sessionSummary,
  };
}
