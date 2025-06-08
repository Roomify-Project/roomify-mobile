import 'dart:io';

import 'package:dio/dio.dart';
import 'package:rommify_app/core/networking/api_networking.dart';

import '../model/send_message_body.dart';

class ChatApiService {
  final Dio dio;
  ChatApiService({required this.dio});
  Future<Response> sendMessage({required SendChatMessageBody sendChatMessage,required File? image}) async {
    print("imageeee ${image}");
    final formData = FormData.fromMap({
      'senderId': sendChatMessage.senderId,
      'receiverId': sendChatMessage.receiverId,
      'message': sendChatMessage.message,
      if(image!=null)
      'File': await MultipartFile.fromFile(image.path, filename: 'upload.jpg'),
    });
    final response= await dio.post(
       ApiConstants.sendMessage,
       data:formData,
      options: Options(
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      ),
   );
     return  response;
  }

  Future<Response> getMessage({required String receiverId}) async {
    final response= await dio.get(ApiConstants.getMessage(receiverId: receiverId));
    return  response;
  }
  Future<Response> getAllChats() async {
    final response= await dio.get(ApiConstants.getAllChats);
    return  response;
  }

}
