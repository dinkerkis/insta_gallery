import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_statusbar_manager/flutter_statusbar_manager.dart';
import 'package:insta_gallery/src/images_screen.dart';
import 'package:insta_gallery/src/utils.dart';
import 'package:insta_gallery/src/video_editor.dart';
import 'package:insta_gallery/src/videos_screen.dart';
import 'package:insta_gallery/src/widgets/bottom_bar.dart';
import 'package:image_cropper/image_cropper.dart';

class InstaGallery extends StatefulWidget {
  final GalleryImagePicked? onGalleryImagePicked;
  final GalleryImagePicked? onGalleryVideoPicked;
  final bool shouldEdit;
  const InstaGallery({Key? key, this.onGalleryImagePicked, this.onGalleryVideoPicked, this.shouldEdit = false}) : super(key: key);

  @override
  _InstaGalleryState createState() => _InstaGalleryState();
}


typedef GalleryImagePicked = void Function(File file);

class _InstaGalleryState extends State<InstaGallery> {
  List<Widget> _pages = [];

  PageController? _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _pages = [
      GalleryImageScreen(onGalleryImagePicked: (File file) {
        selectedVideoIndex = -1;
        if (widget.shouldEdit) {
          _cropImage(file);
        }
        else {
          if (widget.onGalleryImagePicked != null) {
            widget.onGalleryImagePicked!(file);
          }

          Navigator.pop(context);
          FlutterStatusbarManager.setHidden(false);
        }

      }),
      GalleryVideoScreen(onGalleryVideoPicked: (File file) {

        selectedImageIndex = -1;
        if (widget.shouldEdit) {
          //_cropImage(file, isImage: false);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  VideoEditor(file: File(file.path),
                    onGalleryVideoPicked: (file) {
                      if (widget.onGalleryVideoPicked != null) {
                        widget.onGalleryVideoPicked!(file);
                      }
                      Navigator.pop(context);
                      Navigator.pop(context);
                      FlutterStatusbarManager.setHidden(false);
                    },), //TrimmerView( file),
            ),
          );
        }
        else {
        if (widget.onGalleryVideoPicked != null) {
          widget.onGalleryVideoPicked!(file);
        }

        Navigator.pop(context);
        FlutterStatusbarManager.setHidden(false);
        }
      }),
    ];
  }

  Future _cropImage(File imageFile, {bool isImage = true}) async {
    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ]
            : [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio5x3,
          CropAspectRatioPreset.ratio5x4,
          CropAspectRatioPreset.ratio7x5,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Theme.of(context).primaryColorDark,
            toolbarWidgetColor: Theme.of(context).primaryColorLight,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));

    if (croppedFile != null) {
      if (isImage) {
        if (widget.onGalleryImagePicked != null) {
          widget.onGalleryImagePicked!(croppedFile as File);
        }
      }
      else
      {
        if (widget.onGalleryVideoPicked != null) {
          widget.onGalleryVideoPicked!(croppedFile as File);
        }
      }

      if (mounted) {
        Navigator.pop(context);
        FlutterStatusbarManager.setHidden(false);
      }
    }
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  int pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => pageIndex = index);
        },
        children: _pages,
      ),
      bottomNavigationBar: BottomBar(
        onTap: (value) {
          _onItemTapped(value);
        },
        height: 45,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      pageIndex = index;
      //
      //
      //using this page controller you can make beautiful animation effects
      _pageController?.animateToPage(index,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    });
  }
}