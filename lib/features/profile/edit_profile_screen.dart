import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

import '../../core/di/dependency_injection.dart';
import '../../core/helpers/shared_pref_helper.dart';
import '../../core/theming/styles.dart';
import '../change_password/logic/cubit/change_password_cubit.dart';
import '../change_password/ui/change_password_dialog.dart';

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
                flutterShowToast(message: state.updateProfileResponse.message, toastCase: ToastCase.success);
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
                   SizedBox(height: 40.h),
                  CustomTextField(
                    controller: profileCubit.fullNameController,
                    hint: 'FULL NAME'.tr(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your full name'.tr();
                      }
                      return null;
                    },
                  ),
                   SizedBox(height: 15.h),
                  CustomTextField(
                    controller: profileCubit.userNameController,
                    hint: 'USER NAME'.tr(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your username'.tr();
                      }
                      return null;
                    },
                  ),
                   SizedBox(height: 15.h),
                  CustomTextField(
                    controller: profileCubit.emailController,
                    hint: 'EMAIL@GMAIL.COM'.tr(),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email'.tr();
                      }
                      return null;
                    },
                  ),
                   SizedBox(height: 15.h),
                  CustomTextField(
                    controller: profileCubit.phoneNumberController,
                    hint: 'PHONE NUMBER'.tr(),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number'.tr();
                      }
                      return null;
                    },
                  ),
                   SizedBox(height: 15.h),
                  CustomTextField(
                    controller: profileCubit.bioController,
                    hint: 'Bio'.tr(),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number'.tr();
                      }
                      return null;
                    },
                  ),
                   SizedBox(height: 30.h),
                  CustomButton(
                    text: 'CHANGE PASSWORD'.tr(),
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierColor: const Color(0xFF341D38).withOpacity(0.91),
                        builder: (BuildContext context) {
                          return BlocProvider(
                            create: (context) => getIt<ChangePasswordCubit>(),
                            child: const ChangePasswordDialog(),
                          );
                        },
                      );
                    },
                    color: const Color(0xff200625),
                  ),
                  SizedBox(height: 20.h,),
                  ListTile(
                    // title: Text('language'.tr(),style: TextStyles.font14WhiteRegular,),
                    title: Text(context.locale.languageCode == 'ar' ? 'العربية' : 'English',style: TextStyles.font14WhiteRegular,),
                    trailing: Switch(
                      value: context.locale.languageCode == 'ar',
                      onChanged: (value) {
                        if (value) {
                          context.setLocale(const Locale('ar'));
                        } else {
                          context.setLocale(const Locale('en'));
                        }
                      },
                    ),
                  ),
                   SizedBox(height: 60.h),
                  CustomButton(
                    text: 'SAVE CHANGES'.tr(),
                    onPressed: () {
                      profileCubit.updateProfile(
                        updateProfileId: SharedPrefHelper.getString(SharedPrefKey.userId)
                      );
                    },
                    color: const Color(0xff320c39),
                    width: 147,
                    height: 47.h,
                  ),
                   SizedBox(height: 40.h),
                  TextButton(
                    onPressed: () async {
                     await profileCubit.logOut(context: context);
                    },
                    child:  Text(
                      'LOG OUT'.tr(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                   SizedBox(height: 20.h),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
