import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rommify_app/core/helpers/extensions.dart';
import 'package:rommify_app/core/theming/styles.dart';
import 'package:rommify_app/features/chat/logic/cubit/chat_cubit.dart';
import 'package:rommify_app/features/profile/data/models/get_all_chats_response.dart';
import 'package:rommify_app/features/profile/data/models/get_profile_data.dart';

import '../../../core/routing/routes.dart';
import '../../../core/theming/colors.dart';
import '../../../core/widgets/custom_chached_network_image.dart';
import '../../../core/widgets/custom_empity_list.dart';
import '../../../core/widgets/custom_error.dart';
import '../../../core/widgets/custom_shimmer.dart';
import '../logic/cubit/chat_states.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    ChatCubit.get(context).getAllChats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatStates>(
      buildWhen: (previous, current) =>
          current is GetAllChatsLoadingStates ||
          current is GetAllChatsSuccessStates ||
          current is GetAllChatsErrorStates ||
          current is SendMessagesSuccessStates ||
          current is GetMessagesSuccessStates ||
          current is DeleteMessageSuccessStates,
      builder: (BuildContext context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: ColorsManager.colorPrimary,
            leading: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            centerTitle: true,
            title: Text(
              'Chats',
              style: TextStyles.font18WhiteRegular,
            ),
          ),
          backgroundColor: ColorsManager.mainColor,
          body: state is GetAllChatsLoadingStates
              ? Padding(
                  padding: EdgeInsets.only(top: 50.h),
                  child: const Center(child: CustomShimmerEffect()),
                )
              : ChatCubit.get(context).getAllChatResponse!.chats.isEmpty ||
                      ChatCubit.get(context).getAllChatResponse == null
                  ? const Center(
                      child: AnimatedEmptyList(
                        title: "No Following Found",
                        lottieAnimationPath:
                            'assets/animation/empity_list.json',
                      ),
                    )
                  : state is GetAllChatsErrorStates
                      ? Center(
                          child: AnimatedErrorWidget(
                            title: "Loading Error",
                            message: state.error ?? "No data available",
                            lottieAnimationPath: 'assets/animation/error.json',
                            // onRetry: () => postsCubit.getAllPosts(),
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.only(
                              top: 30.h, right: 23.w, left: 23.w),
                          child: ListView.separated(
                            itemCount: ChatCubit.get(context)
                                .getAllChatResponse!
                                .chats
                                .length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                  onTap: () {},
                                  child: ChatItem(
                                    getAllChatResponseData:
                                        ChatCubit.get(context)
                                            .getAllChatResponse!
                                            .chats[index],
                                  ));
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return SizedBox(
                                height: 30.h,
                              );
                            },
                          ),
                        ),
        );
      },
    );
  }
}

class ChatItem extends StatelessWidget {
  final GetAllChatResponseData getAllChatResponseData;

  const ChatItem({super.key, required this.getAllChatResponseData});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.pushNamed(Routes.chatsFriendsScreen, arguments: {
          'getProfileDataModel': GetProfileDataModel(
              id: getAllChatResponseData.chatWithUserId,
              userName: getAllChatResponseData.chatWithName,
              fullName: getAllChatResponseData.chatWithName,
              bio: getAllChatResponseData.chatWithName,
              profilePicture: getAllChatResponseData.chatWithImageUrl,
              email: getAllChatResponseData.chatWithName,
              role: getAllChatResponseData.chatWithName,
              emailConfirmed: true)
        });
      },
      child: Row(
        children: [
          Container(
            width: 50.w,
            height: 50.h,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: ClipOval(
                child: CustomCachedNetworkImage(
              imageUrl: getAllChatResponseData.chatWithImageUrl,
              isDefault: true,
              fit: BoxFit.cover,
              isZoom: true,
            )),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getAllChatResponseData.chatWithName
                      .split(' ')
                      .take(2)
                      .join(' '),
                  style: TextStyles.font19WhiteBold
                      .copyWith(fontWeight: FontWeight.w700),
                ),
                Text(
                  getAllChatResponseData.lastMessageContent,
                  style: TextStyles.font19WhiteBold.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 16.sp,
                      color: Colors.white54),
                ),
              ],
            ),
          ),
          Text(
            ChatCubit.get(context)
                .formatChatTime(getAllChatResponseData.lastMessageTime),
            style: TextStyle(
              color: Colors.white54,
              fontSize: 10.3.sp,
            ),
          ),
        ],
      ),
    );
  }
}
