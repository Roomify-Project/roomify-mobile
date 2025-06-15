import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rommify_app/core/helpers/extensions.dart';
import 'package:rommify_app/core/widgets/custom_shimmer.dart';
import 'package:rommify_app/features/explore_screen/logic/cubit/login_states.dart';

import '../../../core/routing/routes.dart';
import '../../../core/theming/colors.dart';
import '../../../core/theming/styles.dart';
import '../../../core/widgets/custom_chached_network_image.dart';
import '../logic/cubit/posts_cubit.dart';

class SearchUserScreen extends StatefulWidget {
  const SearchUserScreen({Key? key}) : super(key: key);

  @override
  State<SearchUserScreen> createState() => _SearchUserScreenState();
}

class _SearchUserScreenState extends State<SearchUserScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.trim().isNotEmpty) {
      PostsCubit.get(context).searchUser(query: query.trim());
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    PostsCubit.get(context).searchUserModel=null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.colorPrimary,
      appBar: AppBar(
        backgroundColor: ColorsManager.colorPrimary,
        leading: const Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
        centerTitle: true,
        title: Text(
          'Search'.tr(),
          style: TextStyles.font18WhiteRegular,
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              decoration: InputDecoration(
                hintText: 'Search for users...'.tr(),
                hintStyle: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 16,
                ),
                prefixIcon: IconButton(
                  icon: const Icon(Icons.search, color: Colors.grey),
                  onPressed: () => _performSearch(_searchController.text),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
              ),
              onChanged: (value) {
                setState(() {}); // للتحديث زي ظهور زر الـ clear
                if (value.trim().length > 1) {
                  _performSearch(value); // دي بتدير debounce داخل Cubit
                }
              },
              onSubmitted: _performSearch,
            ),
          ),

          // Search Results
          Expanded(
            child: BlocBuilder<PostsCubit, PostsStates>(
              builder: (context, state) {
                if (state is SearchUserLoadingState) {
                  return const Center(child: CustomShimmerEffect());
                }

                if (state is SearchUserErrorState) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          state.message,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.red[600],
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () =>
                              _performSearch(_searchController.text),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child:  Text('Retry'.tr(),
                        ),
                        )],
                    ),
                  );
                }

                if (state is SearchUserSuccessState) {
                  final cubit = PostsCubit.get(context);
                  final searchResults = cubit.searchUserModel;

                  if (searchResults == null ||
                      (searchResults.users.isEmpty ?? true)) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No results found'.tr(),
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try searching with different keywords'.tr(),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: searchResults.users.length,
                    itemBuilder: (context, index) {
                      final user = searchResults.users[index];
                      return ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: user.profilePicture != null
                            ? Container(
                                width: 50.w,
                                height: 50.h,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: ClipOval(
                                    child: CustomCachedNetworkImage(
                                  imageUrl: user.profilePicture!,
                                  fit: BoxFit.cover,
                                  isDefault: true,
                                )))
                            : CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.blue[100],
                                child: Text(
                                  user.userName.isNotEmpty == true
                                      ? user.userName[0].toUpperCase()
                                      : '?',
                                  style: TextStyle(
                                    color: Colors.blue[800],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                        title: Text(user.userName ?? 'Unknown user',
                            style: TextStyles.font18WhiteRegular),
                        subtitle: user.email != null
                            ? Text(
                                user.email!,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              )
                            : null,
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey[400],
                          size: 16,
                        ),
                        onTap: () {
                          context
                              .pushNamed(Routes.profile,arguments: {
                            'profileId': user.id
                          });
                        },
                      );
                    },
                  );
                }

                // Default state - show search prompt
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Search for users'.tr(),
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Enter a username or email'.tr(),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
