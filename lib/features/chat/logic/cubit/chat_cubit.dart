import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/signal_R_service.dart';
import '../../data/model/get_message_model.dart';
import 'chat_states.dart';

class ChatCubit extends Cubit<ChatStates> {

  ChatCubit() : super(ChatInitialStates());
  final ScrollController scrollController = ScrollController();

  List<GetMessageResponse> getMessagesResponse=[];
  TextEditingController messageController = TextEditingController();
  StreamSubscription<Map<String, dynamic>>? _subscription;
  StreamSubscription<String>? _subscriptionString;

  static ChatCubit get(context) => BlocProvider.of<ChatCubit>(context);

  Stream<Map<String, dynamic>>? get friendChatStream =>
      SignalRService.friendChatStream;
  Stream<String>? get friendChatStreamString =>
      SignalRService.friendChatStreamString;
  bool isSent=false;
Map<int,bool> checkSendMessage={};


  void sendMessage(
      {required GetMessageResponse getMessageResponse}) async {
    // checkSendMessage[getMessageResponse.id!]=false;
    print(getMessageResponse.text);
    getMessagesResponse.add(getMessageResponse);
    listenToData();

    print("itemmm ${getMessagesResponse.first.text}");

    emit(GetMessagesSuccessStates());

    // final data = await chatRepo.sendMessage(
    //     sendMessageRequestBody: SendMessageRequestBody(
    //         friendShipId: friendShipId, message: messageController.text));
    // data.when(success: (value) {
    //   checkSendMessage[getMessageResponse.id!]=true;
    //   emit(SendMessagesSuccessStates());
    // }, failure: (error) {
    //
    //   emit(SendMessagesErrorStates());
    // });
  }

  // void getMessages({required chatId}) async {
  //     emit(GetMessagesLoadingStates());
  //     final data = await chatRepo.getMessage(chatId: chatId);
  //     data.when(success: (value) {
  //       print("yesss");
  //       getMessagesResponse = value;
  //       for(var item in getMessagesResponse!)
  //       {
  //         checkSendMessage[item.id!]=true;
  //       }
  //       listenToData();
  //       emit(GetMessagesSuccessStates());
  //     }, failure: (error) {
  //       print("nooo");
  //
  //       emit(GetMessagesErrorStates(error: error.apiErrorModel.title ?? ''));
  //     });
  //
  // }

  Future<void> listenToData() async {
    print("listeennnn");
    _subscriptionString= friendChatStreamString?.listen(
      (getMessageResponse) {
        // final getMessage = GetMessageResponse.fromJson(getMessageResponse);
        print("dataaaa $getMessageResponse");
        getMessagesResponse.add(GetMessageResponse(text: getMessageResponse));
        emit(GetMessagesSuccessStates());
      },
    );
  }
  bool emojiShowing=false;

  void changeEmojiState()
  {
    emojiShowing = !emojiShowing;
    emit(ChangeEmojiState());
  }


  @override
  Future<void> close() {
    _subscription?.cancel();
    messageController.dispose();
    return super.close();
  }
}
