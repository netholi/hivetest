import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  //need to ensure binding bcoz we are running code before the runApp method
  WidgetsFlutterBinding.ensureInitialized();
  //get the document directory
  Directory? docDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(docDir.path); //initialise hive

//first we need to open the box o store the data. here the type is String and box is named place
  await Hive.openBox<String>('place');
  print('Dir : ------------ ${docDir.path}');
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  //MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Box<String> placeBox;

  void initState() {
    super.initState();
    //refence the box we created earlier
    placeBox = Hive.box('place');
    // placeBox.put('name', 'Kerala');
    // placeBox.put('name', 'Tamil nadu');

    print(placeBox.get('name'));
  }

  @override
  Widget build(BuildContext context) {
    print('Hive test 1 ');
    return Container();
  }
}
