import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'package:mms_app/screens/widgets/text_widgets.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble(
      {Key key, this.text, this.isSender, this.isRead, this.timeSent})
      : super(key: key);
  final bool isSender;
  final String timeSent;
  final String text;
  final bool isRead;

  @override
  Widget build(BuildContext context) {
    bool stateTick = false;
    String stateIcon;
    if (isRead == null) {
      stateTick = true;
      stateIcon = 'Waiting';
    } else if (!isRead) {
      stateTick = true;
      stateIcon = 'Unread';
    } else {
      stateTick = true;
      stateIcon = 'Read';
    }

    return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              if (isSender) const Expanded(child: SizedBox(width: 5)),
              Container(
                color: Colors.transparent,
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * .8,
                  minWidth: MediaQuery.of(context).size.width * .3,
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.h, vertical: 8.h),
                  child: Container(
                    decoration: BoxDecoration(
                      color: !isSender ? Color(0xff767F9E) : Color(0xffF2F2F2),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.h),
                        topRight: Radius.circular(15.h),
                        bottomLeft: Radius.circular(isSender ? 15.h : 0),
                        bottomRight: Radius.circular(isSender ? 0 : 15.h),
                      ),
                    ),
                    child: Padding(
                        padding: EdgeInsets.all(8.h),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            regularText(text,
                                fontSize: 15.w,
                                color: !isSender
                                    ? AppColors.white
                                    : AppColors.black),
                            SizedBox(height: 5.h),
                            Row(
                                mainAxisAlignment: isSender
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                                children: <Widget>[
                                  regularText(timeSent,
                                      fontSize: 11.w,
                                      color: !isSender
                                          ? AppColors.white
                                          : AppColors.textGrey,
                                      fontWeight: FontWeight.w500),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 4.h),
                                    child: regularText('●',
                                        fontSize: 10.w,
                                        color: Color(0xff767F9E),
                                        fontWeight: FontWeight.w500),
                                  ),
                                  if (stateTick && isSender)
                                    regularText(stateIcon.toString(),
                                        fontSize: 11.w,
                                        color: Color(0xff767F9E),
                                        fontWeight: FontWeight.w500),
                                ])
                          ],
                        )),
                  ),
                ),
              ),
            ],
          ),
          //  verticalSpaceTiny,
        ],
      ),
    );
  }
}
