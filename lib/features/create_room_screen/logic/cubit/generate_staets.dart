


import '../../data/models/generate_body.dart';
import '../../data/models/generate_image_response.dart';
import '../../data/models/generate_more_response.dart';

abstract class GenerateStates{}
class GenerateInitialState extends GenerateStates{}
//// add post
class GenerateLoadingState extends GenerateStates{}
class  GenerateSuccessState extends GenerateStates{
}
class GenerateErrorState extends GenerateStates{
  final String message;

  GenerateErrorState({required this.message});
}

class ChangeRoomTypeState extends GenerateStates{}

class ChangeRoomDesignState extends GenerateStates{}
class GenerateValidationErrorState extends GenerateStates {
  final String message;
  GenerateValidationErrorState({required this.message});
}


/// upload image
class UploadImageGenerateState extends GenerateStates{}

