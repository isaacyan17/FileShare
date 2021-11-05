import 'package:flutter/material.dart';

class DevScaffold extends StatelessWidget {
  final String title;
  final Widget? body;
  final PreferredSizeWidget? tabBar;

  const DevScaffold({Key? key, this.body, required this.title, this.tabBar})
      : assert(body != null),
        super(key: key);


  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(duration: Duration(milliseconds: 500),
      color: Colors.grey[800],
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          // appBar: AppBar(
          //   title: Text(title),
          //   centerTitle: true,
          //   bottom: tabBar != null ? this.tabBar : null,
          // ),
          body: body,
        ),
      ),

    );
  }

}