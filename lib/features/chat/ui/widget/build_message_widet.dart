import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:rommify_app/features/profile/data/models/get_profile_data.dart';

import '../../../../core/theming/colors.dart';
import '../../../../core/theming/styles.dart';
import '../../logic/cubit/chat_cubit.dart';

Widget buildMessageComposer(
    {required ChatCubit chatCubit,
    required GetProfileDataModel getProfileDataModel}) {
  return Padding(
    padding: EdgeInsets.only(bottom: 15.h),
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: ColorsManager.colorPrimary,
        border: Border(
          top: BorderSide(
            color: Colors.purple.shade800,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              height: 45.h,
              decoration: BoxDecoration(
                color: Colors.purple.shade900,
                borderRadius: BorderRadius.circular(25.r),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Type...',
                        hintStyle: TextStyle(
                          color: Colors.white54,
                          fontSize: 14.sp,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                      ),
                      controller: chatCubit.messageController,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      chatCubit.sendMessage(receiverId: getProfileDataModel.id);
                    },
                    child: Container(
                      width: 35.w,
                      height: 35.h,
                      decoration: BoxDecoration(
                        color: Colors.purple.shade800,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Container(
            width: 45.w,
            height: 45.h,
            decoration: BoxDecoration(
              color: Colors.purple.shade900,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.attach_file,
              color: Colors.white,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 8.w),
          Container(
            width: 45.w,
            height: 45.h,
            decoration: BoxDecoration(
              color: Colors.purple.shade900,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.mic,
              color: Colors.white,
              size: 20.sp,
            ),
          ),
        ],
      ),
    ),
  );
}

class MessageBubble extends StatefulWidget {
  final ChatCubit chatCubit;
  final String message;
  final bool isMe;
  final String time;
  final String messageId;

  MessageBubble({
    required this.message,
    required this.isMe,
    required this.time,
    required this.chatCubit,
    required this.messageId,
  });

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  String? formattedTime;

  @override
  void initState() {
    // TODO: implement initState
    DateTime parsedSentAt = DateTime.parse(widget.time);
    formattedTime = DateFormat('HH:mm').format(parsedSentAt);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Column(
        crossAxisAlignment:
            widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                padding: EdgeInsets.only(
                    left: 8.w, bottom: 8.h, top: 8.h, right: 8.w),
                decoration: BoxDecoration(
                    color: widget.isMe ? Colors.purple[700] : Colors.grey[800],
                    borderRadius: widget.isMe
                        ? BorderRadius.only(
                            topRight: Radius.circular(7.r),
                            bottomLeft: Radius.circular(7.r),
                            bottomRight: Radius.circular(7.r))
                        : BorderRadius.only(
                            topLeft: Radius.circular(7.r),
                            bottomLeft: Radius.circular(7.r),
                            bottomRight: Radius.circular(7.r))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.message,
                      style: TextStyles.font16WhiteInter
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 5.h),
                    SizedBox(
                      width: 60,
                      child: Text(
                        formattedTime ?? "",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9.3.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              widget.isMe
                  ? !widget.chatCubit.checkSendMessage[widget.messageId]!
                      ? Padding(
                          padding: EdgeInsets.only(right: 5.w, bottom: 5.h),
                          child: Icon(
                            Icons.access_time,
                            // أو أي أيقونة تانية زي Icons.check أو Icons.done_all
                            color: Colors.white60,
                            size: 15.sp,
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.only(right: 5.w, bottom: 5.h),
                          child: Icon(
                            Icons.check,
                            // أو أي أيقونة تانية زي Icons.check أو Icons.done_all
                            color: Colors.white60,
                            size: 15.sp,
                          ),
                        )
                  : const SizedBox(),
            ],
          ),
          // IconButton(
          //   icon: Icon(Icons.favorite_border, size: 16),
          //   color: Colors.white54,
          //   onPressed: () {},
          // ),
        ],
      ),
    );
  }
}
