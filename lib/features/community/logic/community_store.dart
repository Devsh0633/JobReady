
import 'package:flutter/foundation.dart';
import 'dart:math' as math;
import '../data/community_post_model.dart';
import '../data/sample_community_posts.dart';
import '../data/community_notification_model.dart';
import 'package:collection/collection.dart';
import '../ml/ml_features.dart';
import '../ml/ml_predictor.dart';
import '../debug/debug_log.dart';
import '../debug/bot_swarm.dart';
import '../debug/score_debug_store.dart';
import '../debug/feed_debug_snapshot.dart';
import '../debug/debug_control_store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:new_project/features/auth/profile_service.dart';
import 'package:new_project/features/auth/user_profile.dart';

class TelemetrySnapshot {
  final int dwellTimeMs;
  final bool expanded;
  final bool openedComments;

  TelemetrySnapshot({
    required this.dwellTimeMs,
    required this.expanded,
    required this.openedComments,
  });
}

class SessionActivity {
  final DateTime timestamp;
  final String postId;
  final String action; // "like", "comment", "view", "expand", "dwell"
  final List<String> tags;
  final String? authorId;
  final String? industryTag;
  final String? format;

  SessionActivity({
    required this.timestamp,
    required this.postId,
    required this.action,
    required this.tags,
    this.authorId,
    this.industryTag,
    this.format,
  });
}

class UserBehaviorProfile {
  final String userId;
  final Map<String, int> industryScores;
  final Map<String, int> topicScores;
  final Map<String, int> formatScores;
  final Map<String, int> communityScores;
  final Map<String, int> authorScores;
  final Set<String> likedPostIds;
  final Set<String> hiddenPostIds;
  final String? onboardingIndustry;

  bool get isColdStart {
    final hasLikes = likedPostIds.isNotEmpty;
    final hasIndustrySignal = industryScores.values.any((v) => v > 0.05);
    return !hasLikes && !hasIndustrySignal;
  }

  String? get primaryIndustry {
    if (industryScores.isEmpty) return onboardingIndustry;
    String? bestKey;
    double bestVal = double.negativeInfinity;
    industryScores.forEach((k, v) {
      if (v > bestVal) {
        bestVal = v.toDouble();
        bestKey = k;
      }
    });
    return bestKey ?? onboardingIndustry;
  }

  final bool isSimulated;
  final String? simulatedLabel;

  UserBehaviorProfile({
    this.userId = 'user_me',
    this.industryScores = const {},
    this.topicScores = const {},
    this.formatScores = const {},
    this.communityScores = const {},
    this.authorScores = const {},
    this.likedPostIds = const {},
    this.hiddenPostIds = const {},
    this.onboardingIndustry,
    this.isSimulated = false,
    this.simulatedLabel,
  });

  UserBehaviorProfile copyWith({
    String? userId,
    Map<String, int>? industryScores,
    Map<String, int>? topicScores,
    Map<String, int>? formatScores,
    Map<String, int>? communityScores,
    Map<String, int>? authorScores,
    Set<String>? likedPostIds,
    Set<String>? hiddenPostIds,
    String? onboardingIndustry,
  }) {
    return UserBehaviorProfile(
      userId: userId ?? this.userId,
      industryScores: industryScores ?? this.industryScores,
      topicScores: topicScores ?? this.topicScores,
      formatScores: formatScores ?? this.formatScores,
      communityScores: communityScores ?? this.communityScores,
      authorScores: authorScores ?? this.authorScores,
      likedPostIds: likedPostIds ?? this.likedPostIds,
      hiddenPostIds: hiddenPostIds ?? this.hiddenPostIds,
      onboardingIndustry: onboardingIndustry ?? this.onboardingIndustry,
      isSimulated: isSimulated,
      simulatedLabel: simulatedLabel,
    );
  }

  // Cold start constructor for new users with known industry
  factory UserBehaviorProfile.coldStartForIndustry(String primaryIndustry) {
    // Strong bias: 1.0 for main, 0.2 for others (scaled to int scores 10 vs 2)
    final allIndustries = [
      'IT & Software',
      'Sales & Marketing',
      'BPO & Support',
      'Core Engineering',
      'Finance',
    ];
    
    final Map<String, int> industryScores = {};
    for (final ind in allIndustries) {
      if (ind == primaryIndustry) {
        industryScores[ind] = 10; // Dominant
      } else {
        industryScores[ind] = 2; // Weak explore signal
      }
    }

    return UserBehaviorProfile(
      userId: 'cold_start_user',
      industryScores: industryScores,
      topicScores: _getDefaultTopicsForIndustry(primaryIndustry),
      formatScores: {'story': 5, 'question': 3, 'resource': 2},
      isSimulated: false,
    );
  }

  // Generic cold start for completely anonymous users
  factory UserBehaviorProfile.genericColdStart() {
    return UserBehaviorProfile(
      userId: 'anonymous_user',
      industryScores: {
        'IT & Software': 2,
        'Sales & Marketing': 2,
        'BPO': 2,
        'Finance': 2,
      },
      topicScores: {
        'Interview': 3,
        'Resume': 3,
        'Career': 3,
      },
      formatScores: {'story': 3, 'question': 3, 'resource': 2},
      isSimulated: false,
    );
  }

  // Persona: IT Professional
  factory UserBehaviorProfile.itPersona() {
    return UserBehaviorProfile(
      userId: 'persona_it',
      industryScores: {'IT & Software': 15},
      topicScores: {
        'DSA': 10,
        'System Design': 10,
        'Algorithms': 8,
        'Coding': 8,
        'Interview': 6,
      },
      formatScores: {'question': 8, 'story': 5, 'resource': 6},
      isSimulated: true,
      simulatedLabel: 'IT Persona',
    );
  }

  // Persona: Marketing Professional
  factory UserBehaviorProfile.marketingPersona() {
    return UserBehaviorProfile(
      userId: 'persona_marketing',
      industryScores: {'Sales & Marketing': 15},
      topicScores: {
        'Case Study': 10,
        'Strategy': 8,
        'Communication': 8,
        'Interview': 6,
      },
      formatScores: {'story': 8, 'resource': 6, 'question': 4},
      isSimulated: true,
      simulatedLabel: 'Marketing Persona',
    );
  }

  // Persona: BPO Professional
  factory UserBehaviorProfile.bpoPersona() {
    return UserBehaviorProfile(
      userId: 'persona_bpo',
      industryScores: {'BPO': 15},
      topicScores: {
        'Communication': 10,
        'Interview': 8,
        'Resume': 6,
        'Career': 6,
      },
      formatScores: {'story': 7, 'question': 6, 'resource': 5},
      isSimulated: true,
      simulatedLabel: 'BPO Persona',
    );
  }

  // Persona: Core Engineering
  factory UserBehaviorProfile.coreEngineeringPersona() {
    return UserBehaviorProfile(
      userId: 'persona_engineering',
      industryScores: {'Engineering': 15, 'IT & Software': 8},
      topicScores: {
        'System Design': 10,
        'Technical': 9,
        'Algorithms': 7,
        'Interview': 6,
      },
      formatScores: {'question': 8, 'resource': 7, 'story': 4},
      isSimulated: true,
      simulatedLabel: 'Core Engineering Persona',
    );
  }

