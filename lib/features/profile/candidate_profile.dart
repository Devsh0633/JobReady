import 'package:cloud_firestore/cloud_firestore.dart';

class CandidateProfile {
  final String userId;
  final String resumeStoragePath;
  final String summary;
  final String primaryIndustry;
  final String yearsExperience;
  final List<CandidateRole> roles;
  final List<String> skills;
  final List<CandidateEducation> education;
  final List<CandidateGap> gaps;
  final DateTime? updatedAt;

  CandidateProfile({
    required this.userId,
    required this.resumeStoragePath,
    required this.summary,
    required this.primaryIndustry,
    required this.yearsExperience,
    required this.roles,
    required this.skills,
    required this.education,
    required this.gaps,
    this.updatedAt,
  });

  factory CandidateProfile.fromJson(Map<String, dynamic> json) {
    return CandidateProfile(
      userId: json['userId'] ?? '',
      resumeStoragePath: json['resumeStoragePath'] ?? '',
      summary: json['summary'] ?? '',
      primaryIndustry: json['primaryIndustry'] ?? '',
      yearsExperience: json['yearsExperience'] ?? '',
      roles: (json['roles'] as List<dynamic>?)
              ?.map((e) => CandidateRole.fromJson(e))
              .toList() ??
          [],
      skills: (json['skills'] as List<dynamic>?)?.cast<String>() ?? [],
      education: (json['education'] as List<dynamic>?)
              ?.map((e) => CandidateEducation.fromJson(e))
              .toList() ??
          [],
      gaps: (json['gaps'] as List<dynamic>?)
              ?.map((e) => CandidateGap.fromJson(e))
              .toList() ??
          [],
      updatedAt: json['updatedAt'] != null
          ? (json['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'resumeStoragePath': resumeStoragePath,
      'summary': summary,
      'primaryIndustry': primaryIndustry,
      'yearsExperience': yearsExperience,
      'roles': roles.map((e) => e.toJson()).toList(),
      'skills': skills,
      'education': education.map((e) => e.toJson()).toList(),
      'gaps': gaps.map((e) => e.toJson()).toList(),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }
}

class CandidateRole {
  final String title;
  final String company;
  final String duration;
  final List<String> highlights;
  final List<String> skills;

  CandidateRole({
    required this.title,
    required this.company,
    required this.duration,
    required this.highlights,
    required this.skills,
  });

  factory CandidateRole.fromJson(Map<String, dynamic> json) {
    String duration = json['duration'] ?? '';
    if (duration.isEmpty && (json['start'] != null || json['end'] != null)) {
      duration = "${json['start'] ?? ''} - ${json['end'] ?? ''}";
    }
    
    return CandidateRole(
      title: json['title'] ?? '',
      company: json['company'] ?? '',
      duration: duration,
      highlights: (json['highlights'] as List<dynamic>?)?.cast<String>() ?? 
                  (json['achievements'] as List<dynamic>?)?.cast<String>() ?? [],
      skills: (json['skills'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'company': company,
      'duration': duration,
      'highlights': highlights,
      'skills': skills,
    };
  }
}

class CandidateEducation {
  final String degree;
  final String year; // Changed to String to be flexible
  final String institution;

  CandidateEducation({
    required this.degree,
    required this.year,
    this.institution = '',
  });

  factory CandidateEducation.fromJson(Map<String, dynamic> json) {
    return CandidateEducation(
      degree: json['degree'] ?? '',
      year: json['year']?.toString() ?? '',
      institution: json['institution'] ?? json['school'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'degree': degree,
      'year': year,
      'institution': institution,
    };
  }
}

class CandidateGap {
  final String from;
  final String to;
  final String note;

  CandidateGap({
    required this.from,
    required this.to,
    required this.note,
  });

  factory CandidateGap.fromJson(Map<String, dynamic> json) {
    return CandidateGap(
      from: json['from'] ?? json['start'] ?? '',
      to: json['to'] ?? json['end'] ?? '',
      note: json['note'] ?? json['duration'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'from': from,
      'to': to,
      'note': note,
    };
  }
}
