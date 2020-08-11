import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'bun_picker.dart';
import 'mul_image_picker_page.dart';
import 'picker_data.dart';
import 'utils_picker.dart';

typedef MulCallback = void Function(List<PickerData>);

typedef SingleCallback = void Function(PickerData);

typedef Callback = void Function(PickerData);

class NbizPickerImage {
  NbizPickerImage._();

  static void debug(bool isDebug) {
    UtilsPicker.isDebug = isDebug;
  }

  static void singlePicker(
    BuildContext context, {
    ImagePickerType type = ImagePickerType.imageAndVideo,
    Language language,
    ImageProvider placeholder,
    Widget back,
    Decoration decoration,
    Color appBarColor = Colors.black,
    Widget emptyView,
    SingleCallback singleCallback,
  }) {
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) => SingleImagePickerPage(
          type: type,
          language: language ?? Language(),
          placeholder: placeholder,
          decoration: decoration,
          appBarColor: appBarColor ?? Colors.blue,
          back: back,
          emptyView: emptyView,
        ),
      ),
    )
        .then((data) {
      if (data != null && singleCallback != null) {
        singleCallback(data);
      }
    });
  }

  static void mulPicker(
    BuildContext context, {
    List<PickerData> data,
    ImagePickerType type = ImagePickerType.imageAndVideo,
    int limit = 9,
    Language language,
    ImageProvider placeholder,
    Widget back,
    Widget menu,
    Decoration decoration,
    Color appBarColor = Colors.black,
    Widget emptyView,
    MulCallback mulCallback,
  }) {
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) => MulImagePicker(
          selectedData: data,
          type: type,
          limit: limit,
          appBarColor: appBarColor ?? Colors.blue,
          language: language ?? Language(),
          placeholder: placeholder,
          decoration: decoration,
          menu: menu,
          back: back,
          emptyView: emptyView,
        ),
      ),
    )
        .then((data) {
      if (data != null && mulCallback != null) {
        mulCallback(data);
      }
    });
  }

  static void takePicture(Callback callback) {
    UtilsPicker.takePicture().then((a) {
      callback(a);
    });
  }

  static void takeVideo(Callback callback) {
    UtilsPicker.takeVideo().then((a) {
      callback(a);
    });
  }
}

enum ImagePickerType {
  onlyImage,
  onlyVideo,
  imageAndVideo,
}

///文字基类
class Language {
  String get showToast => "Only ### images can be selected";

  String get empty => "Empty";
}