  // Persona: Meme Lover
  factory UserBehaviorProfile.memeLoverPersona() {
    return UserBehaviorProfile(
      userId: 'persona_meme',
      industryScores: {'IT & Software': 5, 'General': 10},
      topicScores: {
        'Humor': 10,
        'Memes': 10,
        'Career': 4,
      },
      formatScores: {'meme': 10, 'story': 6, 'resource': 3},
      isSimulated: true,
      simulatedLabel: 'Meme Lover Persona',
    );
  }

  // Persona: Job Seeker
  factory UserBehaviorProfile.jobSeekerPersona() {
    return UserBehaviorProfile(
      userId: 'persona_jobseeker',
      industryScores: {'General': 10},
      topicScores: {
        'Resume': 10,
        'Interview': 10,
        'Career': 8,
        'Job Search': 8,
      },
      formatScores: {'resource': 8, 'story': 7, 'question': 6},
      isSimulated: true,
      simulatedLabel: 'Job-Seeker Persona',
    );
  }

  static Map<String, int> _getDefaultTopicsForIndustry(String industry) {
    switch (industry) {
      case 'IT & Software':
        return {'DSA': 6, 'Algorithms': 5, 'Interview': 5};
      case 'Sales & Marketing':
        return {'Case Study': 6, 'Strategy': 5, 'Interview': 5};
      case 'BPO':
        return {'Communication': 6, 'Interview': 5, 'Career': 4};
      case 'Finance':
        return {'Analysis': 6, 'Interview': 5, 'Career': 4};
      default:
        return {'Interview': 5, 'Career': 4, 'Resume': 4};
    }
  }
}

class CommunityStore {
  // Debug control for remote bot swarm management
  late final DebugControlStore debugControlStore;
  
  // Current user profile (loaded async)
  UserProfile? _currentUserProfile;

