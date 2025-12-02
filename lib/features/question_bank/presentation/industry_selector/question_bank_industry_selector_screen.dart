import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/question_model.dart';
import '../../data/it_questions.dart';
import '../../data/core_questions.dart';
import '../../data/sales_questions.dart';
import '../../data/bpo_questions.dart';
import '../../data/industry_category.dart';
import '../../logic/question_bank_ad_controller.dart';
import '../viewer/question_bank_viewer_screen.dart';


import '../../../../ui/widgets/ad_banner.dart';
import '../../../ads/ad_helper.dart';

class QuestionBankIndustrySelectorScreen extends StatefulWidget {
  const QuestionBankIndustrySelectorScreen({super.key});

  @override
  State<QuestionBankIndustrySelectorScreen> createState() =>
      _QuestionBankIndustrySelectorScreenState();
}

class _QuestionBankIndustrySelectorScreenState
    extends State<QuestionBankIndustrySelectorScreen> {
  IndustryCategory _selectedIndustry = IndustryCategory.it;
  
  final QuestionBankAdController _adController =
      QuestionBankAdController.instance;
  bool _adFree = false;

  @override
  void initState() {
    super.initState();
    // In future: you can load user profile and map to _selectedIndustry here.
    _initAdState();
    // Preload ads when entering this screen
    AdHelper.loadRewardedAd();
    AdHelper.loadInterstitialAd();
  }

  Future<void> _initAdState() async {
    final adFree = await _adController.isAdFree();
    if (mounted) {
      setState(() {
        _adFree = adFree;
      });
    }
  }

  Future<void> _onWatchAdForAdFree() async {
    // Show loading indicator briefly
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    bool rewardEarned = false;

    final adShown = await AdHelper.showRewardedAd(
      context, 
      onUserEarnedReward: (reward) {
        rewardEarned = true;
      },
      onDismissed: () async {
        // Always close the loading dialog first
        if (mounted && Navigator.canPop(context)) {
          Navigator.of(context).pop(); 
        }

        if (rewardEarned) {
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

    if (!adShown) {
      // If ad wasn't shown (because it wasn't ready), the onDismissed might have been called 
      // by our helper, popping the dialog. But just in case, let's make sure user knows.
      // Note: AdHelper calls onDismissed even if not shown, so dialog is already popped.
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Ad is still loading. Please try again in a few seconds.',
              style: GoogleFonts.inter(fontSize: 13),
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  List<QuestionItem> get _currentQuestions {
    switch (_selectedIndustry) {
      case IndustryCategory.it:
        return itQuestions;
      case IndustryCategory.core:
        return coreQuestions;
      case IndustryCategory.sales:
        return salesQuestions;
      case IndustryCategory.bpo:
        return bpoQuestions;
    }
  }

  void _openReader() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QuestionBankViewerScreen(
          initialIndustry: _selectedIndustry,
          initialIndex: 0,
        ),
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
    final theme = Theme.of(context);
    final questionsCount = _currentQuestions.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Interview Question Bank'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),

          // Intro text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Read real interview questions and model answers one-by-one. '
              'Choose your industry to get started.',
              style: GoogleFonts.inter(
                fontSize: 14,
                height: 1.4,
                color: Colors.grey.shade700,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Horizontal industry chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: IndustryCategory.values.map((industry) {
                final isSelected = industry == _selectedIndustry;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(
                      industry.label,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: theme.colorScheme.primary,
                    backgroundColor: Colors.grey.shade200,
                    onSelected: (_) {
                      setState(() {
                        _selectedIndustry = industry;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 16),

          // Go ad-free strip
          if (!_adFree)
            Container(
              width: double.infinity,
              color: Colors.blue.shade50,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                      'Remove ads for today by watching a short video.',
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

          const SizedBox(height: 24),

          // Summary card with "Start Reading" button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedIndustry.label,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$questionsCount curated questions with model answers and deep explanations for this industry.',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        height: 1.4,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'You will see one question per page with no scoring or mic – purely reading and learning.',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        height: 1.4,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: questionsCount == 0 ? null : _openReader,
                        icon: const Icon(Icons.menu_book_rounded),
                        label: Text(
                          'Start Reading Questions',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const Spacer(),

          _buildAdBanner(),
        ],
      ),
    );
  }
}
