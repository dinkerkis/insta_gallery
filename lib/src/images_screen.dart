import 'dart:io';

import 'package:flutter/material.dart';
import 'package:insta_gallery/src/add_screen.dart';
import 'package:insta_gallery/src/utils.dart';
import 'package:insta_gallery/src/widgets/top_bar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

class GalleryImageScreen extends StatefulWidget {

  final GalleryImagePicked onGalleryImagePicked;

  const GalleryImageScreen({Key? key,
    required this.onGalleryImagePicked}) : super(key: key);

  @override
  _GalleryImageScreenState createState() => _GalleryImageScreenState();
}

class _GalleryImageScreenState extends State<GalleryImageScreen> {

  final ScrollController _gridScrollController = ScrollController();
  final ScrollController _singleChildController = ScrollController();
  var selectedIndex = -1;
  bool isExpanded = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (galleryImagesList.length == 0 ) {
      askForPermission();
    }
    else {
      fetchData();
      if (selectedImageIndex != -1) {
        selectedIndex = selectedImageIndex;
      }
      else if (galleryImagesList.length > 0) {
        selectedIndex = 0;
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _singleChildController.dispose();
    _gridScrollController.dispose();
  }

  void _gridListener() {
    if (_gridScrollController.offset <
        _gridScrollController.position.minScrollExtent - 50) {
      _singleChildController.animateTo(_gridScrollController.offset,
          duration: Duration(milliseconds: 100), curve: Curves.linear);
    }
  }

  Future askForPermission() async {
    final status = await Permission.photos.request();
    if (status == PermissionStatus.granted) {
      permissionGranted();
    } else if (status == PermissionStatus.denied) {
      setState(() {
        Navigator.of(context).pop();
      });
      _showMyDialog(context,
          "Gallery permission is needed to select photos. Open settings to grant permission ");
    } else if (status == PermissionStatus.permanentlyDenied) {
      _showMyDialog(context,
          "Gallery permission is needed to select photos. Open settings to grant permission ");
    }
  }

  Future permissionGranted() async {
    var result = await PhotoManager.requestPermissionExtend();
    if (result.isAuth) {
      // success
      assetlist = await PhotoManager.getAssetPathList();
      for (AssetPathEntity item in assetlist)
      {
        if (item.name.toLowerCase().contains('recent')) {
          var assetEntityList = await item.getAssetListPaged(
              0, item.assetCount);
          for (AssetEntity entity in assetEntityList) {
            var file = await entity.file; // image file

            if (file != null && entity.type == AssetType.image) {
              galleryImagesList.add(file as File);
            }
          }
        }
      }
      if (galleryImagesList.length > 0 )
      {
        selectedIndex = 0;
      }

      setState(() {

      });
    } else {
      // fail
      /// if result is fail, you can call `PhotoManager.openSetting();`  to open android/ios applicaton's setting to get permission
    }
  }

  Future fetchData() async {
    var result = await PhotoManager.requestPermissionExtend();
    if (result.isAuth) {
      // success
      var reloadedAssetList = await PhotoManager.getAssetPathList();

      if (reloadedAssetList != assetlist) {
        assetlist = reloadedAssetList;
        galleryImagesList = [];

        for (AssetPathEntity item in assetlist) {
          if (item.name.toLowerCase().contains('recent')) {
            var assetEntityList = await item.getAssetListPaged(
                0, item.assetCount);
            for (AssetEntity entity in assetEntityList) {
              var file = await entity.file; // image file

              if (file != null && entity.type == AssetType.image) {
                galleryImagesList.add(file as File);
              }
            }
          }
        }
        if (galleryImagesList.length > 0) {
          selectedIndex = 0;
        }

        setState(() {

        });
      }
    } else {
      // fail
      /// if result is fail, you can call `PhotoManager.openSetting();`  to open android/ios applicaton's setting to get permission
    }
  }

  @override
  Widget build(BuildContext context) {
    _gridScrollController.addListener(_gridListener);
    _singleChildController.addListener(_gridListener);
    Size _screen = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: _screen.height,
        width: _screen.width,
        color: Theme.of(context).primaryColorDark,
        child: SingleChildScrollView(
          controller: _singleChildController,
          child: Column(
            children: <Widget>[
              AppTopBar(screenName: 'gallery', height: 45,
                onNextButtonPressed: () {
                  selectedImageIndex = selectedIndex;
                  if(widget.onGalleryImagePicked != null && selectedIndex != -1 && galleryImagesList.length > 0) {
                    widget.onGalleryImagePicked(galleryImagesList[selectedIndex]);
                  }
                },),
              Container(
                height: 410,
                color: Theme.of(context).primaryColorLight,
                child: Stack(
                  children: <Widget>[
                    selectedIndex >= 0 ? Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: Image.file((galleryImagesList[selectedIndex]),
                        fit: isExpanded ? BoxFit.cover : BoxFit.contain,),
                    ): Container(),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            _circularStackButton(icon: Icons.expand, onTap: () {
                              setState(() {
                                isExpanded = !isExpanded;
                              });
                            }),
                            // Container(
                            //   width: _screen.width / 1.6,
                            //   child: Row(
                            //     mainAxisAlignment:
                            //     MainAxisAlignment.spaceEvenly,
                            //     children: <Widget>[
                            //       _circularStackButton(icon: Entypo.infinity),
                            //       _circularStackButton(icon: Feather.layout),
                            //       _circularStackButton(
                            //           icon: MaterialCommunityIcons
                            //               .checkbox_multiple_blank_outline,
                            //           text: 'SELECT MULTIPLE'),
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 5,),
              Container(
                //height: _screen.height - 90,
                child: galleryImagesList.length == 0 ? Container(
                    padding: EdgeInsets.only(top: 50),
                    child: CircularProgressIndicator(color: Theme.of(context).primaryColorLight,)) :
                GridView.count(
                    padding: EdgeInsets.only(bottom: 40),
                    controller: _gridScrollController,
                    shrinkWrap: true,
                    crossAxisCount: 4,
                    children: List<Widget>.generate(
                      galleryImagesList.length,
                          (index) => InkWell(
                        child: Container(
                          height: 200,
                          width: 200,
                          child: Image.file(
                            galleryImagesList[index],
                            fit: BoxFit.cover,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                      ),
                    )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _circularStackButton({
    required IconData icon,
    String? text,
    required Function() onTap
  }) {
    return InkWell(
        onTap: ()  {
          if (onTap != null) {
            onTap();
          }
        },
        child:
        text == null ?
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          height: 36,
          width: 36,
          decoration: BoxDecoration(
            color: Color.fromRGBO(81, 84, 86, 0.8),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Center(
            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),
        ):
        Container(
          margin: EdgeInsets.only(left: 5),
          padding: EdgeInsets.symmetric(horizontal: 10),
          height: 36,
          decoration: BoxDecoration(
            color: Color.fromRGBO(81, 84, 86, 0.8),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(icon, color: Colors.white),
                SizedBox(width: 10),
                Text(
                  text,
                  style: TextStyle(color: Colors.white, fontSize: 12),
                )
              ],
            ),
          ),
        )
    );
  }

  Future<void> _showMyDialog(BuildContext context,String  permissionText) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Permission needed"),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(permissionText),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                print('Confirmed');
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Open Settings'),
              onPressed: () async {
                await openAppSettings();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}
