import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rommify_app/core/helpers/constans.dart';
import 'package:rommify_app/core/helpers/shared_pref_helper.dart';
import 'package:rommify_app/features/chat/data/model/send_message_body.dart';
import 'package:rommify_app/features/chat/data/repos/chat_repo.dart';

import '../../../../core/widgets/signal_R_service.dart';
import '../../data/model/get_message_model.dart';
import 'chat_states.dart';

class ChatCubit extends Cubit<ChatStates> {
  final ChatRepo _chatRepo;

  ChatCubit(this._chatRepo) : super(ChatInitialStates());
  final ScrollController scrollController = ScrollController();

  GetMessageResponse? getMessagesResponse;

  TextEditingController messageController = TextEditingController();
  StreamSubscription<Map<String, dynamic>>? _subscription;
  StreamSubscription? _subscriptionInternet;

  StreamSubscription<String>? _subscriptionString;

  Stream<String>? get friendChatStreamString =>
      SignalRService.friendChatStreamString;

  static ChatCubit get(context) => BlocProvider.of<ChatCubit>(context);

  Stream<Map<String, dynamic>>? get friendChatStream =>
      SignalRService.friendChatStream;

  bool isSent = true;
  Map<String, bool> checkSendMessage = {};
  Map<String, String> messageNotSend = {};

  int i = 0;
  DateTime currentDateTime = DateTime.now();
  File? imageFile;

  void pickImage({required ImageSource source}) async {
    final picked = await ImagePicker().pickImage(source: source);
    if (picked != null) {
      imageFile = File(picked.path);
      emit(UploadImageState());
    }
  }

  void clearImage() async {
    imageFile = null;
    emit(UploadImageState());
  }
  void sendMessage({required String receiverId, String? messageNotSent}) async {
    if(messageController.text.isEmpty&&imageFile==null){
      return;
    }

    GetMessageResponseData getMessageResponse = GetMessageResponseData(
        messageId: (i++).toString(),
        senderId: SharedPrefHelper.getString(SharedPrefKey.userId),
        content: messageNotSent ?? messageController.text,
        sentAt: currentDateTime.toString(), attachmentUrl: imageFile);
    print("imaggeeee ${getMessageResponse.attachmentUrl}");

    checkSendMessage[getMessageResponse.messageId] = false;
    messageNotSend[getMessageResponse.messageId] = messageController.text;
    // print(getMessageResponse.text);
    if (messageNotSent == null) {
      getMessagesResponse?.messages.add(getMessageResponse);
      messageController.clear();
      clearImage();
      emit(UploadMessageState());
    }
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (scrollController.hasClients) {
    //     scrollToBottom();
    //   }
    // });
    final response = await _chatRepo.sendMessage(
        sendChatMessageBody: SendChatMessageBody(
            senderId: await SharedPrefHelper.getString(SharedPrefKey.userId),
            receiverId: receiverId,
            message:
            getMessageResponse.content,
        ), image: getMessageResponse.attachmentUrl,

    );


    response.fold(
          (left) {
        isSent = false;
        emit(SendMessagesErrorStates());
      },
          (right) {
        isSent = true;
        checkSendMessage[getMessageResponse.messageId] = true;
        emit(SendMessagesSuccessStates());
      },
    );
  }

  void getMessages({required receiverId}) async {
    emit(GetMessagesLoadingStates());
    final data = await _chatRepo.getMessage(receiverId: receiverId);
    data.fold(
          (left) {
        emit(GetMessagesErrorStates(error: left.apiErrorModel.title));
      },
          (right) {
        print("yesss");

        getMessagesResponse = right;
        for (var item in getMessagesResponse!.messages) {
          checkSendMessage[item.messageId] = true;
        }
        checkInternet(receiverId: receiverId);
        listenToData();

        emit(GetMessagesSuccessStates());
      },
    );
  }

  Future<void> listenToData() async {
    print("listeennnn");
    _subscription = friendChatStream?.listen(
          (getMessageListenResponse) {
        // final getMessage = GetMessageResponse.fromJson(getMessageResponse);
        print("dataaaa ${getMessageListenResponse}");
        final getMessage = GetMessageResponseData.fromJson(getMessageListenResponse);
        getMessagesResponse!.messages.add(getMessage);
        if (!isClosed) {
          emit(GetMessagesSuccessStates());
        }
      },
    );
  }

  bool emojiShowing = false;

  void changeEmojiState() {
    emojiShowing = !emojiShowing;
    print("emojeeee ${emojiShowing}");
    emit(ChangeEmojiState());
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    messageController.dispose();
    scrollController.dispose();
    return super.close();
  }

  void checkInternet({required String receiverId}) async {
    _subscriptionInternet =
        Connectivity().onConnectivityChanged.listen((result) {
          if (result.contains(ConnectivityResult.wifi) ||
              result.contains(ConnectivityResult.mobile)) {
            if (isSent == false) {
              final List<String> keysToSend = checkSendMessage.entries
                  .where((entry) => entry.value == false)
                  .map((entry) => entry.key)
                  .toList();

              for (var key in keysToSend) {
                print('valueeeee $key');
                sendMessage(
                  receiverId: receiverId,
                  messageNotSent: messageNotSend[key],
                );
                checkSendMessage[key] = true;
              }
              isSent = true;
              emit(SendMessagesInternetSuccessStates());
            }
          }
        });
  }


  // void scrollToBottom() {
  //   scrollController.animateTo(
  //     scrollController.position.maxScrollExtent,
  //     duration: Duration(milliseconds: 300),
  //     curve: Curves.easeOut,
  //   );
  // }

  // void scrollToBottom() {
  //   // Verify the controller is attached to a scroll view first
  //   if (!scrollController.hasClients) {
  //     // If controller isn't ready, retry after a short delay
  //     Future.delayed(const Duration(milliseconds: 50), scrollToBottom);
  //     return;
  //   }
  //
  //   // Log for debugging
  //   print("Scrolling to bottom");
  //
  //   // Function to perform the actual scroll
  //   void performScroll() {
  //     if (!scrollController.hasClients) return;
  //
  //     // Calculate maximum scroll extent plus extra buffer
  //     final maxScroll = scrollController.position.maxScrollExtent;
  //     final targetPosition = maxScroll + 100;
  //
  //     scrollController.animateTo(
  //       targetPosition,
  //       duration: const Duration(milliseconds: 300),
  //       curve: Curves.easeOut,
  //     );
  //   }
  //
  //   // Initial scroll
  //   performScroll();
  //
  //   // Wait for layout to complete and any new content to render
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     performScroll();
  //
  //     // One final scroll after a delay to ensure images and content are loaded
  //     Future.delayed(const Duration(milliseconds: 500), performScroll);
  //   });
  // }
}