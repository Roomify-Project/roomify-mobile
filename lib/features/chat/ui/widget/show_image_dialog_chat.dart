import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rommify_app/features/chat/logic/cubit/chat_cubit.dart';
import 'package:rommify_app/features/profile/logic/cubit/profile_cubit.dart';

void showPickImageSnackBarChat(BuildContext context,ChatCubit chatCubit) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TextButton.icon(
            onPressed: () {
              chatCubit.pickImage(source: ImageSource.camera);
            },
            icon: const Icon(Icons.camera_alt, color: Colors.white),
            label: const Text('Camera', style: TextStyle(color: Colors.white)),
          ),
          TextButton.icon(
            onPressed: () {
              chatCubit.pickImage(source: ImageSource.gallery);
            },
            icon: const Icon(Icons.photo_library, color: Colors.white),
            label: const Text('Gallery', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      backgroundColor: Colors.black87,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      duration: const Duration(seconds: 5),
    ),
  );
}