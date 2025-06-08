
import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:rommify_app/features/chat/data/model/get_message_model.dart';
import 'package:rommify_app/features/chat/data/model/send_message_body.dart';
import 'package:rommify_app/features/explore_screen/data/apis/posts_api_service.dart';
import 'package:rommify_app/features/explore_screen/data/models/get_posts_response.dart';

import '../../../../core/networking/api_error_handler.dart';
import '../../../profile/data/models/get_all_chats_response.dart';
import '../apis/chat_api_service.dart';
import '../model/send_message_response.dart';
class ChatRepo {
  final ChatApiService _chatApiService;

  ChatRepo(this._chatApiService);

  Future<Either<ErrorHandler,SendMessageResponse>> sendMessage({required SendChatMessageBody sendChatMessageBody,required File? image}) async {
    try {
      final response = await _chatApiService.sendMessage(sendChatMessage: sendChatMessageBody, image: image);
      return Right(SendMessageResponse.fromJson(response.data));
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }
  Future<Either<ErrorHandler,GetMessageResponse>> getMessage({required String receiverId}) async {
    try {
      final response = await _chatApiService.getMessage(receiverId: receiverId);
      return  Right(GetMessageResponse.fromJson(response.data));
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }
  Future<Either<ErrorHandler,GetAllChatResponse>> getAllChats() async {
    try {
      final response = await _chatApiService.getAllChats();
      return  Right(GetAllChatResponse.fromJson(response.data));
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }


}
