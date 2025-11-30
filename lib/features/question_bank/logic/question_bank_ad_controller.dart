import 'package:shared_preferences/shared_preferences.dart';

class QuestionBankAdController {
  QuestionBankAdController._();

  static final QuestionBankAdController instance =
      QuestionBankAdController._();

  static const int _questionsPerInterstitial = 5;
  static const String _adFreeUntilKey = 'qb_ad_free_until_epoch_ms';

  int _questionViewCounter = 0;

  /// Returns true if ads should be disabled for the rest of today.
  Future<bool> isAdFree() async {
    final prefs = await SharedPreferences.getInstance();
    final millis = prefs.getInt(_adFreeUntilKey);
    if (millis == null) return false;

    final until = DateTime.fromMillisecondsSinceEpoch(millis);
    final now = DateTime.now();

    if (now.isBefore(until)) {
      return true;
    } else {
      // Expired – clear it
      await prefs.remove(_adFreeUntilKey);
      return false;
    }
  }

  /// Unlock ad-free Question Bank for the rest of the day.
  Future<void> unlockAdFreeDay() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    // End of today (23:59:59)
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
    await prefs.setInt(
      _adFreeUntilKey,
      endOfDay.millisecondsSinceEpoch,
    );
  }

  /// Call this whenever the user goes to the next question.
  /// Returns true if we should show an interstitial ad.
  Future<bool> registerAndShouldShowInterstitial() async {
    if (await isAdFree()) return false;

    _questionViewCounter++;
    if (_questionViewCounter >= _questionsPerInterstitial) {
      _questionViewCounter = 0;
      return true;
    }
    return false;
  }
}
