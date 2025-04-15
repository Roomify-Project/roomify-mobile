import 'package:flutter/material.dart';
import 'package:rommify_app/core/theming/colors.dart';
import 'package:rommify_app/features/profile/widget/custom_app_bar.dart';
import 'package:rommify_app/features/profile/widget/custom_button.dart';
import 'package:rommify_app/features/profile/widget/custom_dialog_widget.dart';
import 'package:rommify_app/features/profile/widget/custom_text_field.dart';
import 'package:rommify_app/features/profile/widget/profile_image.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.colorPrimary,
      appBar: CustomAppBar(
        onClose: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const ProfileImage(),
            const SizedBox(height: 40),
            CustomTextField(
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
              hint: 'PHONE NUMBER',
              keyboardType: TextInputType.phone,
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
              onPressed: () {},
              color: const Color(0xff320c39),
              width: 147,
              height: 47,
            ),
            const SizedBox(height: 40),
            TextButton(
              onPressed: () {},
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
        ),
      ),
    );
  }
}