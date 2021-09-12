import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/core/models/login_response.dart';
import 'package:mms_app/core/models/message_model.dart';
import 'package:mms_app/core/storage/local_storage.dart';
import 'package:mms_app/screens/widgets/notification_manager.dart';
import 'package:mms_app/screens/widgets/text_widgets.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:mms_app/screens/widgets/utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'input_widget.dart';
import 'message_bubble.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';

class ChatDetailsView extends StatefulWidget {
  const ChatDetailsView({Key key, this.contact}) : super(key: key);

  final UserData contact;

  @override
  _ChatDetailsViewState createState() => _ChatDetailsViewState();
}

class _ChatDetailsViewState extends State<ChatDetailsView> {
  TextEditingController textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<NewMessageModel> allMessages = <NewMessageModel>[];
  DatabaseReference msgsRef;
  StreamSubscription<Event> msgStream, updateMsgStream;
  StreamSubscription<bool> keyboardStream;

  @override
  void initState() {
    final String conId =
        Utils.conversationId(AppCache.getUser.uid, widget.contact.uid);

    msgStream = FirebaseDatabase.instance
        .reference()
        .child('messages')
        .child(conId)
        .onChildAdded
        .listen((Event event) async {
      final NewMessageModel newModel =
          NewMessageModel.fromJson(event.snapshot.value);

      allMessages.add(newModel);
      allMessages.sort((NewMessageModel b, NewMessageModel a) =>
          a.createdAt.compareTo(b.createdAt));

      Logger().d(event.snapshot.value);
      _scrollController.animateTo(
          _scrollController.position.minScrollExtent - 200,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 500));

      Future<dynamic>.delayed(const Duration(seconds: 1), () async {
        NotificationManager.cancelNotification(widget.contact.uid.hashCode);
      });
      setState(() {});

      if (!newModel.isRead && newModel.to == AppCache.getUser.uid) {
        final Map<String, dynamic> mData = <String, dynamic>{};
        mData.putIfAbsent('isRead', () => true);
        FirebaseDatabase.instance
            .reference()
            .child('messages')
            .child(conId)
            .child(event.snapshot.key)
            .update(mData);

        FirebaseDatabase.instance
            .reference()
            .child('users_chats')
            .child(newModel.to)
            .child(conId)
            .update(mData);

        FirebaseDatabase.instance
            .reference()
            .child('users_chats')
            .child(newModel.from)
            .child(conId)
            .update(mData);
      }
    });

    updateMsgStream = FirebaseDatabase.instance
        .reference()
        .child('messages')
        .child(conId)
        .onChildChanged
        .listen((Event event) async {
      final NewMessageModel newModel =
          NewMessageModel.fromJson(event.snapshot.value);
      allMessages.removeWhere(
          (NewMessageModel e) => e.createdAt == newModel.createdAt);
      allMessages.add(newModel);
      allMessages.sort((NewMessageModel b, NewMessageModel a) =>
          a.createdAt.compareTo(b.createdAt));

      Future<dynamic>.delayed(const Duration(seconds: 1), () async {
        NotificationManager.cancelNotification(widget.contact.uid.hashCode);
      });
      setState(() {});
    });

