import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rommify_app/core/di/dependency_injection.dart';
import 'package:rommify_app/core/helpers/constans.dart';
import 'package:rommify_app/core/helpers/shared_pref_helper.dart';
import 'package:rommify_app/core/theming/colors.dart';
import 'package:rommify_app/core/widgets/custom_chached_network_image.dart';
import 'package:rommify_app/core/widgets/custom_shimmer.dart';
import 'package:rommify_app/features/chat/data/model/get_message_model.dart';
import 'package:rommify_app/features/chat/data/repos/chat_repo.dart';
import 'package:rommify_app/features/chat/logic/cubit/chat_cubit.dart';
import 'package:rommify_app/features/chat/logic/cubit/chat_states.dart';
import 'package:rommify_app/features/chat/ui/widget/build_message_widet.dart';

import '../../../core/theming/styles.dart';
import '../../../core/widgets/custom_error.dart';
import '../../profile/data/models/get_profile_data.dart';

class ChatFriendScreen extends StatefulWidget {
  final GetProfileDataModel getProfileDataModel;

  const ChatFriendScreen({super.key, required this.getProfileDataModel});

  @override
  State<ChatFriendScreen> createState() => _ChatFriendScreenState();
}

class _ChatFriendScreenState extends State<ChatFriendScreen> {
  @override
  void initState() {
    // TODO: implement initState
    ChatCubit.get(context).getMessages(receiverId: widget.getProfileDataModel.id);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatStates>(
      builder: (BuildContext context, state) {
        final chatCubit = ChatCubit.get(context);
        if(state is GetMessagesLoadingStates){
          return Scaffold(
            backgroundColor: ColorsManager.colorPrimary,
            body: Padding(
              padding:  EdgeInsets.only(top: 30.h),
              child: const CustomShimmerEffect(),
            ),
          );
        }
        if(state is GetMessagesErrorStates){
          return Center(
            child: AnimatedErrorWidget(
              title: "Loading Error",
              message: state.error,
              lottieAnimationPath:
              'assets/animation/error.json',
              onRetry: () {
                chatCubit.getMessages(
                    receiverId: widget.getProfileDataModel.id);
              },
            ),
          );
        }
        if(chatCubit.getMessagesResponse!=null) {
          return Scaffold(
            backgroundColor: ColorsManager.colorPrimary,
            appBar: AppBar(
              backgroundColor: ColorsManager.colorPrimary,
              elevation: 0,
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 12.r,
                  // backgroundImage: AssetImage('assets/profile_image.jpg'),
                  child: ClipOval(
                    child: CustomCachedNetworkImage(
                      width: double.infinity,
                        height: double.infinity,
                        imageUrl:widget.getProfileDataModel
                            .profilePicture ==
                            null ||
                            widget.getProfileDataModel
                                .profilePicture ==
                                ""
                            ? Constants.defaultImagePerson
                            : widget.getProfileDataModel
                            .profilePicture,
                    fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              title: Text(widget.getProfileDataModel.userName ?? "",
                style: TextStyles.font19WhiteBold.copyWith(
                    fontWeight: FontWeight.w700),),

            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    // controller: chatCubit.scrollController,
                    reverse: true, // هنا المهم - الليست هتبدأ من تحت
                    padding: const EdgeInsets.all(16),
                    itemCount: chatCubit.getMessagesResponse?.messages.length ?? 0,
                    itemBuilder: (context, index) {
                      // عكس الـ index عشان آخر رسالة تبقى فوق
                      int reversedIndex = (chatCubit.getMessagesResponse?.messages.length ?? 0) - 1 - index;

                      return MessageBubble(
                        message: chatCubit.getMessagesResponse?.messages[reversedIndex].content ?? "",
                        isMe: chatCubit.getMessagesResponse?.messages[reversedIndex].senderId ==
                            SharedPrefHelper.getString(SharedPrefKey.userId),
                        time: chatCubit.getMessagesResponse?.messages[reversedIndex].sentAt ?? "",
                        chatCubit: chatCubit,
                        messageId: chatCubit.getMessagesResponse!.messages[reversedIndex].messageId,
                        image: chatCubit.getMessagesResponse?.messages[reversedIndex].attachmentUrl ?? "",
                      );
                    },
                  ),
                ),
                buildMessageComposer(
                    chatCubit: chatCubit,
                    getProfileDataModel: widget.getProfileDataModel,
                    context: context,
                ),

              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}