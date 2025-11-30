class WriterResult {
  final String subject;
  final String body;
  final List<String> suggestions;

  WriterResult({
    required this.subject,
    required this.body,
    required this.suggestions,
  });

  factory WriterResult.fromJson(Map<String, dynamic> json) {
    return WriterResult(
      subject: json['subject'] ?? '',
      body: json['content'] ?? json['body'] ?? '',
      suggestions: (json['matchedJDPoints'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          (json['suggestions'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subject': subject,
      'body': body,
      'suggestions': suggestions,
    };
  }
}

class InterviewAnalysis {
  final double overallScore;
  final double relevance;
  final double correctness;
  final double clarity;
  final double communication;
  final double softskills;
  final List<String> issues;
  final List<String> improvements;
  final String feedbackMessage;
  final double pace; // Calculated locally (WPM)

  // UI Mappings
  double get fluency => communication;
  double get confidence => softskills;
  double get relevanceScore => relevance;
  double get contentScore => correctness; // Mapping correctness to contentScore
  List<String> get tips => improvements;

  InterviewAnalysis({
    required this.overallScore,
    required this.relevance,
    required this.correctness,
    required this.clarity,
    required this.communication,
    required this.softskills,
    required this.issues,
    required this.improvements,
    this.pace = 0.0,
    this.feedbackMessage = '',
  });

  factory InterviewAnalysis.fromJson(Map<String, dynamic> json) {
    // Handle new schema (Template 4)
    if (json.containsKey('scoreOverall')) {
      return InterviewAnalysis(
        overallScore: (json['scoreOverall'] as num?)?.toDouble() ?? 0.0,
        relevance: (json['scoreRelevance'] as num?)?.toDouble() ?? 0.0,
        correctness: (json['scoreExamples'] as num?)?.toDouble() ?? 0.0, // Map examples to correctness
        clarity: (json['scoreDepth'] as num?)?.toDouble() ?? 0.0, // Map depth to clarity
        communication: 85.0, // Default high if not measured by text AI
        softskills: 85.0, // Default high
        issues: [],
        improvements: (json['improvements'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
        feedbackMessage: "Strengths: ${(json['strengths'] as List?)?.join(', ') ?? 'None'}\n\nBetter Answer: ${(json['suggestedBetterAnswerOutline'] as List?)?.join('\n- ') ?? ''}",
        pace: (json['pace'] as num?)?.toDouble() ?? 0.0,
      );
    }

    // Fallback to old schema
    return InterviewAnalysis(
      overallScore: (json['overallScore'] as num?)?.toDouble() ?? 0.0,
      relevance: (json['relevance'] as num?)?.toDouble() ?? 0.0,
      correctness: (json['correctness'] as num?)?.toDouble() ?? 0.0,
      clarity: (json['clarity'] as num?)?.toDouble() ?? 0.0,
      communication: (json['communication'] as num?)?.toDouble() ?? 0.0,
      softskills: (json['softskills'] as num?)?.toDouble() ?? 0.0,
      issues: (json['issues'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      improvements: (json['improvements'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      pace: (json['pace'] as num?)?.toDouble() ?? 0.0,
      feedbackMessage: json['feedbackMessage'] ?? '',
    );
  }

  InterviewAnalysis copyWith({
    double? overallScore,
    double? relevance,
    double? correctness,
    double? clarity,
    double? communication,
    double? softskills,
    List<String>? issues,
    List<String>? improvements,
    double? pace,
    String? feedbackMessage,
  }) {
    return InterviewAnalysis(
      overallScore: overallScore ?? this.overallScore,
      relevance: relevance ?? this.relevance,
      correctness: correctness ?? this.correctness,
      clarity: clarity ?? this.clarity,
      communication: communication ?? this.communication,
      softskills: softskills ?? this.softskills,
      issues: issues ?? this.issues,
      improvements: improvements ?? this.improvements,
      pace: pace ?? this.pace,
      feedbackMessage: feedbackMessage ?? this.feedbackMessage,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'overallScore': overallScore,
      'relevance': relevance,
      'correctness': correctness,
      'clarity': clarity,
      'communication': communication,
      'softskills': softskills,
      'issues': issues,
      'improvements': improvements,
      'pace': pace,
      'feedbackMessage': feedbackMessage,
    };
  }
}
