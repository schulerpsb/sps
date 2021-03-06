import 'dart:io';

import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:sps/models/sps_login.dart';
import 'package:sps/screens/sps_drawer_screen.dart';
import 'package:video_player/video_player.dart';

class sps_videoPlayer_screen extends StatefulWidget {
  final String _filePath;
  final String _fileType;

  sps_videoPlayer_screen(this._filePath, this._fileType);

  @override
  _sps_mediaPlayer_screen createState() =>
      _sps_mediaPlayer_screen();
}

class _sps_mediaPlayer_screen extends State<sps_videoPlayer_screen> {
  TargetPlatform _platform;
  VideoPlayerController _videoPlayerController1;
  ChewieController _chewieController;

  final SpsLogin spslogin = SpsLogin();
  GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    if(this.widget._fileType == "video") {
      initializeVideoPlayer();
    }
  }

  Future<void> initializeVideoPlayer() async {
    String videoPath;
    videoPath = this.widget._filePath.replaceAll('.jpg', '.mp4');
    videoPath = videoPath.replaceAll('/thumbs/', '/');
    if(File(videoPath).existsSync() == false){
      videoPath = this.widget._filePath.replaceAll('.jpg', '.MOV');
      videoPath = videoPath.replaceAll('/thumbs/', '/');
    }
    // debugPrint(videoPath);
    var file = new File(videoPath);
    _videoPlayerController1 = VideoPlayerController.file(file);
    await _videoPlayerController1.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1,
      autoPlay: false,
      looping: false,
      // Try playing around with some of these other options:
      // showControls: false,
      // materialProgressColors: ChewieProgressColors(
      //   playedColor: Colors.red,
      //   handleColor: Colors.blue,
      //   backgroundColor: Colors.grey,
      //   bufferedColor: Colors.lightGreen,
      // ),
      // placeholder: Container(
      //   color: Colors.grey,
      // ),
      // autoInitialize: true,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFe9eef7), // Cinza Azulado
      appBar: AppBar(
        backgroundColor: Color(0xFF004077), // Azul Schuler
        title: Text(
          'VISUALIZADOR DE VIDEOS',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      endDrawer: sps_drawer(spslogin: spslogin),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Center(
                child: _chewieController != null &&
                        _chewieController
                            .videoPlayerController.value.initialized
                    ? Chewie(
                        controller: _chewieController,
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CircularProgressIndicator(),
                          SizedBox(height: 20),
                          Text('Loading'),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
