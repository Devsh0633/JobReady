import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'auth_screens.dart';
import 'features/auth/presentation/welcome_screen.dart';
import 'package:google_fonts/google_fonts.dart';


import 'features/writer/presentation/writer_screen.dart';
import 'features/speaker/presentation/speaker_screen.dart';




import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'features/ads/ad_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await MobileAds.instance.initialize();
  
  // Preload ads
  AdHelper.loadInterstitialAd();
  AdHelper.loadRewardedAd();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JobReady',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFF1A237E), // Deep Indigo
        scaffoldBackgroundColor: const Color(0xFFF8F9FC), // Soft Blue-Grey
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A237E),
          primary: const Color(0xFF1A237E),
          secondary: const Color(0xFF00E5FF), // Cyan Accent
          surface: Colors.white,

        ),
        textTheme: GoogleFonts.interTextTheme(),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF1A237E), width: 2),
          ),
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
      home: const AuthGate(),
      routes: {
        '/welcome': (context) => const WelcomeScreen(),

        '/mode_selection': (context) => const ModeSelectionScreen(),
        '/writer': (context) => const WriterScreen(),
        '/speaker': (context) => const SpeakerScreen(),
        '/leaks': (context) => const InterviewLeaksScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
      },
    );
  }
}

// Placeholder Screens



class ModeSelectionScreen extends StatelessWidget {
  const ModeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    String industry = "IT & Software";
    if (args is String) {
      industry = args;
    } else if (args is Map) {
      industry = args['industry'] ?? "IT & Software";
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        title: Text('Select Mode', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8EAF6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Selected Industry',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1A237E),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      industry,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1A237E),
                      ),
                    ),
                    const SizedBox(height: 48),
                    _buildModeButton(
                      context,
                      'Write My Application',
                      'Generate cover letters & emails',
                      Icons.edit_document,
                      const Color(0xFF1A237E),
                      () {
                        Navigator.pushNamed(
                          context,
                          '/writer',
                          arguments: industry,
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    _buildModeButton(
                      context,
                      'Practice Interview',
                      'AI-powered voice analysis',
                      Icons.mic,
                      const Color(0xFF00E5FF),
                      () {
                        Navigator.pushNamed(
                          context,
                          '/speaker',
                          arguments: {'industry': industry},
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeButton(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 32, color: color),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}





class InterviewLeaksScreen extends StatelessWidget {
  const InterviewLeaksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final industry = ModalRoute.of(context)?.settings.arguments as String? ?? "All Industries";

    return Scaffold(
      appBar: AppBar(
        title: const Text('InterviewLeaksScreen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Showing recent questions from multiple companies',
              style: GoogleFonts.poppins(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Focus on $industry',
              style: GoogleFonts.poppins(
                fontSize: 18, 
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor
              ),
            ),
            const SizedBox(height: 32),
            const Text('Coming Soon'),
          ],
        ),
      ),
    );
  }
}
