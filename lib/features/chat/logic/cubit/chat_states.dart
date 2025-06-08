abstract class ChatStates {}

class ChatInitialStates extends ChatStates {}
// class ChatInitialStates extends ChatStates{}

//// Get message
class GetMessagesLoadingStates extends ChatStates {}

class GetMessagesSuccessStates<T> extends ChatStates {}

class GetMessagesErrorStates extends ChatStates {
  final String error;

  GetMessagesErrorStates({required this.error});
}

class ChangeEmojiState extends ChatStates{}


// send message
class SendMessagesSuccessStates extends ChatStates {}

class SendMessagesErrorStates extends ChatStates {}


///
class SendMessagesInternetSuccessStates extends ChatStates {}

class UploadImageState extends ChatStates {}
class UploadMessageState extends ChatStates {}


/// get all chats
class GetAllChatsLoadingStates extends ChatStates {}

class GetAllChatsSuccessStates extends ChatStates {}

class GetAllChatsErrorStates extends ChatStates {
  final String error;

  GetAllChatsErrorStates({required this.error});
}

