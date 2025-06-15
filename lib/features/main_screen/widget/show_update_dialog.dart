
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../explore_screen/logic/cubit/posts_cubit.dart';

void showOptionsBottomSheet({required PostsCubit postCubit,required BuildContext context,required String commentId}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) => Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.edit, color: Colors.white),
            title:  Text(
              'Update'.tr(),
              style: const TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.pop(context);
              postCubit.startEditing(commentId: commentId);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title:  Text(
              'Delete'.tr(),
              style: const TextStyle(color: Colors.red),
            ),
            onTap: () {
              Navigator.pop(context);
              showDeleteConfirmation(context: context, postsCubit: postCubit, commentId: commentId);
            },
          ),
          SizedBox(height: 20.h),
        ],
      ),
    ),
  );
}

void showDeleteConfirmation({required BuildContext context,required PostsCubit postsCubit,required String commentId }) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: const Color(0xFF1E1E1E),
      title:  Text(
        'Delete Comment'.tr(),
        style: const TextStyle(color: Colors.white),
      ),
      content:  Text(
        'Are you sure you want to delete this comment?'.tr(),
        style: const TextStyle(color: Colors.white70),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child:  Text(
            'Cancel'.tr(),
            style: const TextStyle(color: Colors.white70),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
           postsCubit.deleteComment(commentId: commentId);
          },
          child:  Text(
            'Delete'.tr(),
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ],
    ),
  );
}

void deleteComment() {
  // Here you would typically call your API to delete the comment
  // PostsCubit.get(context).deleteComment(widget.getCommentData.id);
}
