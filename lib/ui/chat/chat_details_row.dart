import 'package:flutter/material.dart';
import 'package:im_voice_demo/config/contacts.dart';
import 'package:im_voice_demo/ui/item/chat_voice.dart';


typedef TimeShowFunc = void Function(String path);


class ChatDetailsRow extends StatefulWidget {

  final GestureTapCallback? voiceOnTap;
  final TimeShowFunc timeShowFunc;

  const ChatDetailsRow({
    this.voiceOnTap,
    required this.timeShowFunc
  });

  @override
  ChatDetailsRowState createState() => ChatDetailsRowState();

}

class ChatDetailsRowState extends State<ChatDetailsRow> {
  String? path;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: const BoxDecoration(
          color: Color(AppColors.ChatBoxBg),//Color(AppColors.ChatBoxBg),
          border: Border(
            top: BorderSide(color: Colors.white70, width: Constants.DividerWidth),
            bottom: BorderSide(color: Colors.white70, width: Constants.DividerWidth),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            InkWell(
              child: Image.asset('assets/images/chat/ic_voice.webp',
                  width: 25, color: Colors.blueAccent),
              onTap: () {
                if (widget.voiceOnTap != null) {
                  widget.voiceOnTap!();
                }
              },
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(
                    top: 7.0, bottom: 7.0, left: 8.0, right: 8.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0)),
                child: ChatVoice(voiceFile: (path) {
                    setState(() => this.path = path);
                  },
                  timeShowFunc: widget.timeShowFunc,
                ),
              ),
            ),
            InkWell(
              child: Image.asset('assets/images/chat/ic_Emotion.webp',
                  width: 30, fit: BoxFit.cover),
              onTap: () {



              },
            ),
            // widget.more,
          ],
        ),
      ),
      onTap: () {},
    );
  }

}
