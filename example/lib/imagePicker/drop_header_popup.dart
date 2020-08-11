import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'image_picker.dart';
import 'utils_picker.dart';

typedef OnSelected<T> = void Function(T value);

class DropHeaderPicker extends StatefulWidget {
  const DropHeaderPicker({Key key, this.type, this.title, this.onSelect})
      : super(key: key);
  final ImagePickerType type;
  final Widget title;
  final OnSelected<String> onSelect;


  @override
  State<StatefulWidget> createState() {
    return DropHeaderState();
  }
}

class DropHeaderState extends State<DropHeaderPicker> {
  final List<String> _folders = [];
  String _folder = "";

  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((d) => UtilsPicker.getFolders(widget.type)
          ..then((folders) {
            setState(() {
              _folders.clear();
              _folders.addAll(folders);
              _folder = _folders[0];
              widget.onSelect(_folder);
            });
          }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:const EdgeInsets.symmetric(horizontal: 48),
      child: _folders.isEmpty
          ?const SizedBox.shrink()
          : SizedBox.expand(
              child: FlatButton(
                onPressed: () {
                  _showDropPopup(_folders, _folder).then((folder) {
                    if (folder != null) {
                      _folder = folder;
                      widget.onSelect(_folder);
                    }
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      _folder.split("/").last,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style:const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    Icon(Icons.arrow_drop_down,color: Colors.white,size: 24)
                  ],
                ),
              ),
            ),
    );
  }

  Future<String> _showDropPopup(List<String> data, String select) async {
    return showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierColor:const Color(0x01000000),
        barrierLabel: "",
        transitionDuration:const Duration(milliseconds: 150),
        transitionBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation, Widget child) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            ),
            child: child,
          );
        },
        pageBuilder: (context, firstAnim, secondAnim) {
          const double left = 48;
          const right = 48.0;
        final  double top = MediaQuery.of(context).padding.top + 48;
          double height = 48.0 * data.length;
          double bottom = MediaQuery.of(context).padding.bottom;
         final double maxHeight = MediaQuery.of(context).size.height - top - bottom;
          height = height > maxHeight ? maxHeight : height;
          bottom = bottom + maxHeight - height;
          return Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            margin: EdgeInsets.only(
              left: left,
              right: right,
              top: top,
              bottom: bottom,
            ),
            child: ListView.builder(
              physics:const ClampingScrollPhysics(),
              padding:const EdgeInsets.only(),
              itemBuilder: (context, index) {
                return RawMaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop(data[index]);
                  },
                  child: Text(
                    data[index].split("/").last,
                    style:const TextStyle(color: Colors.black, fontSize: 16),
                  ),
                );
              },
              itemCount: data.length,
            ),
          );
        });
  }
}
