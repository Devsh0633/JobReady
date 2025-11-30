import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../logic/community_store.dart';
import '../debug/feed_debug_snapshot.dart';

enum UserProfile {
  realUser('My Profile', null),
  itUser('IT User', null),
  marketingUser('Marketing User', null),
  financeUser('Finance User', null),
  bpoUser('BPO User', null),
  engineeringUser('Core Engineering User', null),
  newUser('Random New User', null),
  memeLover('Meme Lover', null),
  jobSeeker('Job-Seeker', null);

  final String label;
  final UserBehaviorProfile? Function()? profileFactory;
  const UserProfile(this.label, this.profileFactory);

  UserBehaviorProfile? getProfile(CommunityStore store) {
    switch (this) {
      case UserProfile.realUser:
        return store.userProfile;
      case UserProfile.itUser:
        return UserBehaviorProfile.itPersona();
      case UserProfile.marketingUser:
        return UserBehaviorProfile.marketingPersona();
      case UserProfile.bpoUser:
        return UserBehaviorProfile.bpoPersona();
      case UserProfile.engineeringUser:
        return UserBehaviorProfile.coreEngineeringPersona();
      case UserProfile.memeLover:
        return UserBehaviorProfile.memeLoverPersona();
      case UserProfile.jobSeeker:
        return UserBehaviorProfile.jobSeekerPersona();
      case UserProfile.newUser:
        return UserBehaviorProfile.genericColdStart();
      default:
        return store.userProfile;
    }
  }
}

class ExplainRankingScreen extends StatefulWidget {
  const ExplainRankingScreen({super.key});

  @override
  State<ExplainRankingScreen> createState() => _ExplainRankingScreenState();
}

