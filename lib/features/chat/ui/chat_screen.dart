import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rommify_app/core/helpers/extensions.dart';
import 'package:rommify_app/core/routing/routes.dart';
import 'package:rommify_app/core/theming/styles.dart';

import '../../../core/theming/colors.dart';
class ChatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.mainColor,
      body: Padding(
        padding:  EdgeInsets.only(top: 72.h,right: 23.w,left: 23.w),
        child: ListView.separated(
          itemCount: 10,
          itemBuilder: (context, index) {
            return InkWell(
                onTap: () {
                  context.pushNamed(Routes.chatsFriendsScreen);
                },
                child: ChatItem());
          }, separatorBuilder: (BuildContext context, int index) {
            return SizedBox(height: 18.h,);
        },
        ),
      ),
    );
  }
}

class ChatItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Row(
      children: [
        const CircleAvatar(
          backgroundImage: NetworkImage('https://via.placeholder.com/150'),
          radius: 25,
        ),
        SizedBox(width: 5.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ali Ellebi',
                style: TextStyles.font19WhiteBold.copyWith(fontWeight: FontWeight.w700),
              ),
              Text(
                'Hi bro, how are you?',
                style:TextStyles.font19WhiteBold.copyWith(fontWeight: FontWeight.w700,fontSize: 16.sp,color:Colors.white54),
              ),
            ],
          ),
        ),
         Column(
          children: [
            Text(
              '02:00 AM',
              style: TextStyle(color: Colors.white54,fontSize: 6.3.sp,),
            ),
            SizedBox(height: 9.h,),
            Container(

            )
          ],
        ),
      ],
    );
  }
}