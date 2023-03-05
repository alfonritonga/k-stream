import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kstream/app/modules/film_detail/views/film_detail_view.dart';
import 'package:kstream/app/routes/app_pages.dart';
import 'package:kstream/constants/constants.dart';
import 'package:kstream/models/film_model.dart';

import '../controllers/home_controller.dart';
import 'package:startapp_sdk/startapp.dart';

class HomeView extends StatefulWidget {
  HomeView({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<HomeView> {
  final controller = Get.isRegistered<HomeController>()
      ? Get.find<HomeController>()
      : Get.put(HomeController());

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
    // TODO make sure to comment out this line before release
    startAppSdk.setTestAdsEnabled(false);
    // startAppSdk.set

    // TODO your app doesn't need to call this method unless for debug purposes
    startAppSdk.getSdkVersion().then((value) {
      setState(() => _sdkVersion = value);
    });
    banner();
    videoBanner();
    mcBanner();
    inteesitital();
    super.initState();
  }

  void banner() {
    startAppSdk.loadBannerAd(
      StartAppBannerType.BANNER,
      prefs: const StartAppAdPreferences(adTag: 'primary'),
      onAdImpression: () {
        debugPrint('onAdImpression: banner');
      },
      onAdClicked: () {
        debugPrint('onAdClicked: banner');
      },
    ).then((bannerAd) {
      setState(() {
        this.bannerAd = bannerAd;
      });
    }).onError<StartAppException>((ex, stackTrace) {
      debugPrint("Error loading Banner ad: ${ex.message}");
    }).onError((error, stackTrace) {
      debugPrint("Error loading Banner ad: $error");
    });
  }

  void videoBanner() {}

  void mcBanner() {
    startAppSdk
        .loadBannerAd(
      StartAppBannerType.MREC,
      prefs: const StartAppAdPreferences(adTag: 'secondary'),
    )
        .then((mrecAd) {
      setState(() {
        this.mrecAd = mrecAd;
      });
    }).onError<StartAppException>((ex, stackTrace) {
      debugPrint("Error loading Mrec ad: ${ex.message}");
    }).onError((error, stackTrace) {
      debugPrint("Error loading Mrec ad: $error");
    });
  }

  void inteesitital() {
    startAppSdk
        .loadInterstitialAd(
      prefs: const StartAppAdPreferences(adTag: 'home_screen'),
      onAdDisplayed: () {
        debugPrint('onAdDisplayed: interstitial');
      },
      onAdNotDisplayed: () {
        debugPrint('onAdNotDisplayed: interstitial');

        setState(() {
          // NOTE interstitial ad can be shown only once
          this.interstitialAd?.dispose();
          this.interstitialAd = null;
        });
      },
      onAdClicked: () {
        debugPrint('onAdClicked: interstitial');
      },
      onAdHidden: () {
        debugPrint('onAdHidden: interstitial');

        setState(() {
          // NOTE interstitial ad can be shown only once
          this.interstitialAd?.dispose();
          this.interstitialAd = null;
        });
      },
    )
        .then((interstitialAd) {
      setState(() {
        this.interstitialAd = interstitialAd;
      });
    }).onError<StartAppException>((ex, stackTrace) {
      debugPrint("Error loading Interstitial ad: ${ex.message}");
    }).onError((error, stackTrace) {
      debugPrint("Error loading Interstitial ad: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    banner();
    var buttonStyle =
        ButtonStyle(minimumSize: MaterialStateProperty.all(Size(224, 36)));
    return Scaffold(
        backgroundColor: Color(0xFFFAFAFA),
        appBar: AppBar(
          title: const Text('K-Stream v1.0.0',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: GetBuilder<HomeController>(
          init: HomeController(),
          initState: (_) async {
            controller.films();
          },
          dispose: (_) {},
          builder: (_) {
            return Container(
                padding: const EdgeInsets.all(16),
                child: Obx(() => controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: controller.filmModel.value.data?.length ?? 0,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                              onTap: () {
                                startAppSdk
                                    .loadRewardedVideoAd(
                                  prefs: const StartAppAdPreferences(
                                      adTag: 'home_screen_rewarded_video'),
                                  onAdDisplayed: () {
                                    // debugPrint('onAdDisplayed: rewarded video');
                                  },
                                  onAdNotDisplayed: () {
                                    // debugPrint(
                                    //     'onAdNotDisplayed: rewarded video');

                                    setState(() {
                                      // NOTE rewarded video ad can be shown only once
                                      this.rewardedVideoAd?.dispose();
                                      this.rewardedVideoAd = null;
                                    });
                                  },
                                  onAdClicked: () {
                                    // debugPrint('onAdClicked: rewarded video');
                                  },
                                  onAdHidden: () {
                                    // debugPrint('onAdHidden: rewarded video');

                                    setState(() {
                                      // NOTE rewarded video ad can be shown only once
                                      this.rewardedVideoAd?.dispose();
                                      this.rewardedVideoAd = null;
                                    });
                                  },
                                  onVideoCompleted: () {
                                    debugPrint(
                                        'onVideoCompleted: rewarded video completed, user gain a reward');

                                    // setState(() {
                                    //   reward = reward != null ? reward! + 1 : 1;
                                    // });
                                    // rewardedVideoAd!.show();
                                    Get.to(FilmDetailView(
                                      film: controller
                                          .filmModel.value.data![index],
                                    ));
                                  },
                                )
                                    .then((rewardedVideoAd) {
                                  rewardedVideoAd.show();
                                  Get.to(FilmDetailView(
                                    film:
                                        controller.filmModel.value.data![index],
                                  ));
                                }).onError<StartAppException>((ex, stackTrace) {
                                  debugPrint(
                                      "Error loading Rewarded Video ad: ${ex.message}");
                                }).onError((error, stackTrace) {
                                  debugPrint(
                                      "Error loading Rewarded Video ad: $error");
                                });
                              },
                              child: CardDrakor(
                                  controller.filmModel.value.data![index]));
                        },
                      )));
          },
        ),
        bottomNavigationBar: Container(
          height: 50.0,
          // color: Colors.white,
          child: bannerAd != null ? StartAppBanner(bannerAd!) : Container(),
        ));
  }
}

class CardDrakor extends StatelessWidget {
  CardDrakor(
    this.film, {
    super.key,
  });

  DataFilm film;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        color: Colors.white,
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  mediaUrl + film.poster!,
                  width: 100,
                  height: 100,
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${film.title}',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    const SizedBox(height: 4),
                    Text('Drama Korea',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Colors.black)),
                    const SizedBox(height: 4),
                    // Text('8 Video',
                    //     style: TextStyle(
                    //         fontSize: 14,
                    //         fontWeight: FontWeight.normal,
                    //         color: Colors.black)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // jam update
                        Text('1 Jam yang lalu',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: Colors.black)),
                        // view
                        Text('${film.views ?? 0} views',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: Colors.black)),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
