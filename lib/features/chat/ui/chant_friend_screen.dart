import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rommify_app/core/theming/colors.dart';

import '../../../core/theming/styles.dart';

class ChatFriendScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.colorPrimary,
      appBar: AppBar(
        backgroundColor: ColorsManager.colorPrimary,
        elevation: 0,
        leading: Padding(
          padding:  EdgeInsets.only(left: 12.w),
          child: const CircleAvatar(
            radius: 12,
            backgroundImage: AssetImage('assets/profile_image.jpg'),
          ),
        ),
        title: Padding(
          padding:  EdgeInsets.only(left: 1.w),
          child: Text('Antoneos',style: TextStyles.font19WhiteBold.copyWith(fontWeight: FontWeight.w700),),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return MessageBubble(
                  message: messages[index]['text'],
                  isMe: messages[index]['isMe'],
                  time: messages[index]['time'],
                );
              },
            ),
          ),
          _buildMessageComposer(),
        ],
      ),
    );
  }

  Widget _buildMessageComposer() {
    return Container(
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
                    ),
                  ),
                  Container(
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
    );
  }}

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String time;

  MessageBubble({
    required this.message,
    required this.isMe,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Column(
        crossAxisAlignment:
        isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 8.w,bottom: 8.h,top: 8.h,right: 45.w),
            decoration: BoxDecoration(
              color: isMe ? Colors.purple[700] : Colors.grey[800],
              borderRadius:isMe?
              BorderRadius.only(topRight: Radius.circular(7.r),bottomLeft: Radius.circular(7.r),bottomRight: Radius.circular(7.r)):
              BorderRadius.only(topLeft: Radius.circular(7.r),bottomLeft: Radius.circular(7.r),bottomRight: Radius.circular(7.r))
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style:  TextStyles.font16WhiteInter.copyWith(fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 5.h),
                Text(
                  time,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 6.3.sp,
                    fontWeight: FontWeight.w400
                  ),
                ),
              ],
            ),
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

// Sample messages data
final List<Map<String, dynamic>> messages = [
  {
    'text': 'Hi bro, how are you?',
    'isMe': false,
    'time': '09:30 AM',
  },
  {
    'text': 'Hi bro, how are you?',
    'isMe': true,
    'time': '09:31 AM',
  },
  // Add more messages as needed
];