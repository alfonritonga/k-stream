import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kstream/app/modules/home/views/home_view.dart';
import 'package:kstream/app/modules/splash/splash_page.dart';
import 'package:kstream/app/routes/app_pages.dart';
import 'package:startapp_sdk/startapp.dart';

class Root extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Root> {
  var startAppSdk = StartAppSdk();
  var _sdkVersion = "";

  StartAppBannerAd? bannerAd;
  StartAppBannerAd? mrecAd;
  StartAppInterstitialAd? interstitialAd;
  StartAppRewardedVideoAd? rewardedVideoAd;
  StartAppNativeAd? nativeAd;
  int? reward;

  @override
  void initState() {
    super.initState();

    // TODO make sure to comment out this line before release
    startAppSdk.setTestAdsEnabled(true);

    // TODO your app doesn't need to call this method unless for debug purposes
    startAppSdk.getSdkVersion().then((value) {
      setState(() => _sdkVersion = value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'K-Stream',
      debugShowCheckedModeBanner: false,
      // add font
      theme: ThemeData(
        fontFamily: GoogleFonts.openSans().fontFamily,
      ),
      initialRoute: Routes.SPLASHSCREEN,
      getPages: [
        GetPage(
          name: Routes.SPLASHSCREEN,
          page: () => SplashScreen(),
        ),
        GetPage(
          name: Routes.HOME,
          page: () => HomeView(),
        ),
      ],
    );
  }
}
