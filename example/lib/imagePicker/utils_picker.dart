import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'image_picker.dart';
import 'picker_data.dart';

class UtilsPicker {
  UtilsPicker._();

  static const String packageName = "flutter_image_picker";
  static const MethodChannel channel = MethodChannel('image_picker');
  static bool isDebug = !kReleaseMode;

  static Future<List<String>> getFolders(ImagePickerType type) async {
    final List<dynamic> a = await channel.invokeMethod(
      'getFolders',
      getType(type),
    );
    final List<String> folders = a.map((a) {
      final String folder = a;
      return folder;
    }).toList();
    return folders;
  }

  static Future<List<PickerData>> getImages(String folder) async {
    final List<dynamic> a = await channel.invokeMethod(
      'getImages',
      folder,
    );
    final List<PickerData> data = a.map(
      (a) {
        final PickerData b = PickerData.fromJson(a);
        return b;
      },
    ).toList();

    data.sort((a, b) {
      return b.time.compareTo(a.time);
    });
    return data;
  }

  static Future<void> updateAndGetPath(PickerData data) async {
    if (Platform.isIOS && (data.path == null || data.path.isEmpty)) {
      final String path =
          await UtilsPicker.channel.invokeMethod("getPath", data.id);
      data.path = path;
      data.name = path.split("/").last;
      data.mimeType =
          "${data.mimeType}${data.path.split(".").last.toLowerCase()}";
    }
  }

  static Future<void> cancelAll() async {
    await channel.invokeMethod("cancelAll");
  }

  static Future<PickerData> takePicture() async {
    final dynamic a = await channel.invokeMethod("takePicture");
    PickerData b = PickerData.fromJson(a);
    b = await convertSingleData(b);
    return b;
  }

  static Future<PickerData> takeVideo() async {
    final dynamic a = await channel.invokeMethod("takeVideo");
    PickerData b = PickerData.fromJson(a);
    b = await convertSingleData(b);
    return b;
  }

  static Future<List<PickerData>> convertMulData(List<PickerData> data) async {
    for (PickerData a in data) {
      await updateAndGetPath(a);
    }
    return data;
  }

  static Future<PickerData> convertSingleData(PickerData data) async {
    await updateAndGetPath(data);
    return data;
  }

  static const AssetImage placeholder = AssetImage(
    "images/placeholder.webp",
    package: packageName,
  );

  static const IconData back = IconData(
    0xe62a,
    fontFamily: 'iconfont',
    fontPackage: packageName,
  );

  static const IconData save = IconData(
    0xe601,
    fontFamily: 'iconfont',
    fontPackage: packageName,
  );

  static const IconData video = IconData(
    0xe641,
    fontFamily: 'iconfont',
    fontPackage: packageName,
  );

  static int getType(ImagePickerType type) {
    switch (type) {
      case ImagePickerType.onlyImage:
        return 1;
      case ImagePickerType.onlyVideo:
        return 2;
      case ImagePickerType.imageAndVideo:
        return 3;
    }
    return 3;
  }

  static int width2px(BuildContext context, {double ratio = 1}) {
    final m = MediaQuery.of(context);
    final int a = m.size.width * m.devicePixelRatio ~/ ratio;
    return a;
  }

  static bool isSupportImageFormatString(Uint8List bytes) {
    final String format = imageFormatString(bytes);
    return format != "unknow";
  }

  static String imageFormatString(Uint8List bytes) {
    if (bytes == null || bytes.isEmpty) {
      return "unknow";
    }
    final int format = bytes[0];
    if (format == 0xff) {
      return ".jpg";
    } else if (format == 0x89) {
      return ".png";
    } else if (format == 0x47) {
      return ".gif";
    } else if (format == 0x52) {
      return ".webp";
    } else {
      return "unknow";
    }
  }

  static bool isEmpty(String s) {
    return s == null || s.isEmpty;
  }

  // static Future<bool> permissImage() async {
  // return await Permission.storage.status;
  // if (Platform.isAndroid) {
  //   await [Permission.camera, Permission.storage].request();
  // } else if (Platform.isIOS) {
  //   await [Permission.photos].request();
  // }
  // }
}
