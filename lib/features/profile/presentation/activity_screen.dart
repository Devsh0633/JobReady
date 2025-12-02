import 'package:flutter/material.dart';



class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
    // Safe Mode Wrapper
    try {
      return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Your Activity'),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Liked'),
                Tab(text: 'Commented'),
                Tab(text: 'Replies'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              _buildPlaceholderTab('Posts you liked will appear here', Icons.favorite_border),
              _buildPlaceholderTab('Posts you commented on will appear here', Icons.comment_outlined),
              _buildPlaceholderTab('Replies to your posts will appear here', Icons.reply_outlined),
            ],
          ),
        ),
      );
    } catch (e) {
      return Scaffold(
        appBar: AppBar(title: const Text('Activity')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Something went wrong: $e'),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildPlaceholderTab(String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
