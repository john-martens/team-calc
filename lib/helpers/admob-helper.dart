import 'dart:io';
import 'package:firebase_admob/firebase_admob.dart';

class AdMobHelper {
  InterstitialAd myInterstitial;

  String getAppId() {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3768518226199114~8287859103';
    } else {
      return 'ca-app-pub-3768518226199114~4999350786';
    }
  }

  String getBannerId() {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3768518226199114/9068789436';
    } else {
      return 'ca-app-pub-3768518226199114/6803387042';
    }
  }

  String getFullPageId() {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3768518226199114/8621549951';
    } else {
      return 'ca-app-pub-3768518226199114/9152388213';
    }
  }

  void showInterstitialAd() {
    myInterstitial..show();
  }
}
