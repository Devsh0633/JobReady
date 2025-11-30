import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../ui/widgets/ad_banner.dart';
import '../../ai/ai_client.dart';

import '../../auth/user_profile.dart';
import '../../profile/candidate_profile.dart';
import '../../profile/candidate_profile_service.dart';

class WriterScreen extends StatefulWidget {
  const WriterScreen({super.key});

  @override
  State<WriterScreen> createState() => _WriterScreenState();
}

class _WriterScreenState extends State<WriterScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _subjectController = TextEditingController();
  final _bodyController = TextEditingController();

  // Input Controllers (for generation context)
  final _nameController = TextEditingController();
  final _companyController = TextEditingController();
  final _roleController = TextEditingController();
  final _jdController = TextEditingController(); // New JD Controller
  final _customSkillController = TextEditingController();

  // State
  bool _isLoading = false;
  bool _isTyping = false;
  String _displayedBody = "";
  String? _selectedDocType;
  String? _selectedExperience;
  String? _selectedSkill;

  // Options
  final List<String> _docTypes = [
    "Cover Letter",
    "LinkedIn Note",
    "Cold Email"
  ];

  final List<String> _experienceLevels = [
    "Fresher (0 years)",
    "1–3 years",
    "3–5 years"
  ];

  final Map<String, List<String>> _industrySkills = {
    "IT & Software": [
      "Java",
      "Python",
      "Full-Stack Web Development",
      "Data Structures & Algorithms",
      "SQL / Databases",
      "Other"
    ],
    "Sales & Marketing": [
      "B2B Sales",
      "Inside Sales",
      "Digital Marketing",
      "Lead Generation",
      "Client Relationship Management",
      "Other"
    ],
    "Core Engineering": [
      "Electrical Maintenance",
      "Mechanical Design",
      "AutoCAD / SolidWorks",
      "Site Supervision",
      "Quality Control",
      "Other"
    ],
    "BPO & Support": [
      "Customer Support",
      "Voice Process",
      "Non-Voice Process",
      "Email Support",
      "Problem Solving",
      "Other"
    ],
  };

  bool _isInitialized = false;

  CandidateProfile? _candidateProfile;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final args = ModalRoute.of(context)?.settings.arguments;
      String industry = "IT & Software";
      if (args is String) {
        industry = args;
      } else if (args is Map) {
        industry = args['industry'] ?? "IT & Software";
      }

      if (args is Map) {
        final profile = args['profile'] as UserProfile?;
        if (profile != null) {
          _nameController.text = profile.name;
          if (_experienceLevels.contains(profile.experienceBand)) {
            _selectedExperience = profile.experienceBand;
          }
          
          // Try to load CandidateProfile
          _loadCandidateProfile(profile.id);
          
          final industrySkills = _industrySkills[industry] ?? [];
          String? matchedSkill;
          for (final skill in profile.skills) {
            if (industrySkills.contains(skill)) {
              matchedSkill = skill;
              break;
            }
          }

          if (matchedSkill != null) {
            _selectedSkill = matchedSkill;
          } else if (profile.skills.isNotEmpty) {
            _selectedSkill = "Other";
            _customSkillController.text = profile.skills.join(", ");
          }
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
        // Auto-fill from candidate profile if available
        if (_selectedExperience == null && _experienceLevels.contains(profile.yearsExperience)) {
             // Basic mapping, can be improved
        }
      });
    }
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _bodyController.dispose();
    _nameController.dispose();
    _companyController.dispose();
    _roleController.dispose();
    _jdController.dispose();
    _customSkillController.dispose();
    super.dispose();
  }

  Future<void> _generateDraft(String industry) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    String finalSkill = _selectedSkill == "Other"
        ? _customSkillController.text
        : _selectedSkill ?? "";

    // Build Profile Map from UI + CandidateProfile
    final Map<String, dynamic> profileMap = {
      "name": _nameController.text,
      "experience": _selectedExperience,
      "topSkill": finalSkill,
      "industry": industry,
    };

    if (_candidateProfile != null) {
      profileMap.addAll(_candidateProfile!.toJson());
    }

    try {
      final result = await AiClient.instance.generateApplication(
        profile: profileMap,
        company: _companyController.text,
        role: _roleController.text,
        format: _selectedDocType?.toLowerCase().replaceAll(" ", "_") ?? "cold_email",
        jd: _jdController.text,
      );

      setState(() {
        _subjectController.text = result.subject;
        _isLoading = false;
      });
      _simulateTyping(result.body);
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _simulateTyping(String fullText) {
    _displayedBody = "";
    _isTyping = true;
    _bodyController.text = "";
    
    int index = 0;
    Timer.periodic(const Duration(milliseconds: 10), (timer) {
      if (index < fullText.length) {
        if (mounted) {
          setState(() {
            _displayedBody += fullText[index];
            _bodyController.text = _displayedBody;
          });
        }
        index++;
      } else {
        _isTyping = false;
        timer.cancel();
      }
    });
  }



  Future<void> _handleAdGate(VoidCallback onSuccess) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Premium Feature"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text("Watching Ad...", style: GoogleFonts.inter()),
          ],
        ),
      ),
    );

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      Navigator.pop(context);
      onSuccess();
    }
  }

  Future<void> _saveAsPdf() async {
    if (_bodyController.text.isEmpty) return;

    await _handleAdGate(() async {
      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                if (_subjectController.text.isNotEmpty)
                  pw.Text("Subject: ${_subjectController.text}", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
                pw.SizedBox(height: 20),
                pw.Text(_bodyController.text, style: const pw.TextStyle(fontSize: 12)),
              ],
            );
          },
        ),
      );

      await Printing.sharePdf(bytes: await pdf.save(), filename: 'application.pdf');
    });
  }

  Future<void> _copyToClipboard() async {
    if (_bodyController.text.isEmpty) return;

    await _handleAdGate(() {
      final text = "Subject: ${_subjectController.text}\n\n${_bodyController.text}";
      Clipboard.setData(ClipboardData(text: text));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Copied to clipboard!')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    String industry = "IT & Software";
    if (args is String) {
      industry = args;
    } else if (args is Map) {
      industry = args['industry'] ?? "IT & Software";
    }

    final skills = _industrySkills[industry] ?? _industrySkills["IT & Software"]!;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        title: Text('$industry Writer', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Inputs Section
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
                              'Application Details',
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1A237E),
                              ),
                            ),
                            const SizedBox(height: 24),
                            DropdownButtonFormField<String>(
                              key: ValueKey(_selectedDocType),
                              initialValue: _selectedDocType,
                              decoration: const InputDecoration(
                                labelText: 'Document Type',
                                prefixIcon: Icon(Icons.description_outlined),
                              ),
                              items: _docTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                              onChanged: (v) => setState(() => _selectedDocType = v),
                              validator: (v) => v == null ? 'Required' : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                labelText: 'Your Name',
                                prefixIcon: Icon(Icons.person_outline),
                              ),
                              validator: (v) => v?.isEmpty == true ? 'Required' : null,
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              key: ValueKey(_selectedExperience),
                              initialValue: _selectedExperience,
                              decoration: const InputDecoration(
                                labelText: 'Experience',
                                prefixIcon: Icon(Icons.timeline),
                              ),
                              items: _experienceLevels.map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
                              onChanged: (v) => setState(() => _selectedExperience = v),
                              validator: (v) => v == null ? 'Required' : null,
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              key: ValueKey(_selectedSkill),
                              initialValue: _selectedSkill,
                              decoration: const InputDecoration(
                                labelText: 'Top Skill',
                                prefixIcon: Icon(Icons.star_outline),
                              ),
                              isExpanded: true,
                              items: skills.map((s) => DropdownMenuItem(value: s, child: Text(s, overflow: TextOverflow.ellipsis))).toList(),
                              onChanged: (v) => setState(() => _selectedSkill = v),
                              validator: (v) => v == null ? 'Required' : null,
                            ),
                            if (_selectedSkill == "Other") ...[
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _customSkillController,
                                decoration: const InputDecoration(
                                  labelText: 'Custom Skill',
                                  prefixIcon: Icon(Icons.edit_outlined),
                                ),
                                validator: (v) => v?.isEmpty == true ? 'Required' : null,
                              ),
                            ],
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _companyController,
                              decoration: const InputDecoration(
                                labelText: 'Target Company',
                                prefixIcon: Icon(Icons.business),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _roleController,
                                decoration: const InputDecoration(
                                  labelText: 'Target Role',
                                  prefixIcon: Icon(Icons.work_outline),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _jdController,
                                maxLines: 3,
                                decoration: const InputDecoration(
                                  labelText: 'Job Description (Optional)',
                                  hintText: 'Paste JD here for better personalization...',
                                  prefixIcon: Icon(Icons.description),
                                  alignLabelWithHint: true,
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Generate Button
                      SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : () => _generateDraft(industry),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1A237E),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 4,
                            shadowColor: const Color(0xFF1A237E).withValues(alpha: 0.4),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.auto_awesome),
                                    const SizedBox(width: 12),
                                    Text('Generate Draft', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600)),
                                  ],
                                ),
                        ),
                      ),
                      
                      const SizedBox(height: 32),

                      // Editor Section
                      if (_bodyController.text.isNotEmpty || _isLoading || _isTyping) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Your Draft', style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold)),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8EAF6),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.auto_awesome, size: 14, color: Color(0xFF1A237E)),
                                  const SizedBox(width: 6),
                                  Text("AI Generated", style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF1A237E), fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        // Subject Field
                        TextField(
                          controller: _subjectController,
                          maxLength: 120,
                          style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                          decoration: const InputDecoration(
                            labelText: 'Email Subject',
                            prefixIcon: Icon(Icons.subject),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Body Editor with Gradient Border
                        _isLoading 
                        ? Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            child: Container(
                              height: 300,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22),
                              gradient: const LinearGradient(
                                colors: [Color(0xFF1A237E), Color(0xFF00E5FF)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            padding: const EdgeInsets.all(2),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: TextField(
                                controller: _bodyController,
                                maxLines: 15,
                                style: GoogleFonts.inter(fontSize: 15, height: 1.6),
                                decoration: const InputDecoration(
                                  hintText: "Your email draft will appear here...",
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(24),
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(height: 24),

                        // Regenerate Button
                        if (!_isLoading && !_isTyping)
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton.icon(
                              onPressed: () => _generateDraft(industry),
                              icon: const Icon(Icons.refresh, size: 18),
                              label: const Text("Regenerate Draft"),
                              style: TextButton.styleFrom(foregroundColor: const Color(0xFF1A237E)),
                            ),
                          ),


                        const SizedBox(height: 32),

                        // Actions (Copy / PDF)
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: _copyToClipboard,
                                icon: const Icon(Icons.copy, size: 20),
                                label: const Text("Copy Text"),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  side: const BorderSide(color: Color(0xFF1A237E)),
                                  foregroundColor: const Color(0xFF1A237E),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _saveAsPdf,
                                icon: const Icon(Icons.picture_as_pdf, size: 20),
                                label: const Text("Save PDF"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1A237E),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  elevation: 0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            // Ad Banner at the bottom
            const SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Center(child: AdBanner()),
              ),
            ),
          ],
        ),
      ),
    );
  }


}
