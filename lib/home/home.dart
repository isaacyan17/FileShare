import 'package:file_share/universal/dev_scaffold.dart';
import 'package:flutter/material.dart';

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
              height: 200,
              color: Colors.grey,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CircleAvatar(
                  radius: 15,
                  backgroundImage: NetworkImage(
                      "https://pbs.twimg.com/media/D22N_huX4AEbb1y.jpg"),
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
                SizedBox(
                  width: 0,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
