import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import '../../../auth_screens.dart'; // For PersonalizedHomeScreen navigation
import '../../auth/user_profile.dart';
import '../../auth/profile_service.dart';
import '../candidate_profile_service.dart';


class EditProfileScreen extends StatefulWidget {
  final UserProfile profile;

  const EditProfileScreen({super.key, required this.profile});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _goalsController;
  late TextEditingController _resumeController;
  late TextEditingController _portfolioController;

  String? _selectedIndustry;
  String? _selectedExperience;
  final List<String> _selectedSkills = [];

  bool _isLoading = false;
  bool _isAnalyzingResume = false;
  String? _resumeFileName;

  final List<String> _industries = [
    "IT & Software",
    "Sales & Marketing",
    "Core Engineering",
    "BPO & Support"
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
      "SQL / Databases"
    ],
    "Sales & Marketing": [
      "B2B Sales",
      "Digital Marketing",
      "Lead Generation",
      "Client Relationship Management"
    ],
    "Core Engineering": [
      "Electrical Maintenance",
      "Mechanical Design",
      "AutoCAD/SolidWorks",
      "Site Supervision",
      "Quality Control"
    ],
    "BPO & Support": [
      "Customer Support",
      "Voice Process",
      "Non-Voice Process",
      "Email Support",
      "Problem Solving"
    ],
  };

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.name);
    _goalsController = TextEditingController(text: widget.profile.goals);
    _resumeController = TextEditingController(text: widget.profile.resumeUrl);
    _portfolioController = TextEditingController(text: widget.profile.portfolioUrl);
    _selectedIndustry = widget.profile.primaryIndustry;
    _selectedExperience = widget.profile.experienceBand;
    _selectedSkills.addAll(widget.profile.skills);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _goalsController.dispose();
    _resumeController.dispose();
    _portfolioController.dispose();
    super.dispose();
  }

  Future<void> _pickResume() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        setState(() {
          _resumeFileName = result.files.single.name;
          _isAnalyzingResume = true;
        });

        final service = CandidateProfileService();
        final userId = FirebaseAuth.instance.currentUser?.uid ?? widget.profile.id;

        try {
          final profile = await service.processResume(userId, result.files.single.path ?? '');

          if (mounted) {
            setState(() {
              _isAnalyzingResume = false;
              _resumeController.text = profile.resumeStoragePath;
              
              // Optional: Update skills if they were empty or user wants to overwrite?
              // For edit mode, maybe we strictly preserve user edits unless they ask?
              // Let's just update the resume URL for now to be safe.
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Resume updated successfully!')),
            );
          }
        } catch (e) {
          if (mounted) {
            setState(() {
              _isAnalyzingResume = false;
              _resumeFileName = null; // Clear the file name as processing failed
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to process resume: $e')),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isAnalyzingResume = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload resume: $e')),
        );
      }
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedIndustry == null || _selectedExperience == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select industry and experience')),
      );
      return;
    }
    if (_selectedSkills.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one skill')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final updatedProfile = UserProfile(
        id: widget.profile.id,
        email: widget.profile.email,
        name: _nameController.text,
        primaryIndustry: _selectedIndustry!,
        experienceBand: _selectedExperience!,
        skills: _selectedSkills,
        goals: _goalsController.text,
        resumeUrl: _resumeController.text,
        portfolioUrl: _portfolioController.text,
      );

      await ProfileService().saveProfile(updatedProfile);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
        // Navigate back to Home with updated profile
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => PersonalizedHomeScreen(profile: updatedProfile)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save profile: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final skills = _industrySkills[_selectedIndustry] ?? _industrySkills["IT & Software"]!;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Basic Info ---
                Text('Basic Info', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v?.isEmpty == true ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _goalsController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Career Goals',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),

                // --- Industry & Experience ---
                Text('Professional Details', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  // ignore: deprecated_member_use
                  value: _selectedIndustry,
                  decoration: const InputDecoration(
                    labelText: 'Industry',
                    prefixIcon: Icon(Icons.work_outline),
                    border: OutlineInputBorder(),
                  ),
                  items: _industries.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedIndustry = val;
                      // Don't clear skills on edit, just let them be or maybe warn?
                      // For now, let's keep it simple.
                    });
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  // ignore: deprecated_member_use
                  value: _selectedExperience,
                  decoration: const InputDecoration(
                    labelText: 'Experience',
                    prefixIcon: Icon(Icons.timeline),
                    border: OutlineInputBorder(),
                  ),
                  items: _experienceLevels.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (val) => setState(() => _selectedExperience = val),
                ),
                const SizedBox(height: 24),

                // --- Skills ---
                Text('Skills (Select up to 3)', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: skills.map((skill) {
                    final isSelected = _selectedSkills.contains(skill);
                    return FilterChip(
                      label: Text(skill),
                      selected: isSelected,
                      selectedColor: const Color(0xFF1A237E).withValues(alpha: 0.1),
                      checkmarkColor: const Color(0xFF1A237E),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            if (_selectedSkills.length < 3) _selectedSkills.add(skill);
                          } else {
                            _selectedSkills.remove(skill);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // --- Resume & Portfolio ---
                Text('Resume & Portfolio', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                
                // Resume Upload UI
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      if (_isAnalyzingResume)
                        const Row(
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(width: 16),
                            Text("Uploading & Analyzing..."),
                          ],
                        )
                      else if (_resumeFileName != null)
                         ListTile(
                          leading: const Icon(Icons.check_circle, color: Colors.green),
                          title: Text(_resumeFileName!),
                          subtitle: const Text("Ready to save"),
                          trailing: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => setState(() => _resumeFileName = null),
                          ),
                        )
                      else if (_resumeController.text.isNotEmpty)
                        ListTile(
                          leading: const Icon(Icons.description, color: Color(0xFF1A237E)),
                          title: const Text("Stored Resume (PDF)"),
                          subtitle: const Text("Tap to replace"),
                          trailing: const Icon(Icons.edit),
                          onTap: _pickResume,
                        )
                      else
                        ListTile(
                          leading: const Icon(Icons.upload_file),
                          title: const Text("Upload Resume (PDF)"),
                          onTap: _pickResume,
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _portfolioController,
                  decoration: const InputDecoration(
                    labelText: 'Portfolio URL (Optional)',
                    prefixIcon: Icon(Icons.link),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 40),

                // --- Save Button ---
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A237E),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'Save Changes',
                            style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
