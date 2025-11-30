import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../ui/widgets/ad_banner.dart';
import '../../ai/ai_client.dart';
import '../../ai/ai_models.dart';
import '../../community/presentation/new_thread_screen.dart';
import '../../community/data/community_post_model.dart';
import '../../practice_interview/data/interview_questions.dart';
import '../../auth/user_profile.dart';
import '../../profile/candidate_profile.dart';
import '../../profile/candidate_profile_service.dart';
class SpeakerScreen extends StatefulWidget {
  const SpeakerScreen({super.key});

  @override
  State<SpeakerScreen> createState() => _SpeakerScreenState();
}

class _SpeakerScreenState extends State<SpeakerScreen> {
  // State Variables
  String _currentQuestion = "Tap 'Next Question' to start.";
  final _textController = TextEditingController();
  String _industry = "IT & Software";
  bool _isInitialized = false;
  
  // Timer & Analysis
  Timer? _timer;
  int _elapsedSeconds = 0;
  bool _isTimerRunning = false;
  bool _isAnalyzing = false;
  
  // Job Setup State
  bool _isJobSetupComplete = false;
  bool _isGeneratingQuestions = false;
  final _companyController = TextEditingController();
  final _roleController = TextEditingController();
  final _jdController = TextEditingController();
  CandidateProfile? _candidateProfile;
  List<String> _generatedQuestions = [];
  int _currentQuestionIndex = 0;

