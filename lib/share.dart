import 'package:file_share/home/home.dart';
import 'package:file_share/router/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

class Share extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    String route = '/';
    if(GetPlatform.isWeb){
      route = '/room';
    }
    return GetMaterialApp(
      title: 'File Share',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Open Sans',
        primaryColor: Colors.white,
        cardColor: Colors.white,
        canvasColor: Colors.grey[50],
        disabledColor: Colors.grey,
        buttonTheme: Theme.of(context).buttonTheme.copyWith(colorScheme: ColorScheme.dark()),
        appBarTheme: AppBarTheme(
          elevation: 0.0,
        )
      ),
      initialRoute: route,
      getPages: AppPages.page,
      // home: Home(),
    );
  }

}