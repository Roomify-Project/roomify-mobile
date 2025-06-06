import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rommify_app/core/helpers/constans.dart';
import 'package:rommify_app/core/widgets/custom_chached_network_image.dart';
import 'package:rommify_app/features/profile/logic/cubit/profile_cubit.dart';
import 'package:rommify_app/features/profile/widget/show_image_dialog.dart';

class ProfileImage extends StatelessWidget {
  final ProfileCubit profileCubit;

  const ProfileImage({Key? key, required this.profileCubit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        GestureDetector(
          onTap: () {
            showPickImageSnackBar(context, profileCubit);
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 134,
                height: 134,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey,
                ),
                child: ClipOval(
                  child: profileCubit.imageFile != null
                      ? Image.file(
                          profileCubit.imageFile!,
                          fit: BoxFit
                              .cover, // علشان الصورة تملأ الدائرة بشكل صحيح
                        )
                      : ClipOval(
                          child: CustomCachedNetworkImage(
                            imageUrl: profileCubit
                                .getProfileDataModel
                                ?.profilePicture ==
                                null ||
                                profileCubit
                                    .getProfileDataModel!
                                    .profilePicture ==
                                    ""
                                ? Constants.defaultImagePerson
                                : profileCubit
                                .getProfileDataModel!
                                .profilePicture,
                            fit: BoxFit
                                .cover, // علشان الصورة تملأ الدائرة بشكل صحيح
                          ),
                        ),
                ),
              ),
              Container(
                width: 134,
                height: 134,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ],
          ),
        ),
        profileCubit.imageFile != null
            ? Padding(
                padding: const EdgeInsets.only(top: 10, right: 5),
                child: Container(
                  width: 24.w,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: InkWell(
                    onTap: () {
                      profileCubit.clearImage();
                    },
                    child: const Center(
                      child: Icon(
                        Icons.close,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
