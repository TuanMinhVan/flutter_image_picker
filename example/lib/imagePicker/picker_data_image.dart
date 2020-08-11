import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui show Codec;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'picker_data.dart';
import 'utils_picker.dart';

class PickerDataImage extends ImageProvider<PickerDataImage> {
  const PickerDataImage(
    this.data, {
    this.targetWidth,
    this.targetHeight,
    this.scale = 1.0,
  })  : assert(data != null),
        assert(scale != null);

  final PickerData data;
  final int targetWidth, targetHeight;
  final double scale;

  @override
  Future<PickerDataImage> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<PickerDataImage>(this);
  }

  @override
  ImageStreamCompleter load(PickerDataImage key, DecoderCallback decode) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode),
      scale: key.scale,
      informationCollector: () sync* {
        yield DiagnosticsProperty<ImageProvider>('Image provider', this);
        yield DiagnosticsProperty<PickerDataImage>('Image key', key);
      },
    );
  }

  Future<ui.Codec> _loadAsync(
      PickerDataImage key, DecoderCallback decode) async {
    assert(key == this);
    await UtilsPicker.updateAndGetPath(data);
    Uint8List bytes;
    final File file = File(data.path);
    final exists = file.existsSync();
    if (!exists) {
      return null;
    }
    if (!UtilsPicker.isSupportImageFormatString(await file.openRead(0, 3).first)) {
      bytes = await UtilsPicker.channel.invokeMethod(
        'toUInt8List',
        [
          data.id,
          data.isImage,
          targetWidth,
          targetHeight,
        ],
      );
      return await decode(bytes);
    }
    bytes = await file.readAsBytes();
    if (bytes == null || bytes.lengthInBytes == 0) {
      return null;
    }
    if (targetWidth == null && targetHeight == null) {
      return await decode(bytes);
    } else if (targetWidth <= 0 && targetHeight == null) {
      return await decode(bytes);
    } else if (targetWidth > 0 && targetHeight == null) {
      return await decode(
        bytes,
        cacheWidth: targetWidth > data.width ? targetWidth : -1,
      );
    } else if (targetWidth == null && targetHeight <= 0) {
      return await decode(bytes);
    } else if (targetWidth == null && targetHeight > 0) {
      return await decode(
        bytes,
        cacheHeight: targetHeight > data.height ? targetHeight : -1,
      );
    } else {
      int w = data.width;
      int h = data.height;
      final double wd = w / targetWidth.toDouble();
      final double hd = h / targetHeight.toDouble();
      final double be = max(1, max(wd, hd));
      w = w ~/ be;
      h = h ~/ be;
      return await decode(
        bytes,
        cacheWidth: w,
        cacheHeight: h,
      );
    }
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    final PickerDataImage typedOther = other;
    return data == typedOther.data &&
        scale == typedOther.scale &&
        targetWidth == typedOther.targetWidth &&
        targetHeight == typedOther.targetHeight;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => hashValues(data, targetWidth, targetHeight, scale);
}
