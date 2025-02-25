import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rommify_app/features/create_room_screen/ui/widget/room_type_item.dart';

class RoomTypeListView extends StatelessWidget {
  const RoomTypeListView({super.key});

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      height: 76.h,
      child: ListView.separated(

          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return const RoomTypeItem();
          },
          separatorBuilder: (context, index) {
            return SizedBox(
              width: 10.w,
            );
          },
          itemCount: 7),
    )
    ;
  }
}
