import 'dart:convert';
import 'package:flutter/material.dart';
import 'score_debug_store.dart';
import 'bot_swarm.dart';
import '../logic/community_store.dart';

class DebugConsoleScreen extends StatelessWidget {
  const DebugConsoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug Console'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFF121212),
      body: ListenableBuilder(
        listenable: ScoreDebugStore.instance,
        builder: (context, _) {
          final debugStore = ScoreDebugStore.instance;
          final snapshot = debugStore.lastSnapshot;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // 1. Streaming Toggle
              SwitchListTile(
                title: const Text(
                  'Stream feed debug data to dashboard',
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: const Text(
                  'When enabled, ranking snapshots are sent to the debug backend.',
                  style: TextStyle(color: Colors.white70),
                ),
                value: debugStore.isDebugStreamingEnabled,
                onChanged: debugStore.setDebugStreamingEnabled,
                activeTrackColor: Colors.greenAccent,
              ),
              const Divider(color: Colors.white24),

              // 2. Demo Bot Swarm Toggle
              ListenableBuilder(
                listenable: CommunityStore.instance.debugControlStore,
                builder: (context, _) {
                  final debugControl = CommunityStore.instance.debugControlStore;
                  return SwitchListTile(
                    title: const Text(
                      'Demo: 100-bot swarm',
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: const Text(
                      'Internal debug only – starts/stops bot simulation.',
                      style: TextStyle(color: Colors.white70),
                    ),
                    value: debugControl.demoBotSwarmEnabled,
                    onChanged: (value) {
                      debugControl.setDemoBotSwarmEnabled(value);
                    },
                    activeTrackColor: Colors.orangeAccent,
                  );
                },
              ),
              const Divider(color: Colors.white24),

              // 3. Bot Controls
              const SizedBox(height: 16),
              const Text(
                "Bot Swarm Controls",
                style: TextStyle(
                    color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildBotControls(),
              const Divider(color: Colors.white24),

              // 3. Snapshot Preview
              const SizedBox(height: 16),
              const Text(
                "Last Snapshot",
                style: TextStyle(
                    color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (snapshot == null) ...[
                const Text(
                  'No snapshots yet. Open the For You feed to generate one.',
                  style: TextStyle(color: Colors.white54),
                ),
              ] else ...[
                Text(
                  'Timestamp: ${snapshot.createdAt.toIso8601String()}',
                  style: const TextStyle(color: Colors.white70),
                ),
                Text(
                  'Feed Type: ${snapshot.feedType}',
                  style: const TextStyle(color: Colors.white70),
                ),
                Text(
                  'Posts Ranked: ${snapshot.posts.length}',
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: SelectableText(
                    const JsonEncoder.withIndent('  ').convert(snapshot.toJson()),
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      color: Colors.greenAccent,
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
  Widget _buildBotControls() {
    return StatefulBuilder(
      builder: (context, setState) {
        final isRunning = BotSwarm.instance.isRunning;
        return Row(
          children: [
            ElevatedButton.icon(
              onPressed: isRunning
                  ? null
                  : () {
                      BotSwarm.instance.startDemoBotSwarm();
                      setState(() {});
                    },
              icon: const Icon(Icons.play_arrow),
              label: const Text("Start Simulation"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: !isRunning
                  ? null
                  : () {
                      BotSwarm.instance.stopDemoBotSwarm();
                      setState(() {});
                    },
              icon: const Icon(Icons.stop),
              label: const Text("Stop"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }
}
