import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


class ComMomBar extends StatelessWidget implements PreferredSizeWidget {

  ComMomBar(
      {this.title = '',
      this.showShadow = false,
      this.rightDMActions,
      this.backgroundColor = Colors.amber,
      this.mainColor = Colors.black,
      this.titleW,
      this.bottom,
      this.leadingImg = '',
      this.leadingW});

  final String title;
  final bool showShadow;
  final List<Widget>? rightDMActions;
  final Color backgroundColor;
  final Color mainColor;
  final Widget? titleW;
  final Widget? leadingW;
  final PreferredSizeWidget? bottom;
  final String leadingImg;

  @override
  Size get preferredSize => const Size(100, 50);

  Widget leading(BuildContext context) {
    final bool isShow = Navigator.canPop(context);
    if (isShow) {
      return InkWell(
        child: SizedBox(
          width: 15,
          height: 28,
          child: leadingImg != ''
              ? Image.asset(leadingImg)
              : Icon(CupertinoIcons.back, color: mainColor),
        ),
        onTap: () {
          if (Navigator.canPop(context)) {
            FocusScope.of(context).requestFocus(FocusNode());
            Navigator.pop(context);
          }
        },
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return showShadow
        ? Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        color: Colors.grey, width: showShadow ? 0.5 : 0.0))),
            child: AppBar(
              title: titleW ?? Text(
                      title,
                      style: TextStyle(
                          color: mainColor,
                          fontSize: 17.0,
                          fontWeight: FontWeight.w600),
                    ),
              backgroundColor: mainColor,
              elevation: 0.0,
              brightness: Brightness.light,
              leading: leadingW ?? leading(context),
              centerTitle: true,
              actions: rightDMActions ?? [new Center()],
              bottom: bottom,
            ),
          )
        : AppBar(
            title: titleW ?? Text(
                    title,
                    style: TextStyle(
                        color: mainColor,
                        fontSize: 17.0,
                        fontWeight: FontWeight.w600),
                  ),
            backgroundColor: backgroundColor,
            elevation: 0.0,
            brightness: Brightness.light,
            leading: leadingW ?? leading(context),
            centerTitle: false,
            bottom: bottom ?? null,
            actions: rightDMActions ?? [Center()],
          );
  }
}
