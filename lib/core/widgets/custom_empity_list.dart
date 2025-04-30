import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomEmptyList extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final String? imagePath;
  final VoidCallback? onRefresh;

  const CustomEmptyList({
    Key? key,
    this.title = "No Data Found",
    this.subtitle = "It seems there are no items to display at the moment",
    this.imagePath,
    this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Custom Image or Lottie Animation
              Container(
                height: 200,
                width: 200,
                child: imagePath != null
                    ? Image.asset(
                  imagePath!,
                  fit: BoxFit.contain,
                )
                    : Image.asset(
                  'assets/images/empty_list.png', // Add your default empty state image
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 32),

              // Title
              Text(
                title!,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Subtitle
              Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Refresh Button
              if (onRefresh != null)
                ElevatedButton.icon(
                  onPressed: onRefresh,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Refresh'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// Alternative version with animation
class AnimatedEmptyList extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final String? lottieAnimationPath;
  final VoidCallback? onRefresh;

  const AnimatedEmptyList({
    Key? key,
    this.title = "No Data Found",
    this.subtitle = "It seems there are no items to display at the moment",
    this.lottieAnimationPath,
    this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Lottie Animation
              if (lottieAnimationPath != null)
                Lottie.asset(
                  lottieAnimationPath!,
                  height: 200,
                  repeat: true,
                ),

              const SizedBox(height: 32),

              // Title with gradient
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).colorScheme.secondary,
                  ],
                ).createShader(bounds),
                child: Text(
                  title!,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 16),

              // Subtitle
              Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // Animated Refresh Button
              if (onRefresh != null)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).colorScheme.secondary,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).primaryColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: onRefresh,
                        borderRadius: BorderRadius.circular(12),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.refresh_rounded,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Refresh',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// Usage Example:
class MyListView extends StatelessWidget {
  final List<dynamic> items;

  const MyListView({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return CustomEmptyList(
        title: "No Posts Yet",
        subtitle: "Be the first one to create a post!",
        imagePath: "assets/images/empty_posts.png",
        onRefresh: () {
          // Implement refresh logic
        },
      );
    }

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(items[index].toString()),
        );
      },
    );
  }
}

// Alternative usage with animation:
class MyAnimatedListView extends StatelessWidget {
  final List<dynamic> items;

  const MyAnimatedListView({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return AnimatedEmptyList(
        title: "No Posts Yet",
        subtitle: "Be the first one to create a post!",
        lottieAnimationPath: "assets/animations/empty_state.json",
        onRefresh: () {
          // Implement refresh logic
        },
      );
    }

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(items[index].toString()),
        );
      },
    );
  }
}