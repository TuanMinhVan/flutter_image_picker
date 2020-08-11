import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'imagePicker/bun_picker.dart';

void main() async {
  const SystemUiOverlayStyle dark = SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
    statusBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  );
  SystemChrome.setSystemUIOverlayStyle(dark);
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: UtilsPicker.getFolders(ImagePickerType.onlyImage),
        builder: (context, snapshot) {
          return Text('dsadsa');
        },
      ),
    );
  }
}
