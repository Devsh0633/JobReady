import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/community_post_model.dart';
import 'community_theme.dart';
import 'widgets/community_post_card.dart';

import '../logic/community_store.dart';

class ThreadDetailScreen extends StatefulWidget {
  final CommunityPost post;
  const ThreadDetailScreen({super.key, required this.post});

  @override
  State<ThreadDetailScreen> createState() => _ThreadDetailScreenState();
}

class _ThreadDetailScreenState extends State<ThreadDetailScreen> {
  final CommunityStore _store = CommunityStore.instance;
  late CommunityPost _post;
  final TextEditingController _replyController = TextEditingController();
  String? _replyToAuthorName;
  String? _replyParentId;

  @override
  void initState() {
    super.initState();
    _post = widget.post;
    // Listen to store updates to keep this post fresh
    _store.postsNotifier.addListener(_onPostsChanged);
  }

  void _onPostsChanged() {
    final updated = _store.posts.firstWhere(
      (p) => p.id == _post.id,
      orElse: () => _post,
    );
    if (!mounted) return;
    setState(() {
      _post = updated;
    });
  }

  @override
  void dispose() {
    _store.postsNotifier.removeListener(_onPostsChanged);
    _replyController.dispose();
    super.dispose();
  }

  void _submitReply() {
    final text = _replyController.text.trim();
    if (text.isEmpty) return;
    _store.addReply(
      postId: _post.id,
      body: text,
      replyToAuthorName: _replyToAuthorName,
      parentReplyId: _replyParentId,
    );
    _replyController.clear();
    setState(() {
      _replyToAuthorName = null;
      _replyParentId = null;
    });
    FocusScope.of(context).unfocus();
  }

  void _clearReplyTarget() {
    setState(() {
      _replyParentId = null;
      _replyToAuthorName = null;
    });
  }

  void _toggleReplyUpvote(CommunityReply reply) {
    _store.toggleReplyUpvote(
      postId: _post.id,
      replyId: reply.id,
    );
  }

  void _setReplyTo(CommunityReply reply) {
    setState(() {
      // Only 1-level thread: always point to top-level parent
      _replyParentId = reply.parentReplyId ?? reply.id;
      _replyToAuthorName = reply.authorName;
    });
    // Optionally focus the TextField using a FocusNode if needed, 
    // but user might just want to see who they are replying to.
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'Just now';
  }

  Widget _buildRepliesList() {
    final allReplies = _post.replies;
    final topLevelReplies =
        allReplies.where((r) => r.parentReplyId == null).toList();

    if (topLevelReplies.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Text(
            "No replies yet. Be the first!",
            style: GoogleFonts.inter(
              color: Colors.grey.shade500,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: topLevelReplies.map((parent) {
        final children =
            allReplies.where((r) => r.parentReplyId == parent.id).toList();

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommunityReplyCard(
                reply: parent,
                onUpvote: () => _toggleReplyUpvote(parent),
                onReply: () => _setReplyTo(parent),
              ),
              if (children.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 32, top: 4),
                  child: Column(
                    children: children.map((child) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: CommunityReplyCard(
                          reply: child,
                          onUpvote: () => _toggleReplyUpvote(child),
                          onReply: () => _setReplyTo(child),
                          isChild: true,
                        ),
                      );
                    }).toList(),
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              CommunityTheme.backgroundTop,
              CommunityTheme.backgroundBottom,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // AppBar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.of(context).pop(),
                      color: Colors.black87,
                    ),
                    Text(
                      "Discussion",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        _post.title,
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Author Row
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: CommunityTheme.accentPurple.withValues(alpha: 0.1),
                            child: Text(
                              _post.authorName[0],
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: CommunityTheme.accentPurple,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _post.authorName,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                '${_post.authorTag} • ${_timeAgo(_post.createdAt)}',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Tags
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _post.tags.map((tag) {
                          return Chip(
                            label: Text(tag),
                            labelStyle: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.grey.shade800,
                            ),
                            backgroundColor: Colors.white,
                            side: BorderSide(color: Colors.grey.shade300),
                            padding: EdgeInsets.zero,
                            visualDensity: VisualDensity.compact,
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),

                      // Body Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          _post.body,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            height: 1.6,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Replies Header
                      Row(
                        children: [
                          Text(
                            "Replies",
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: CommunityTheme.accentPurple.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              // Use actual replies length as source of truth for UI consistency
                              '${_post.replies.length}',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: CommunityTheme.accentPurple,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Replies List
                      // Replies List
                      _buildRepliesList(),
                      
                      const SizedBox(height: 80), // Space for bottom input
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_replyParentId != null && _replyToAuthorName != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: CommunityTheme.accentPurple.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: CommunityTheme.accentPurple.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.reply, size: 16, color: CommunityTheme.accentPurple),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Replying to $_replyToAuthorName',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: CommunityTheme.accentPurple,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: _clearReplyTarget,
                        child: Icon(Icons.close, size: 16, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _replyController,
                      decoration: InputDecoration(
                        hintText: "Add a reply...",
                        hintStyle: GoogleFonts.inter(color: Colors.grey.shade400),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  CircleAvatar(
                    backgroundColor: CommunityTheme.accentPurple,
                    child: IconButton(
                      icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                      onPressed: _submitReply,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
