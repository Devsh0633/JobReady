class UserProfile {
  final String id; // User ID from Firestore
  final String email;
  final String name;
  final String primaryIndustry; // "IT & Software", "Sales & Marketing", "Core Engineering", "BPO & Support"
  final String experienceBand; // "Fresher (0 years)", "1–3 years", "3–5 years"
  final List<String> skills; // up to 3 skill strings
  final String? goals; // short statement like "Get first core job"
  final String? resumeUrl;
  final String? portfolioUrl;

  UserProfile({
    required this.id,
    required this.email,
    required this.name,
    required this.primaryIndustry,
    required this.experienceBand,
    required this.skills,
    this.goals,
    this.resumeUrl,
    this.portfolioUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'primaryIndustry': primaryIndustry,
      'experienceBand': experienceBand,
      'skills': skills,
      'goals': goals,
      'resumeUrl': resumeUrl,
      'portfolioUrl': portfolioUrl,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String? ?? '', // Handle missing ID gracefully
      email: json['email'] as String,
      name: json['name'] as String,
      primaryIndustry: json['primaryIndustry'] as String,
      experienceBand: json['experienceBand'] as String,
      skills: List<String>.from(json['skills'] as List),
      goals: json['goals'] as String?,
      resumeUrl: json['resumeUrl'] as String?,
      portfolioUrl: json['portfolioUrl'] as String?,
    );
  }
}