    keyboardStream =
        KeyboardVisibility.onChange.listen((bool isKeyboardVisible) {
      setState(() {
        this.isKeyboardVisible = isKeyboardVisible;
      });

      if (isKeyboardVisible && isEmojiVisible) {
        setState(() {
          isEmojiVisible = false;
        });
      }
    });
    super.initState();
  }

  bool isEmojiVisible = false;
  bool isKeyboardVisible = false;

  String isReplyTitle;
  String isReplyBody;
  FocusNode focusNode = FocusNode();

  void onEmojiSelected(String emoji) => setState(() {
        textController.text = textController.text + emoji;
      });

  Future<void> toggleEmojiKeyboard() async {
    if (isKeyboardVisible) {
      FocusScope.of(context).unfocus();
    }

    setState(() {
      isEmojiVisible = !isEmojiVisible;
    });
  }

  Future<bool> onBackPress() {
    if (isEmojiVisible) {
      toggleEmojiKeyboard();
    } else {
      Navigator.pop(context);
    }

    return Future<bool>.value(false);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    updateMsgStream.cancel();
    keyboardStream.cancel();
    msgStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: null,
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: AppColors.white,
            appBar: AppBar(
                elevation: 3,
                centerTitle: false,
                leadingWidth: 40.h,
                titleSpacing: 0,
                bottom: PreferredSize(
                  child: SizedBox(),
                  preferredSize: Size(2, 10.h),
                ),
                actions: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          launch('tel:${widget.contact.companyPhone}');
                        },
                        child: Image.asset(
                          'images/call.png',
                          height: 24.h,
                          width: 24.h,
                        ),
                      )
                    ],
                  ),
                  SizedBox(width: 12.h),
                ],
                title: Row(
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(12.h),
                        child: Image.asset(
                          'images/placeholder.png',
                          height: 44.h,
                          width: 44.h,
                        )),
                    SizedBox(width: 12.h),
                    regularText(widget.contact.name,
                        fontSize: 18.sp, fontWeight: FontWeight.w600),
                  ],
                )),
            body: FooterLayout(
              child: Column(
                children: [
                  if (allMessages.isEmpty)
                    Expanded(
                      child: Center(
                        child: regularText(
                          'Your conversation starts here',
                          fontSize: 11.sp,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  Expanded(
                      child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20.h),
                        topLeft: Radius.circular(20.h),
                      ),
                    ),
                    child: ListView.builder(
                        itemCount: allMessages.length,
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        reverse: true,
                        controller: _scrollController,
                        itemBuilder: (BuildContext context, int index) {
                          return MessageBubble(
                            text: allMessages[index].text,
                            isSender:
                                allMessages[index].from == AppCache.getUser.uid,
                            isRead: allMessages[index].isRead,
                            timeSent: DateFormat('hh:mm a').format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    allMessages[index].createdAt)),
                          );
                        }),
                  )),
                ],
              ),
              footer: InputWidget(
                onBlurred: toggleEmojiKeyboard,
                controller: textController,
                isEmojiVisible: isEmojiVisible,
                focusNode: focusNode,
                isBusy: false,
                isKeyboardVisible: isKeyboardVisible,
                onChanged: (String a) => setState(() {}),
                onSentMessage: (String message) async {
                  _scrollController.animateTo(
                      _scrollController.position.minScrollExtent - 200,
                      curve: Curves.easeOut,
                      duration: const Duration(milliseconds: 300));
                  sendOneMessage();
                  setState(() {});
                },
              ),
            ),
          );
        });
  }

  Future<bool> sendOneMessage() async {
    final String text = textController.text;
    UserData toUser = widget.contact;

    final int timeStamp = DateTime.now().millisecondsSinceEpoch;
    final String conId = Utils.conversationId(AppCache.getUser.uid, toUser.uid);

    final Map<String, dynamic> mData = <String, dynamic>{};

    mData.putIfAbsent('text', () => text);
    mData.putIfAbsent('createdAt', () => timeStamp);
    mData.putIfAbsent('from', () => AppCache.getUser.uid);
    mData.putIfAbsent('fromName', () => AppCache.getUser.name);
    mData.putIfAbsent('fromImg', () => AppCache.getUser.image);
    mData.putIfAbsent('to', () => toUser.uid);
    mData.putIfAbsent('toName', () => toUser.name);
    mData.putIfAbsent('toImg', () => toUser.image);
    mData.putIfAbsent('isRead', () => false);

    final Map<String, dynamic> userData = <String, dynamic>{};
    userData.putIfAbsent('text', () => text);
    userData.putIfAbsent('createdAt', () => timeStamp);
    userData.putIfAbsent('from', () => AppCache.getUser.uid);
    userData.putIfAbsent('fromName', () => AppCache.getUser.name);
    userData.putIfAbsent('fromImg', () => AppCache.getUser.image);
    userData.putIfAbsent('to', () => toUser.uid);
    userData.putIfAbsent('toName', () => toUser.name);
    userData.putIfAbsent('toImg', () => toUser.image);
    userData.putIfAbsent('isRead', () => false);

    FirebaseDatabase.instance
        .reference()
        .child('users_chats')
        .child(toUser.uid)
        .child(conId)
        .set(userData);
    FirebaseDatabase.instance
        .reference()
        .child('messages')
        .child(conId)
        .child(timeStamp.toString())
        .set(mData);
    FirebaseDatabase.instance
        .reference()
        .child('users_chats')
        .child(AppCache.getUser.uid)
        .child(conId)
        .set(userData);
    return true;
  }
}
