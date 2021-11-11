import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

/// 消息为text 格式的widget
class MessageTextView extends StatelessWidget {
  final String? text;
  final bool? sendByServer;
  final log = Logger();

  MessageTextView({this.text, this.sendByServer: false});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment:
          sendByServer! ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: sendByServer!?Colors.lightBlue:Colors.cyan[50],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 200),
                  child: Theme(
                    data: ThemeData(
                      textSelectionTheme: TextSelectionThemeData(
                        cursorColor: Colors.red,
                        selectionColor: Color(0xffd3c1fe),
                      ),
                    ),
                    child: SelectableText(
                      text!,
                      style: TextStyle(
                        fontSize: 14,
                        letterSpacing: 1,
                        color: sendByServer!?Colors.white:Colors.black,
                      ),
                    ),
                  )),
            ],
          ),
        ),
        if (!sendByServer!)
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                log.d('复制到粘贴板');
              },
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.copy,
                  size: 18,
                ),
              ),
            ),
          )
      ],
    );
  }
}
