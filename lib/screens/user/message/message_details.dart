import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/screens/widgets/text_widgets.dart';
import 'package:mms_app/app/size_config/extensions.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'input_widget.dart';
import 'message_bubble.dart';

class ChatDetailsView extends StatefulWidget {
  const ChatDetailsView({Key key}) : super(key: key);

  @override
  _ChatDetailsViewState createState() => _ChatDetailsViewState();
}

class _ChatDetailsViewState extends State<ChatDetailsView> {
  TextEditingController textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  StreamSubscription<bool> keyboardStream;

  @override
  void initState() {
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
      _scrollController.animateTo(
          _scrollController.position.minScrollExtent - 200,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 500));
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
    keyboardStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                Image.asset(
                  'images/call.png',
                  height: 24.h,
                  width: 24.h,
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
              regularText('Stones',
                  fontSize: 18.sp, fontWeight: FontWeight.w600),
            ],
          )),
      body: Column(
        children: [
          Expanded(
              child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20.h),
                topLeft: Radius.circular(20.h),
              ),
            ),
            child: ListView.builder(
                itemCount: 12,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                reverse: true,
                controller: _scrollController,
                itemBuilder: (BuildContext context, int index) {
                  switch ('') {
                    case 'text':
                      return MessageBubble(
                          text:
                              'Hey Elvis, How are you doing? I’d love to know if you are free',
                          isSender: index.isEven,
                          isRead: index.isEven,
                          timeSent: '12:34');
                      break;
                    default:
                      return MessageBubble(
                          text:
                              'Hey Elvis, How are you doing? I’d love to know if you are free',
                          isSender: index.isEven,
                          isRead: index.isOdd,
                          timeSent: '12:34');
                  }
                }),
          )),
          InputWidget(
            onBlurred: toggleEmojiKeyboard,
            controller: textController,
            isEmojiVisible: isEmojiVisible,
            focusNode: focusNode,
            isBusy: false,
            sendMediaTo: '',
            sendMediaToName: '',
            sendMediaToImg: '',
            isKeyboardVisible: isKeyboardVisible,
            onChanged: (String a) => setState(() {}),
            onSentMessage: (String message) async {
              _scrollController.animateTo(
                  _scrollController.position.minScrollExtent - 200,
                  curve: Curves.easeOut,
                  duration: const Duration(milliseconds: 300));

              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
