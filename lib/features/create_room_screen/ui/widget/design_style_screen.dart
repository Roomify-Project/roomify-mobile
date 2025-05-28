import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rommify_app/features/create_room_screen/logic/cubit/generate_cubit.dart';
import 'package:rommify_app/features/create_room_screen/logic/cubit/generate_staets.dart';

class DesignStyleScreen extends StatelessWidget {
  final GenerateCubit generateCubit;
  const DesignStyleScreen({super.key, required this.generateCubit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: generateCubit,
      child: BlocBuilder<GenerateCubit,GenerateStates>(
        builder: (BuildContext context, state) {
          return  Dialog(
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
                          'Choose design style',
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
                          _buildStyleCard('Modern', 'modern', 'assets/images/modern.png', context),
                          _buildStyleCard('Classic', 'classic', 'assets/images/classic.png', context),
                          _buildStyleCard('Minimalistic', 'minimalist', 'assets/images/Minimalist.png', context),
                          _buildStyleCard('Industrial', 'industrial', 'assets/images/industral.jpg', context),
                          _buildStyleCard('Rustic', 'rustic', 'assets/images/rustic.jpg', context),
                          _buildStyleCard('Scandinavian', 'scandinavian', 'assets/images/scandinavian.jpg', context),
                          _buildStyleCard('Contemporary', 'contemporary', 'assets/images/Contemporary.jpg', context),
                          _buildStyleCard('Bohemian', 'bohemian', 'assets/images/Bohemian.jpg', context),
                          _buildStyleCard('Transitional', 'transitional', 'assets/images/Transitional.jpeg', context),
                          _buildStyleCard('ArtDeco', 'art deco', 'assets/images/ArtDeco.jpg', context),
                          _buildStyleCard('MidCenturyModern', 'mid century', 'assets/images/MidCenturyModern.jpg', context),
                          _buildStyleCard('ShabbyChic', 'shabby chic', 'assets/images/ShabbyChic.jpg', context),
                          _buildStyleCard('Victorian', 'victorian', 'assets/images/Victorian.jpg', context),
                          _buildStyleCard('Farmhouse', 'farmhouse', 'assets/images/Farmhouse.jpg', context),
                          _buildStyleCard('Eclectic', 'eclectic', 'assets/images/Eclectic.jpg', context),
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
          );
        },

      ),
    );
  }

  Widget _buildStyleCard(String backendValue, String displayName, String imagePath, BuildContext context) {
    return InkWell(
      onTap: () {
        GenerateCubit.get(context).setDesignStyle(designRoomType: backendValue);
        GenerateCubit.get(context).setImageStyle(image: imagePath);
      },
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border:
                  GenerateCubit.get(context).roomStyle == backendValue?
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
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}