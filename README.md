# insta_gallery

A new Flutter project.

## Getting Started

## iOS Target

This package will work for iOS 13 or later versions.

## iOS plist config 

Because the album is a privacy privilege, you need user permission to access it. You must to modify the Info.plist file in Runner project.

``` 
    <key>NSCameraUsageDescription</key>
    <string>Use</string>
    <key>NSMicrophoneUsageDescription</key>
    <string>Use</string>
    <key>NSAppleMusicUsageDescription</key>
    <string>Use</string>
    <key>NSPhotoLibraryUsageDescription</key>
    <string>Use</string>
    
``` 

## 1.  Add in pubspec.yaml file under
 
 dependencies:
``` 
 insta_gallery:  
   git:  
     url: https://github.com/dinkerkis/insta_gallery.git
``` 
 
## 2. Add package

``` 
import 'package:insta_gallery/insta_gallery.dart';

``` 


## 3.  Use in the code like this: 

``` 
InstaGallery(shouldEdit: true,
                  onGalleryImagePicked: (file) {
                    if (mounted) {
                      setState(() {

                      });
                    }
                  },
                  onGalleryVideoPicked: (file) {
                    if (mounted) {
                      setState(() {

                      });
                    }
                  },
                )
```


## 4.  Example:

``` 

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {

  File? galleryImagePicked;
  File? galleryVideoPicked;
  VideoPlayerController _controller = VideoPlayerController.network('');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Container(
            height: double.infinity,
            width: double.infinity,
            child:
            galleryImagePicked == null && galleryVideoPicked == null ? Center(
                child: Text(
                  'Add New Post',
                )):
            galleryImagePicked != null ?
            Image.file(galleryImagePicked as File, fit: BoxFit.contain,) :
            galleryVideoPicked != null ? Stack(
                children: <Widget>[
                  Center(
                    child: _controller.value.isInitialized
                        ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                        : Container(),
                  ),
                  Center(
                    child: _controller.value.isInitialized
                        ? FloatingActionButton(
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
                    ) : Container(),
                  ),
                ]
            ) : SizedBox(height: 0,)
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
            MaterialPageRoute(
                builder: (_) => InstaGallery(shouldEdit: true,
                  onGalleryImagePicked: (file) {
                    galleryImagePicked = file;
                    galleryVideoPicked = null;
                    if (mounted) {
                      setState(() {

                      });
                    }
                  },
                  onGalleryVideoPicked: (file) {
                    galleryVideoPicked = file;
                    galleryImagePicked = null;
                    _controller = VideoPlayerController.file(
                        file)
                      ..initialize().then((_) {
                        _controller.pause();
                        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
                        setState(() {});
                      });
                  },
                ),
                fullscreenDialog: true),
          );
        },
        child: const Icon(Icons.camera_alt_rounded),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


``` 
