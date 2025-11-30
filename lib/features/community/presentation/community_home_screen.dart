import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/community_post_model.dart';
import '../logic/community_store.dart';
import '../data/community_notification_model.dart';
import 'community_theme.dart';
import 'widgets/community_post_card.dart';
import 'thread_detail_screen.dart';
import 'new_thread_screen.dart';
import '../debug/debug_console_screen.dart';

enum FeedMode {
  forYou,
  latest,
}

class CommunityHomeScreen extends StatefulWidget {
  const CommunityHomeScreen({super.key});

  @override
  State<CommunityHomeScreen> createState() => _CommunityHomeScreenState();
}

class _CommunityHomeScreenState extends State<CommunityHomeScreen> {
  int _selectedTabIndex = 0;
  FeedMode _feedMode = FeedMode.forYou;
  final CommunityStore _store = CommunityStore.instance;

  List<CommunityPost> _filterPostsByTab(List<CommunityPost> posts) {
    // Note: 'posts' argument is ignored in favor of store getters
    // but kept to satisfy ValueListenableBuilder signature if needed,
    // though we are pulling directly from store logic now.
    
    switch (_selectedTabIndex) {
      case 1: // Trending
        return _store.getTrendingPosts();
      case 2: // My Threads
        return _store.getMyThreads();
      case 0: // For You
      default:
        return _feedMode == FeedMode.forYou
            ? _store.getForYouPosts()
            : _store.getLatestPosts();
    }
  }

  void _openNotificationsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        // Mark all as read when opening
        _store.markAllNotificationsRead();

        return ValueListenableBuilder<List<CommunityNotification>>(
          valueListenable: _store.notificationsNotifier,
          builder: (context, notifications, _) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Notifications',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: notifications.isEmpty
                      ? Center(
                          child: Text(
                            'No notifications yet',
                            style: GoogleFonts.inter(color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          itemCount: notifications.length,
                          itemBuilder: (context, index) {
                            final notif = notifications[index];
                            final diff = DateTime.now().difference(notif.createdAt);
                            String timeAgo;
                            if (diff.inDays > 0) {
                              timeAgo = '${diff.inDays}d ago';
                            } else if (diff.inHours > 0) {
                              timeAgo = '${diff.inHours}h ago';
                            } else {
                              timeAgo = '${diff.inMinutes}m ago';
                            }

                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor:
                                    CommunityTheme.accentPurple.withValues(alpha: 0.1),
                                child: const Icon(
                                  Icons.notifications_outlined,
                                  color: CommunityTheme.accentPurple,
                                  size: 20,
                                ),
                              ),
                              title: Text(
                                notif.message,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                              trailing: Text(
                                timeAgo,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        );
      },
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
              // AppBar-like Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.of(context).pop(),
                      color: Colors.black87,
                    ),

                    GestureDetector(
                      onLongPress: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const DebugConsoleScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Community",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const Spacer(),
                    ValueListenableBuilder<List<CommunityNotification>>(
                      valueListenable: _store.notificationsNotifier,
                      builder: (context, notifs, _) {
                        final unreadCount = notifs.where((n) => !n.isRead).length;
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.favorite_outline),
                              onPressed: () {
                                _openNotificationsBottomSheet(context);
                              },
                              color: Colors.black87,
                            ),
                            if (unreadCount > 0)
                              Positioned(
                                right: 10,
                                top: 10,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 16,
                                    minHeight: 16,
                                  ),
                                  child: Text(
                                    unreadCount > 9 ? '9+' : '$unreadCount',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Tabs
              Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _buildTab("For You", 0),
                    const SizedBox(width: 24),
                    _buildTab("Trending", 1),
                    const SizedBox(width: 24),
                    _buildTab("My Threads", 2),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // Post List
              Expanded(
                child: ValueListenableBuilder<List<CommunityPost>>(
                  valueListenable: _store.postsNotifier,
                  builder: (context, posts, _) {
                    final visiblePosts = _filterPostsByTab(posts);
                    if (visiblePosts.isEmpty) {
                      if (_selectedTabIndex == 2) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "No threads yet",
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Start a conversation with the community\nby posting your first thread.",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return Center(
                        child: Text(
                          "No posts yet. Start the conversation!",
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      );
                    }
                    return Column(
                      children: [
                        if (_selectedTabIndex == 0) ...[
                          const SizedBox(height: 8),
                          _buildFeedModeToggle(),
                          const SizedBox(height: 4),
                        ],
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: visiblePosts.length,
                            itemBuilder: (context, index) {
                              final post = visiblePosts[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: CommunityPostCard(
                                  post: post,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            ThreadDetailScreen(post: post),
                                      ),
                                    );
                                  },
                                  onUpvote: () {
                                    _store.togglePostUpvote(post.id);
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const NewThreadScreen(),
            ),
          );
        },
        backgroundColor: CommunityTheme.accentPurple,
        icon: const Icon(Icons.edit, color: Colors.white),
        label: Text(
          "Create Post",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTabIndex = index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: isSelected ? CommunityTheme.accentPurple : Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 3,
            width: isSelected ? 24 : 0,
            decoration: BoxDecoration(
              color: CommunityTheme.accentPurple,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildFeedModeToggle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildModeChip(
              label: "For You",
              mode: FeedMode.forYou,
            ),
            _buildModeChip(
              label: "Latest",
              mode: FeedMode.latest,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeChip({
    required String label,
    required FeedMode mode,
  }) {
    final bool isSelected = _feedMode == mode;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (_feedMode != mode) {
            setState(() {
              _feedMode = mode;
            });
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? Colors.black : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
