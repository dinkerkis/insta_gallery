import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget {
  final double height;
  final ValueChanged<int> onTap;
  const BottomBar({
    Key? key,
    required this.height,
    required this.onTap,
  }) : super(key: key);

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  bool _isGallery = true;
  bool _isCamera = true;
  bool _isVideo = false;

  TextStyle _selectedStyle = const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18);
  TextStyle _unSelectedStyle = const TextStyle(fontWeight: FontWeight.normal, color: Colors.white, fontSize: 18);

  @override
  Widget build(BuildContext context) {
    _selectedStyle = TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColorLight, fontSize: 20);
    _unSelectedStyle = TextStyle(fontWeight: FontWeight.normal, color: Theme.of(context).primaryColorLight, fontSize: 18);

    return  Container(
        color: Theme.of(context).primaryColorDark,
        // height: widget.height,
        child: SafeArea(child: Container(
          height: widget.height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // FlatButton(
              //   child: Text(
              //     'Library',
              //     style: _isGallery ? _selectedStyle : _unSelectedStyle,
              //   ),
              //   onPressed: () {
              //     setState(() {
              //       _setFlagTrue(buttonName: 'gallery');
              //       widget.onTap(0);
              //     });
              //   },
              // ),
              FlatButton(
                child: Text('Photo',
                    style: _isCamera ? _selectedStyle : _unSelectedStyle),
                onPressed: () {
                  setState(() {
                    _setFlagTrue(buttonName: 'camera');
                    widget.onTap(0);
                  });
                },
              ),
              FlatButton(
                child: Text(
                  'Video',
                  style: _isVideo ? _selectedStyle : _unSelectedStyle,
                ),
                onPressed: () {
                  setState(() {
                    _setFlagTrue(buttonName: 'video');
                    widget.onTap(1);
                  });
                },
              ),
            ],
          ),
        )
        )
    );
  }

  void _setFlagTrue({required String buttonName}) {
    if (buttonName == 'gallery') {
      _isGallery = true;
      _isCamera = false;
      _isVideo = false;
    } else if (buttonName == 'camera') {
      _isGallery = false;
      _isCamera = true;
      _isVideo = false;
    } else {
      _isGallery = false;
      _isCamera = false;
      _isVideo = true;
    }
  }
}
