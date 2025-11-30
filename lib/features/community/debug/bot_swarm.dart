import 'dart:async';
import 'dart:math';
import '../logic/community_store.dart';
import '../data/community_post_model.dart';
import 'debug_log.dart';
import 'bot_profiles.dart';

/// Enhanced Bot swarm with dual modes:
/// 1. NORMAL MODE: 1-2 new posts on app open
/// 2. DEMO MODE: 100 bots generating posts/interactions when debug console active
class BotSwarm {
  BotSwarm._();
  static final BotSwarm instance = BotSwarm._();

  Timer? _postTimer;
  Timer? _interactionTimer;
  final _rng = Random();
  
  bool _isRunning = false;
  bool _normalModeInitialized = false;
  int _demoPostCount = 0;
  static const int _maxDemoPosts = 50;

  bool get isRunning => _isRunning;

  /// NORMAL MODE: Seed 1-2 bot posts on app open
  void seedBasicBotPostsIfNeeded() {
    if (_normalModeInitialized) return;
    _normalModeInitialized = true;

    DebugLog.instance.add("NORMAL MODE: Seeding 1-2 bot posts");
    
    final numPosts = 1 + _rng.nextInt(2); // 1 or 2 posts
    for (int i = 0; i < numPosts; i++) {
      // Pick a random bot from the master list
      final bot = allBots[_rng.nextInt(allBots.length)];
      _createRealisticBotPost(bot: bot, isNormalMode: true);
    }
  }

  /// DEMO MODE: Start intensive bot simulation
  void startDemoBotSwarm() {
    if (_isRunning) return;
    _isRunning = true;
    _demoPostCount = 0;
    
    DebugLog.instance.add("DEMO MODE: BOT SWARM STARTED (100 bots)");

    // Initial seed for demo: 10 posts per industry
    _seedDemoContent();

    // Post creation every 3–6 seconds (slower than before to avoid flood)
    _postTimer = Timer.periodic(
      Duration(seconds: 3 + _rng.nextInt(4)),
      (_) {
         final bot = allBots[_rng.nextInt(allBots.length)];
        _createRealisticBotPost(bot: bot, isNormalMode: false);
      },
    );

    // Interactions every 1–2 seconds
    _interactionTimer = Timer.periodic(
      Duration(seconds: 1 + _rng.nextInt(2)),
      (_) => _intelligentInteraction(),
    );
  }

  void stopDemoBotSwarm() {
    if (!_isRunning) return;
    _isRunning = false;
    
    DebugLog.instance.add("DEMO MODE: BOT SWARM STOPPED");
    _postTimer?.cancel();
    _interactionTimer?.cancel();
  }

  void _seedDemoContent() {
    // 10 posts per industry
    final industries = ['IT & Software', 'Sales & Marketing', 'BPO & Support', 'Core Engineering'];
    
    for (final industry in industries) {
      final bots = botsForIndustry(industry);
      // Pick 10 random bots from this industry
      bots.shuffle(_rng);
      final selected = bots.take(10);
      
      for (final bot in selected) {
         _createRealisticBotPost(bot: bot, isNormalMode: false);
      }
    }
  }

  void _createRealisticBotPost({required BotProfile bot, required bool isNormalMode}) {
    // Cap demo posts
    if (!isNormalMode && _demoPostCount >= _maxDemoPosts) {
      return;
    }

    // Generate script (stubbed here, ideally from a helper)
    final script = _generateScriptForBot(bot);
    
    final post = CommunityPost(
      id: 'bot_post_${DateTime.now().millisecondsSinceEpoch}_${_rng.nextInt(10000)}',
      authorId: bot.id,
      authorName: bot.displayName,
      authorTag: '${bot.industryTag} | ${bot.role}',
      title: script.title,
      body: script.body,
      type: CommunityPostType.story,
      tags: script.topicTags,
      topicTags: script.topicTags,
      industryTag: bot.industryTag, // Use bot's industry
      format: script.format,
      createdAt: DateTime.now(),
      upvotes: 0,
      likeCount: 0,
      commentsCount: 0,
      commentCount: 0,
      shareCount: 0,
      hasCurrentUserUpvoted: false,
      replies: [],
      authorTotalLikes: _rng.nextInt(500),
      authorTotalComments: _rng.nextInt(200),
      authorTotalPosts: _rng.nextInt(50) + 5,
      isFromBot: true, // EXPLICIT FLAG
    );

    final store = CommunityStore.instance;
    store.addPost(post);
    
    // Ensure we have enough replies to make the high comment count plausible
    // (This was added in previous task, keeping it)
    store.ensureDemoReplies(post);
    
    if (!isNormalMode) {
      _demoPostCount++;
    }
    
    DebugLog.instance.add(
      isNormalMode 
        ? "NORMAL: ${bot.displayName} posted '${script.title}'"
        : "DEMO: ${bot.displayName} posted '${script.title}'"
    );
  }