  CommunityStore._() {
    // Initialize debug control store and start listening to Firestore
    debugControlStore = DebugControlStore(
      firestore: FirebaseFirestore.instance,
      botSwarm: BotSwarm.instance,
    );
    debugControlStore.startListening();

    // Seed a few notifications on init ONLY if user has posted (to avoid fake history)
    if (hasCurrentUserPosted) {
      _addNotification(
        'Riya liked your interview answer on "Tell me about yourself."',
      );
      _addNotification(
        'Aman commented on your post "Got rejected at Infosys – AMA."',
      );
    }
    
    // NORMAL MODE: Seed 1-2 bot posts on app initialization
    Future.delayed(const Duration(milliseconds: 500), () {
      BotSwarm.instance.seedBasicBotPostsIfNeeded();
    });

    // Load user profile for debug snapshots
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      _currentUserProfile = await ProfileService().loadProfile();
    } catch (e) {
      debugPrint('CommunityStore: Failed to load user profile: $e');
    }
  }

  static final CommunityStore instance = CommunityStore._();

  // In a real app, current user would come from auth/profile.
  // For now, we use a simple placeholder name.
  final String currentUserName = 'You';
  final String currentUserTag = 'JobReady user';

  static const String _bot1Name = 'Riya (Senior Dev)';
  static const String _bot1Tag = 'SDE-2 @ Product Startup';
  static const String _bot2Name = 'Aman (HR Buddy)';
  static const String _bot2Tag = 'Campus Recruiter';

  bool _hasBotReplied(CommunityPost post) {
    return post.replies.any((r) =>
        r.authorName == _bot1Name || r.authorName == _bot2Name);
  }

  final String currentUserId = 'user_me';
  final String currentUserIndustryTag = 'IT & Software';
  String? _currentPersonaId;

  bool get hasCurrentUserPosted {
    return posts.any((p) => p.authorId == currentUserId);
  }

  final ValueNotifier<List<CommunityPost>> postsNotifier =
      ValueNotifier<List<CommunityPost>>(List.from(sampleCommunityPosts));

  final ValueNotifier<List<CommunityNotification>> notificationsNotifier =
      ValueNotifier<List<CommunityNotification>>([]);

  final ValueNotifier<UserBehaviorProfile> userProfileNotifier =
      ValueNotifier<UserBehaviorProfile>(UserBehaviorProfile(userId: 'user_me'));

  /// ML-powered user preference vector
  UserVector userVector = UserVector.empty();

  /// Telemetry temporary buffers
  final Map<String, DateTime> _postOpenTimestamps = {};
  final Map<String, bool> _expandedFlags = {};
  final Map<String, bool> _openedCommentsFlags = {};
  
  /// Social Proximity Memory: userId -> interaction count
  final Map<String, int> _userAuthorInteractions = {};

  /// Session Intelligence Window (last 10 actions)
  final List<SessionActivity> _sessionWindow = [];
  final ValueNotifier<List<SessionActivity>> sessionWindowNotifier = ValueNotifier([]);

  /// Feed Debug Snapshots for Explainer Panel
  final ValueNotifier<List<FeedDebugSnapshot>> feedDebugSnapshotsNotifier = ValueNotifier([]);

  List<CommunityPost> get posts => postsNotifier.value;
  List<CommunityNotification> get notifications =>
      notificationsNotifier.value;
  UserBehaviorProfile get userProfile => userProfileNotifier.value;
  List<SessionActivity> get debugSessionWindow => List.unmodifiable(_sessionWindow);

  // --- Feed Getters ---

  List<CommunityPost> getForYouPosts() {
    // Automatically enable debug streaming when For You feed is accessed
    ScoreDebugStore.instance.ensureStreamingForCommunityFeed();
    
    return getForYouPostsForProfile(userProfile);
  }

  Map<String, double> _buildEffectiveIndustryWeights(UserBehaviorProfile profile) {
    // 1. Base weights from profile (normalized)
    final baseWeights = <String, double>{};
    double totalBase = 0;
    if (profile.industryScores.isNotEmpty) {
      profile.industryScores.forEach((k, v) {
        baseWeights[k] = v.toDouble();
        totalBase += v;
      });
    }
    
    if (totalBase > 0) {
      baseWeights.updateAll((k, v) => v / totalBase);
    }

    // 2. Session weights
    final sessionMix = _computeSessionIndustryMix();

    // 3. Combine
    final effective = <String, double>{};
    final allKeys = {...baseWeights.keys, ...sessionMix.keys};
    
    for (final key in allKeys) {
      final baseW = baseWeights[key] ?? 0.0;
      final sessionW = sessionMix[key] ?? 0.0;
      // Blend: 60% base, 40% session (as per prompt)
      // But if session is empty, base is 100%.
      if (sessionMix.isEmpty) {
        effective[key] = baseW;
      } else {
        effective[key] = (0.6 * baseW) + (0.4 * sessionW);
      }
    }
    
    return effective;
  }

  List<CommunityPost> getForYouPostsForProfile(UserBehaviorProfile profile) {
    // Temporarily swap profile for simulation (only if simulated)
    final originalProfile = userProfile;
    if (profile.isSimulated) {
      userProfileNotifier.value = profile;
    }

    final visiblePosts = posts
        .where((p) => !profile.hiddenPostIds.contains(p.id))
        .toList();

    // For debug visualizer: store components by postId
    final Map<String, _ScoreComponent> scoreParts = {};
    final Map<String, _DetailedScoreBreakdown> detailedBreakdowns = {};

    // Pre-calculate global maxes for normalization
    int maxLikes = 1;
    int maxComments = 1;
    int maxPosts = 1;

    if (visiblePosts.isNotEmpty) {
      maxLikes = visiblePosts.map((p) => p.authorTotalLikes).reduce(math.max);
      maxComments = visiblePosts.map((p) => p.authorTotalComments).reduce(math.max);
      maxPosts = visiblePosts.map((p) => p.authorTotalPosts).reduce(math.max);
    }
    if (maxLikes == 0) maxLikes = 1;
    if (maxComments == 0) maxComments = 1;
    if (maxPosts == 0) maxPosts = 1;

    // ML-blended scoring
    final scored = visiblePosts.map((p) {
      final pv = buildVectorForPost(p);
      
      // Calculate ALL individual components for detailed breakdown
      final topicMatch = _topicMatchScore(p);
      final formatPref = _formatPreferenceScore(p);
      final communityAff = _communityAffinityScore(p);
      final authorAff = _authorAffinityScore(p);
      final engagement = _engagementQualityScore(p);
      final freshness = _freshnessScore(p);
      final negative = _negativeSignalScore(p);
      
      final rep = _authorReputationScore(p, maxLikes, maxComments, maxPosts);
      final prox = _socialProximityScore(p);
      final spike = _sessionSpikeScore(p);

      // Add to rule score
      var rule = _scoreForUser(p);
      // Clamp final rule score to 100 max (it was roughly 0-60 before)
      rule = rule.clamp(0.0, 100.0);

      final ml = mlScore(userVector, pv, rule);

      final telemetry = collectTelemetry(p.id);
      final pred = predictEngagement(
        score: ml,
        dwellTimeMs: telemetry.dwellTimeMs,
        expanded: telemetry.expanded,
        openedComments: telemetry.openedComments,
      );

      // Store detailed breakdown for explainer panel
      detailedBreakdowns[p.id] = _DetailedScoreBreakdown(
        topicScore: topicMatch,
        formatScore: formatPref,
        communityScore: communityAff,
        authorScore: authorAff,
        engagementScore: engagement,
        freshnessScore: freshness,
        mlProb: pred.probability,
        sessionSpike: spike,
        reputationScore: rep,
        proximityScore: prox,
        negativePenalty: negative,
        finalScoreBeforeModifiers: rule,
      );

      // Store components for debug visualizer
      scoreParts[p.id] = _ScoreComponent(
        topicScore: topicMatch,
        freshnessScore: freshness,
        mlProbability: pred.probability,
        ruleScore: rule,
        reputationScore: rep,
        proximityScore: prox,
        sessionSpikeScore: spike,
      );
      
      // Log if debug console is active
      DebugLog.instance.add(
        "REP ${p.authorId}: ${rep.toStringAsFixed(1)} | PROX ${prox.toStringAsFixed(1)} | SPIKE ${spike.toStringAsFixed(1)} | RULE ${rule.toStringAsFixed(1)}"
      );

      return MapEntry(p, pred.probability);
    }).toList();

    // Industry Scaling (Step 4 of plan)
    final industryWeights = _buildEffectiveIndustryWeights(profile);
    final scaledScored = scored.map((entry) {
      final post = entry.key;
      final originalProb = entry.value;
      
      final factor = industryWeights[post.industryTag] ?? 0.0;
      // Boost: 1.0 + 0.5 * factor (factor 0..1 -> 1.0..1.5)
      final boost = 1.0 + (0.5 * factor);
      
      // We apply this boost to the "probability" used for sorting, 
      // or we should have applied it to the rule score earlier?
      // The prompt says: "Apply industry scaling to each post’s final score".
      // Here we have `entry.value` which is `pred.probability` (ML output).
      // The ML output is 0-1.
      // Let's boost the probability for sorting purposes.
      
      final boostedProb = (originalProb * boost).clamp(0.0, 1.0);
      return MapEntry(post, boostedProb);
    }).toList();

    // 1) Sort by boosted probability
    scaledScored.sort((a, b) => b.value.compareTo(a.value));

    // 2) Apply explore–exploit BEFORE diversity
    final blended = _applyExploreExploit(scaledScored);

    // 3) Apply diversity AFTER explore–exploit
    final diversified = _applyDiversity(blended);

    // Emit debug snapshot
    _emitDebugSnapshotForRankedPosts(
      userId: _currentUserProfile?.email ?? currentUserId,
      userDisplayName: _currentUserProfile?.name ?? currentUserId,
      personaId: _currentPersonaId ?? 'real_user',
      feedType: 'for_you',
      rankedPosts: diversified,
      sessionActivity: _sessionWindow,
      detailedBreakdowns: detailedBreakdowns,
      scoreComponents: scoreParts,
    );

    DebugLog.instance.add("FinalRankingBuilt: count=${diversified.length}");

    // Restore original profile if we swapped it
    if (profile.isSimulated) {
      userProfileNotifier.value = originalProfile;
    }

    return diversified;


  }

  List<CommunityPost> getTrendingPosts() {
    final now = DateTime.now();
    final allPosts = List<CommunityPost>.from(posts);

    double trendingScore(CommunityPost p) {
      final hours = now
          .difference(p.createdAt)
          .inHours
          .toDouble()
          .clamp(1.0, 72.0); // avoid division by zero, cap at 72h
      final numerator = p.likeCount + p.commentCount * 2 + p.shareCount * 3;
      return numerator / hours;
    }

    allPosts.sort((a, b) => trendingScore(b).compareTo(trendingScore(a)));
    return allPosts;
  }

  List<CommunityPost> getMyThreads() {
    final myPosts = posts.where((p) => p.authorId == currentUserId).toList();
    myPosts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return myPosts;
  }

  List<CommunityPost> getLikedPostsForUser(String userId, UserBehaviorProfile profile) {
    final liked = posts.where((p) => profile.likedPostIds.contains(p.id)).toList();
    liked.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return liked;
  }

  List<CommunityPost> getCommentedPostsForUser(String userId) {
    final commented = posts.where((p) {
      return p.replies.any((r) => r.authorId == userId);
    }).toList();
    commented.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return commented;
  }

  List<CommunityReply> getRepliesForPost(String postId) {
    final post = posts.firstWhereOrNull((p) => p.id == postId);
    if (post == null) return [];
    final replies = List<CommunityReply>.from(post.replies);
    replies.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return replies;
  }

  List<CommunityReply> getRepliesByUser(String userId) {
    final allReplies = <CommunityReply>[];
    for (final post in posts) {
      final userReplies = post.replies.where((r) => r.authorId == userId);
      allReplies.addAll(userReplies);
    }
    allReplies.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return allReplies;
  }

  /// Backfill replies for demo posts that have high comment counts but no actual reply objects.
  /// This ensures the thread detail screen looks plausible in demo mode.
  void ensureDemoReplies(CommunityPost post) {
    // Only for demo/simulated posts that have inflated counts
    if (post.replies.length >= post.commentCount) return;
    if (post.commentCount < 5) return; // Don't bother for small counts

    final needed = math.min(post.commentCount - post.replies.length, 10); // Cap at 10 extra
    final newReplies = <CommunityReply>[];
    final now = DateTime.now();

    for (int i = 0; i < needed; i++) {
      newReplies.add(
        CommunityReply(
          id: 'demo_reply_${post.id}_$i',
          authorName: 'Bot User ${i + 1}',
          authorId: 'bot_demo_${i + 1}',
          roleTag: 'Community Member',
          body: "This is a generated reply for demo purposes to match the comment count.",
          createdAt: now.subtract(Duration(minutes: (needed - i) * 10)),
          upvotes: math.Random().nextInt(10),
          hasCurrentUserUpvoted: false,
          replyToAuthorName: null,
          parentReplyId: null,
        ),
      );
    }

    final updatedReplies = [...post.replies, ...newReplies];
    // We don't update commentCount here because we want to preserve the "inflated" demo count
    // or we update it to match? The prompt says "It’s okay to show higher numbers only if bots actually generate corresponding likes/comments".
    // But also "Thread detail must recompute real comment count (normal mode)".
    // So for demo mode, we just want *some* replies.
    
    final updatedPost = post.copyWith(replies: updatedReplies);
    
    final currentList = List<CommunityPost>.from(posts);
    final index = currentList.indexWhere((p) => p.id == post.id);
    if (index != -1) {
      currentList[index] = updatedPost;
      _updatePosts(currentList);
    }
  }

  List<CommunityPost> getLatestPosts() {
    final visible = posts.where((p) {
      return !userProfile.hiddenPostIds.contains(p.id);
    }).toList();

    visible.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return visible;
  }

  /// Apply diversity constraints on a pre-sorted list of posts.
  ///
  /// - Prevents long streaks from the same author
  /// - Prevents long streaks for the same first topic tag
  ///
  /// This runs AFTER scoring, so we respect the ranking while keeping
  /// the feed feeling fresh and less repetitive.
  List<CommunityPost> _applyDiversity(
    List<CommunityPost> sorted, {
    int maxSameAuthorInARow = 2,
    int maxSameTopicInARow = 2,
  }) {
    if (sorted.length <= 2) return sorted;

    final List<CommunityPost> result = [];
    String? lastAuthorId;
    int sameAuthorStreak = 0;

    String? lastTopic;
    int sameTopicStreak = 0;

    final remaining = List<CommunityPost>.from(sorted);

    while (remaining.isNotEmpty) {
      // Try to pick the first post that doesn't violate constraints
      CommunityPost? picked;
      int pickedIndex = 0;

      for (int i = 0; i < remaining.length; i++) {
        final candidate = remaining[i];

        final authorId = candidate.authorId;
        final topic = candidate.topicTags.isNotEmpty
            ? candidate.topicTags.first
            : null;

        final wouldBreakAuthor =
            (authorId == lastAuthorId && sameAuthorStreak >= maxSameAuthorInARow);

        final wouldBreakTopic =
            (topic != null &&
                topic == lastTopic &&
                sameTopicStreak >= maxSameTopicInARow);

        if (!wouldBreakAuthor && !wouldBreakTopic) {
          picked = candidate;
          pickedIndex = i;
          break;
        }
      }

      // If none found that satisfies constraints, just pick the first (to avoid empty loop)
      picked ??= remaining.first;
      pickedIndex = remaining.indexOf(picked);

      remaining.removeAt(pickedIndex);
      result.add(picked);

      if (pickedIndex != 0) {
        DebugLog.instance.add("DiversityRemoved: ${remaining[0].id} (topic/author repetition)");
      }

      // Update streak tracking
      final pickedAuthor = picked.authorId;
      final pickedTopic =
          picked.topicTags.isNotEmpty ? picked.topicTags.first : null;

      if (pickedAuthor == lastAuthorId) {
        sameAuthorStreak += 1;
      } else {
        lastAuthorId = pickedAuthor;
        sameAuthorStreak = 1;
      }

      if (pickedTopic != null && pickedTopic == lastTopic) {
        sameTopicStreak += 1;
      } else {
        lastTopic = pickedTopic;
        sameTopicStreak = 1;
      }
    }

    return result;
  }

  /// Selects a blend of high-confidence (exploit) and
  /// exploratory (low-certainty or unseen-topic) posts.
  ///
  /// Inputs:
  ///   scoredPosts   → list of (post, probability) sorted descending
  ///   exploreRatio  → % of posts that should come from exploration
  ///
  /// Output:
  ///   a new blended list before diversity filtering.
  List<CommunityPost> _applyExploreExploit(
    List<MapEntry<CommunityPost, double>> scoredPosts, {
    double exploreRatio = 0.15, // 15% exploration
  }) {
    if (scoredPosts.isEmpty) return [];

    final int total = scoredPosts.length;
    final int exploreCount = (total * exploreRatio).round().clamp(1, 5);
    final int exploitCount = total - exploreCount;

    // ----- EXPLOIT (take top N) -----
    final exploitPosts = scoredPosts
        .take(exploitCount)
        .map((e) => e.key)
        .toList();

    // ----- EXPLORE (take from lowest certainty zone) -----
    // pick from the tail 40% of posts to keep it varied
    final tailStart = (total * 0.60).floor();
    final tail = scoredPosts.sublist(tailStart);

    final exploreShuffled = List<MapEntry<CommunityPost, double>>.from(tail)
      ..shuffle();

    final explorePosts = exploreShuffled
        .take(exploreCount)
        .map((e) => e.key)
        .toList();

    // Merge — but keep exploit first so feed “feels smart” while still exploring
    DebugLog.instance.add(
      "ExploreExploit: exploit=${exploitPosts.length}, explore=${explorePosts.length}"
    );
    return [
      ...exploitPosts,
      ...explorePosts,
    ];
  }

  // --- Scoring Helpers ---

  double _topicMatchScore(CommunityPost post) {
    // 1 if topic aligned with user, 0 neutral, for now no negatives.
    if (post.industryTag == currentUserIndustryTag) {
      return 1.0;
    }

    for (final tag in post.topicTags) {
      final engagement = userProfile.topicScores[tag] ?? 0;
      if (engagement > 0) {
        return 1.0;
      }
    }

    return 0.0;
  }

  double _formatPreferenceScore(CommunityPost post) {
    final engagement = userProfile.formatScores[post.format] ?? 0;
    if (engagement <= 0) return 0.0;
    return (engagement / 10.0).clamp(0.0, 1.0);
  }

  double _communityAffinityScore(CommunityPost post) {
    if (post.communityId == 'general') return 0.5;
    
    // Strong binding to profile industry scores
    // Normalize profile score (max usually around 10-20, so divide by 20)
    final rawScore = (userProfile.industryScores[post.industryTag] ?? 0) / 20.0;
    
    // Boost if it matches the explicit "main" industry tag (if we had one stored separately)
    // For now, we rely on the fact that coldStart sets the main industry to 10 and others to 2.
    // So main industry gets ~0.5, others ~0.1.
    
    // However, we want main industry to be 1.0 if possible.
    // Let's check if this is the highest scored industry in profile
    int maxScore = 0;
    if (userProfile.industryScores.isNotEmpty) {
      maxScore = userProfile.industryScores.values.reduce(math.max);
    }
    
    if (maxScore > 0 && (userProfile.industryScores[post.industryTag] ?? 0) == maxScore) {
      return 1.0;
    }

    return rawScore.clamp(0.0, 0.8);
  }

  double _authorAffinityScore(CommunityPost post) {
    if (post.authorId == currentUserId) return 1.0;
    return 0.0;
  }

  // --- Session Intelligence Helpers ---

  Map<String, double> _computeSessionIndustryMix() {
    if (_sessionWindow.isEmpty) return {};

    final counts = <String, double>{};
    double total = 0;

    // Weight recent events more? For now, flat count of last 10 relevant events
    for (final event in _sessionWindow) {
      if (event.industryTag != null) {
        // Only count high-signal events
        double weight = 0.0;
        switch (event.action) {
          case 'like': weight = 2.0; break;
          case 'comment': weight = 3.0; break;
          case 'high_dwell': weight = 1.5; break;
          case 'expand': weight = 1.0; break;
          case 'view': weight = 0.5; break;
          default: weight = 0.2;
        }
        
        counts[event.industryTag!] = (counts[event.industryTag!] ?? 0.0) + weight;
        total += weight;
      }
    }

    if (total == 0) return {};

    // Normalize
    final mix = <String, double>{};
    counts.forEach((key, value) {
      mix[key] = value / total;
    });
    return mix;
  }

  double _computeSessionTopicOverlap(CommunityPost post) {
     if (_sessionWindow.isEmpty) return 0.0;
     
     final sessionTags = <String>{};
     for (final event in _sessionWindow) {
       sessionTags.addAll(event.tags);
     }
     
     if (sessionTags.isEmpty) return 0.0;
     
     final overlap = post.topicTags.toSet().intersection(sessionTags).length;
     return (overlap / 3.0).clamp(0.0, 1.0); // Cap at 3 overlapping tags
  }

  double _engagementQualityScore(CommunityPost post) {
    final likes = post.likeCount.toDouble();
    final comments = post.commentCount.toDouble();
    final shares = post.shareCount.toDouble();

    final raw = likes * 0.5 + comments * 1.0 + shares * 2.0;
    return (raw / 50.0).clamp(0.0, 1.0); // normalize to [0,1]
  }

  double _freshnessScore(CommunityPost post) {
    final now = DateTime.now();
    final ageHours = now.difference(post.createdAt).inHours.toDouble();
    final score = 1.0 - ageHours * 0.02; // -0.02 per hour (~0 after ~2 days)
    DebugLog.instance.add("FreshnessScore: ${post.id} = $score");
    return score.clamp(0.0, 1.0);
  }

  double _authorReputationScore(CommunityPost post, int maxLikes, int maxComments, int maxPosts) {
    final normLikes = (post.authorTotalLikes / maxLikes).clamp(0.0, 1.0);
    final normComments = (post.authorTotalComments / maxComments).clamp(0.0, 1.0);
    final normPosts = (post.authorTotalPosts / maxPosts).clamp(0.0, 1.0);

    final score = (0.4 * normLikes) + (0.4 * normComments) + (0.2 * normPosts);
    return score * 20.0; // Max 20 points
  }

  double _socialProximityScore(CommunityPost post) {
    double score = 0.0;
    
    // +20 if user has liked/commented on this author before
    final interactions = _userAuthorInteractions[post.authorId] ?? 0;
    if (interactions > 0) {
      score += 20.0;
    }

    // +10 if user and author share primaryIndustry
    if (post.industryTag == currentUserIndustryTag) {
      score += 10.0;
    }

    // +5 if user engaged with posts having similar tags recently (simplified: check user vector)
    // We'll check if any of the post's tags have a high weight in userVector
    for (final tag in post.topicTags) {
      if ((userVector.topicWeights[tag] ?? 0) > 0.5) {
        score += 5.0;
        break; // Max +5 for this rule
      }
    }

    return score;
  }

  void _trackSessionActivity({
    required String postId,
    required String action,
    bool isBot = false,
  }) {
    if (isBot) return; // GUARD: Bots don't affect session window
    final post = posts.firstWhereOrNull((p) => p.id == postId);
    if (post == null) return;

    final activity = SessionActivity(
      timestamp: DateTime.now(),
      postId: postId,
      action: action,
      tags: post.topicTags,
      authorId: post.authorId,
      industryTag: post.industryTag,
      format: post.format,
    );

    _sessionWindow.add(activity);

    // Keep only last 10
    if (_sessionWindow.length > 10) {
      _sessionWindow.removeAt(0);
    }

    // Remove older than 20 mins
    final cutoff = DateTime.now().subtract(const Duration(minutes: 20));
    _sessionWindow.removeWhere((a) => a.timestamp.isBefore(cutoff));
    
    // Notify listeners
    sessionWindowNotifier.value = List.from(_sessionWindow);
  }

  double _sessionSpikeScore(CommunityPost post) {
    if (_sessionWindow.isEmpty) return 0.0;

    final mix = _computeSessionIndustryMix();
    double score = 0.0;

    // 1. Industry match from session (0.0 - 1.0)
    final industryWeight = mix[post.industryTag] ?? 0.0;
    score += industryWeight * 20.0; // Scale up to be impactful (0-20 pts)

    // 2. Topic match from session (0.0 - 1.0)
    final topicOverlap = _computeSessionTopicOverlap(post);
    score += topicOverlap * 10.0; // Scale up (0-10 pts)

    // 3. Direct recent interaction (same author/format) - kept from original logic but simplified
    // We can reuse the detailed loop if we want, but the mix+overlap covers 80% of the intent.
    // Let's keep a small boost for recency of specific signals if needed, 
    // but the prompt asked to use the mix.
    
    return score.clamp(0.0, 25.0);
  }

  double _negativeSignalScore(CommunityPost post) {
    if (userProfile.hiddenPostIds.contains(post.id)) {
      return 1.0;
    }
    return 0.0;
  }

  double _coldStartIndustryAffinity(String postIndustry, UserBehaviorProfile profile) {
    // Use onboarding or computed primary industry
    final String? mainIndustry = profile.primaryIndustry ?? profile.onboardingIndustry;
    if (mainIndustry == null) {
      // No clue, return neutral weight
      return 0.5;
    }

    if (postIndustry == mainIndustry) {
      // Strong boost for user’s chosen industry
      return 1.0;
    } else {
      // Small baseline for exploration
      return 0.25;
    }
  }

  double _industryAffinityFromProfile(UserBehaviorProfile profile, String postIndustry) {
    if (profile.industryScores.isEmpty) return 0.5; // Neutral if no scores

    final maxScore = profile.industryScores.values.reduce(math.max);
    if (maxScore == 0) return 0.5; // Avoid division by zero

    final postIndustryScore = profile.industryScores[postIndustry] ?? 0;
    return (postIndustryScore / maxScore).clamp(0.0, 1.0);
  }

  double _scoreForUser(CommunityPost post) {
    // Buried if hidden.
    if (userProfile.hiddenPostIds.contains(post.id)) {
      return -9999.0;
    }

    final topicMatchScore = _topicMatchScore(post);
    
    // Cold Start Logic
    double industryAffinity;
    double freshnessIndustryBoost;
    
    if (userProfile.isColdStart) {
      industryAffinity = _coldStartIndustryAffinity(post.industryTag, userProfile);
      // For cold start, we want strong industry signal, but still respect time
      freshnessIndustryBoost = industryAffinity * (0.6 + 0.4 * _freshnessScore(post));
    } else {
      industryAffinity = _industryAffinityFromProfile(userProfile, post.industryTag);
      // For non-cold users, keep it subtle
      freshnessIndustryBoost = industryAffinity * (0.3 + 0.7 * _freshnessScore(post));
    }

    final authorAffinity = _authorAffinityScore(post);
    final engagementScore = _engagementQualityScore(post);
    final freshnessScore = _freshnessScore(post);
    final sessionSpikeScore = _sessionSpikeScore(post);
    final negativeSignals = _negativeSignalScore(post);

    // Weights (tuned for demo)
    const wTopic = 25.0;
    const wIndustry = 20.0; // Using freshnessIndustryBoost here
    const wAuthor = 15.0;
    const wEngage = 15.0;
    const wFresh = 10.0;
    const wSession = 10.0;
    const wNeg = 20.0;

    final score = 
      (wTopic * topicMatchScore) +
      (wIndustry * freshnessIndustryBoost) + 
      (wAuthor * authorAffinity) +
      (wEngage * engagementScore) +
      (wFresh * freshnessScore) +
      (wSession * sessionSpikeScore) -
      (wNeg * negativeSignals);

    return score;
  }

  PostVector buildVectorForPost(CommunityPost post) {
    return PostVector(
      topicTags: post.topicTags,
      format: post.format,
      communityId: post.communityId,
      likeCount: post.likeCount,
      commentCount: post.commentCount,
      createdAt: post.createdAt,
    );
  }

  double cosineSim(UserVector u, PostVector p) {
    if (p.topicTags.isEmpty) return 0;

    double dot = 0;
    double magU = 0;
    double magP = 0;

    for (final tag in p.topicTags) {
      final w = u.topicWeights[tag] ?? 0;
      dot += w * 1.0;
      magU += w * w;
      magP += 1.0;
    }

    if (magU == 0 || magP == 0) return 0;

    final normU = math.sqrt(magU);
    final normP = math.sqrt(magP);

    return dot / (normU * normP);
  }

  MLScoreBreakdown mlScore(UserVector u, PostVector p, double ruleScore) {
    final cs = cosineSim(u, p);

    // simple probability model (phase 2-lite)
    final prob = (0.25 * cs) +
                 (0.2 * (p.likeCount / 20).clamp(0,1)) +
                 (0.2 * (p.commentCount / 10).clamp(0,1)) +
                 (0.15 * u.recencyBias.clamp(0.5,2.0)) +
                 (0.2 * ((DateTime.now().difference(p.createdAt).inHours) < 4 ? 1 : 0));

    final finalScore = (ruleScore * 0.6) + (prob * 0.4);



    return MLScoreBreakdown(
      cosineSimilarity: cs,
      probabilityScore: prob,
      ruleScore: ruleScore,
      finalBlendedScore: finalScore,
      details: {
        "topic_match": cs,
        "prob_engagement": prob,
        "rule_base": ruleScore,
        "final": finalScore,
      },
    );
  }

  void _updateMLWeights({
    required CommunityPost post,
    required double topicInc,
    required double formatInc,
    required double commInc,
    required double recencyInc,
  }) {
    final newTopicWeights = Map<String, double>.from(userVector.topicWeights);
    for (final tag in post.topicTags) {
      newTopicWeights[tag] = (newTopicWeights[tag] ?? 0.0) + topicInc;
    }

    final newFormatWeights = Map<String, double>.from(userVector.formatWeights);
    newFormatWeights[post.format] = (newFormatWeights[post.format] ?? 0.0) + formatInc;

    final newCommWeights = Map<String, double>.from(userVector.communityWeights);
    newCommWeights[post.communityId] = (newCommWeights[post.communityId] ?? 0.0) + commInc;

    final newRecency = (userVector.recencyBias + recencyInc).clamp(0.0, 2.0);

    userVector = UserVector(
      topicWeights: newTopicWeights,
      formatWeights: newFormatWeights,
      communityWeights: newCommWeights,
      recencyBias: newRecency,
    );
  }

  void _updatePosts(List<CommunityPost> updated) {
    postsNotifier.value = List.unmodifiable(updated);
  }

  void _updateNotifications(List<CommunityNotification> updated) {
    notificationsNotifier.value = List.unmodifiable(updated);
  }

  void _updateUserProfile(UserBehaviorProfile updated) {
    userProfileNotifier.value = updated;
  }

  void _trackInteraction(CommunityPost post, int weight, {bool isBot = false}) {
    if (isBot) return; // GUARD: Bots don't affect user profile

    final profile = userProfile;

    final newIndustryScores = Map<String, int>.from(profile.industryScores);
    newIndustryScores[post.industryTag] =
        (newIndustryScores[post.industryTag] ?? 0) + weight;

    final newTopicScores = Map<String, int>.from(profile.topicScores);
    for (final tag in post.topicTags) {
      newTopicScores[tag] = (newTopicScores[tag] ?? 0) + weight;
    }

    final newFormatScores = Map<String, int>.from(profile.formatScores);
    newFormatScores[post.format] = (newFormatScores[post.format] ?? 0) + weight;

    final newCommunityScores = Map<String, int>.from(profile.communityScores);
    newCommunityScores[post.communityId] =
        (newCommunityScores[post.communityId] ?? 0) + weight;

    final newAuthorScores = Map<String, int>.from(profile.authorScores);
    newAuthorScores[post.authorId] =
        (newAuthorScores[post.authorId] ?? 0) + weight;

    // Update likedPostIds if weight is positive (like)
    final newLikedPostIds = Set<String>.from(profile.likedPostIds);
    if (weight == 1) {
      newLikedPostIds.add(post.id);
    }

    _updateUserProfile(profile.copyWith(
      industryScores: newIndustryScores,
      topicScores: newTopicScores,
      formatScores: newFormatScores,
      communityScores: newCommunityScores,
      authorScores: newAuthorScores,
      likedPostIds: newLikedPostIds,
    ));
  }

  // Toggle upvote on a post
  // --- Bot Specific Actions (Do not affect user profile) ---

  /// Like from an external actor (bot), should NOT mutate current user profile.
  Future<void> likePostAsBot(String postId, {required String botId}) async {
    final post = posts.firstWhereOrNull((p) => p.id == postId);
    if (post == null) return;

    // 1) Increment like count on the post model (in-memory)
    final updatedPost = post.copyWith(
      likeCount: post.likeCount + 1,
      authorTotalLikes: post.authorTotalLikes + 1,
    );
    
    _updatePostInList(updatedPost);
  }

  /// Comment from bot identity
  Future<void> addCommentAsBot({
    required String postId,
    required String botId,
    required String botName,
    required String text,
  }) async {
    final post = posts.firstWhereOrNull((p) => p.id == postId);
    if (post == null) return;

    // Create CommunityReply with authorId = botId, authorName = botName
    final reply = CommunityReply(
      id: 'reply_${DateTime.now().millisecondsSinceEpoch}_${math.Random().nextInt(1000)}',
      authorName: botName,
      authorId: botId,
      roleTag: 'Community Member', // Default role for bots
      body: text,
      createdAt: DateTime.now(),
      upvotes: 0,
      hasCurrentUserUpvoted: false,
    );

    // Append to replies list for that post.
    final updatedReplies = [...post.replies, reply];

    // Increment comment count on the post.
    final updatedPost = post.copyWith(
      replies: updatedReplies,
      commentCount: post.commentCount + 1,
      commentsCount: post.commentsCount + 1, // Update both if they exist
      authorTotalComments: post.authorTotalComments + 1,
    );

    _updatePostInList(updatedPost);
  }

  void _updatePostInList(CommunityPost updatedPost) {
    final currentList = List<CommunityPost>.from(posts);
    final index = currentList.indexWhere((p) => p.id == updatedPost.id);
    if (index != -1) {
      currentList[index] = updatedPost;
      postsNotifier.value = currentList;
    }
  }

  // --- End Bot Specific Actions ---

  void togglePostUpvote(String postId, {bool isBot = false}) {
    final updated = <CommunityPost>[];
    for (final post in posts) {
      if (post.id == postId) {
        final isNowUpvoted = !post.hasCurrentUserUpvoted;
        final newUpvotes =
            post.upvotes + (isNowUpvoted ? 1 : -1).clamp(-post.upvotes, 1);
        updated.add(
          post.copyWith(
            hasCurrentUserUpvoted: isNowUpvoted,
            upvotes: newUpvotes < 0 ? 0 : newUpvotes,
          ),
        );
        if (isNowUpvoted) {
          _trackInteraction(post, 1, isBot: isBot); // +1 for like
          _trackSessionActivity(postId: postId, action: 'like', isBot: isBot);
          
          // Update social proximity
          if (!isBot) {
             _userAuthorInteractions[post.authorId] = (_userAuthorInteractions[post.authorId] ?? 0) + 1;
          }

          // ML Update for Like
          if (!isBot) {
            _updateMLWeights(
              post: post,
              topicInc: 0.4,
              formatInc: 0.3,
              commInc: 0.2,
              recencyInc: 0.02,
            );
          }
        }
      } else {
        updated.add(post);
      }
    }
    _updatePosts(updated);
  }

  void _injectBotEngagement(String postId, {required int stage}) {
    final currentList = posts;
    final index = currentList.indexWhere((p) => p.id == postId);
    if (index == -1) return;

    final post = currentList[index];

    // Only for posts from the current user
    if (!post.isByCurrentUser) return;

    // If bots already replied, do nothing
    if (_hasBotReplied(post)) return;

    final now = DateTime.now();
    final List<CommunityReply> extraReplies = [];

    if (stage == 1) {
      extraReplies.add(
        CommunityReply(
          id: 'bot1_${now.millisecondsSinceEpoch}',
          authorName: _bot1Name,
          authorId: 'bot_riya',
          roleTag: _bot1Tag,
          body:
              "Love how honestly you shared this. Many juniors underestimate how important reflection is. This is a solid step.",
          createdAt: now,
          upvotes: 1,
          hasCurrentUserUpvoted: false,
          replyToAuthorName: post.authorName,
          parentReplyId: null, // top-level reply under the post
        ),
      );
    } else if (stage == 2) {
      extraReplies.add(
        CommunityReply(
          id: 'bot2_${now.millisecondsSinceEpoch}',
          authorName: _bot2Name,
          authorId: 'bot_aman',
          roleTag: _bot2Tag,
          body:
              "From an HR perspective this is exactly the kind of self-awareness we look for. Keep sharing these learnings!",
          createdAt: now,
          upvotes: 1,
          hasCurrentUserUpvoted: false,
          replyToAuthorName: post.authorName,
          parentReplyId: null,
        ),
      );
    } else {
      return;
    }

    if (extraReplies.isEmpty) return;

    final updatedReplies = [...post.replies, ...extraReplies];

    // Each bot "likes" the post once when they comment
    final updatedPost = post.copyWith(
      replies: updatedReplies,
      commentsCount: updatedReplies.length,
      upvotes: post.upvotes + extraReplies.length,
    );

    final newList = [...currentList];
    newList[index] = updatedPost;
    _updatePosts(newList);

    // Notifications for the user
    if (stage == 1) {
      _addNotification(
          '${_bot1Name.split(' ').first} commented on your post "${post.title}".');
    } else if (stage == 2) {
      _addNotification(
          '${_bot2Name.split(' ').first} commented on your post "${post.title}".');
    }
  }

  void _scheduleBotsForNewPost(String postId) {
    // Stage 1: after 10s
    Future.delayed(const Duration(seconds: 10), () {
      _injectBotEngagement(postId, stage: 1);
    });

    // Stage 2: 20s after the first (i.e., ~30s from post creation)
    Future.delayed(const Duration(seconds: 30), () {
      _injectBotEngagement(postId, stage: 2);
    });
  }

  // Add a new reply to a post
  void addReply({
    required String postId,
    required String body,
    String? replyToAuthorName,
    String? parentReplyId,
    bool isBot = false,
  }) {
    if (body.trim().isEmpty) return;
    final updated = <CommunityPost>[];

    for (final post in posts) {
      if (post.id == postId) {
        final newReply = CommunityReply(
          id: 'reply_${DateTime.now().millisecondsSinceEpoch}',
          // If bot, parse name from body or use generic. Ideally passed in, but keeping compatible.
          authorName: isBot ? body.split(':')[0].replaceAll('🤖 ', '') : currentUserName,
          authorId: isBot ? 'bot_generic' : currentUserId,
          roleTag: isBot ? 'Bot' : currentUserTag,
          body: body.trim(),
          createdAt: DateTime.now(),
          upvotes: 0,
          hasCurrentUserUpvoted: false,
          replyToAuthorName: replyToAuthorName,
          parentReplyId: parentReplyId,
        );

        final newReplies = [...post.replies, newReply];
        updated.add(
          post.copyWith(
            replies: newReplies,
            commentsCount: newReplies.length,
          ),
        );

        // Optional notification: "You replied to X" or "New comment on post"
        if (!isBot) {
          _addNotification(
            'You replied on "${post.title}"',
          );
        }

        _trackInteraction(post, 3, isBot: isBot); // +3 for reply
        _trackSessionActivity(postId: postId, action: 'comment', isBot: isBot);

        if (!isBot) {
          // Update social proximity
          _userAuthorInteractions[post.authorId] = (_userAuthorInteractions[post.authorId] ?? 0) + 1;

          // ML Update for Reply
          _updateMLWeights(
            post: post,
            topicInc: 0.8,
            formatInc: 0.6,
            commInc: 0.3,
            recencyInc: 0.04,
          );
        }
      } else {
        updated.add(post);
      }
    }

    _updatePosts(updated);
  }

  // Toggle upvote on a reply
  void toggleReplyUpvote({
    required String postId,
    required String replyId,
  }) {
    final updated = <CommunityPost>[];
    for (final post in posts) {
      if (post.id == postId) {
        final updatedReplies = post.replies.map((reply) {
          if (reply.id == replyId) {
            final isNowUpvoted = !reply.hasCurrentUserUpvoted;
            final newUpvotes =
                reply.upvotes + (isNowUpvoted ? 1 : -1).clamp(-reply.upvotes, 1);
            return reply.copyWith(
              hasCurrentUserUpvoted: isNowUpvoted,
              upvotes: newUpvotes < 0 ? 0 : newUpvotes,
            );
          }
          return reply;
        }).toList();
        updated.add(
          post.copyWith(replies: updatedReplies),
        );
      } else {
        updated.add(post);
      }
    }
    _updatePosts(updated);
  }

  void hidePost(String postId) {
    final profile = userProfile;
    final newHiddenPostIds = Set<String>.from(profile.hiddenPostIds);
    newHiddenPostIds.add(postId);
    _updateUserProfile(profile.copyWith(hiddenPostIds: newHiddenPostIds));
    
    // Trigger UI update by refreshing posts list (filtering happens in getters)
    _updatePosts(posts); 
  }

  // Create a new post
  void createPost({
    required String title,
    required String body,
    required CommunityPostType type,
    List<String>? tags,
  }) {
    final trimmedTitle = title.trim();
    final trimmedBody = body.trim();
    if (trimmedTitle.isEmpty || trimmedBody.isEmpty) return;

    final newPost = CommunityPost(
      id: 'post_${DateTime.now().millisecondsSinceEpoch}',
      title: trimmedTitle,
      body: trimmedBody,
      type: type,
      authorName: currentUserName,
      authorId: currentUserId,
      authorTag: currentUserTag,
      tags: tags ?? const [],
      upvotes: 0,
      commentsCount: 0,
      createdAt: DateTime.now(),
      replies: const [],
      isByCurrentUser: true,
      hasCurrentUserUpvoted: false,
      industryTag: currentUserIndustryTag,
      topicTags: tags ?? const [],
      format: type.name,
      communityId: 'general',
      shareCount: 0,
    );

    final updated = [newPost, ...posts];
    _updatePosts(updated);

    _addNotification('Your new post "${newPost.title}" is live in Community.');

    if (newPost.isByCurrentUser) {
      _scheduleBotsForNewPost(newPost.id);
      BotSwarm.instance.reactToUserPost(newPost.id);
      DebugLog.instance.add("UserPostDetected: ${newPost.id} → bots scheduled");
    }
  }

  void addPost(CommunityPost post) {
    final updated = [post, ...posts];
    _updatePosts(updated);
  }

  // Notifications helpers

  void _addNotification(String message) {
    final newNotification = CommunityNotification(
      id: 'notif_${DateTime.now().millisecondsSinceEpoch}_${DateTime.now().microsecond}',
      message: message,
      createdAt: DateTime.now(),
      isRead: false,
    );
    final updated = [newNotification, ...notifications];
    _updateNotifications(updated);
  }

  void markAllNotificationsRead() {
    final updated = notifications
        .map((n) => n.copyWith(isRead: true))
        .toList();
    _updateNotifications(updated);
  }

  /// Call when a post becomes visible on screen.
  void onPostImpression(String postId) {
    _postOpenTimestamps[postId] = DateTime.now();
  }

  /// Call when post is expanded ("see more").
  void onPostExpanded(String postId) {
    _expandedFlags[postId] = true;
    _trackSessionActivity(postId: postId, action: 'expand');
  }

  /// Call when comments section opened.
  void onPostCommentsOpened(String postId) {
    _openedCommentsFlags[postId] = true;
    _trackSessionActivity(postId: postId, action: 'view_comments');
  }

  /// Collect telemetry for a post.
  TelemetrySnapshot collectTelemetry(String postId) {
    final start = _postOpenTimestamps[postId];

    int dwell = 0;
    final now = DateTime.now();
    if (start != null) {
      dwell = now.difference(start).inMilliseconds;
      
      // Session Intelligence Dwell Tracking
      if (dwell > 8000) {
        _trackSessionActivity(postId: postId, action: 'high_dwell');
      } else if (dwell > 2000) {
        _trackSessionActivity(postId: postId, action: 'medium_dwell');
      } else if (dwell > 300) {
         _trackSessionActivity(postId: postId, action: 'view');
      }
    }

    return TelemetrySnapshot(
      dwellTimeMs: dwell,
      expanded: _expandedFlags[postId] ?? false,
      openedComments: _openedCommentsFlags[postId] ?? false,
    );
  }

  void cleanupTelemetry(String postId) {
    _postOpenTimestamps.remove(postId);
    _expandedFlags.remove(postId);
    _openedCommentsFlags.remove(postId);
  }
  void _emitDebugSnapshotForRankedPosts({
    required String userId,
    String? userDisplayName, // NEW
    required String personaId,
    required String feedType,
    required List<CommunityPost> rankedPosts,
    required List<SessionActivity> sessionActivity,
    required Map<String, _DetailedScoreBreakdown> detailedBreakdowns,
    required Map<String, _ScoreComponent> scoreComponents,
  }) {
    final snapshotPosts = <FeedDebugPostScore>[];

    for (int i = 0; i < rankedPosts.length; i++) {
      final post = rankedPosts[i];
      final breakdown = detailedBreakdowns[post.id];
      
      if (breakdown == null) continue;

      snapshotPosts.add(FeedDebugPostScore(
        postId: post.id,
        title: post.title,
        industryTag: post.industryTag,
        finalScore: breakdown.finalScoreBeforeModifiers,
        ruleScore: breakdown.finalScoreBeforeModifiers,
        mlScore: breakdown.mlProb,
        topicScore: breakdown.topicScore,
        industryScore: breakdown.communityScore,
        authorScore: breakdown.authorScore,
        engagementScore: breakdown.engagementScore,
        freshnessScore: breakdown.freshnessScore,
        sessionScore: breakdown.sessionSpike,
        negativeScore: breakdown.negativePenalty,
        formatScore: breakdown.formatScore,
        reputationScore: breakdown.reputationScore,
        proximityScore: breakdown.proximityScore,
        tags: post.topicTags,
        rank: i + 1,
        reason: "Ranked #${i + 1}",
      ));
    }

    final snapshot = FeedDebugSnapshot(
      userId: userId,
      userDisplayName: userDisplayName, // NEW
      personaId: personaId,
      feedType: feedType,
      createdAt: DateTime.now(),
      isColdStart: userProfile.isColdStart,
      posts: rankedPosts.map((p) {
        final components = scoreComponents[p.id];
        final breakdown = detailedBreakdowns[p.id];
        return FeedDebugPostScore(
          postId: p.id,
          title: p.title,
          industryTag: p.industryTag,
          finalScore: breakdown?.finalScoreBeforeModifiers ?? 0.0,
          ruleScore: components?.ruleScore ?? 0.0,
          mlScore: components?.mlProbability ?? 0.0,
          topicScore: components?.topicScore ?? 0.0,
          industryScore: breakdown?.communityScore ?? 0.0,
          authorScore: breakdown?.authorScore ?? 0.0,
          engagementScore: breakdown?.engagementScore ?? 0.0,
          freshnessScore: components?.freshnessScore ?? 0.0,
          sessionScore: components?.sessionSpikeScore ?? 0.0,
          negativeScore: breakdown?.negativePenalty ?? 0.0,
          formatScore: breakdown?.formatScore ?? 0.0,
          reputationScore: components?.reputationScore ?? 0.0,
          proximityScore: components?.proximityScore ?? 0.0,
          tags: p.topicTags,
          rank: rankedPosts.indexOf(p) + 1,
          reason: "Ranked #${rankedPosts.indexOf(p) + 1}",
        );
      }).toList(),
      sessionSummary: _buildSessionSummary(sessionActivity),
    );

    // Push to debug store (which handles logging and Firestore)
    ScoreDebugStore.instance.pushFeedDebugSnapshot(snapshot);
  }

  Map<String, dynamic> _buildSessionSummary(List<SessionActivity> activities) {
    if (activities.isEmpty) return {'status': 'No recent activity'};
    
    final summary = <String, dynamic>{
      'count': activities.length,
      'lastAction': activities.last.action,
      'lastTimestamp': activities.last.timestamp.toIso8601String(),
      'industries': activities.map((a) => a.industryTag).whereType<String>().toSet().toList(),
    };
    return summary;
  }
}

class _ScoreComponent {
  final double topicScore;
  final double freshnessScore;
  final double mlProbability;
  final double ruleScore;
  final double reputationScore;
  final double proximityScore;
  final double sessionSpikeScore;

  _ScoreComponent({
    required this.topicScore,
    required this.freshnessScore,
    required this.mlProbability,
    required this.ruleScore,
    this.reputationScore = 0.0,
    this.proximityScore = 0.0,
    this.sessionSpikeScore = 0.0,
  });
}

class _DetailedScoreBreakdown {
  final double topicScore;
  final double formatScore;
  final double communityScore;
  final double authorScore;
  final double engagementScore;
  final double freshnessScore;
  final double mlProb;
  final double sessionSpike;
  final double reputationScore;
  final double proximityScore;
  final double negativePenalty;
  final double finalScoreBeforeModifiers;

  _DetailedScoreBreakdown({
    required this.topicScore,
    required this.formatScore,
    required this.communityScore,
    required this.authorScore,
    required this.engagementScore,
    required this.freshnessScore,
    required this.mlProb,
    required this.sessionSpike,
    required this.reputationScore,
    required this.proximityScore,
    required this.negativePenalty,
    required this.finalScoreBeforeModifiers,
  });
}
