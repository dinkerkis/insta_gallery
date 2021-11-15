import 'package:cropper_and_trimmer/cropper_and_trimmer.dart';
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
  bool _isCamera = true;
  bool _isVideo = false;

  TextStyle _selectedStyle = const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18);
  TextStyle _unSelectedStyle = const TextStyle(fontWeight: FontWeight.normal, color: Colors.white, fontSize: 18);

  @override
  Widget build(BuildContext context) {
    _selectedStyle = TextStyle(fontWeight: FontWeight.bold, color: secondaryColor, fontSize: 20);
    _unSelectedStyle = TextStyle(fontWeight: FontWeight.normal, color: secondaryColor, fontSize: 18);

    return  Container(
        color: primaryColor,
        child: SafeArea(child: Container(
          height: widget.height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
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
    if (buttonName == 'camera') {
      _isCamera = true;
      _isVideo = false;
    } else {
      _isCamera = false;
      _isVideo = true;
    }
  }
}
