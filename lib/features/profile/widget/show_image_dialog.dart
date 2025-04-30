import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rommify_app/features/profile/logic/cubit/profile_cubit.dart';

void showPickImageSnackBar(BuildContext context,ProfileCubit profileCubit) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TextButton.icon(
            onPressed: () {
              profileCubit.pickImage(source: ImageSource.camera);
            },
            icon: const Icon(Icons.camera_alt, color: Colors.white),
            label: const Text('Camera', style: TextStyle(color: Colors.white)),
          ),
          TextButton.icon(
            onPressed: () {
              profileCubit.pickImage(source: ImageSource.gallery);
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