import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'dialog_loading.dart';
import 'drop_header_popup.dart';
import 'image_picker.dart';
import 'image_picker_app_bar.dart';
import 'picker_data.dart';
import 'picker_data_image.dart';
import 'utils_picker.dart';

class MulImagePicker extends StatefulWidget {
  const MulImagePicker({
    Key key,
    this.limit = 9,
    this.selectedData,
    this.type = ImagePickerType.imageAndVideo,
    this.back,
    this.menu,
    this.decoration,
    this.appBarColor = Colors.blue,
    this.language,
    this.placeholder,
    this.emptyView,
  }) : super(key: key);
  final int limit;
  final List<PickerData> selectedData;
  final ImagePickerType type;
  final Widget back, menu;
  final Decoration decoration;
  final Color appBarColor;
  final Language language;
  final ImageProvider placeholder;
  final Widget emptyView;

  @override
  State<StatefulWidget> createState() {
    return MulImagePickerPageState();
  }
}

class MulImagePickerPageState extends State<MulImagePicker> {
  final List<PickerData> selectedData = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<PickerData> data = [];
  bool isFirst = true;

  @override
  void dispose() {
    UtilsPicker.cancelAll();
    super.dispose();
  }

  @override
  void initState() {
    if (widget.selectedData != null) {
      selectedData.addAll(widget.selectedData);
    }
    // Utils.log("initState");
    super.initState();
  }

  void getData(String folder) {
    UtilsPicker.getImages(folder)
      ..then((files) {
        data.clear();
        data.addAll(files);
        isFirst = false;
      })
      ..whenComplete(() {
        if (mounted) {
          setState(() {});
          // Utils.log("whenComplete");
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: ImagePickerAppBar(
        context: context,
        center: DropHeaderPicker(
          type: widget.type,
          onSelect: (item) {
            getData(item);
          },
        ),
        language: widget.language,
        back: widget.back ??
            const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
        onBackCallback: () {
          Navigator.of(context).pop();
        },
        menu: widget.menu ??
            const Icon(
              UtilsPicker.save,
              color: Colors.white,
            ),
        onSaveCallback: () {
          LoadingPickerDialog.showLoadingDialog(context);
          UtilsPicker.convertMulData(selectedData).whenComplete(() {
            Navigator.of(context)..pop()..pop(selectedData);
          });
        },
        decoration: widget.decoration,
        appBarColor: widget.appBarColor,
      ),
      body: body(),
    );
  }

  Widget body() {
    if (isFirst) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (data.isEmpty) {
      return Center(child: widget.emptyView ?? Text(widget.language.empty));
    } else {
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemBuilder: (context, index) => _createItem(data[index]),
        itemCount: data.length,
        padding: EdgeInsets.fromLTRB(
          8,
          8,
          8,
          8 + MediaQuery.of(context).padding.bottom,
        ),
      );
    }
  }

  Widget _createItem(PickerData data) {
    return Stack(
      alignment: AlignmentDirectional.bottomEnd,
      children: <Widget>[
        FadeInImage(
          placeholder: widget.placeholder ?? UtilsPicker.placeholder,
          image: PickerDataImage(
            data,
            targetWidth: UtilsPicker.width2px(context, ratio: 3),
            targetHeight: UtilsPicker.width2px(context, ratio: 3),
          ),
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        RawMaterialButton(
          fillColor:
              selectedData.contains(data) ? Colors.white54 : Colors.transparent,
          constraints: const BoxConstraints.expand(),
          highlightElevation: 0,
          elevation: 0,
          disabledElevation: 0,
          onPressed: () {
            if (selectedData.contains(data)) {
              setState(() {
                selectedData.removeWhere((a) {
                  return a == data;
                });
              });
            } else {
              if (selectedData.length < widget.limit) {
                setState(() {
                  selectedData
                    ..removeWhere((a) {
                      return a == data;
                    })
                    ..add(data);
                });
              } else {
                _scaffoldKey.currentState.showSnackBar(
                  SnackBar(
                    content: Text(
                      widget.language.showToast.replaceAll(
                        "###",
                        "${widget.limit}",
                      ),
                    ),
                  ),
                );
              }
            }
          },
          child: Text(
            showNumberText(data),
            style: TextStyle(
              fontSize: 48,
              color: widget.appBarColor ?? Colors.black,
            ),
          ),
        ),
        iconVideo(data),
      ],
    );
  }

  Widget iconVideo(PickerData data) {
    if (data.isImage) {
      return Container(
        width: 0,
        height: 0,
      );
    }
    return Icon(
      UtilsPicker.video,
      color: widget.appBarColor ?? Colors.blue,
    );
  }

  String showNumberText(PickerData data) {
    final int num = selectedData.indexOf(data) + 1;
    if (num == 0) {
      return "";
    } else {
      return "$num";
    }
  }
}