  void _intelligentInteraction() {
    final store = CommunityStore.instance;
    final allPosts = store.posts;
    if (allPosts.isEmpty) return;

    // Pick 5-10 active bots this tick
    final activeBotCount = 5 + _rng.nextInt(6);
    final activeBots = List.generate(
      activeBotCount,
      (_) => allBots[_rng.nextInt(allBots.length)],
    );

    for (final bot in activeBots) {
      // Filter posts based on behavior type
      final List<CommunityPost> targetPosts;

      switch (bot.behaviorType) {
        case BotBehaviorType.specialist:
          targetPosts = allPosts.where((p) => p.industryTag == bot.industryTag).toList();
          break;
        case BotBehaviorType.explorer:
          // 70% own industry, 30% others
          if (_rng.nextDouble() < 0.7) {
             targetPosts = allPosts.where((p) => p.industryTag == bot.industryTag).toList();
          } else {
             targetPosts = allPosts.where((p) => p.industryTag != bot.industryTag).toList();
          }
          break;
        case BotBehaviorType.generalist:
          targetPosts = allPosts;
          break;
      }

      if (targetPosts.isEmpty) continue;

      final target = targetPosts[_rng.nextInt(targetPosts.length)];

      // Decide action based on bot bias
      if (_rng.nextDouble() < bot.likeBias) {
        // GUARD: Do not like user posts if user hasn't posted (defensive check)
        if (target.authorId == store.currentUserId && !store.hasCurrentUserPosted) {
           continue;
        }

        store.likePostAsBot(target.id, botId: bot.id);
        DebugLog.instance.add("${bot.displayName} liked '${target.title}'");
      }

      if (_rng.nextDouble() < bot.commentBias) {
         // GUARD: Do not comment on user posts if user hasn't posted
        if (target.authorId == store.currentUserId && !store.hasCurrentUserPosted) {
           continue;
        }

        final comments = [
          "Great insights!",
          "This is exactly what I needed.",
          "Thanks for sharing!",
          "Interesting perspective.",
          "Can you elaborate more?",
          "I had a similar experience.",
          "This helped me a lot!",
          "Agreed!",
          "Well said.",
        ];
        
        final commentBody = comments[_rng.nextInt(comments.length)];
        
        store.addCommentAsBot(
          postId: target.id,
          botId: bot.id,
          botName: bot.displayName,
          text: commentBody,
        );
        DebugLog.instance.add("${bot.displayName} commented on '${target.title}'");
      }
    }
  }

  void reactToUserPost(String postId) {
    if (!_isRunning) return;
    
    // Schedule a reaction in 2-10 seconds
    Future.delayed(Duration(seconds: 2 + _rng.nextInt(8)), () {
      if (!_isRunning) return;
      
      final store = CommunityStore.instance;
      // Find the post
      final post = store.posts.firstWhere(
        (p) => p.id == postId,
        orElse: () => store.posts.first,
      );
      if (store.posts.isEmpty) return;

      // Pick 1-3 random bots to react
      final reactorCount = 1 + _rng.nextInt(3);
      for (int i = 0; i < reactorCount; i++) {
        final bot = allBots[_rng.nextInt(allBots.length)];
        
        // 50% chance to like
        if (_rng.nextBool()) {
          store.likePostAsBot(post.id, botId: bot.id);
          DebugLog.instance.add("REACT: ${bot.displayName} liked user post");
        }
        
        // 30% chance to comment
        if (_rng.nextDouble() < 0.3) {
           final comments = [
            "Great post!",
            "Thanks for sharing.",
            "Interesting!",
            "Welcome to the community!",
          ];
          final body = comments[_rng.nextInt(comments.length)];
          store.addCommentAsBot(
            postId: post.id, 
            botId: bot.id,
            botName: bot.displayName,
            text: body,
          );
          DebugLog.instance.add("REACT: ${bot.displayName} commented on user post");
        }
      }
    });
  }

  // Simple script generator (stub)
  _BotScript _generateScriptForBot(BotProfile bot) {
     // In a real app, this would pick from a large JSON or template list.
     // Here we just return a generic one based on industry.
     
     if (bot.industryTag == 'IT & Software') {
       return _BotScript(
         title: "Tips for ${bot.role} interviews?",
         body: "I have an interview coming up for a ${bot.role} position. Any advice on what topics to focus on? I've been brushing up on DSA and System Design.",
         topicTags: ["Interviews", "Career Advice"],
         industryTag: bot.industryTag,
         format: "question"
       );
     } else if (bot.industryTag == 'Sales & Marketing') {
        return _BotScript(
         title: "Closing deals in this market",
         body: "As a ${bot.role}, I've noticed clients are taking longer to decide. How are you all handling the longer sales cycles? Any strategies that work?",
         topicTags: ["Sales Strategy", "Market Trends"],
         industryTag: bot.industryTag,
         format: "discussion"
       );
     } else {
        return _BotScript(
         title: "Day in the life of a ${bot.role}",
         body: "Just wanted to share a quick win from today. Managed to solve a complex issue that's been bugging the team for weeks. Persistence pays off!",
         topicTags: ["Work Life", "Motivation"],
         industryTag: bot.industryTag,
         format: "story"
       );
     }
  }
}

class _BotScript {
  final String title;
  final String body;
  final List<String> topicTags;
  final String industryTag;
  final String format;

  _BotScript({
    required this.title,
    required this.body,
    required this.topicTags,
    required this.industryTag,
    required this.format,
  });
}
