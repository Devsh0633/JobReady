import 'package:flutter/material.dart';
import 'dart:async'; // For Timer
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_project/features/auth/profile_service.dart';
import 'package:new_project/features/auth/user_profile.dart';
import 'package:new_project/features/question_bank/presentation/industry_selector/question_bank_industry_selector_screen.dart';
import 'ui/widgets/ad_banner.dart';
import 'ui/widgets/community_hero_button.dart';
import 'features/community/presentation/community_home_screen.dart';
import 'features/auth/presentation/welcome_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'features/profile/candidate_profile_service.dart';
import 'features/profile/candidate_profile.dart';
import 'features/profile/presentation/edit_profile_screen.dart';
// ---------------------------------------------------------------------------
// AUTH FLOW WIDGETS
// ---------------------------------------------------------------------------

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (snapshot.hasData) {
          final user = snapshot.data!;
          
          // Check Email Verification
          if (!user.emailVerified) {
            return const VerifyEmailScreen();
          }

          // Check if Profile Exists
          return FutureBuilder<UserProfile?>(
            future: ProfileService().loadProfile(),
            builder: (context, profileSnapshot) {
              if (profileSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(body: Center(child: CircularProgressIndicator()));
              }
              
              if (profileSnapshot.hasData && profileSnapshot.data != null) {
                return PersonalizedHomeScreen(profile: profileSnapshot.data!);
              }
              
              // No profile found, go to onboarding
              return const OnboardingScreen();
            },
          );
        }

        return const WelcomeScreen();
      },
    );
  }
}

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool _isSendingVerification = false;
  bool _canResendEmail = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _checkEmailVerified();
    
    // Enable resend after 30 seconds
    Future.delayed(const Duration(seconds: 30), () {
      if (mounted) setState(() => _canResendEmail = true);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _checkEmailVerified() async {
    _timer = Timer.periodic(const Duration(seconds: 3), (_) async {
      await FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;
      if (user?.emailVerified ?? false) {
        _timer?.cancel();
        // Force rebuild of AuthGate
        if (mounted) {
           // We can't easily force AuthGate rebuild from here without a state management solution or navigation.
           // But since AuthGate listens to authStateChanges, reloading user might not trigger it if the user object reference doesn't change?
           // Actually, authStateChanges fires on sign in/out. 
           // We might need to manually navigate or use a stream that emits user changes.
           // Simplest for now: Navigate to AuthGate (which will re-evaluate)
           Navigator.of(context).pushReplacement(
             MaterialPageRoute(builder: (_) => const AuthGate()),
           );
        }
      }
    });
  }

  Future<void> _sendVerificationEmail() async {
    try {
      setState(() => _isSendingVerification = true);
      await ProfileService().sendEmailVerification();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verification email sent! Check your inbox.')),
      );
      setState(() => _canResendEmail = false);
      Future.delayed(const Duration(seconds: 30), () {
        if (mounted) setState(() => _canResendEmail = true);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSendingVerification = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        title: const Text('Verify Email'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ProfileService().logout(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.email_outlined, size: 80, color: Color(0xFF1A237E)),
            const SizedBox(height: 24),
            Text(
              'Verify your email address',
              style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'We have sent a verification email to ${FirebaseAuth.instance.currentUser?.email}. Please verify your email to continue.',
              style: GoogleFonts.inter(fontSize: 16, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _canResendEmail ? _sendVerificationEmail : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A237E),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: _isSendingVerification
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('Resend Email'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => ProfileService().logout(),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _rememberMe = true;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await ProfileService().login(
        _emailController.text.trim(),
        _passwordController.text,
      );
      
      // AuthGate will handle navigation
      if (mounted) {
         // If we are on a separate route (e.g. pushed from welcome), we might need to pop or replace.
         // But usually AuthGate is the root. If we are here, we probably pushed this screen.
         // Let's pop until we are back to root or replace with AuthGate.
         // Actually, if AuthGate is the root, and we are here, we might be in a pushed route.
         // If we just pop, AuthGate will rebuild with new user.
         Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${e.toString().replaceAll("Exception: ", "")}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _resetPassword() async {
    final emailController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter your email to receive a password reset link.'),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (emailController.text.isEmpty) return;
              try {
                await ProfileService().resetPassword(emailController.text.trim());
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Reset link sent! Check your email.')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              }
            },
            child: const Text('Send Link'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
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
                const SizedBox(height: 20),
                Text(
                  'Welcome Back',
                  style: GoogleFonts.outfit(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A237E),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign in to continue your progress',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 48),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your email' : null,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock_outlined),
                  ),
                  obscureText: true,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your password' : null,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      activeColor: const Color(0xFF1A237E),
                      onChanged: (val) => setState(() => _rememberMe = val!),
                    ),
                    Text(
                      'Remember Me',
                      style: GoogleFonts.inter(color: Colors.grey[700]),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: _resetPassword,
                      child: Text(
                        'Forgot Password?',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF1A237E),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A237E),
                      foregroundColor: Colors.white,
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'Login',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: GoogleFonts.inter(color: Colors.grey[600]),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/signup');
                      },
                      child: Text(
                        'Sign Up',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF1A237E),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final service = ProfileService();
      await service.signUp(
        _emailController.text.trim(),
        _passwordController.text,
      );
      
      // Send verification email
      await service.sendEmailVerification();

      if (mounted) {
        // AuthGate will detect the new user. 
        // Since email is not verified, it should show VerifyEmailScreen.
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signup failed: ${e.toString().replaceAll("Exception: ", "")}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
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
                const SizedBox(height: 20),
                Text(
                  'Create Account',
                  style: GoogleFonts.outfit(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A237E),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Start your journey to your dream job',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 48),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your email' : null,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock_outlined),
                  ),
                  obscureText: true,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your password' : null,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    prefixIcon: Icon(Icons.lock_outlined),
                  ),
                  obscureText: true,
                  validator: (value) =>
                      value!.isEmpty ? 'Please confirm your password' : null,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _signup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A237E),
                      foregroundColor: Colors.white,
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'Sign Up',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: GoogleFonts.inter(color: Colors.grey[600]),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: Text(
                        'Login',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF1A237E),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentStep = 0;

  final _nameController = TextEditingController();
  final _goalsController = TextEditingController();

  String? _selectedIndustry;
  String? _selectedExperience;

  final List<String> _selectedSkills = [];

  final _resumeController = TextEditingController();
  final _portfolioController = TextEditingController();

  
  // Resume Upload State
  String? _resumeFileName;
  bool _isAnalyzingResume = false;
  CandidateProfile? _parsedProfile;

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

  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // No editing logic needed here anymore
  }

  void _nextPage() {
    if (_currentStep < 3) {
      if (_currentStep == 0) {
        if (_nameController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enter your name')),
          );
          return;
        }
      } else if (_currentStep == 1) {
        if (_selectedIndustry == null || _selectedExperience == null) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Please select industry and experience')));
          return;
        }
      } else if (_currentStep == 2) {
        if (_selectedSkills.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please select at least one skill')));
          return;
        }
      }

      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
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

        // Process Resume (Upload + Parse)
        final service = CandidateProfileService();
        // Use current user's ID
        final userId = FirebaseAuth.instance.currentUser?.uid ?? 'temp_user_${DateTime.now().millisecondsSinceEpoch}'; 
        
        try {
          final profile = await service.processResume(userId, result.files.single.path ?? '');

          if (mounted) {
            setState(() {
              _parsedProfile = profile;
              _isAnalyzingResume = false;
              _resumeController.text = profile.resumeStoragePath; // Save URL
              
              // Auto-fill fields from parsed profile if empty
              if (_selectedSkills.isEmpty) {
                _selectedSkills.addAll(profile.skills.take(3));
              }
              if (_selectedIndustry == null) {
                _selectedIndustry = profile.primaryIndustry;
              }
            });
            
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Resume uploaded & analyzed successfully!')),
            );
          }
        } catch (e) {
           if (mounted) {
            setState(() => _isAnalyzingResume = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to process resume: $e')),
            );
          }
        }
      }
    } catch (e) {
      debugPrint('Error picking file: $e');
      if (mounted) {
        setState(() {
          _isAnalyzingResume = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload resume: $e')),
        );
      }
    }
  }



  void _previousPage() {
    _pageController.previousPage(
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    setState(() => _currentStep--);
  }

  Future<void> _finishOnboarding() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: No user logged in')),
      );
      return;
    }

    final args = ModalRoute.of(context)?.settings.arguments;
    String email = user.email ?? "";
    
    // If editing, keep existing email/id (though ID should match auth uid)
    if (args is UserProfile) {
      email = args.email;
    }

    final profile = UserProfile(
      id: user.uid,
      email: email,
      name: _nameController.text,
      primaryIndustry: _selectedIndustry!,
      experienceBand: _selectedExperience!,
      skills: _selectedSkills,
      goals: _goalsController.text,
      resumeUrl: _resumeController.text,
      portfolioUrl: _portfolioController.text,
    );

    await ProfileService().saveProfile(profile);

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) => PersonalizedHomeScreen(profile: profile)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print("DEBUG: Building OnboardingScreen. _isEditing: $_isEditing");
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        title: Text(
          'Setup Profile',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: null,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: (_currentStep + 1) / 4,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF1A237E)),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildStep1(),
                  _buildStep2(),
                  _buildStep3(),
                  _buildStep4(),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentStep > 0)
                    TextButton(
                      onPressed: _previousPage,
                      child: Text(
                        'Back',
                        style: GoogleFonts.inter(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  else
                    const SizedBox(width: 60),
                  ElevatedButton(
                    onPressed: _currentStep < 3 ? _nextPage : _finishOnboarding,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A237E),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                    ),
                    child: Text(
                      _currentStep < 3 ? 'Next' : 'Finish & Save',
                      style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep1() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Let\'s start with the basics',
              style: GoogleFonts.outfit(
                  fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 8),
          Text('Tell us a bit about yourself.',
              style: GoogleFonts.inter(fontSize: 16, color: Colors.grey[600])),
          const SizedBox(height: 32),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Your Name',
              prefixIcon: Icon(Icons.person_outline),
            ),
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _goalsController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Career Goals (Optional)',
              hintText: 'e.g., Get my first job in software development...',
              alignLabelWithHint: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Where are you heading?',
              style: GoogleFonts.outfit(
                  fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 8),
          Text('Select your industry and experience level.',
              style: GoogleFonts.inter(fontSize: 16, color: Colors.grey[600])),
          const SizedBox(height: 32),
          DropdownButtonFormField<String>(
            key: const Key('industry_dropdown'),
            initialValue: _selectedIndustry,
            decoration: const InputDecoration(
              labelText: 'Primary Industry',
              prefixIcon: Icon(Icons.work_outline),
            ),
            items: _industries
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (val) {
              setState(() {
                _selectedIndustry = val;
                _selectedSkills.clear(); // Reset skills if industry changes
              });
            },
          ),
          const SizedBox(height: 24),
          DropdownButtonFormField<String>(
            key: const Key('experience_dropdown'),
            initialValue: _selectedExperience,
            decoration: const InputDecoration(
              labelText: 'Experience Level',
              prefixIcon: Icon(Icons.timeline),
            ),
            items: _experienceLevels
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (val) => setState(() => _selectedExperience = val),
          ),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    final skills =
        _industrySkills[_selectedIndustry] ?? _industrySkills["IT & Software"]!;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('What are your top skills?',
              style: GoogleFonts.outfit(
                  fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 8),
          Text('Select up to 3 skills you want to highlight.',
              style: GoogleFonts.inter(fontSize: 16, color: Colors.grey[600])),
          const SizedBox(height: 32),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: skills.map((skill) {
              final isSelected = _selectedSkills.contains(skill);
              return FilterChip(
                label: Text(skill),
                selected: isSelected,
                selectedColor: const Color(0xFF1A237E).withValues(alpha: 0.1),
                checkmarkColor: const Color(0xFF1A237E),
                labelStyle: GoogleFonts.inter(
                  color: isSelected ? const Color(0xFF1A237E) : Colors.black87,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected ? const Color(0xFF1A237E) : Colors.grey.shade300,
                  ),
                ),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      if (_selectedSkills.length < 3) {
                        _selectedSkills.add(skill);
                      }
                    } else {
                      _selectedSkills.remove(skill);
                    }
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStep4() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Add your links',
              style: GoogleFonts.outfit(
                  fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 8),
          Text('Showcase your work and resume.',
              style: GoogleFonts.inter(fontSize: 16, color: Colors.grey[600])),
          const SizedBox(height: 32),
          Text('Showcase your work and resume.',
              style: GoogleFonts.inter(fontSize: 16, color: Colors.grey[600])),
          const SizedBox(height: 32),
          
          // Resume Upload Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey.shade50,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.description_outlined, color: Colors.grey[700]),
                    const SizedBox(width: 12),
                    Text(
                      'Resume / CV (PDF)',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (_isAnalyzingResume)
                  Row(
                    children: [
                      const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                      const SizedBox(width: 12),
                      Text(
                        'Uploading & Analyzing...',
                        style: GoogleFonts.inter(color: const Color(0xFF1A237E), fontWeight: FontWeight.w500),
                      ),
                    ],
                  )
                else if (_resumeFileName != null)
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _resumeFileName!,
                              style: GoogleFonts.inter(color: Colors.green[700], fontWeight: FontWeight.w500),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'Ready to save',
                              style: GoogleFonts.inter(fontSize: 10, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () {
                          setState(() {
                            _resumeFileName = null;
                            _parsedProfile = null;
                            _resumeController.clear();
                          });
                        },
                      ),
                    ],
                  )
                else if (_resumeController.text.isNotEmpty)
                   Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Stored Resume (PDF)",
                              style: GoogleFonts.inter(color: const Color(0xFF1A237E), fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "Tap replace to upload a new one",
                              style: GoogleFonts.inter(fontSize: 10, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: _pickResume,
                        child: const Text("Replace"),
                      ),
                    ],
                  )
                else
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _pickResume,
                      icon: const Icon(Icons.upload_file),
                      label: const Text('Upload Resume (PDF)'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF1A237E),
                        side: const BorderSide(color: Color(0xFF1A237E)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  
                if (_parsedProfile != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, size: 16, color: Colors.green),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Profile analyzed! We\'ll personalize your experience.',
                            style: GoogleFonts.inter(fontSize: 12, color: Colors.green[800]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'We use this to personalize your emails and interview questions.',
            style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[500]),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _portfolioController,
            decoration: const InputDecoration(
              labelText: 'Portfolio URL (Optional)',
              hintText: 'https://...',
              prefixIcon: Icon(Icons.link),
            ),
          ),
        ],
      ),
    );
  }
}

