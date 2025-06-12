import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:rommify_app/core/helpers/constans.dart';
import 'package:rommify_app/core/helpers/shared_pref_helper.dart';
import 'package:rommify_app/features/chat/data/model/send_message_body.dart';
import 'package:rommify_app/features/chat/data/repos/chat_repo.dart';
import 'package:rommify_app/features/profile/data/models/get_all_chats_response.dart';

import '../../../../core/widgets/signal_R_service.dart';
import '../../../../core/widgets/signal_r_notification.dart';
import '../../../log_in/data/models/login_response.dart';
import '../../data/model/get_message_model.dart';
import 'chat_states.dart';

class ChatCubit extends Cubit<ChatStates> {
  final ChatRepo _chatRepo;

  ChatCubit(this._chatRepo) : super(ChatInitialStates());
  final ScrollController scrollController = ScrollController();

  GetMessageResponse? getMessagesResponse;
  GetAllChatResponse? getAllChatResponse;

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

  String? jsonString;
  LoginResponse? model;
  Map<String, dynamic> userMap = {};

  void sendMessage({required String receiverId, String? messageNotSent}) async {
    DateTime currentDateTime = DateTime.now();

    if (messageController.text.isEmpty && imageFile == null) {
      return;
    }
    if (jsonString == null) {
      jsonString = await SharedPrefHelper.get<String>(key: SharedPrefKey.data);
      Map<String, dynamic> userMap = jsonDecode(jsonString!);
      model = LoginResponse.fromJson(userMap);
    }
    GetMessageResponseData getMessageResponse = GetMessageResponseData(
        messageId: (i++).toString(),
        senderId: SharedPrefHelper.getString(SharedPrefKey.userId),
        content: messageNotSent ?? messageController.text,
        sentAt: currentDateTime.toString(),
        attachmentUrl: imageFile);
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
        message: getMessageResponse.content,
      ),
      image: getMessageResponse.attachmentUrl,
    );

    response.fold(
      (left) {
        isSent = false;
        emit(SendMessagesErrorStates());
      },
      (right) async {
        print("iiiii ${i}");

        isSent = true;
        int index = getMessagesResponse!.messages.indexWhere(
          (element) => element.messageId == getMessageResponse.messageId,
        );
        if (index != -1) {
          final updatedResponse = getMessageResponse.copyWith(
              messageId: right.messageData.messageId);
          getMessagesResponse!.messages[index] = updatedResponse;
          checkSendMessage[updatedResponse.messageId] = true;
        }
        print("sendddddddd");
        NotificationSignalRService.sendPushNotification(
          title: '${SharedPrefHelper.getString(SharedPrefKey.name)}',
          body: getMessageResponse.content,
          userId: receiverId,
          messageId: right.messageData.messageId,
          chatId: await SharedPrefHelper.getString(SharedPrefKey.userId),
          userName: model!.userName,
          userImage: await SharedPrefHelper.getString(SharedPrefKey.image),
          role: model!.roles,
          image: right.messageData.attachmentUrl,
          bio: model!.userName,
          email: model!.userName,
        );

        // ✅ تحديث كل الشاتات بناءً على الرسائل
        if (getAllChatResponse != null) {
          List<GetAllChatResponseData> updatedChats =
              getAllChatResponse!.chats.map((chat) {
            if (chat.chatWithUserId == receiverId) {
              return chat.copyWith(
                lastMessageContent:getMessageResponse.content.isEmpty&&right.messageData.attachmentUrl!=null?
                "Send photo":
                getMessageResponse.content,
                lastMessageTime: currentDateTime.toString(),
              );
            }
            return chat;
          }).toList();

          // ✅ تحديث الكائن الأساسي
          getAllChatResponse = GetAllChatResponse(chats: updatedChats);
        }

        emit(SendMessagesSuccessStates());
      },
    );
  }

  bool isListen = false;

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
        if (isListen == false) {
          listenToData();
        }

        emit(GetMessagesSuccessStates());
      },
    );
  }

  Future<void> listenToData() async {
    DateTime currentDateTime = DateTime.now();

    print("listeennnn");
    _subscription = friendChatStream?.listen(
      (getMessageListenResponse) {
        // final getMessage = GetMessageResponse.fromJson(getMessageResponse);
        print("dataaaa ${getMessageListenResponse}");
        final getMessage =
            GetMessageResponseData.fromJson(getMessageListenResponse);
        getMessagesResponse!.messages.add(getMessage);
        if (getAllChatResponse != null) {
          List<GetAllChatResponseData> updatedChats =
              getAllChatResponse!.chats.map((chat) {
            print("senderIdddddddddddd${getMessage.senderId}");
            print("chatWithUserId${chat.chatWithUserId}");
            if (chat.chatWithUserId == getMessage.senderId) {
              return chat.copyWith(
                lastMessageContent:getMessage.content.isEmpty&&getMessage.attachmentUrl!=null?
              "Send photo":getMessage.content,
                lastMessageTime: currentDateTime.toString(),
              );
            }
            return chat;
          }).toList();

          // ✅ تحديث الكائن الأساسي
          getAllChatResponse = GetAllChatResponse(chats: updatedChats);
        }
        if (!isClosed) {
          isListen = true;
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

  void getAllChats() async {
    emit(GetAllChatsLoadingStates());
    final data = await _chatRepo.getAllChats();
    data.fold(
      (left) {
        emit(GetAllChatsErrorStates(error: left.apiErrorModel.title));
      },
      (right) {
        print("yesss");

        getAllChatResponse = right;

        emit(GetAllChatsSuccessStates());
      },
    );
  }

  void deleteMessage(
      {required String messageId, required String recievdId}) async {
    DateTime currentDateTime = DateTime.now();

    print("iiiii ${i}");
    emit(DeleteMessageLoadingStates());
    final data = await _chatRepo.deleteMessage(messageId: messageId);
    data.fold(
      (left) {
        emit(DeleteMessageErrorStates(error: left.apiErrorModel.title));
      },
      (right) async {
        final index = getMessagesResponse!.messages
            .indexWhere((msg) => msg.messageId == messageId);

        if (index != -1) {
          final updatedMessage = getMessagesResponse!.messages[index].copyWith(
            content: "🚫 you deleted this message",
            attachmentUrl: "",
          );

          print("attachmentUrlllllllll ${updatedMessage.attachmentUrl}");
          getMessagesResponse!.messages[index] = updatedMessage;
          if (getAllChatResponse != null &&
              getMessagesResponse!.messages.last.messageId == messageId) {
            List<GetAllChatResponseData> updatedChats =
                getAllChatResponse!.chats.map((chat) {
              // print("senderIdddddddddddd${getMessage.senderId}");
              // print("chatWithUserId${chat.chatWithUserId}");
              if (chat.chatWithUserId == recievdId) {
                return chat.copyWith(
                  lastMessageContent: "🚫 you deleted this message",
                  lastMessageTime: currentDateTime.toString(),
                );
              }
              return chat;
            }).toList();
            print("message updateddd");
            // ✅ تحديث الكائن الأساسي
            getAllChatResponse = GetAllChatResponse(chats: updatedChats);
          }
          print('Message updated!');
        } else {
          print('Message not found');
        }
        NotificationSignalRService.sendPushNotification(
          title: '${SharedPrefHelper.getString(SharedPrefKey.name)}',
          body: "message is deleted",
          userId: recievdId,
          messageId: messageId,
          chatId: await SharedPrefHelper.getString(SharedPrefKey.userId),
          userName: model!.userName,
          userImage: await SharedPrefHelper.getString(SharedPrefKey.image),
          role: model!.roles,
          bio: model!.userName,
          email: model!.userName,
        );

        emit(DeleteMessageSuccessStates(messgae: right));
      },
    );
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
  String formatChatTime(String timeString) {
    final dateTime = DateTime.parse(timeString);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    final diff = now.difference(dateTime);

    final timeFormat = DateFormat.jm(); // Example: 9:00 AM

    if (messageDate == today) {
      return "Today ${timeFormat.format(dateTime)}";
    } else if (messageDate == yesterday) {
      return "Yesterday ${timeFormat.format(dateTime)}";
    } else if (diff.inDays < 7) {
      return "${DateFormat.EEEE().format(dateTime)} ${timeFormat.format(dateTime)}"; // e.g. Monday 3:00 PM
    } else if (diff.inDays < 14) {
      return "Last week";
    } else {
      return DateFormat.yMd()
          .add_jm()
          .format(dateTime); // e.g. 6/5/2025 12:38 PM
    }
  }

  String formatTimeOnly(String timeString) {
    final dateTime = DateTime.parse(timeString);
    return DateFormat.jm().format(dateTime); // مثال: 3:45 PM
  }
}
