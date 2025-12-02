import 'dart:io';

class AdConfig {
  // ===========================================================================
  // INSTRUCTIONS FOR USER:
  // 1. Go to https://apps.admob.com
  // 2. Create an App (or select existing) -> App Settings -> Copy "App ID"
  // 3. Create an Ad Unit (Banner) -> Copy "Ad Unit ID"
  // ===========================================================================

  // ---------------------------------------------------------------------------
  // STEP 1: Replace these with your REAL Ad Unit IDs from AdMob Console
  // ---------------------------------------------------------------------------
  // NOTE: Keep the Test IDs for development to avoid policy violations!
  // Only switch to Real IDs when you are ready to publish.
  
  // REAL IDs (Commented out for Demo/Testing)
  // static const String _androidBannerId = 'ca-app-pub-9034613854927603/1702693973';
  // static const String _iosBannerId = 'ca-app-pub-9034613854927603/1702693973'; 
  // static const String _androidInterstitialId = 'ca-app-pub-9034613854927603/3618410878';
  // static const String _iosInterstitialId = 'ca-app-pub-9034613854927603/3618410878'; 
  // static const String _androidRewardedId = 'ca-app-pub-9034613854927603/1976535454';
  // static const String _iosRewardedId = 'ca-app-pub-9034613854927603/1976535454'; 

  // GOOGLE TEST IDs (Use these for Hackathon/Demo)
  static const String _androidBannerId = 'ca-app-pub-3940256099942544/6300978111';
  static const String _iosBannerId = 'ca-app-pub-3940256099942544/2934735716';

  static const String _androidInterstitialId = 'ca-app-pub-3940256099942544/1033173712';
  static const String _iosInterstitialId = 'ca-app-pub-3940256099942544/4411468910';

  static const String _androidRewardedId = 'ca-app-pub-3940256099942544/5224354917';
  static const String _iosRewardedId = 'ca-app-pub-3940256099942544/1712485313';

  // ---------------------------------------------------------------------------
  // Logic to select the correct ID based on platform
  // ---------------------------------------------------------------------------
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return _androidBannerId;
    } else if (Platform.isIOS) {
      return _iosBannerId;
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return _androidInterstitialId;
    } else if (Platform.isIOS) {
      return _iosInterstitialId;
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return _androidRewardedId;
    } else if (Platform.isIOS) {
      return _iosRewardedId;
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }
}
