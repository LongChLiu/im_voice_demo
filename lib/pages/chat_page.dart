import 'package:im_voice_demo/config/contacts.dart';
import 'package:im_voice_demo/tools/data/database.dart';
import 'package:im_voice_demo/tools/voicePlayer/voice_player.dart';
import 'package:im_voice_demo/ui/bar/commom_bar.dart';
import 'package:im_voice_demo/ui/chat/chat_details_row.dart';
import 'package:flutter/material.dart';
import 'package:im_voice_demo/ui/view/main_input.dart';


class ChatPage extends StatefulWidget {
  final String? title;

  ChatPage({this.title});

  @override
  _ChatPageState createState() => _ChatPageState();
}


class _ChatPageState extends State<ChatPage> {

  double keyboardHeight = 270.0;
  String? newGroupName;

  final ScrollController _sC = ScrollController();
  PageController pageC = PageController();

  @override
  void initState() {
    super.initState();
    DB().database;
  }

  @override
  Widget build(BuildContext context) {
    if (keyboardHeight == 270.0 && MediaQuery.of(context).viewInsets.bottom != 0) {
      keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    }

    var body = [
      GestureDetector(
        child:
          Stack(children: [

            Container(
              width: 200,
              height: 680,
              color: Colors.black,
            ),

            Positioned(child:
              Container(
                child: const Align(
                  child: Text("点击播放",textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.deepPurple,fontSize: 25),),
                  alignment: Alignment.center,
                ),
                color: Colors.lime,
              ),
              left: 0,right: 0,top: 0,bottom: 0,
            ),

          ],
         ),

        onTap: (){
          print("播放录音ing ———————————————————————————————————");
          VoicePlayer.playVoice();
        },

      ),
      ChatDetailsRow(
        voiceOnTap: () {

        },
        timeShowFunc: (timeTxt){

          print("MainPage主页聊天内容打印: $timeTxt");

        },
      ),
      Container(width: 200,height: 20,color: Colors.deepPurpleAccent),
    ];

    return Scaffold(
      appBar: ComMomBar(title: widget.title!),
      body: MainInputBody(
        onTap: () => setState(() {

          },
        ),
        decoration: const BoxDecoration(color: Colors.cyanAccent),
        child: Column(children: body),
      ),
    );
  }


  @override
  void dispose() {
    super.dispose();
    _sC.dispose();
  }

}








class AppStyles {

  static const TitleStyle = TextStyle(
    fontSize: Constants.TitleTextSize,
    color: Color(AppColors.TitleColor),
  );

  static const DesStyle = TextStyle(
    fontSize: Constants.DesTextSize,
    color: Color(AppColors.DesTextColor),
  );

  static const UnreadMsgCountDotStyle = TextStyle(
    fontSize: 12.0,
    color: Color(AppColors.NotifyDotText),
  );

  static const DeviceInfoItemTextStyle = TextStyle(
    fontSize: Constants.DesTextSize,
    color: Color(AppColors.DeviceInfoItemText),
  );

  static const GroupTitleItemTextStyle = TextStyle(
    fontSize: 14.0,
    color: Color(AppColors.ContactGroupTitleText),
  );

  static const IndexLetterBoxTextStyle =
  TextStyle(fontSize: 32.0, color: Colors.white);

  static const HeaderCardTitleTextStyle = TextStyle(
      fontSize: 20.0,
      color: Color(AppColors.HeaderCardTitleText),
      fontWeight: FontWeight.bold);

  static const HeaderCardDesTextStyle = TextStyle(
      fontSize: 14.0,
      color: Color(AppColors.HeaderCardDesText),
      fontWeight: FontWeight.normal);

  static const ButtonDesTextStyle = TextStyle(
      fontSize: 12.0,
      color: Color(AppColors.ButtonDesText),
      fontWeight: FontWeight.bold);

  static const NewTagTextStyle = TextStyle(
      fontSize: Constants.DesTextSize,
      color: Colors.white,
      fontWeight: FontWeight.bold);

  static const ChatBoxTextStyle = TextStyle(
      textBaseline: TextBaseline.alphabetic,
      fontSize: Constants.ContentTextSize,
      color: const Color(AppColors.TitleColor));
}
