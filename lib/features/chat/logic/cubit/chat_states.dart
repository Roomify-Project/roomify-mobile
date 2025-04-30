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