class PersonalizedHomeScreen extends StatelessWidget {
  final UserProfile profile;

  const PersonalizedHomeScreen({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back,',
              style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[600]),
            ),
            Text(
              profile.name,
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black87),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
          PopupMenuButton<String>(
            offset: const Offset(0, 56),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(
                backgroundColor: const Color(0xFF1A237E),
                child: Text(
                  profile.name.isNotEmpty ? profile.name[0].toUpperCase() : 'U',
                  style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            onSelected: (value) async {
              if (value == 'edit_profile') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => EditProfileScreen(profile: profile)),
                );
              } else if (value == 'logout') {
                await ProfileService().clearCredentials();
                await ProfileService().clearProfile();
                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/welcome', (route) => false);
                }
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'edit_profile',
                child: Row(
                  children: [
                    const Icon(Icons.person_outline, color: Colors.black87, size: 20),
                    const SizedBox(width: 12),
                    Text('Edit Profile', style: GoogleFonts.inter(fontSize: 14)),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'activity',
                child: Row(
                  children: [
                    const Icon(Icons.history, color: Colors.black87, size: 20),
                    const SizedBox(width: 12),
                    Text('Activity', style: GoogleFonts.inter(fontSize: 14)),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    const Icon(Icons.logout, color: Colors.red, size: 20),
                    const SizedBox(width: 12),
                    Text('Logout', style: GoogleFonts.inter(fontSize: 14, color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Summary Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1A237E), Color(0xFF3949AB)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1A237E).withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Your Profile',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          profile.primaryIndustry,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildProfileStat('Experience', profile.experienceBand),
                  const SizedBox(height: 8),
                  _buildProfileStat('Skills', profile.skills.take(3).join(", ")),
                  if (profile.goals != null && profile.goals!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.flag_outlined, color: Colors.white70, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              profile.goals!,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: Colors.white.withValues(alpha: 0.1),
                                fontStyle: FontStyle.italic,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            Text(
              'Quick Actions',
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            // Primary Actions Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1,
              children: [
                _buildActionCard(
                  context,
                  'Write Application',
                  Icons.edit_document,
                  const Color(0xFFE3F2FD),
                  const Color(0xFF1565C0),
                  () {
                    Navigator.pushNamed(
                      context,
                      '/writer',
                      arguments: {
                        'industry': profile.primaryIndustry,
                        'profile': profile,
                      },
                    );
                  },
                ),
                _buildActionCard(
                  context,
                  'Practice Interview',
                  Icons.mic,
                  const Color(0xFFE0F2F1),
                  const Color(0xFF00695C),
                  () {
                    Navigator.pushNamed(
                      context,
                      '/speaker',
                      arguments: {
                        'industry': profile.primaryIndustry,
                        'experienceBand': profile.experienceBand,
                        'profile': profile,
                      },
                    );
                  },
                ),
                _buildActionCard(
                  context,
                  'Question Bank',
                  Icons.menu_book_rounded,
                  const Color(0xFFF3E5F5),
                  const Color(0xFF6A1B9A),
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const QuestionBankIndustrySelectorScreen(),
                      ),
                    );
                  },
                ),

              ],
            ),
            
            const SizedBox(height: 24),



            // Community Hero Button
            CommunityHeroButton(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const CommunityHomeScreen(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      const begin = Offset(0.0, 1.0);
                      const end = Offset.zero;
                      const curve = Curves.easeOutCubic;
                      var tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));
                      return SlideTransition(
                        position: animation.drive(tween),
                        child: FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                      );
                    },
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // Ad Banner
            const Center(child: AdBanner()),
            
            const SizedBox(height: 24),


          ],
        ),
      ),
    );
  }

  Widget _buildProfileStat(String label, String value) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: GoogleFonts.inter(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 14,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    IconData icon,
    Color bgColor,
    Color iconColor,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      elevation: 0, // Flat style with border or shadow
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade100),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 28),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
