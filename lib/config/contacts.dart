import 'package:flutter/material.dart';

class AppColors {
  static const TitleColor = 0xff181818;
  static const DesTextColor = 0xff999999;
  static const NotifyDotText = 0xffffffff;
  static const DeviceInfoItemText = 0xff606062;
  static const ContactGroupTitleText = 0xff888888;
  static const HeaderCardTitleText = 0xff353535;
  static const HeaderCardDesText = 0xff7f7f7f;
  static const ButtonDesText = 0xff8c8c8c;
  static const ChatBoxBg = 0xfff7f7f7;
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
      color: Color(AppColors.TitleColor));

}

class Constants {
  static const DividerWidth = 0.2;
  static const TitleTextSize = 16.0;
  static const ContentTextSize = 20.0;
  static const DesTextSize = 13.0;
}
