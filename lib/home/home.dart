import 'package:file_share/router/app_routes.dart';
import 'package:file_share/server/server_view.dart';
import 'package:file_share/universal/dev_scaffold.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:get/get.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return DevScaffold(
      title: 'Home',
      body: Container(
        child: Column(
          children: [
            Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.4,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              color: Colors.grey[100],
              padding: const EdgeInsets.all(20.0),
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 40.0,
              runSpacing: 20.0,
              children: [
                ActionCard(
                  icon:Icons.send,
                  color: Colors.red,
                  title: '建立连接',
                  onPressed: (){
                    Get.toNamed(AppRoutes.Room);
                  },
                ),
                ActionCard(
                  icon:Icons.title,
                  color: Colors.amber,
                  title: 'TODO',
                  onPressed: (){
                    print('pressed');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 创建按钮Widget
class ActionCard extends StatelessWidget {
  final void Function()? onPressed;
  final String? title;
  final IconData? icon;
  final Color? color;

  ActionCard({Key? key, this.onPressed, this.title, this.icon, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onPressed,
      child: Ink(
        height: MediaQuery
            .of(context)
            .size
            .height * 0.1,
        width: MediaQuery
            .of(context)
            .size
            .width * 0.2,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[200]!,
              blurRadius: 10,
              spreadRadius: 5,
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color),
            SizedBox(
              height: 10,
            ),
            Text(title!,
                style: TextStyle(
                  fontSize: 12,
                ))
          ],
        ),
      ),
    );
  }
}
