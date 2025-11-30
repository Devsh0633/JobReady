import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../community/data/community_post_model.dart';
import '../../community/logic/community_store.dart';
import '../../community/presentation/widgets/community_post_card.dart';
import '../../community/presentation/thread_detail_screen.dart';
// I'll check if AppColors exists, otherwise I'll use CommunityTheme or standard colors.
// I'll use CommunityTheme for now as it's used in CommunityHomeScreen.
import '../../community/presentation/community_theme.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final CommunityStore _store = CommunityStore.instance;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Activity',
          style: GoogleFonts.poppins(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: CommunityTheme.accentPurple,
          unselectedLabelColor: Colors.grey,
          indicatorColor: CommunityTheme.accentPurple,
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          tabs: const [
            Tab(text: 'Liked'),
            Tab(text: 'Commented'),
            Tab(text: 'Replies'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildLikedTab(),
          _buildCommentedTab(),
          _buildRepliesTab(),
        ],
      ),
    );
  }

  Widget _buildLikedTab() {
    return ValueListenableBuilder(
      valueListenable: _store.postsNotifier, // Rebuild when posts change
      builder: (context, value, child) {
        final posts = _store.getLikedPostsForUser(_store.currentUserId, _store.userProfile);
        
        if (posts.isEmpty) {
          return _buildEmptyState(
            "No liked posts yet",
            "Like posts that resonate with you to build your activity history.",
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: CommunityPostCard(
                post: post,
                onTap: () => _navigateToPost(post),
                onUpvote: () => _store.togglePostUpvote(post.id),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCommentedTab() {
    return ValueListenableBuilder(
      valueListenable: _store.postsNotifier,
      builder: (context, value, child) {
        final posts = _store.getCommentedPostsForUser(_store.currentUserId);

        if (posts.isEmpty) {
          return _buildEmptyState(
            "No comments yet",
            "Jump into the discussion by commenting on a thread.",
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8, left: 4),
                    child: Text(
                      "You commented on this thread",
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  CommunityPostCard(
                    post: post,
                    onTap: () => _navigateToPost(post),
                    onUpvote: () => _store.togglePostUpvote(post.id),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildRepliesTab() {
    return ValueListenableBuilder(
      valueListenable: _store.postsNotifier,
      builder: (context, value, child) {
        final replies = _store.getRepliesByUser(_store.currentUserId);

        if (replies.isEmpty) {
          return _buildEmptyState(
            "No replies yet",
            "Your replies to community threads will appear here.",
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: replies.length,
          separatorBuilder: (context, index) => const Divider(height: 32),
          itemBuilder: (context, index) {
            final reply = replies[index];
            // Find the post for this reply to get the title
            // This is a bit inefficient (O(N*M)) but fine for MVP scale.
            // A better way would be to have a map or pass it from store.
            final post = _store.posts.firstWhere(
              (p) => p.replies.contains(reply),
              orElse: () => CommunityPost.generateBotPost(), // Fallback
            );

            return InkWell(
              onTap: () => _navigateToPost(post),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "In: ${post.title}",
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    reply.body,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatDate(reply.createdAt),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToPost(CommunityPost post) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ThreadDetailScreen(post: post),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'Just now';
  }
}
