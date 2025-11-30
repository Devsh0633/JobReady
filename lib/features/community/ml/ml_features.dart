/// Lightweight vector-based ML representation for Feed Ranking.
/// Works entirely offline, optimized for mobile.
class UserVector {
  final Map<String, double> topicWeights;
  final Map<String, double> formatWeights;
  final Map<String, double> communityWeights;
  final double recencyBias;

  const UserVector({
    required this.topicWeights,
    required this.formatWeights,
    required this.communityWeights,
    required this.recencyBias,
  });

  factory UserVector.empty() {
    return const UserVector(
      topicWeights: {},
      formatWeights: {},
      communityWeights: {},
      recencyBias: 1.0,
    );
  }
}

/// Vector representing a post's semantic & behavioral attributes.
class PostVector {
  final List<String> topicTags;
  final String format;
  final String communityId;
  final int likeCount;
  final int commentCount;
  final DateTime createdAt;

  const PostVector({
    required this.topicTags,
    required this.format,
    required this.communityId,
    required this.likeCount,
    required this.commentCount,
    required this.createdAt,
  });
}

/// Combined ML scoring bundle – used by the Debug Console to visualize internals.
class MLScoreBreakdown {
  final double cosineSimilarity;
  final double probabilityScore;
  final double ruleScore;
  final double finalBlendedScore;

  final Map<String, double> details;

  const MLScoreBreakdown({
    required this.cosineSimilarity,
    required this.probabilityScore,
    required this.ruleScore,
    required this.finalBlendedScore,
    required this.details,
  });
}
