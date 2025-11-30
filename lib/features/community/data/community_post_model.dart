
enum CommunityPostType {
  story,       // Interview story
  question,    // Help me with this question
  feedback,    // Rate my answer / give feedback
}

class CommunityReply {
  final String id;
  final String authorName;
  final String authorId;       // Added authorId
  final String roleTag;        // e.g. "SDE-1, Fintech" or "BPO, Fresher"
  final String body;
  final DateTime createdAt;
  final int upvotes;
  final bool hasCurrentUserUpvoted;
  final String? replyToAuthorName; // for "reply to a comment"
  final String? parentReplyId; // id of the comment this reply belongs to (top-level comment)

  const CommunityReply({
    required this.id,
    required this.authorName,
    required this.authorId,
    required this.roleTag,
    required this.body,
    required this.createdAt,
    this.upvotes = 0,
    this.hasCurrentUserUpvoted = false,
    this.replyToAuthorName,
    this.parentReplyId,
  });

  CommunityReply copyWith({
    String? id,
    String? authorName,
    String? authorId,
    String? roleTag,
    String? body,
    DateTime? createdAt,
    int? upvotes,
    bool? hasCurrentUserUpvoted,
    String? replyToAuthorName,
    String? parentReplyId,
  }) {
    return CommunityReply(
      id: id ?? this.id,
      authorName: authorName ?? this.authorName,
      authorId: authorId ?? this.authorId,
      roleTag: roleTag ?? this.roleTag,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      upvotes: upvotes ?? this.upvotes,
      hasCurrentUserUpvoted:
          hasCurrentUserUpvoted ?? this.hasCurrentUserUpvoted,
      replyToAuthorName: replyToAuthorName ?? this.replyToAuthorName,
      parentReplyId: parentReplyId ?? this.parentReplyId,
    );
  }
}

class CommunityPost {
  final String id;
  final String title;
  final String body;
  final CommunityPostType type;
  final String authorName;
  final String authorTag;      // e.g. "IT & Software | 0-1 yrs"
  final List<String> tags;     // e.g. ["DSA", "Amazon OA"]
  final int upvotes;
  final int commentsCount;
  final DateTime createdAt;
  final List<CommunityReply> replies;
  final bool isByCurrentUser;         // true for posts you create later
  final bool hasCurrentUserUpvoted;   // used to toggle upvote state

  // New ranking fields
  final String industryTag;        // e.g. 'IT & Software', 'Sales & Marketing'
  final List<String> topicTags;    // e.g. ['System Design', 'Mock Interview']
  final String format;             // 'story', 'question', 'tip', 'text'
  final String communityId;        // e.g. 'general', 'mock_interviews'
  final String authorId;           // 'user_me', 'user_riya', etc.
  final int likeCount;
  final int commentCount;
  final int shareCount;
  final int authorTotalLikes;
  final int authorTotalComments;
  final int authorTotalPosts;
  final bool isFromBot;

  const CommunityPost({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.authorName,
    required this.authorTag,
    required this.tags,
    required this.upvotes,
    required this.commentsCount,
    required this.createdAt,
    required this.replies,
    this.isByCurrentUser = false,
    this.hasCurrentUserUpvoted = false,
    this.industryTag = 'General',
    this.topicTags = const [],
    this.format = 'text',
    this.communityId = 'general',
    this.authorId = 'unknown',
    this.likeCount = 0,
    this.commentCount = 0,
    this.shareCount = 0,

    this.authorTotalLikes = 0,
    this.authorTotalComments = 0,
    this.authorTotalPosts = 0,
    this.isFromBot = false,
  });

  CommunityPost copyWith({
    String? id,
    String? title,
    String? body,
    CommunityPostType? type,
    String? authorName,
    String? authorTag,
    List<String>? tags,
    int? upvotes,
    int? commentsCount,
    DateTime? createdAt,
    List<CommunityReply>? replies,
    bool? isByCurrentUser,
    bool? hasCurrentUserUpvoted,
    String? industryTag,
    List<String>? topicTags,
    String? format,
    String? communityId,
    String? authorId,
    int? likeCount,
    int? commentCount,
    int? shareCount,

    int? authorTotalLikes,
    int? authorTotalComments,
    int? authorTotalPosts,
    bool? isFromBot,
  }) {
    return CommunityPost(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      authorName: authorName ?? this.authorName,
      authorTag: authorTag ?? this.authorTag,
      tags: tags ?? this.tags,
      upvotes: upvotes ?? this.upvotes,
      commentsCount: commentsCount ?? this.commentsCount,
      createdAt: createdAt ?? this.createdAt,
      replies: replies ?? this.replies,
      isByCurrentUser: isByCurrentUser ?? this.isByCurrentUser,
      hasCurrentUserUpvoted:
          hasCurrentUserUpvoted ?? this.hasCurrentUserUpvoted,
      industryTag: industryTag ?? this.industryTag,
      topicTags: topicTags ?? this.topicTags,
      format: format ?? this.format,
      communityId: communityId ?? this.communityId,
      authorId: authorId ?? this.authorId,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      shareCount: shareCount ?? this.shareCount,
      authorTotalLikes: authorTotalLikes ?? this.authorTotalLikes,
      authorTotalComments: authorTotalComments ?? this.authorTotalComments,
      authorTotalPosts: authorTotalPosts ?? this.authorTotalPosts,
      isFromBot: isFromBot ?? this.isFromBot,
    );
  }


  static CommunityPost generateBotPost() {
    final now = DateTime.now();
    return CommunityPost(
      id: 'bot_post_${now.millisecondsSinceEpoch}',
      title: 'Bot Generated Discussion',
      body: 'This is an automated discussion starter to test the feed algorithm.',
      type: CommunityPostType.story,
      authorName: 'Simulated User',
      authorTag: 'Bot',
      tags: const ['Simulation', 'Test'],
      upvotes: 5,
      commentsCount: 2,
      createdAt: now,
      replies: const [],
      industryTag: 'IT & Software',
      topicTags: const ['Simulation'],
      format: 'story',
      communityId: 'general',
      authorId: 'bot_user',
      likeCount: 5,
      commentCount: 2,
      shareCount: 0,
      authorTotalLikes: 50,
      authorTotalComments: 20,
      authorTotalPosts: 10,
    );
  }
}
