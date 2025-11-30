import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/community_post_model.dart';
import '../community_theme.dart';

class CommunityPostCard extends StatelessWidget {
  final CommunityPost post;
  final VoidCallback onTap;
  final VoidCallback? onUpvote;

  const CommunityPostCard({
    super.key,
    required this.post,
    required this.onTap,
    this.onUpvote,
  });

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'Just now';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                CommunityTheme.accentPurple.withValues(alpha: 0.03),
                CommunityTheme.accentAqua.withValues(alpha: 0.03),
              ],
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Author & Tag
              Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: CommunityTheme.accentPurple.withValues(alpha: 0.1),
                    child: Text(
                      post.authorName[0],
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: CommunityTheme.accentPurple,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${post.authorName} • ${post.authorTag}',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _buildTypeBadge(post.type),
                ],
              ),
              const SizedBox(height: 12),

              // Title
              Text(
                post.title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 6),

              // Body Snippet
              Text(
                post.body,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: Colors.black54,
                  height: 1.5,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // Tags
              if (post.tags.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: post.tags.take(3).map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Text(
                        '#$tag',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 12),

              // Stats Row
              Row(
                children: [
                  InkWell(
                    onTap: onUpvote,
                    borderRadius: BorderRadius.circular(16),
                    child: Row(
                      children: [
                        Icon(
                          post.hasCurrentUserUpvoted
                              ? Icons.favorite
                              : Icons.favorite_border,
                          size: 18,
                          color: post.hasCurrentUserUpvoted
                              ? CommunityTheme.accentPurple
                              : Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${post.upvotes}',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: post.hasCurrentUserUpvoted
                                ? CommunityTheme.accentPurple
                                : Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.mode_comment_outlined, size: 18, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    '${post.commentsCount}',
                    style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
                  ),
                  const Spacer(),
                  Text(
                    _timeAgo(post.createdAt),
                    style: GoogleFonts.inter(fontSize: 11, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeBadge(CommunityPostType type) {
    Color color;
    String label;
    switch (type) {
      case CommunityPostType.story:
        color = Colors.blue;
        label = 'Story';
        break;
      case CommunityPostType.question:
        color = Colors.orange;
        label = 'Question';
        break;
      case CommunityPostType.feedback:
        color = Colors.purple;
        label = 'Feedback';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class CommunityReplyCard extends StatelessWidget {
  final CommunityReply reply;
  final VoidCallback? onUpvote;
  final VoidCallback? onReply;
  final bool isChild;

  const CommunityReplyCard({
    super.key,
    required this.reply,
    this.onUpvote,
    this.onReply,
    this.isChild = false,
  });

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'Just now';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isChild ? Colors.grey.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isChild ? Colors.grey.shade200 : Colors.grey.shade300,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                reply.authorName,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  reply.roleTag,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                _timeAgo(reply.createdAt),
                style: GoogleFonts.inter(
                  fontSize: 10,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
          if (reply.replyToAuthorName != null) ...[
            const SizedBox(height: 4),
            Text(
              'Replying to ${reply.replyToAuthorName}',
              style: GoogleFonts.inter(
                fontSize: 11,
                color: CommunityTheme.accentPurple,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
          const SizedBox(height: 8),
          Text(
            reply.body,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              InkWell(
                onTap: onUpvote,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Row(
                    children: [
                      Icon(
                        reply.hasCurrentUserUpvoted
                            ? Icons.favorite
                            : Icons.favorite_border,
                        size: 14,
                        color: reply.hasCurrentUserUpvoted
                            ? CommunityTheme.accentPurple
                            : Colors.grey.shade500,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${reply.upvotes}',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: reply.hasCurrentUserUpvoted
                              ? CommunityTheme.accentPurple
                              : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              InkWell(
                onTap: onReply,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Text(
                    'Reply',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
