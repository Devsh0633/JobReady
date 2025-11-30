import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:read_pdf_text/read_pdf_text.dart';
import 'candidate_profile.dart';
import '../ai/ai_client.dart';

class CandidateProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Collection reference
  CollectionReference<Map<String, dynamic>> get _profiles =>
      _firestore.collection('candidate_profiles');

  /// Process a resume PDF: Extract text -> Parse with Gemini -> Upload to Storage -> Save to Firestore
  Future<CandidateProfile> processResume(String userId, String filePath) async {
    try {
      // 1. Extract text from PDF
      String text = "";
      try {
        text = await ReadPdfText.getPDFtext(filePath);
      } catch (e) {
        print("Error reading PDF: $e");
        throw Exception("Failed to extract text from PDF: $e");
      }

      if (text.isEmpty) {
        throw Exception("PDF content is empty");
      }

      // 2. Parse with Gemini (Real AI)
      final Map<String, dynamic> jsonProfile = await AiClient.instance.parseResume(text);

      // 3. Upload PDF to Firebase Storage
      String downloadUrl = "";
      try {
        downloadUrl = await uploadResume(File(filePath), userId);
      } catch (e) {
        print("Error uploading resume: $e");
        // We continue even if upload fails, but ideally we should handle this.
        // For now, we'll just use the local path as fallback or empty.
      }

      // 4. Create CandidateProfile object
      final profile = CandidateProfile.fromJson({
        'userId': userId,
        'resumeStoragePath': downloadUrl.isNotEmpty ? downloadUrl : filePath, 
        ...jsonProfile,
      });

      // 5. Save to Firestore
      await saveProfile(profile);

      return profile;
    } catch (e) {
      print('Error processing resume: $e');
      rethrow;
    }
  }

  /// Uploads the resume file to Firebase Storage and returns the download URL
  Future<String> uploadResume(File file, String userId) async {
    try {
      final ref = _storage.ref().child('resumes/$userId/resume.pdf');
      final uploadTask = ref.putFile(file);
      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception("Failed to upload resume: $e");
    }
  }

  // Keep the mock for fallback if needed, or remove it. 
  // Renaming it to indicate it's a fallback/mock.
  Future<CandidateProfile> processResumeMock(String userId, String filePath) async {
     // Redirect to the real one
     return processResume(userId, filePath);
  }

  Future<void> saveProfile(CandidateProfile profile) async {
    try {
      await _profiles.doc(profile.userId).set(profile.toJson());
    } catch (e) {
      print('Error saving candidate profile: $e');
      rethrow;
    }
  }

  Future<CandidateProfile?> getProfile(String userId) async {
    try {
      final doc = await _profiles.doc(userId).get();
      if (doc.exists && doc.data() != null) {
        return CandidateProfile.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      print('Error fetching candidate profile: $e');
      return null;
    }
  }
}
