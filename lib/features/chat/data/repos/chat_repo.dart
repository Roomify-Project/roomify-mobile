
import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:rommify_app/features/chat/data/model/get_message_model.dart';
import 'package:rommify_app/features/chat/data/model/send_message_body.dart';
import 'package:rommify_app/features/explore_screen/data/apis/posts_api_service.dart';
import 'package:rommify_app/features/explore_screen/data/models/get_posts_response.dart';

import '../../../../core/networking/api_error_handler.dart';
import '../apis/chat_api_service.dart';
class ChatRepo {
  final ChatApiService _chatApiService;

  ChatRepo(this._chatApiService);

  Future<Either<ErrorHandler,String>> sendMessage({required SendChatMessageBody sendChatMessageBody}) async {
    try {
      final response = await _chatApiService.sendMessage(sendChatMessage: sendChatMessageBody);
      return const Right("Message sent successfully.");
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


}
