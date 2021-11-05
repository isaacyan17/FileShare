import 'package:file_share/home/home.dart';
import 'package:flutter/material.dart';

class Share extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'File Share',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Open Sans',
        primaryColor: Colors.black,
        cardColor: Colors.black,
        canvasColor: Colors.black,
        disabledColor: Colors.grey,
        buttonTheme: Theme.of(context).buttonTheme.copyWith(colorScheme: ColorScheme.dark()),
        appBarTheme: AppBarTheme(
          elevation: 0.0,
        )
      ),
      home: Home(),
    );
  }

}