import 'package:file_share/server/server.dart';
import 'package:file_share/universal/dev_scaffold.dart';
import 'package:flutter/material.dart';
import 'dart:io';

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
              height: 250,
              color: Colors.grey,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey,
                  child: ElevatedButton(
                    child: Text(
                      "Press",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                    onPressed: (){
                     print('pressed');
                     Server().init();
                    },
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  "Locate Us",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white
                  ),

                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
