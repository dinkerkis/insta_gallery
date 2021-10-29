import 'package:flutter/material.dart';
import 'package:flutter_statusbar_manager/flutter_statusbar_manager.dart';

typedef NextButtonPressed = void Function();

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final String screenName;
  final NextButtonPressed onNextButtonPressed;

  const AppTopBar({
    Key? key,
    required this.height,
    required this.screenName,
    required this.onNextButtonPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColorDark,
      leadingWidth: 100,
      leading: FlatButton(
        child: Text(
          'Cancel',
          style: TextStyle(
            color: Theme.of(context).primaryColorLight,
            fontSize: 18,
          ),
        ),
        onPressed: () {
          Navigator.pop(context);
          FlutterStatusbarManager.setHidden(false);
        },
      ),
      actions: [FlatButton(
        child: Text(
          'Next',
          style: TextStyle(
            color: Theme.of(context).primaryColorLight,
            fontSize: 18,
          ),
        ),
        onPressed: () {
          if (onNextButtonPressed != null) {
            onNextButtonPressed();
          }
          // Navigator.pop(context);
          // FlutterStatusbarManager.setHidden(false);
        },
      )
      ],);
    Container(
      height: height,
      color: Theme.of(context).primaryColorDark,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FlatButton(
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              FlutterStatusbarManager.setHidden(false);
            },
          ),
          // FlatButton(
          //   child: screenName == 'gallery'
          //       ? Row(
          //     children: [
          //       Text(
          //         'Recent',
          //         style: TextStyle(
          //           color: Colors.white,
          //           fontSize: 18,
          //           fontWeight: FontWeight.bold,
          //         ),
          //       ),
          //       Icon(
          //         Ionicons.ios_arrow_down,
          //         color: Colors.white,
          //       )
          //     ],
          //   )
          //       : Text(
          //     screenName == 'camera' ? 'Photo' : 'Video',
          //     style: TextStyle(fontSize: 18, color: Colors.white),
          //   ),
          //   onPressed: () {},
          // ),
          screenName == 'gallery'
              ? FlatButton(
            child: Text(
              '   Next',
              style: TextStyle(
                color: Theme.of(context).primaryColorLight,
                fontSize: 18,
              ),
            ),
            onPressed: () {
              if (onNextButtonPressed != null) {
                onNextButtonPressed();
              }
              Navigator.pop(context);
              FlutterStatusbarManager.setHidden(false);
            },
          )
              : FlatButton(
            child: Container(),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
