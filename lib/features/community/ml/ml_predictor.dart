import 'package:flutter/foundation.dart';
import 'ml_features.dart';

/// Discrete label for how likely a user is to meaningfully engage with a post.
enum EngagementLikelihood {
  low,
  medium,
  high,
}

/// Bundle returned by the lite-ML predictor.
class EngagementPrediction {
  final double probability; // 0.0 – 1.0
  final EngagementLikelihood bucket;
  final String explanation;

  const EngagementPrediction({
    required this.probability,
    required this.bucket,
    required this.explanation,
  });
}

/// Lite ML-style engagement predictor.
/// Combines the MLScoreBreakdown with a couple of simple behavioral
/// signals (like dwell time, expansions) to simulate an ML model.
///
/// This is NOT a real trained model, but its structure mirrors one,
/// which is perfect for a hackathon demo.
EngagementPrediction predictEngagement({
  required MLScoreBreakdown score,
  int dwellTimeMs = 0,
  bool expanded = false,
  bool openedComments = false,
}) {
  // Start from ML probabilityScore (already a 0–1-ish value)
  double p = score.probabilityScore;

  // Dwell time: >2.5 seconds = stronger interest
  if (dwellTimeMs > 2500) {
    p += 0.10;
  }

  // Expanded post (e.g. tap "see more")
  if (expanded) {
    p += 0.08;
  }

  // Opened comments = strong interest signal
  if (openedComments) {
    p += 0.12;
  }

  // Clamp to [0,1]
  p = p.clamp(0.0, 1.0);

  // Bucketization
  EngagementLikelihood bucket;
  if (p < 0.33) {
    bucket = EngagementLikelihood.low;
  } else if (p < 0.66) {
    bucket = EngagementLikelihood.medium;
  } else {
    bucket = EngagementLikelihood.high;
  }

  // Explanation for Debug Console
  final List<String> reasons = [];

  if (score.cosineSimilarity > 0.5) {
    reasons.add('Strong topic match with user interests');
  } else if (score.cosineSimilarity > 0.2) {
    reasons.add('Moderate topic match');
  } else {
    reasons.add('Weak topic match');
  }

  if (dwellTimeMs > 2500) {
    reasons.add('User lingered on this post (high dwell time)');
  }

  if (expanded) {
    reasons.add('User expanded the post content');
  }

  if (openedComments) {
    reasons.add('User opened comments');
  }

  if (score.ruleScore > 0) {
    reasons.add('Rule-based score contributed positively');
  }

  if (reasons.isEmpty) {
    reasons.add('Limited signals so far – exploration candidate');
  }

  final explanation = reasons.join(' · ');

  if (kDebugMode) {
    // Optional logging for development; safe to leave in.
    debugPrint(
      '[EngagementPrediction] prob=${p.toStringAsFixed(2)}, '
      'bucket=$bucket, reasons=$explanation',
    );
  }

  return EngagementPrediction(
    probability: p,
    bucket: bucket,
    explanation: explanation,
  );
}
