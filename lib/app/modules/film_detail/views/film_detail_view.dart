import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'package:get/get.dart';
import 'package:kstream/constants/constants.dart';
import 'package:kstream/models/film_model.dart';
import 'package:video_player/video_player.dart';

import '../controllers/film_detail_controller.dart';

class FilmDetailView extends StatefulWidget {
  FilmDetailView({Key? key, required this.film}) : super(key: key);

  DataFilm film;
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<FilmDetailView> {
  late ChewieController chewieController;

  final controller = Get.isRegistered<FilmDetailController>()
      ? Get.find<FilmDetailController>()
      : Get.put(FilmDetailController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FilmDetailView'),
        centerTitle: true,
      ),
      body: GetBuilder<FilmDetailController>(
        init: FilmDetailController(),
        initState: (_) async {
          controller.updateLink(widget.film.url1!);
          chewieController = ChewieController(
            videoPlayerController: controller.videoPlayerController.value,
            autoPlay: false,
            aspectRatio: 16 / 9,
            looping: false,
            allowFullScreen: true,
            // background color
            materialProgressColors: ChewieProgressColors(
              playedColor: Colors.pink,
              handleColor: Colors.blue,
              backgroundColor: Colors.transparent,
              bufferedColor: Colors.grey,
            ),
            placeholder: Container(
              color: Colors.black,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
            deviceOrientationsOnEnterFullScreen: [
              DeviceOrientation.landscapeLeft,
              DeviceOrientation.landscapeRight,
            ],
            deviceOrientationsAfterFullScreen: [
              DeviceOrientation.portraitUp,
              DeviceOrientation.portraitDown,
            ],
          );
        },
        dispose: (_) {
          chewieController.dispose();
          chewieController.videoPlayerController.dispose();
          print('dispose chewie controller');
        },
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            children: [
              Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Chewie(
                  controller: chewieController,
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Text(
                  widget.film.title!,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              // genre
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Text(
                  widget.film.genre!,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Text(
                  widget.film.synopsis!,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          );
        },
      ),
      // bottomNavigationBar: Container(
      //     height: 50.0,
      //     // color: Colors.white,
      //     child: StartAppBanner(bannerAd!)),
    );
  }
}
