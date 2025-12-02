import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/question_model.dart';
import '../../data/question_bank_repository.dart';
import '../../data/it_questions.dart';
import '../../data/core_questions.dart';
import '../../data/sales_questions.dart';
import '../../data/industry_category.dart';
import '../../data/bpo_questions.dart';
import '../../logic/question_bank_ad_controller.dart';
import '../../../community/presentation/new_thread_screen.dart';
import '../../../community/data/community_post_model.dart';
import '../../../ads/ad_helper.dart';



import '../../../../ui/widgets/ad_banner.dart';

class QuestionBankViewerScreen extends StatefulWidget {
  final IndustryCategory initialIndustry;
  final int initialIndex;

  const QuestionBankViewerScreen({
    super.key,
    this.initialIndustry = IndustryCategory.it,
    this.initialIndex = 0,
  });

  @override
  State<QuestionBankViewerScreen> createState() =>
      _QuestionBankViewerScreenState();
}

class _QuestionBankViewerScreenState extends State<QuestionBankViewerScreen> {
  int _currentIndex = 0;
  IndustryCategory _selectedIndustry = IndustryCategory.it;
  late List<QuestionItem> _questions;
  late QuestionBankAdController _adController;
  bool _adFree = false;
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    _selectedIndustry = widget.initialIndustry;
    _questions = QuestionBankRepository.forIndustry(_selectedIndustry);
    _adController = QuestionBankAdController.instance;
    _currentIndex = widget.initialIndex.clamp(0, _questions.length - 1);
    _initAdState();
    
    // Preload ads
    AdHelper.loadInterstitialAd();
    AdHelper.loadRewardedAd();

    // Trigger fade-in animation
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() => _opacity = 1.0);
      }
    });
  }

  Future<void> _initAdState() async {
    final adFree = await _adController.isAdFree();
    if (mounted) {
      setState(() {
        _adFree = adFree;
      });
    }
  }

  void _loadQuestions() {
    switch (_selectedIndustry) {
      case IndustryCategory.it:
        _questions = itQuestions;
        break;
      case IndustryCategory.core:
        _questions = coreQuestions;
        break;
      case IndustryCategory.sales:
        _questions = salesQuestions;
        break;
      case IndustryCategory.bpo:
        _questions = bpoQuestions;
        break;
    }

    if (_questions.isEmpty) {
      _currentIndex = 0;
    } else {
      _currentIndex = _currentIndex.clamp(0, _questions.length - 1);
    }
  }

  void _onIndustryChanged(IndustryCategory? newIndustry) {
    if (newIndustry == null) return;
    setState(() {
      _selectedIndustry = newIndustry;
      _currentIndex = 0;
      _loadQuestions();
    });
  }

  void _goPrevious() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
    }
  }

  Future<void> _onNextPressed() async {
    if (_currentIndex >= _questions.length - 1) return;

    // Register question view & decide whether to show an interstitial
    final shouldShowAd =
        await _adController.registerAndShouldShowInterstitial();

    if (shouldShowAd && !_adFree && mounted) {
      await _showInterstitialPlaceholder();
    }

    if (!mounted) return;

    setState(() {
      _currentIndex++;
    });
  }

  Future<void> _showInterstitialPlaceholder() async {
    // Show loading indicator briefly
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    await AdHelper.showInterstitialAd(context, onComplete: () {
      if (mounted) {
        Navigator.of(context).pop(); // Close loading
      }
    });
  }

  Future<void> _onWatchAdForAdFree() async {
    // Show loading indicator briefly
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    bool earnedReward = false;

    await AdHelper.showRewardedAd(
      context,
      onUserEarnedReward: (reward) {
        earnedReward = true;
      },
      onDismissed: () async {
        if (mounted && Navigator.canPop(context)) {
          Navigator.of(context).pop(); // Close loading
        }

        if (earnedReward) {
          await _adController.unlockAdFreeDay();
          final adFree = await _adController.isAdFree();
          if (mounted) {
            setState(() {
              _adFree = adFree;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Ads removed for the rest of today in Question Bank.',
                  style: GoogleFonts.inter(fontSize: 13),
                ),
                duration: const Duration(seconds: 3),
              ),
            );
          }
        }
      }
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      margin: const EdgeInsets.only(top: 16, bottom: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Colors.grey.shade800,
        ),
      ),
    );
  }

  Widget _buildContentText(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 13,
        height: 1.5,
        color: Colors.grey.shade900,
      ),
    );
  }

  Widget _buildAdBanner() {
    if (_adFree) {
      // When ad-free is active, hide banner completely.
      return const SizedBox.shrink();
    }

    return const Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: AdBanner(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Question Bank'),
        ),
        body: Center(
          child: Text(
            'No questions available for ${_selectedIndustry.label}.',
            style: GoogleFonts.inter(fontSize: 14),
          ),
        ),
      );
    }

    final total = _questions.length;
    final question = _questions[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Question Bank'),
      ),
      body: AnimatedOpacity(
        opacity: _opacity,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeIn,
        child: Column(
          children: [
            // Top info bar
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    'Question ${_currentIndex + 1} of $total',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const Spacer(),
                  DropdownButton<IndustryCategory>(
                    value: _selectedIndustry,
                    underline: const SizedBox.shrink(),
                    borderRadius: BorderRadius.circular(8),
                    items:
                        QuestionBankRepository.allIndustries.map((industry) {
                      return DropdownMenuItem(
                        value: industry,
                        child: Text(
                          industry.label,
                          style: GoogleFonts.inter(fontSize: 13),
                        ),
                      );
                    }).toList(),
                    onChanged: _onIndustryChanged,
                  ),
                ],
              ),
            ),

          // Small strip for ad-free toggle
          if (!_adFree)
            Container(
              width: double.infinity,
              color: Colors.blue.shade50,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.block,
                    size: 16,
                    color: Colors.blue.shade700,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Remove ads for today by watching a 30-second video.',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.blue.shade900,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _onWatchAdForAdFree,
                    child: Text(
                      'Go ad-free',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Topic pill
                  if (question.topic.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        question.topic,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),

                  Text(
                    'Interview Question',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    question.question,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  _buildSectionHeader('Model Answer (Short)'),
                  _buildContentText(question.shortAnswer),

                  _buildSectionHeader('Deep Explanation'),
                  _buildContentText(question.deepExplanation),

                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.forum_outlined, size: 18),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NewThreadScreen(
                            initialTitle: 'Discuss: ${question.topic.isNotEmpty ? question.topic : 'Interview Question'}',
                            initialBody: 'Question:\n${question.question}\n\nModel Answer (short):\n${question.shortAnswer}',
                            initialType: CommunityPostType.question,
                            initialTags: const ['Interview Question'],
                          ),
                        ),
                      );
                    },
                    label: Text(
                      'Discuss this question in Community',
                      style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Navigation buttons
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.arrow_back_ios_new, size: 16),
                    onPressed:
                        _currentIndex > 0 ? _goPrevious : null,
                    label: Text(
                      'Previous',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.arrow_forward_ios, size: 16),
                    onPressed:
                        _currentIndex < total - 1 ? _onNextPressed : null,
                    label: Text(
                      'Next',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Banner ad at bottom (hidden if ad-free)
          _buildAdBanner(),
        ],
      ),
      ),
    );
  }
}
