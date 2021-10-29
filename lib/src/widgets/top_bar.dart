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
         },
      )
      ],);
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
