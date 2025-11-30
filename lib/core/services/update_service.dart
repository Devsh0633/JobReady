import 'package:flutter/material.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';
import 'package:restart_app/restart_app.dart';

class UpdateService {
  final _shorebirdCodePush = ShorebirdCodePush();

  Future<void> checkForUpdate(BuildContext context) async {
    // 1. Check if Shorebird is available
    final isAvailable = _shorebirdCodePush.isShorebirdAvailable();
    if (!isAvailable) {
      print("Shorebird not available (running in debug or no internet?)");
      return;
    }

    try {
      // 2. Check for new patch
      final isUpdateAvailable = await _shorebirdCodePush.isNewPatchAvailableForDownload();
      
      if (isUpdateAvailable) {
        // 3. Show Update Dialog
        if (context.mounted) {
          _showUpdateDialog(context);
        }
      }
    } catch (e) {
      print("Error checking for update: $e");
    }
  }

  void _showUpdateDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("New Update Available"),
        content: const Text(
          "A new version of JobReady is available with latest improvements.\n\nUpdate now for the best experience.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Later"),
          ),
          ElevatedButton(
            onPressed: () => _downloadAndApplyUpdate(context),
            child: const Text("Update Now"),
          ),
        ],
      ),
    );
  }

  Future<void> _downloadAndApplyUpdate(BuildContext context) async {
    // Show downloading state
    Navigator.pop(context); // Close previous dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("Downloading update..."),
          ],
        ),
      ),
    );

    try {
      await _shorebirdCodePush.downloadUpdateIfAvailable();
      
      if (context.mounted) {
        Navigator.pop(context); // Close downloading dialog
        
        // Show restart dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text("Update Ready"),
            content: const Text("The update has been downloaded. Restart the app to apply changes."),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Restart.restartApp();
                },
                child: const Text("Restart Now"),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Close downloading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Update failed: $e")),
        );
      }
    }
  }
}
