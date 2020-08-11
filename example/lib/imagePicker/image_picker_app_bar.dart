import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'image_picker.dart';

typedef OnBackCallback = Function();
typedef OnSaveCallback = Function();

class ImagePickerAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ImagePickerAppBar({
    Key key,
    @required this.context,
    @required this.center,
    this.back,
    this.menu,
    this.onBackCallback,
    this.onSaveCallback,
    this.decoration,
    this.language,
    this.appBarColor,
  }) : super(key: key);
  final BuildContext context;
  final Widget center, back, menu;
  final OnBackCallback onBackCallback;
  final OnSaveCallback onSaveCallback;
  final Decoration decoration;
  final Color appBarColor;
  final Language language;


  @override
  Size get preferredSize => Size.fromHeight(
        48 + MediaQuery.of(context).padding.top,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48 + MediaQuery.of(context).padding.top,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      decoration: decoration ?? BoxDecoration(color: appBarColor),
      child: Stack(
        children: <Widget>[
          center,
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: RawMaterialButton(
              onPressed: onBackCallback,
              child: back,
              highlightElevation: 0,
              elevation: 0,
              disabledElevation: 0,
              constraints:const BoxConstraints(
                minWidth: 48,
                minHeight: 48,
                maxHeight: 48,
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            bottom: 0,
            child: RawMaterialButton(
              onPressed: onSaveCallback,
              child: menu,
              highlightElevation: 0,
              elevation: 0,
              disabledElevation: 0,
              constraints:const BoxConstraints(
                minWidth: 48,
                minHeight: 48,
                maxHeight: 48,
              ),
            ),
          )
        ],
      ),
    );
  }
}
