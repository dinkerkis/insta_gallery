
import 'dart:io';
import 'dart:typed_data';

import 'package:cropper_and_trimmer/cropper_and_trimmer.dart';
import 'package:flutter/material.dart';
import 'package:insta_gallery/src/add_screen.dart';
import 'package:insta_gallery/src/utils.dart';
import 'package:insta_gallery/src/widgets/top_bar.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';

class GalleryVideoScreen extends StatefulWidget {

  final GalleryImagePicked onGalleryVideoPicked;

  const GalleryVideoScreen({Key? key,
    required this.onGalleryVideoPicked}) : super(key: key);

  @override
  _GalleryVideoScreenState createState() => _GalleryVideoScreenState();
}

class _GalleryVideoScreenState extends State<GalleryVideoScreen> {

  final ScrollController _gridScrollController = ScrollController();
  final ScrollController _singleChildController = ScrollController();
  var selectedIndex = -1;
  bool isExpanded = true;
  VideoPlayerController _controller = VideoPlayerController.network('');
  List<Uint8List> galleryVideosThumbnailList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (galleryVideosList.length == 0 ) {
      loadData();
    }
    else {
      fetchData();
      if (selectedVideoIndex != -1) {
        selectedIndex = selectedVideoIndex;
      }
      else if (galleryVideosList.length > 0) {
        selectedIndex = 0;
      }
    }

    getThumbnails();
    setVideo();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _singleChildController.dispose();
    _gridScrollController.dispose();
    _controller.dispose();
  }

  void _gridListener() {
    if (_gridScrollController.offset <
        _gridScrollController.position.minScrollExtent - 50) {
      _singleChildController.animateTo(_gridScrollController.offset,
          duration: Duration(milliseconds: 100), curve: Curves.linear);
    }
  }

  Future loadData() async {
    for (AssetPathEntity item in assetlist)
    {
      if (item.name.toLowerCase().contains('video')) {
        var assetEntityList = await item.getAssetListPaged(
            0, item.assetCount);
        for (AssetEntity entity in assetEntityList) {

          var file = await entity.file; // image file

          if (file != null && entity.type == AssetType.video) {
            galleryVideosEntityList.add(entity);
            galleryVideosList.add(file as File);
          }
        }
      }
    }
    if (galleryVideosList.length > 0 )
    {
      selectedIndex = 0;
      getThumbnails();
      setVideo();
    }

    setState(() {

    });
  }

  Future fetchData() async {
    var result = await PhotoManager.requestPermissionExtend();
    if (result.isAuth) {
      // success
      var reloadedAssetList = await PhotoManager.getAssetPathList();

      if (reloadedAssetList != assetlist) {
        assetlist = reloadedAssetList;
        galleryVideosEntityList = [];
        galleryVideosList = [];

        loadData();
      }
    }
  }

  void setVideo() {
    if (galleryVideosList.length > 0 && selectedIndex != -1) {
      var file = galleryVideosList[selectedIndex];

      if (file != null) {
        _controller = VideoPlayerController.file(file)
          ..initialize().then((_) {
            _controller.pause();
            // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
            setState(() {});
          });
      }

    }
  }

  Future getThumbnails() async {
    galleryVideosThumbnailList = [];

    for (AssetEntity entity in galleryVideosEntityList) {

      var thumb = await entity.thumbData; // image file

      if (thumb != null ) {
        galleryVideosThumbnailList.add(thumb as Uint8List);
      }
      setState(() {

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _gridScrollController.addListener(_gridListener);
    _singleChildController.addListener(_gridListener);
    Size _screen = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
        height: _screen.height,
        width: _screen.width,
        // color: primaryColor,
        child: SingleChildScrollView(
          controller: _singleChildController,
          child: Column(
            children: <Widget>[
              AppTopBar(screenName: 'gallery', height: 45,
                onNextButtonPressed: () {
                  selectedVideoIndex = selectedIndex;
                  if(widget.onGalleryVideoPicked != null && selectedIndex != -1 && galleryVideosList.length > 0) {
                    widget.onGalleryVideoPicked(galleryVideosList[selectedIndex]);
                  }
                },),
              Container(
                height: 410,
                // color: secondaryColor,
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: _controller.value.isInitialized
                          ? AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child:
                          VideoPlayer(_controller)
                      ) : Container(),
                    ),
                    Center(
                      child: _controller.value.isInitialized
                          ? FloatingActionButton(
                        backgroundColor: primaryColor,
                        onPressed: () {
                          setState(() {
                            _controller.value.isPlaying
                                ? _controller.pause()
                                : _controller.play();
                          });
                        },
                        child: Icon(
                          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow, color: secondaryColor,
                        ),
                      ) : Container(),
                    ),
                  ],
                ),
              ),
              Divider(height: 5,),
              Container(
                //height: _screen.height - 90,
                child: galleryVideosList.length == 0 ? Container(
                    padding: EdgeInsets.only(top: 50),
                    child: CircularProgressIndicator(
                      color: secondaryColor,)) :
                GridView.count(
                    padding: EdgeInsets.only(bottom: 40),
                    controller: _gridScrollController,
                    shrinkWrap: true,
                    crossAxisCount: 4,
                    children: List<Widget>.generate(
                        galleryVideosList.length,
                            (index) => InkWell(
                          child: Stack(//fit: StackFit.expand,
                            children: [
                              galleryVideosThumbnailList.length == galleryVideosList.length ?  Container(
                                  height: 200,
                                  width: 200,
                                  child: Image.memory(galleryVideosThumbnailList[index],
                                    fit: BoxFit.cover,
                                    alignment: Alignment.center,)) : Container(),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [
                                        Colors.transparent,
                                        Colors.black54,
                                      ],
                                      begin: const FractionalOffset(0.0, 0.0),
                                      end: const FractionalOffset(0.0, 1.0),
                                      stops: [0.0, 1.0],
                                      tileMode: TileMode.clamp),
                                ),
                              ),
                              Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(galleryVideosEntityList.length == galleryVideosList.length ?
                                  galleryVideosEntityList[index].duration.toString() + ' sec' : '',
                                      maxLines: 1,
                                      style: TextStyle(
                                        color: secondaryColor,
                                        fontSize: 18, fontWeight: FontWeight.w600,
                                      )
                                  )
                              ),
                            ],
                          ),
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                              setVideo();
                            });
                          },
                        )
                    )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
