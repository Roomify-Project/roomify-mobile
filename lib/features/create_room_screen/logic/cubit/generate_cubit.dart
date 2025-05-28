import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rommify_app/core/helpers/constans.dart';
import 'package:rommify_app/core/helpers/extensions.dart';
import 'package:rommify_app/core/helpers/shared_pref_helper.dart';
import 'package:rommify_app/core/widgets/flutter_show_toast.dart';
import 'package:rommify_app/features/create_room_screen/data/models/generate_image_response.dart';


import '../../../../core/routing/routes.dart';
import '../../../explore_screen/logic/cubit/login_states.dart';
import '../../data/models/generate_body.dart';
import '../../data/repos/generate_repo.dart';
import 'generate_staets.dart';

class GenerateCubit extends Cubit<GenerateStates> {
  final GenerateRepo _generateRepo;

  GenerateCubit(this._generateRepo) : super(GenerateInitialState());

  static GenerateCubit get(context) => BlocProvider.of<GenerateCubit>(context);

  File? imageFile;
  String roomType="";
  String roomStyle="";
  String descriptionText="";
  final generateController=TextEditingController();
  GeneratedImagesResponse ?generatedImagesResponse;

  void pickImage({required ImageSource source}) async {
    final picked = await ImagePicker().pickImage(source: source);
    if (picked != null) {
      imageFile = File(picked.path);
      emit(UploadImageGenerateState());
    }
  }

  void clearImage() async {
    imageFile = null;
    emit(UploadImageGenerateState());
  }
  void setRoomType({required titleRoomType}){
    roomType=titleRoomType;
    emit(ChangeRoomTypeState());
  }
  void setDesignStyle({required designRoomType}){
    roomStyle=designRoomType;
    emit(ChangeRoomDesignState());
  }

  void generate({required BuildContext context}) async {
    if (imageFile == null) {
      emit(GenerateValidationErrorState(message: "Please upload an image."));
      // flutterShowToast(message: "Please upload an image.", toastCase: ToastCase.error);
      return;
    }

    if (generateController.text.trim().isEmpty) {
      emit(GenerateValidationErrorState(message: "Please enter a description."));
      // flutterShowToast(message: "Please enter a description.", toastCase: ToastCase.error);
      return;
    }

    if (roomType == '' || roomType.trim().isEmpty) {
      // flutterShowToast(message: "Please select room type.", toastCase: ToastCase.error);

      emit(GenerateValidationErrorState(message: "Please select room type."));
      return;
    }

    if (roomStyle == '' || roomStyle.trim().isEmpty) {
      emit(GenerateValidationErrorState(message: "Please select design style."));
      return;
    }

    emit(GenerateLoadingState());
    context.pushNamed(Routes.generateRoomScreen,arguments: {
      'generateCubit':this
    });

    final response = await _generateRepo.generate(
      imageFile: imageFile!,
      generateBodyModel: GenerateBodyModel(
        userId: await SharedPrefHelper.getString(SharedPrefKey.userId),
        roomType: roomType,
        roomStyle: roomStyle,
        descriptionText: generateController.text,
      ),
    );

    response.fold(
          (left) {
        emit(GenerateErrorState(message: left.apiErrorModel.title ?? ""));
      },
          (right) {
            generatedImagesResponse=right;
        emit(GenerateSuccessState(right));
      },
    );
  }
}
