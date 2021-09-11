import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/app/size_config/config.dart';
import 'package:mms_app/core/models/home_chat_model.dart';
import 'package:mms_app/core/models/login_response.dart';
import 'package:mms_app/core/routes/router.dart';
import 'package:mms_app/core/storage/local_storage.dart';
import 'package:mms_app/screens/widgets/app_empty_widget.dart';
import 'package:mms_app/screens/widgets/notification_widget.dart';
import 'package:mms_app/screens/widgets/text_widgets.dart';
import 'package:mms_app/app/size_config/extensions.dart';

import 'message_details.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({Key key}) : super(key: key);

  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  List<HomeChatModel> allChats = <HomeChatModel>[];
  Map<String, HomeChatModel> allChatMap = <String, HomeChatModel>{};
  Logger log = Logger();
  DatabaseReference msgsRef;
  StreamSubscription<Event> msgAddedStream, msgChangedStream;

  @override
  void initState() {
    msgsRef = FirebaseDatabase.instance
        .reference()
        .child('users_chats')
        .child(AppCache.getUser.uid);

    msgAddedStream = msgsRef.onChildAdded.listen((Event event) {
      // for personal chats
      final HomeChatModel chatModel =
          HomeChatModel.fromJson(event.snapshot.value);
      print(chatModel.toUid);

      allChatMap.update(event.snapshot.key, (HomeChatModel a) => chatModel,
          ifAbsent: () => chatModel);

      allChats.clear();
      allChatMap.forEach((String key, HomeChatModel value) {
        allChats.add(value);
      });

      Logger().d(allChats.first.toJson());
      allChats.sort((HomeChatModel a, HomeChatModel b) =>
          b.createdAt.compareTo(a.createdAt));
      if (mounted) {
        setState(() {});
      }
    });

    msgChangedStream = msgsRef.onChildChanged.listen((Event event) {
      // for personal chats
      final HomeChatModel chatModel =
          HomeChatModel.fromJson(event.snapshot.value);
      allChatMap.update(event.snapshot.key, (HomeChatModel a) => chatModel,
          ifAbsent: () => chatModel);
      allChats.clear();
      allChatMap.forEach((String key, HomeChatModel value) {
        allChats.add(value);
      });

      allChats.sort((HomeChatModel a, HomeChatModel b) =>
          b.createdAt.compareTo(a.createdAt));
      if (mounted) {
        setState(() {});
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    msgAddedStream.cancel();
    msgChangedStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.all(20.h),
              child: Row(
                children: [
                  regularText(
                    'Messages',
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryColor,
                  ),
                  Spacer(),
                  AppNotificationsWidget()
                ],
              ),
            ),
            allChats.isEmpty
                ? AppEmptyWidget(text: 'Chat is Empty')
                : Expanded(
                    child: ListView.separated(
                      itemCount: allChats.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            navigateTo(
                                context,
                                ChatDetailsView(
                                  contact: UserData(
                                    name: allChats[index].toName,
                                    uid: allChats[index].toUid ==
                                            AppCache.getUser.uid
                                        ? allChats[index].fromUid
                                        : allChats[index].toUid,
                                    image: allChats[index].toImg,
                                  ),
                                ));
                          },
                          child: Container(
                              color: !allChats[index].isRead
                                  ? Colors.greenAccent.withOpacity(.3)
                                  : null,
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.h, horizontal: 20.h),
                              child: Row(
                                children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(8.h),
                                      child: Image.asset(
                                        'images/placeholder.png',
                                        height: 60.h,
                                        width: 60.h,
                                      )),
                                  SizedBox(width: 6.h),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            regularText(
                                              allChats[index].toName,
                                              fontSize: 17.sp,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.primaryColor,
                                            ),
                                            Spacer(),
                                            regularText(
                                              DateFormat('hh:mm a').format(
                                                  DateTime
                                                      .fromMillisecondsSinceEpoch(
                                                          allChats[index]
                                                              .createdAt)),
                                              fontSize: 15.sp,
                                              color: AppColors.grey,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 6.h),
                                        regularText(
                                          allChats[index].lastText,
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 17.sp,
                                          maxLines: 2,
                                          color: AppColors.grey,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.h),
                          child: Divider(
                            height: 0,
                            thickness: 1.h,
                            color: AppColors.grey.withOpacity(.2),
                          ),
                        );
                      },
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