  // Analysis Results
  InterviewAnalysis? _analysis;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is String) {
        _industry = args;
      } else if (args is Map) {
        _industry = args['industry'] ?? "IT & Software";
        final profile = args['profile'] as UserProfile?;
        if (profile != null) {
          _loadCandidateProfile(profile.id);
        }
      }
      _isInitialized = true;
    }
  }

  Future<void> _loadCandidateProfile(String userId) async {
    final service = CandidateProfileService();
    final profile = await service.getProfile(userId);
    if (profile != null && mounted) {
      setState(() {
        _candidateProfile = profile;
      });
    }
  }

  @override
  void dispose() {
    _companyController.dispose();
    _roleController.dispose();
    _jdController.dispose();
    super.dispose();
  }

  Future<void> _startPractice() async {
    if (_roleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a target role')),
      );
      return;
    }

    setState(() => _isGeneratingQuestions = true);



    try {
      final questions = await AiClient.instance.generateInterviewQuestions(
        profile: _candidateProfile?.toJson() ?? {},
        role: _roleController.text,
        company: _companyController.text,
        jd: _jdController.text,
      );

      if (mounted) {
        setState(() {
          _generatedQuestions = questions;
          _isJobSetupComplete = true;
          _isGeneratingQuestions = false;
          _currentQuestion = questions.isNotEmpty ? questions.first : "Ready to start.";
          _currentQuestionIndex = 0;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isGeneratingQuestions = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to generate questions. Using standard set.')),
        );
        // Fallback to standard flow
        setState(() => _isJobSetupComplete = true);
      }
    }
  }

  void _nextQuestion() {
    if (_generatedQuestions.isNotEmpty) {
      setState(() {
        _currentQuestionIndex = (_currentQuestionIndex + 1) % _generatedQuestions.length;
        _currentQuestion = _generatedQuestions[_currentQuestionIndex];
        _resetState();
      });
      return;
    }

    final questions = questionsByIndustry[_industry] ?? hrQuestions;
    
    if (questions.isEmpty) {
      setState(() {
        _currentQuestion = "No questions found for $_industry";
      });
      return;
    }
    
    setState(() {
      // Create a new list to shuffle to avoid modifying the original if it were mutable
      final List<String> shuffled = List.from(questions)..shuffle();
      _currentQuestion = shuffled.first;
      _resetState();
    });
  }

  void _resetState() {
    _timer?.cancel();
    _textController.clear();
    _elapsedSeconds = 0;
    _isTimerRunning = false;
    _isAnalyzing = false;
    _analysis = null;
    setState(() {});
  }

  void _startAnswer() {
    _resetState(); // Clear previous
    setState(() => _isTimerRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => _elapsedSeconds++);
    });
  }

  void _stopAndAnalyze() {
    _timer?.cancel();
    setState(() => _isTimerRunning = false);
    
    // Show Ad Gate before analysis
    _handleAdGate(() {
      _analyzeText();
    });
  }

  Future<void> _handleAdGate(VoidCallback onSuccess) async {
    int countdown = 10;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          // Start timer inside the dialog if not already running
          // But StatefulBuilder rebuilds, so we need a way to tick.
          // Actually, let's use a Timer here.
          Timer.periodic(const Duration(seconds: 1), (timer) {
            if (countdown > 0) {
              if (context.mounted) {
                 setState(() => countdown--);
              }
            } else {
              timer.cancel();
              if (context.mounted) {
                Navigator.pop(context); // Close dialog
                onSuccess(); // Run success callback
              }
            }
          });

          return AlertDialog(
            title: const Text("Ad Break"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.play_circle_outline, size: 48, color: Color(0xFF1A237E)),
                const SizedBox(height: 16),
                Text("Watching Ad...", style: GoogleFonts.inter()),
                const SizedBox(height: 8),
                Text(
                  "$countdown s",
                  style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text("Analysis will start automatically.", style: GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _analyzeText() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    setState(() => _isAnalyzing = true);

    // 1. Local Metrics Calculation
    final words = text.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    final wordCount = words.length;
    final durationMin = _elapsedSeconds / 60.0;
    final wpm = durationMin > 0 ? (wordCount / durationMin) : 0.0;
    
    try {


      // 2. AI Analysis (Backend)
      final aiResult = await AiClient.instance.analyzeInterview(
        question: _currentQuestion,
        answer: text,
        metrics: {
          "wordCount": wordCount,
          "wpm": wpm,
          "durationSeconds": _elapsedSeconds,
        },
        profile: _candidateProfile?.toJson(),
        jd: _jdController.text,
      );

      setState(() {
        _analysis = aiResult.copyWith(
          pace: wpm, // Use local WPM as it's more accurate
        );
        _isAnalyzing = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('AI server unavailable. Please check your internet or API key.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isAnalyzing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        title: Text('Voice Analysis', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!_isJobSetupComplete) ...[
              // Job Setup Wizard
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Job Setup',
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1A237E),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'We\'ll generate personalized questions based on this role and your resume.',
                      style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _companyController,
                      decoration: const InputDecoration(
                        labelText: 'Target Company (Optional)',
                        prefixIcon: Icon(Icons.business),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _roleController,
                      decoration: const InputDecoration(
                        labelText: 'Target Role',
                        prefixIcon: Icon(Icons.work_outline),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _jdController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Job Description (Optional)',
                        hintText: 'Paste JD here...',
                        prefixIcon: Icon(Icons.description),
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isGeneratingQuestions ? null : _startPractice,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1A237E),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: _isGeneratingQuestions
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('Start Practice Interview'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          setState(() => _isJobSetupComplete = true);
                        },
                        child: const Text('Skip Setup (Use Standard Questions)'),
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
            // Question Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1A237E), Color(0xFF3949AB)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1A237E).withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "Interview Question",
                      style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _currentQuestion,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _isTimerRunning ? null : () {
                      _nextQuestion();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('✓ New question loaded!'),
                          duration: Duration(seconds: 1),
                          backgroundColor: Color(0xFF43A047),
                        ),
                      );
                    },
                    icon: const Icon(Icons.refresh, size: 20),
                    label: Text("Next Question", style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: const Color(0xFF1A237E),
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Instructions
            Text(
              "Step 1: Tap 'Start Answer' & use keyboard mic to dictate.\nStep 2: Tap 'Stop & Analyze' when done.",
              style: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade600, height: 1.5),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Input Area
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _textController,
                maxLines: 6,
                decoration: const InputDecoration(
                  hintText: "Tap the microphone icon on your keyboard and start speaking...",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(20),
                ),
                style: GoogleFonts.inter(fontSize: 16),
              ),
            ),
            const SizedBox(height: 24),

            // Controls
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isTimerRunning ? null : _startAnswer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF43A047),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 4,
                      shadowColor: const Color(0xFF43A047).withValues(alpha: 0.4),
                    ),
                    child: Text(_isTimerRunning ? "Recording... $_elapsedSeconds s" : "Start Answer", style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: (_isTimerRunning && !_isAnalyzing) ? _stopAndAnalyze : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE53935),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 4,
                      shadowColor: const Color(0xFFE53935).withValues(alpha: 0.4),
                    ),
                    child: _isAnalyzing
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text("Stop & Analyze", style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: Colors.white)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Analysis Loading Shimmer
            if (_isAnalyzing)
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Column(
                  children: [
                    Container(height: 20, width: 200, color: Colors.white),
                    const SizedBox(height: 16),
                    Container(height: 100, width: double.infinity, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12))),
                    const SizedBox(height: 16),
                    Container(height: 100, width: double.infinity, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12))),
                  ],
                ),
              ),

            // Results Section
            if (_analysis != null && !_isAnalyzing) ...[
              Text("Analysis Results", style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 16),
              
              // AI Verdict Card
              Container(
                padding: const EdgeInsets.all(24),
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _analysis!.relevanceScore < 50 ? const Color(0xFFFFEBEE) : const Color(0xFFE8F5E9),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (_analysis!.relevanceScore < 50 ? Colors.red : Colors.green).withValues(alpha: 0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _analysis!.relevanceScore < 50 ? Icons.warning_amber_rounded : Icons.check_circle_outline_rounded,
                          color: _analysis!.relevanceScore < 50 ? const Color(0xFFD32F2F) : const Color(0xFF388E3C),
                          size: 32,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _analysis!.relevanceScore < 50 ? "Needs Improvement" : "Solid Answer",
                          style: GoogleFonts.outfit(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: _analysis!.relevanceScore < 50 ? const Color(0xFFD32F2F) : const Color(0xFF388E3C),
                          ),
                        ),
                      ],
                    ),
                    if (_analysis!.relevanceScore < 50) ...[
                      const SizedBox(height: 12),
                      Text(
                        _analysis!.feedbackMessage.isNotEmpty 
                            ? _analysis!.feedbackMessage 
                            : "Your answer didn't fully address the question. Focus on relevance.",
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ] else if (_analysis!.feedbackMessage.isNotEmpty) ...[
                       const SizedBox(height: 12),
                       Text(
                        _analysis!.feedbackMessage,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              
              // 1. Relevance Check
              if (_analysis!.relevanceScore < 50)
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFFFE0B2)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber, color: Color(0xFFEF6C00)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Your answer is not relevant to the question. Try addressing the key point.",
                          style: GoogleFonts.inter(color: const Color(0xFFE65100), fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),

              // 2. Content Structure Check
              if (_analysis!.contentScore < 40)
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFBBDEFB)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: Color(0xFF1565C0)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Your answer is missing structure. Try using: Situation → Task → Action → Result.",
                          style: GoogleFonts.inter(color: const Color(0xFF0D47A1), fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),

              // 3. Fluency Check
              if (_analysis!.fluency < 40)
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEBEE),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFFFCDD2)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.mic_off, color: Color(0xFFC62828)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "You paused frequently or hesitated.",
                          style: GoogleFonts.inter(color: const Color(0xFFB71C1C), fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),

              // Scores
              _buildScoreBar("Fluency", _analysis!.fluency, const Color(0xFF1E88E5)),
              _buildScoreBar("Confidence", _analysis!.confidence, const Color(0xFF8E24AA)),
              _buildScoreBar("Clarity", _analysis!.clarity, const Color(0xFFFB8C00)),
              _buildScoreBar("Pace (${_analysis!.pace.round()} wpm)", _analysis!.pace > 100 ? 100 : _analysis!.pace, const Color(0xFF43A047)),
              
              const SizedBox(height: 24),

              // Tips
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFFFECB3)),
                  boxShadow: [
                    BoxShadow(color: const Color(0xFFFFC107).withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      const Icon(Icons.lightbulb_outline, color: Color(0xFFF57F17), size: 24),
                      const SizedBox(width: 12),
                      Text("Key Feedback", style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18, color: const Color(0xFFF57F17)))
                    ]),
                    const SizedBox(height: 16),
                    ..._analysis!.tips.map((tip) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.arrow_right, color: Color(0xFFF57F17), size: 20),
                          const SizedBox(width: 8),
                          Expanded(child: Text(tip, style: GoogleFonts.inter(fontSize: 15, color: Colors.black87, height: 1.5))),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 32),
            
            // Ask Community Button
            if (_analysis != null)
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    final transcript = _textController.text.trim();
                    final tips = _analysis!.tips;
                    final summaryBuffer = StringBuffer();
                    summaryBuffer.writeln('Here is my interview answer and analysis from JobReady:');
                    summaryBuffer.writeln('');
                    summaryBuffer.writeln('Question: $_currentQuestion');
                    summaryBuffer.writeln('');
                    summaryBuffer.writeln('Transcript:');
                    summaryBuffer.writeln(transcript.isEmpty ? '(No transcript)' : transcript);
                    summaryBuffer.writeln('');
                    summaryBuffer.writeln('Analysis:');
                    summaryBuffer.writeln('Fluency: ${_analysis!.fluency.round()}/100');
                    summaryBuffer.writeln('Confidence: ${_analysis!.confidence.round()}/100');
                    summaryBuffer.writeln('Clarity: ${_analysis!.clarity.round()}/100');
                    summaryBuffer.writeln('');
                    if (tips.isNotEmpty) {
                      summaryBuffer.writeln('Tips from the app:');
                      for (final tip in tips) {
                        summaryBuffer.writeln('- $tip');
                      }
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NewThreadScreen(
                          initialTitle: 'Feedback on my interview answer',
                          initialBody: summaryBuffer.toString(),
                          initialType: CommunityPostType.feedback,
                          initialTags: const ['Answer Feedback'],
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.forum_outlined),
                  label: const Text('Ask Community for feedback'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A237E),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 4,
                    shadowColor: const Color(0xFF1A237E).withValues(alpha: 0.4),
                  ),
                ),
              ),
          ], // End of main children list
            // Ad Banner
            const SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.only(top: 24.0),
                child: Center(child: AdBanner()),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreBar(String label, double score, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
              Text("${score.round()}/100", style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: color)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: (score / 100).clamp(0.0, 1.0),
              backgroundColor: color.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 10,
            ),
          ),
        ],
      ),
    );
  }
}
