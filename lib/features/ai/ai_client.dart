import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'ai_env.dart';
import 'ai_models.dart';

class AiException implements Exception {
  final String message;
  AiException(this.message);
  @override
  String toString() => 'AiException: $message';
}

class AiClient {
  AiClient._();
  static final instance = AiClient._();

  late final GenerativeModel _model;
  bool _isInitialized = false;

  void _init() {
    if (_isInitialized) return;
    if (!AiEnv.hasValidKey) {
      throw AiException("Missing Gemini API Key in AiEnv");
    }
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: AiEnv.geminiApiKey,
      generationConfig: GenerationConfig(
        temperature: 0.7,
        responseMimeType: 'application/json',
      ),
    );
    _isInitialized = true;
  }

  // Helper to try fallback model if primary fails
  Future<GenerateContentResponse> _generateWithFallback(List<Content> content) async {
    try {
      return await _model.generateContent(content);
    } catch (e) {
      if (e.toString().contains("not found") || e.toString().contains("404")) {
        print("Primary model failed, trying fallback: gemini-pro");
        final fallbackModel = GenerativeModel(
          model: 'gemini-pro',
          apiKey: AiEnv.geminiApiKey,
          generationConfig: GenerationConfig(
            temperature: 0.7,
            // gemini-pro might not support JSON mode natively in all versions, 
            // but we'll try. If it fails, we might need to remove responseMimeType.
             responseMimeType: 'application/json',
          ),
        );
        return await fallbackModel.generateContent(content);
      }
      rethrow;
    }
  }

  // --- Template 1: Resume Parsing ---
  Future<Map<String, dynamic>> parseResume(String resumeText) async {
    _init();
    const systemPrompt = """
You are JobReady AI — an expert Hiring Manager + HR Professional + Career Coach.
Your role: Convert a user's resume into a structured candidate profile with zero hallucination.

RULES:
- Use only the resume text given.
- Never invent companies, projects, degrees, dates, achievements.
- Detect real information with high accuracy.
- Identify gaps, strengths, ATS keywords.
- Output only the JSON schema provided.

EXPECTED OUTPUT JSON SCHEMA:
{
  "summary": "string",
  "primaryIndustry": "string",
  "yearsExperience": "string",
  "roles": [
    { "title": "string", "company": "string", "start": "string", "end": "string", "achievements": ["string"] }
  ],
  "skills": ["string"],
  "education": [{ "degree": "string", "school": "string", "year": "string" }],
  "gaps": [{ "start": "string", "end": "string", "duration": "string" }],
  "strengths": ["string"],
  "riskAreas": ["string"],
  "keywords": ["string"]
}
""";

    final content = [Content.text("$systemPrompt\n\nRESUME TEXT:\n$resumeText")];
    
    try {
      final response = await _generateWithFallback(content);
      return _parseJson(response.text);
    } catch (e) {
      throw AiException("Failed to parse resume: $e");
    }
  }

  // --- Template 2: Application Writer ---
  Future<WriterResult> generateApplication({
    required Map<String, dynamic> profile,
    required String company,
    required String role,
    required String format, // cold_email | linkedin_note | cover_letter
    String jd = "",
  }) async {
    _init();
    const systemPrompt = """
You are JobReady AI — an expert career coach + senior HR + hiring manager.
Your role: Write personalized job application content.

RULES:
- NEVER invent experience not in the resume.
- Keep writing short, punchy, and recruiter-friendly.
- Do not use overly formal or robotic language.
- Tailor messaging directly to the job + resume strengths.
- Respect the selected format.

EXPECTED OUTPUT JSON SCHEMA:
{
  "content": "string (the actual email/note body)",
  "tone": "string",
  "usedSkills": ["string"],
  "matchedJDPoints": ["string"]
}
""";

    final userPrompt = """
Candidate Profile JSON: ${jsonEncode(profile)}
Format: $format
Company: $company
Role: $role
Job Description: $jd
""";

    final content = [Content.text("$systemPrompt\n\n$userPrompt")];

    try {
      final response = await _generateWithFallback(content);
      final json = _parseJson(response.text);
      return WriterResult.fromJson(json);
    } catch (e) {
      throw AiException("Failed to generate application: $e");
    }
  }

  // --- Template 3: Interview Questions ---
  Future<List<String>> generateInterviewQuestions({
    required Map<String, dynamic> profile,
    required String role,
    required String company,
    String jd = "",
  }) async {
    _init();
    const systemPrompt = """
You are JobReady AI — an elite interviewer.
Your task: Generate 10–15 personalized interview questions.

RULES:
- Must be diverse (Experience, Behavioral, Technical, Culture, Gaps).
- PERSONALIZED, not generic.
- NO "Tell me about yourself".

EXPECTED OUTPUT JSON SCHEMA:
{
  "questions": [
    {
      "id": "string",
      "text": "string (the question)",
      "category": "string",
      "difficulty": "string",
      "idealAnswerSummary": ["string"]
    }
  ]
}
""";

    final userPrompt = """
Candidate Profile JSON: ${jsonEncode(profile)}
Role: $role
Company: $company
Job Description: $jd
""";

    final content = [Content.text("$systemPrompt\n\n$userPrompt")];

    try {
      final response = await _generateWithFallback(content);
      final json = _parseJson(response.text);
      final questionsList = json['questions'] as List;
      // We return just the text for now to match UI, but could return full objects later
      return questionsList.map((q) => q['text'] as String).toList();
    } catch (e) {
      throw AiException("Failed to generate questions: $e");
    }
  }

  // --- Template 4: Answer Analysis ---
  Future<InterviewAnalysis> analyzeInterview({
    required String question,
    required String answer,
    required Map<String, dynamic> metrics, // wordCount, wpm, etc.
    Map<String, dynamic>? profile,
    String jd = "",
  }) async {
    _init();
    const systemPrompt = """
You are JobReady AI — a strict but fair hiring manager.
Your role: Evaluate the user's spoken interview answer.

RULES:
- Be precise and deeply analytical.
- Identify missing examples, metrics, clarity.
- Provide actionable suggestions.
- Do NOT be generic.

EXPECTED OUTPUT JSON SCHEMA:
{
  "scoreOverall": number (1-100),
  "scoreRelevance": number (1-100),
  "scoreDepth": number (1-100),
  "scoreExamples": number (1-100),
  "strengths": ["string"],
  "improvements": ["string"],
  "suggestedBetterAnswerOutline": ["string"]
}
""";

    final userPrompt = """
Question: $question
User Answer: $answer
Metrics: ${jsonEncode(metrics)}
Candidate Profile: ${profile != null ? jsonEncode(profile) : "{}"}
Job Description: $jd
""";

    final content = [Content.text("$systemPrompt\n\n$userPrompt")];

    try {
      final response = await _model.generateContent(content);
      final json = _parseJson(response.text);
      
      // Map to existing InterviewAnalysis model
      return InterviewAnalysis(
        relevance: (json['scoreRelevance'] as num).toDouble(),
        clarity: (json['scoreDepth'] as num).toDouble(), // Mapping depth to clarity
        overallScore: (json['scoreOverall'] as num).toDouble(),
        softskills: (json['scoreOverall'] as num).toDouble(), // Using overall as confidence proxy
        communication: metrics['wpm'] > 100 ? 90.0 : 70.0, // Simple heuristic for fluency
        pace: (metrics['wpm'] as num).toDouble(),
        improvements: List<String>.from(json['improvements']),
        feedbackMessage: "Strengths: ${(json['strengths'] as List).join(', ')}. \n\nSuggestion: ${(json['suggestedBetterAnswerOutline'] as List).join(' ')}", 
        correctness: (json['scoreExamples'] as num).toDouble(), // Mapping examples to correctness
        issues: [], // Empty list for issues
      );
    } catch (e) {
      throw AiException("Failed to analyze answer: $e");
    }
  }

  // Helper to parse JSON from Gemini response (handles markdown code blocks)
  Map<String, dynamic> _parseJson(String? text) {
    if (text == null) return {};
    String cleanText = text.trim();
    if (cleanText.startsWith('```json')) {
      cleanText = cleanText.substring(7);
    }
    if (cleanText.startsWith('```')) {
      cleanText = cleanText.substring(3);
    }
    if (cleanText.endsWith('```')) {
      cleanText = cleanText.substring(0, cleanText.length - 3);
    }
    return jsonDecode(cleanText);
  }
}

// AI CLIENT NOTE (2025-11-26):
// - All AI calls (Writer + Interview) now go through AiClient.
// - Backend uses Gemini-only (no OpenAI).
// - Response shape is aligned with existing HTTP functions.
