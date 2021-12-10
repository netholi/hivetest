import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  //need to ensure binding bcoz we are running code before the runApp method
  WidgetsFlutterBinding.ensureInitialized();
  //get the document directory
  Directory docDir = await getApplicationDocumentsDirectory();
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

  final TextEditingController _nameController = TextEditingController();
  void initState() {
    super.initState();
    //refence the box we created earlier
    placeBox = Hive.box('place');
    // placeBox.put('01', 'Kerala');
    // placeBox.put('02', 'Tamil nadu');

    print(placeBox.get('01'));
  }

  @override
  Widget build(BuildContext context) {
    print('Hive test 1 ');
    int selectdIndex = 0;
    return Scaffold(
      appBar: AppBar(
        title: Text('Hive demo'),
      ),
      body: Column(
        children: [
          Expanded(
              // placeBox.length == 0
              // ? Text('No Data : ${placeBox.length}')
              //  :
              child: ValueListenableBuilder(
                  valueListenable: placeBox.listenable(),
                  builder: (context, Box<String> place, _) {
                    return ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            onTap: () => selectdIndex = index,
                            title: Text(placeBox.getAt(index)!),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                setState(() {
                                  placeBox.deleteAt(index);
                                });
                              },
                            ),
                          );
                        },
                        itemCount: place.length // placeBox.length,
                        );
                  })),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _nameController.text = '';
                    showDialog(
                        context: context,
                        builder: (_) {
                          return Dialog(
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(36)),
                              padding: EdgeInsets.all(32),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    decoration:
                                        InputDecoration(hintText: 'State Name'),
                                    controller: _nameController,
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        final state = _nameController.text;
                                        print(placeBox.length);
                                        placeBox.add(state);

                                        Navigator.pop(context);
                                      },
                                      child: Text('Submit'))
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  child: Text('Add state'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _nameController.text = placeBox.getAt(selectdIndex)!;
                    showDialog(
                        context: context,
                        builder: (_) {
                          return Dialog(
                            child: Container(
                              padding: EdgeInsets.all(32),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: _nameController,
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        final state = _nameController.text;
                                        placeBox.put(selectdIndex, state);
                                        Navigator.pop(context);
                                      },
                                      child: Text('Submit'))
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  child: Text('Update state'),
                ),
                // ElevatedButton(
                //   onPressed: () {},
                //   child: Text('Delete state'),
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
