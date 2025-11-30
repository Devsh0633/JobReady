class SpeechAnalysisResult {
  final int wordCount;
  final double wpm;
  final int fillerCount;
  final int pauseCount;
  final double longestPauseEstimate;
  final double volumeStability; // now a text-based proxy
  final double fluencyScore;
  final double confidenceScore;
  final double clarityScore;
  final double paceScore;
  final String transcript;
  
  // Sprint 10 Enhancements
  final double richness;
  final double repetitionRate;

  SpeechAnalysisResult({
    required this.wordCount,
    required this.wpm,
    required this.fillerCount,
    required this.pauseCount,
    required this.longestPauseEstimate,
    required this.volumeStability,
    required this.fluencyScore,
    required this.confidenceScore,
    required this.clarityScore,
    required this.paceScore,
    required this.transcript,
    required this.richness,
    required this.repetitionRate,
  });
}

class SpeechAnalyzer {
  static const List<String> fillerWords = [
    "um",
    "uh",
    "like",
    "basically",
    "actually",
    "you know",
    "so",
    "err",
  ];

  static SpeechAnalysisResult analyze({
    required String transcript,
    required double totalDurationSeconds,
  }) {
    final cleaned = transcript.trim();

    // Avoid divide-by-zero
    final safeDuration = totalDurationSeconds <= 0 ? 1.0 : totalDurationSeconds;

    // 1) Word count
    final words = cleaned.isEmpty
        ? <String>[]
        : cleaned.split(RegExp(r"\s+"));
    final wordCount = words.length;

    // 2) WPM
    final wpm = wordCount == 0 ? 0.0 : (wordCount / safeDuration) * 60.0;

    // 3) Filler count
    int fillerCount = 0;
    for (final filler in fillerWords) {
      fillerCount += RegExp("\\b$filler\\b", caseSensitive: false)
          .allMatches(cleaned)
          .length;
    }

    // 4) Estimated pauses via punctuation
    // Count '.', '?', '!' as potential pause markers
    final pauseMatches = RegExp(r"[\.!\?]+").allMatches(cleaned).length;
    final pauseCount = pauseMatches;

    // Estimate "longest pause" very roughly:
    // If there are pauses, approximate longest pause as a fraction of total time
    double longestPauseEstimate = 0.0;
    if (pauseCount > 0) {
      // Assume longest pause ~ 30–40% of avg segment duration
      final avgSegmentDuration = safeDuration / (pauseCount + 1);
      longestPauseEstimate = avgSegmentDuration * 0.4;
    }

    // 5) VolumeStability proxy (now based on how close WPM is to ideal range)
    // Ideal WPM for spoken answers: ~120–160
    final idealMin = 120.0;
    final idealMax = 160.0;
    double stabilityScore;
    if (wpm == 0) {
      stabilityScore = 0.3;
    } else if (wpm < idealMin) {
      stabilityScore = (wpm / idealMin).clamp(0.0, 1.0);
    } else if (wpm > idealMax) {
      stabilityScore = ((idealMax / wpm)).clamp(0.0, 1.0);
    } else {
      stabilityScore = 1.0;
    }
    
    // Sprint 10: Vocabulary Richness (Type-Token Ratio)
    final uniqueWords = words.map((w) => w.toLowerCase()).toSet();
    final richness = wordCount > 0 ? (uniqueWords.length / wordCount) * 100 : 0.0;

    // Sprint 10: Repetition Rate (Adjacent duplicates)
    int repeatCount = 0;
    for (int i = 1; i < words.length; i++) {
      if (words[i].toLowerCase() == words[i - 1].toLowerCase()) {
        repeatCount++;
      }
    }
    final repetitionRate = wordCount > 0 ? (repeatCount / wordCount) * 100 : 0.0;

    // 6) Scores (all clamped 10–100 to avoid ugly zeroes)
    // Fluency penalizes fillers + excessive pauses
    final fluencyRaw = 100 - (fillerCount * 5) - (pauseCount * 2);
    final fluencyScore = fluencyRaw.clamp(10, 100).toDouble();

    // Confidence uses stability proxy + low filler count
    final confidenceRaw = (stabilityScore * 100) - (fillerCount * 2);
    final confidenceScore = confidenceRaw.clamp(10, 100).toDouble();

    // Clarity penalizes super long estimated pauses
    final clarityRaw = 100 - (longestPauseEstimate * 10);
    final clarityScore = clarityRaw.clamp(10, 100).toDouble();

    // Pace based on how far WPM is from 140
    final paceRaw = 100 - (wpm - 140).abs();
    final paceScore = paceRaw.clamp(10, 100).toDouble();

    return SpeechAnalysisResult(
      wordCount: wordCount,
      wpm: wpm,
      fillerCount: fillerCount,
      pauseCount: pauseCount,
      longestPauseEstimate: longestPauseEstimate,
      volumeStability: stabilityScore,
      fluencyScore: fluencyScore,
      confidenceScore: confidenceScore,
      clarityScore: clarityScore,
      paceScore: paceScore,
      transcript: transcript,
      richness: richness,
      repetitionRate: repetitionRate,
    );
  }
}
