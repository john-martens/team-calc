import 'package:flutter/material.dart';
import 'app.dart';
import 'package:provider/provider.dart';
import './helpers/db-connector.dart';
import 'package:flutter/services.dart';
import 'package:firebase_admob/firebase_admob.dart';
import './helpers/admob-helper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  //ca-app-pub-3768518226199114/9068789436 banner id android
  //ca-app-pub-3768518226199114/6803387042 banner id ios
  //ca-app-pub-3768518226199114~8287859103 android app id
  //ca-app-pub-3768518226199114~4999350786 ios app id
  FirebaseAdMob.instance.initialize(appId: AdMobHelper().getAppId());
  runApp(
    ChangeNotifierProvider(
      create: (context) => DBConnector(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: App());
  }
}
