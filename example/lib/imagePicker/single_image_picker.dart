import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'bun_picker.dart';

class SingleImagePickerPage extends StatefulWidget {
  const SingleImagePickerPage({
    Key key,
    this.type = ImagePickerType.imageAndVideo,
    this.back,
    this.decoration,
    this.language,
    this.placeholder,
    this.appBarColor = Colors.blue,
    this.emptyView,
  }) : super(key: key);
  final ImagePickerType type;
  final Widget back;
  final Decoration decoration;
  final Language language;
  final ImageProvider placeholder;
  final Color appBarColor;
  final Widget emptyView;

  @override
  State<StatefulWidget> createState() {
    return SingleImagePickerPageState();
  }
}

class SingleImagePickerPageState extends State<SingleImagePickerPage> {
  final List<PickerData> data = [];
  bool isFirst = true;

  @override
  void dispose() {
    UtilsPicker.cancelAll();
    super.dispose();
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
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          constraints: const BoxConstraints.expand(),
          onPressed: () {
            UtilsPicker.convertSingleData(data).whenComplete(() {
              LoadingPickerDialog.showLoadingDialog(context);
              Navigator.of(context)..pop()..pop(data);
            });
          },
          shape: const CircleBorder(),
        ),
        iconVideo(data),
      ],
    );
  }

  Widget iconVideo(PickerData data) {
    if (data.isImage) {
      return const SizedBox.shrink();
    }
    return Icon(
      UtilsPicker.video,
      color: widget.appBarColor ?? Colors.blue,
    );
  }
}
