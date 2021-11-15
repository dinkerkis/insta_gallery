import 'dart:io';

import 'package:cropper_and_trimmer/cropper_and_trimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbar_manager/flutter_statusbar_manager.dart';
import 'package:insta_gallery/src/images_screen.dart';
import 'package:insta_gallery/src/utils.dart';
import 'package:insta_gallery/src/videos_screen.dart';
import 'package:insta_gallery/src/widgets/bottom_bar.dart';

class InstaGallery extends StatefulWidget {
  final GalleryImagePicked? onGalleryImagePicked;
  final GalleryImagePicked? onGalleryVideoPicked;
  final bool shouldEdit;
  final bool shouldPreview;
  final bool saveToGallery;
  final Color? backgroundColor;
  final Color? primaryColor;
  final Color? secondaryColor;

  const InstaGallery({
    Key? key,
    this.onGalleryImagePicked,
    this.onGalleryVideoPicked,
    this.shouldEdit = false,
    this.shouldPreview = false,
    this.saveToGallery = false,
    this.backgroundColor,
    this.primaryColor,
    this.secondaryColor,
  }) : super(key: key);

  @override
  _InstaGalleryState createState() => _InstaGalleryState();
}

typedef GalleryImagePicked = void Function(File file);

class _InstaGalleryState extends State<InstaGallery> {
  List<Widget> _pages = [];

  PageController? _pageController;

  @override
  void initState() {

    backgroundColor = widget.backgroundColor ?? backgroundColor;
    primaryColor = widget.primaryColor ?? primaryColor;
    secondaryColor = widget.secondaryColor ?? secondaryColor;

    super.initState();
    _pageController = PageController();

    _pages = [
      GalleryImageScreen(onGalleryImagePicked: (File file) {
        selectedVideoIndex = -1;
        if (widget.shouldEdit) {

          Navigator.push(context,
            MaterialPageRoute(
                builder: (_) =>
                    CropperAndTrimmer(
                      file: file,
                      shouldPreview: widget.shouldPreview,
                      saveToGallery: widget.saveToGallery,
                      primaryColor: widget.primaryColor,
                      secondaryColor: widget.secondaryColor,
                      backgroundColor: widget.backgroundColor,
                      fileType: FileType.image,
                      onImageUpdated: (file) {
                        if (widget.onGalleryImagePicked != null) {
                          widget.onGalleryImagePicked!(file);
                        }
                        if (mounted) {
                          Navigator.pop(context);
                          FlutterStatusbarManager.setHidden(false);
                        }

                      },
                    ),
                fullscreenDialog: true),
          );
        }
        else {
          if (widget.onGalleryImagePicked != null) {
            widget.onGalleryImagePicked!(file);
          }
          if (mounted) {
            Navigator.pop(context);
            FlutterStatusbarManager.setHidden(false);
          }
        }

      }),
      GalleryVideoScreen(onGalleryVideoPicked: (File file) {

        selectedImageIndex = -1;
        if (widget.shouldEdit) {

          Navigator.push(context,
            MaterialPageRoute(
                builder: (_) =>
                    CropperAndTrimmer(
                      file: file,
                      shouldPreview: widget.shouldPreview,
                      saveToGallery: widget.saveToGallery,
                      primaryColor: widget.primaryColor,
                      secondaryColor: widget.secondaryColor,
                      backgroundColor: widget.backgroundColor,
                      fileType: FileType
                          .video,
                      onVideoUpdated: (file) {
                        if (widget.onGalleryVideoPicked != null) {
                          widget.onGalleryVideoPicked!(file);
                        }
                        if (mounted) {
                          Navigator.pop(context);
                          FlutterStatusbarManager.setHidden(false);
                        }
                      },
                    ),
                fullscreenDialog: true),
          );
        }
        else {
          if (widget.onGalleryVideoPicked != null) {
            widget.onGalleryVideoPicked!(file);
          }
          if (mounted) {
            Navigator.pop(context);
            FlutterStatusbarManager.setHidden(false);
          }
        }
      }),
    ];
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  int pageIndex = 0;
  @override
  Widget build(BuildContext context) {


    backgroundColor = widget.backgroundColor ?? Colors.white;
    primaryColor = widget.primaryColor ?? Theme.of(context).primaryColorDark;
    secondaryColor = widget.secondaryColor ?? Theme.of(context).primaryColorLight;

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