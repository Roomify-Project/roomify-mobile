import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rommify_app/features/create_room_screen/logic/cubit/generate_cubit.dart';
import 'package:rommify_app/features/create_room_screen/logic/cubit/generate_staets.dart';

class RoomTypeScreen extends StatelessWidget {
  final GenerateCubit generateCubit;
  const RoomTypeScreen({super.key, required this.generateCubit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: generateCubit,
      child: BlocBuilder<GenerateCubit,GenerateStates>(
        builder: (BuildContext context, state) {
          return  Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: Dialog(
              insetPadding: const EdgeInsets.symmetric(horizontal: 0),
              child: Container(
                width: 402.w,
                height: 679.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF27012f),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Choose room type',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 35),
                      Expanded(
                        child: GridView.count(
                          physics: const BouncingScrollPhysics(),
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 19,
                          childAspectRatio: 185 / 145,
                          children: [
                            _buildRoomCard('LivingRoom', 'living room', 'assets/images/download 18.png', context),
                            _buildRoomCard('Bedroom', 'bedroom', 'assets/images/download 15.png', context),
                            _buildRoomCard('Kitchen', 'kitchen', 'assets/images/download 17.png', context),
                            _buildRoomCard('Bathroom', 'bathroom', 'assets/images/download 19.png', context),
                            _buildRoomCard('Office', 'office', 'assets/images/download 16.png', context),
                            _buildRoomCard('DiningRoom', 'dining room', 'assets/images/dining.jpg', context),
                            _buildRoomCard('Hallway', 'hallway', 'assets/images/hallway.jpg', context),
                            _buildRoomCard('HomeLibrary', 'home library', 'assets/images/home_library.jpg', context),
                            _buildRoomCard('StudyRoom', 'study room', 'assets/images/study_room.jpg', context),
                            _buildRoomCard('GuestRoom', 'guest room', 'assets/images/guest_image.jpg', context),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 29),
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Save',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },

      ),
    );
  }

  Widget _buildRoomCard(String backendValue, String displayName, String imagePath, BuildContext context) {
    return InkWell(
      onTap: () {
        GenerateCubit.get(context).setRoomType(titleRoomType: backendValue);
        GenerateCubit.get(context).setImageType(image: imagePath);
      },
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border:
                  GenerateCubit.get(context).roomType == backendValue?
                  Border.all(color: Colors.purple, width: 2):null
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            displayName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}