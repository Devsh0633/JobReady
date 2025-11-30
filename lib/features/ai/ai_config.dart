// AI Configuration
// Replace with your actual Firebase Cloud Functions base URL
const String kAiBaseUrl = "https://us-central1-jobready-community.cloudfunctions.net";

class AiEndpoints {
  static String get writerGenerate => "$kAiBaseUrl/writerGenerate";
  static String get writerShorten => "$kAiBaseUrl/writerShorten";
  static String get writerExpand => "$kAiBaseUrl/writerExpand";
  static String get writerFormal => "$kAiBaseUrl/writerFormal";
  static String get writerSimplify => "$kAiBaseUrl/writerSimplify";
  static String get interviewAnalyze => "$kAiBaseUrl/interviewAnalyze";
}