class _ExplainRankingScreenState extends State<ExplainRankingScreen> {
  UserProfile _selectedProfile = UserProfile.realUser;
  final CommunityStore _store = CommunityStore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Algorithm Explainer'),
        backgroundColor: Colors.black87,
      ),
      body: Column(
        children: [
          _buildProfileSelector(),
          _buildFeedSummary(),
          Expanded(
            child: _buildPostBreakdowns(),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey.shade100,
      child: Row(
        children: [
          const Icon(Icons.person, size: 20),
          const SizedBox(width: 8),
          const Text(
            'View as:',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButton<UserProfile>(
              value: _selectedProfile,
              isExpanded: true,
              items: UserProfile.values.map((profile) {
                return DropdownMenuItem(
                  value: profile,
                  child: Text(profile.label),
                );
              }).toList(),
              onChanged: (profile) {
                if (profile != null) {
                  setState(() {
                    _selectedProfile = profile;
                  });
                  // Trigger feed refresh with new profile
                  _refreshFeedWithProfile();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _refreshFeedWithProfile() {
    final profile = _selectedProfile.getProfile(_store);
    if (profile != null) {
      // Trigger feed regeneration with selected profile
      _store.getForYouPostsForProfile(profile);
    }
  }

  Widget _buildFeedSummary() {
    return ListenableBuilder(
      listenable: _store.feedDebugSnapshotsNotifier,
      builder: (context, child) {
        final snapshots = _store.feedDebugSnapshotsNotifier.value;
        final profile = _selectedProfile.getProfile(_store);
        final isSimulated = profile?.isSimulated ?? false;
        
        if (snapshots.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue.shade50,
            child: const Text(
              'No feed data yet. Open the Community feed to generate rankings.',
              style: TextStyle(fontSize: 12),
            ),
          );
        }

        final snapshot = snapshots.first;
        final avgML = snapshot.posts.isEmpty 
            ? 0.0 
            : snapshot.posts.map((s) => s.mlScore).reduce((a, b) => a + b) / snapshot.posts.length;

        return Container(
          padding: const EdgeInsets.all(16),
          color: isSimulated ? Colors.amber.shade50 : Colors.blue.shade50,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isSimulated) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Viewing feed as: ${profile?.simulatedLabel ?? _selectedProfile.label} (simulated)',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
              Text(
                'Feed Snapshot Summary',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text('• ${snapshot.posts.length} posts ranked'),
              Text('• Average ML Score: ${(avgML * 100).toStringAsFixed(1)}%'),
              Text('• Profile: ${_selectedProfile.label}'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPostBreakdowns() {
    return ListenableBuilder(
      listenable: _store.feedDebugSnapshotsNotifier,
      builder: (context, child) {
        final snapshots = _store.feedDebugSnapshotsNotifier.value;
        if (snapshots.isEmpty) {
          return const Center(
            child: Text('No data available'),
          );
        }

        final snapshot = snapshots.first;
        final postScores = snapshot.posts;

        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: postScores.length,
          itemBuilder: (_, i) {
            final snap = postScores[i];
            final post = _store.posts.firstWhere(
              (p) => p.id == snap.postId,
              orElse: () => _store.posts.first,
            );

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              elevation: 3,
              child: ExpansionTile(
                title: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '#${snap.rank}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Score: ${snap.finalScore.toStringAsFixed(1)}',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildScoreBar('Topic Match', snap.topicScore, 25, Colors.blue),
                        _buildScoreBar('Format Pref', snap.formatScore, 10, Colors.cyan),
                        _buildScoreBar('Community', snap.industryScore, 20, Colors.indigo),
                        _buildScoreBar('Author Affinity', snap.authorScore, 15, Colors.deepPurple),
                        _buildScoreBar('Engagement', snap.engagementScore, 15, Colors.amber),
                        _buildScoreBar('Freshness', snap.freshnessScore, 20, Colors.orange),
                        _buildScoreBar('Reputation', snap.reputationScore, 20, Colors.purple),
                        _buildScoreBar('Proximity', snap.proximityScore, 35, Colors.teal),
                        _buildScoreBar('Session Spike', snap.sessionScore, 25, Colors.redAccent),
                        _buildScoreBar('ML Probability', snap.mlScore * 100, 100, Colors.green),
                        if (snap.negativeScore > 0)
                          _buildScoreBar('Negative Signals', -snap.negativeScore * 30, 30, Colors.red),
                        const SizedBox(height: 16),
                        _buildExplanation(snap),
                      ],
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

  Widget _buildScoreBar(String label, double value, double max, Color color) {
    final v = value.clamp(0, max);
    final fraction = max == 0 ? 0.0 : (v / max);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
              ),
              Text(
                '${v.toStringAsFixed(1)}/${max.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 10,
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutCubic,
              tween: Tween(begin: 0.0, end: fraction),
              builder: (context, animatedFraction, child) {
                return LinearProgressIndicator(
                  value: animatedFraction,
                  minHeight: 5,
                  backgroundColor: color.withValues(alpha: 0.15),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExplanation(FeedDebugPostScore snap) {
    final profile = _selectedProfile.getProfile(_store);
    final isSimulated = profile?.isSimulated ?? false;
    final reasons = <String>[];

    if (isSimulated && profile != null) {
      // Add cold start / persona-specific explanations
      if (snap.topicScore > 15) {
        reasons.add('✓ Matches ${profile.simulatedLabel} interests in ${snap.tags.join(', ')}');
      }
      if (profile.industryScores.isNotEmpty) {
        final topIndustry = profile.industryScores.entries.reduce((a, b) => a.value > b.value ? a : b).key;
        reasons.add('✓ Boosted for $topIndustry persona profile');
      }
    }

    if (snap.topicScore > 15) {
      reasons.add('✓ Highly relevant to your interests (${snap.tags.join(', ')})');
    }
    if (snap.sessionScore > 10) {
      reasons.add('✓ Matches your current session behavior (+${snap.sessionScore.toStringAsFixed(0)} Session Spike)');
    }
    if (snap.proximityScore > 15) {
      reasons.add('✓ You\'ve interacted with this author before (+${snap.proximityScore.toStringAsFixed(0)} Proximity)');
    }
    if (snap.reputationScore > 10) {
      reasons.add('✓ High-quality author (+${snap.reputationScore.toStringAsFixed(0)} Reputation)');
    }
    if (snap.mlScore > 0.6) {
      reasons.add('✓ ML model predicts ${(snap.mlScore * 100).toStringAsFixed(0)}% engagement likelihood');
    }
    if (snap.freshnessScore > 15) {
      reasons.add('✓ Fresh content prioritized');
    }
    if (snap.engagementScore > 10) {
      reasons.add('✓ High engagement quality');
    }
    if (snap.negativeScore > 0.5) {
      reasons.add('⚠ Previously hidden similar content (−${(snap.negativeScore * 30).toStringAsFixed(0)} pts)');
    }

    if (reasons.isEmpty) {
      reasons.add('Standard ranking based on multiple factors');
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Why you\'re seeing this:',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...reasons.map((r) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  r,
                  style: const TextStyle(fontSize: 11),
                ),
              )),
        ],
      ),
    );
  }
}
