import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rommify_app/features/create_room_screen/logic/cubit/generate_cubit.dart';

void showPickImageSnackBarGenerate(BuildContext context, GenerateCubit generateCubit) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: Colors.black87,
    builder: (_) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton.icon(
              onPressed: () {
                Navigator.pop(context);
                generateCubit.pickImage(source: ImageSource.camera);
              },
              icon: const Icon(Icons.camera_alt, color: Colors.white),
              label: const Text('Camera', style: TextStyle(color: Colors.white)),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.pop(context);
                generateCubit.pickImage(source: ImageSource.gallery);
              },
              icon: const Icon(Icons.photo_library, color: Colors.white),
              label: const Text('Gallery', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    },
  );
}
