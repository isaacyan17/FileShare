import 'package:flutter/material.dart';

class MessageTipView extends StatelessWidget {
  late final String text;

  MessageTipView({required this.text});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
