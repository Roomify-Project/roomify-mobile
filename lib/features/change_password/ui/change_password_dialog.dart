import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:rommify_app/features/change_password/logic/cubit/change_password_cubit.dart';
import 'package:rommify_app/features/change_password/logic/cubit/change_password_states.dart';
import 'package:rommify_app/features/profile/widget/custom_text_field.dart';
import '../../../../core/widgets/flutter_show_toast.dart';

class ChangePasswordDialog extends StatelessWidget {
  const ChangePasswordDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChangePasswordCubit, ChangePasswordStates>(
      listener: (context, state) {
        if (state is ChangePasswordLoadingState) {
          EasyLoading.show();
        } else if (state is ChangePasswordSuccessState) {
          EasyLoading.dismiss();
          Navigator.pop(context);
          flutterShowToast(
              message: state.message, toastCase: ToastCase.success);
        } else if (state is ChangePasswordErrorState) {
          EasyLoading.dismiss();
          flutterShowToast(message: state.message, toastCase: ToastCase.error);
        }
      },
      builder: (context, state) {
        final cubit = ChangePasswordCubit.get(context);
        
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 18),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 100,
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Container(
                    width: 368,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                    decoration: BoxDecoration(
                      color: const Color(0xff210426),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 20),
                        CustomTextField(
                          controller: cubit.currentPasswordController,
                          hint: 'OLD PASSWORD'.tr(),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your old password'.tr();
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        CustomTextField(
                          controller: cubit.newPasswordController,
                          hint: 'NEW PASSWORD'.tr(),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your new password'.tr();
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        CustomTextField(
                          controller: cubit.confirmNewPasswordController,
                          hint: 'CONFIRM NEW PASSWORD'.tr(),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your new password'.tr();
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: 147,
                          height: 47,
                          child: ElevatedButton(
                            onPressed: () => cubit.changePassword(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF320C39),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(17),
                              ),
                            ),
                            child:  Text(
                              'CONFIRM'.tr(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 31, // Adjusted position
                child: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Text(
                      '×',
                      style: TextStyle(
                        color: Color(0xFF311b35),
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        height: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}