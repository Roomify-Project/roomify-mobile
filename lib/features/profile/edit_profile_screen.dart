import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:rommify_app/core/helpers/constans.dart';
import 'package:rommify_app/core/theming/colors.dart';
import 'package:rommify_app/core/widgets/flutter_show_toast.dart';
import 'package:rommify_app/features/profile/logic/cubit/profile_cubit.dart';
import 'package:rommify_app/features/profile/logic/cubit/profile_states.dart';
import 'package:rommify_app/features/profile/widget/custom_app_bar.dart';
import 'package:rommify_app/features/profile/widget/custom_button.dart';
import 'package:rommify_app/features/profile/widget/custom_dialog_widget.dart';
import 'package:rommify_app/features/profile/widget/custom_text_field.dart';
import 'package:rommify_app/features/profile/widget/profile_image.dart';

import '../../core/helpers/shared_pref_helper.dart';

class EditProfileScreen extends StatelessWidget {
  final ProfileCubit profileCubit;

  const EditProfileScreen({super.key, required this.profileCubit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.colorPrimary,
      appBar: CustomAppBar(
        onClose: () => Navigator.pop(context),
      ),
      body: BlocProvider.value(
        value: profileCubit,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 60),
          child: BlocConsumer<ProfileCubit, ProfileStates>(
            buildWhen: (previous, current) =>
                current is UpdateProfileSuccessState ||
                current is UpdateProfileLoadingState ||
                current is UpdateProfileErrorState ||
                current is UploadImageState,
            listenWhen: (previous, current) =>
                current is UpdateProfileSuccessState ||
                current is UpdateProfileLoadingState ||
                current is UpdateProfileErrorState,
            listener: (context, state) {
              if(state is UpdateProfileLoadingState ){
                EasyLoading.show();
              }
              else if(state is UpdateProfileSuccessState){
                EasyLoading.dismiss();
                flutterShowToast(message: "Update Profile Successfully", toastCase: ToastCase.success);
              }
              else if(state is UpdateProfileErrorState){
                EasyLoading.dismiss();
                flutterShowToast(message: state.message, toastCase: ToastCase.error);
              }
            },
            builder: (context, state) {
              final profileCubit = ProfileCubit.get(context);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ProfileImage(
                    profileCubit: ProfileCubit.get(context),
                  ),
                  const SizedBox(height: 40),
                  CustomTextField(
                    controller: profileCubit.fullNameController,
                    hint: 'FULL NAME',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your full name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  CustomTextField(
                    controller: profileCubit.userNameController,
                    hint: 'USER NAME',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your username';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  CustomTextField(
                    controller: profileCubit.emailController,
                    hint: 'EMAIL@GMAIL.COM',
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  CustomTextField(
                    controller: profileCubit.phoneNumberController,
                    hint: 'PHONE NUMBER',
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  CustomTextField(
                    controller: profileCubit.bioController,
                    hint: 'Bio',
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  CustomButton(
                    text: 'CHANGE PASSWORD',
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierColor: const Color(0xFF341D38).withOpacity(0.91),
                        builder: (BuildContext context) {
                          return const ChangePasswordDialog();
                        },
                      );
                    },
                    color: const Color(0xff200625),
                  ),
                  const SizedBox(height: 60),
                  CustomButton(
                    text: 'SAVE CHANGES',
                    onPressed: () {
                      profileCubit.updateProfile(
                          updateProfileId:SharedPrefHelper.getString(SharedPrefKey.userId));
                    },
                    color: const Color(0xff320c39),
                    width: 147,
                    height: 47,
                  ),
                  const SizedBox(height: 40),
                  TextButton(
                    onPressed: () async {
                     await profileCubit.logOut(context: context);
                    },
                    child: const Text(
                      'LOG OUT',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
