import 'dart:io';

import 'package:dio/dio.dart';
import 'package:rommify_app/core/networking/api_networking.dart';

import '../model/send_message_body.dart';

class ChatApiService {
  final Dio dio;
  ChatApiService({required this.dio});
  Future<Response> sendMessage({required SendChatMessageBody sendChatMessage}) async {
   final response= await dio.post(ApiConstants.sendMessage,
       data:{
     'SenderId':sendChatMessage.senderId,
     'ReceiverId':sendChatMessage.receiverId,
     'Message':sendChatMessage.message,
   });
     return  response;
  }

  Future<Response> getMessage({required String receiverId}) async {
    final response= await dio.get(ApiConstants.getMessage(receiverId: receiverId));
    return  response;
  }

}
