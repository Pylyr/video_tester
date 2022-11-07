import 'dart:async';

import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

void main() => runApp(VideoApp());

class VideoApp extends StatefulWidget {
  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  late VideoPlayerController _controller;

  void skip30every5() {
    Timer(_controller.value.duration, () {
      _controller.seekTo(_controller.value.position + Duration(seconds: 30));
      Timer(Duration(seconds: 5), () {
        skip30every5();
        // print how much of the video is loaded
        print(_controller.value.position);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        'https://www.quintic.com/software/sample_videos/Equine%20Walk%20300fps.avi')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
        // skip30every5();
        // _controller.play();
      });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Demo',
      home: Scaffold(
        body: Center(
          child: _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : Container(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          },
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
