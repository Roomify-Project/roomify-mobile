import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomErrorWidget extends StatelessWidget {
  final String? title;
  final String? message;
  final String? imagePath;
  final VoidCallback? onRetry;
  final String? buttonText;
  final bool showImage;

  const CustomErrorWidget({
    Key? key,
    this.title = "Oops! Something went wrong",
    this.message = "An unexpected error occurred. Please try again later.",
    this.imagePath,
    this.onRetry,
    this.buttonText = "Try Again",
    this.showImage = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (showImage) ...[
            Container(
              height: 200,
              width: 200,
              child: imagePath != null
                  ? Image.asset(
                imagePath!,
                fit: BoxFit.contain,
              )
                  : Image.asset(
                'assets/images/error.png', // Add your default error image
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 40),
          ],

          // Error Icon with Animation
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 800),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.error_outline_rounded,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),

          // Error Title
          Text(
            title!,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Error Message
          Text(
            message!,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // Retry Button
          if (onRetry != null)
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.refresh),
                  const SizedBox(width: 8),
                  Text(buttonText!),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// Animated version with more features
class AnimatedErrorWidget extends StatefulWidget {
  final String? title;
  final String? message;
  final String? lottieAnimationPath;
  final VoidCallback? onRetry;
  final VoidCallback? onContactSupport;
  final String? buttonText;

  const AnimatedErrorWidget({
    Key? key,
    this.title = "Oops! Something went wrong",
    this.message = "An unexpected error occurred. Please try again later.",
    this.lottieAnimationPath,
    this.onRetry,
    this.onContactSupport,
    this.buttonText = "Try Again",
  }) : super(key: key);

  @override
  State<AnimatedErrorWidget> createState() => _AnimatedErrorWidgetState();
}

class _AnimatedErrorWidgetState extends State<AnimatedErrorWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Lottie Animation
            if (widget.lottieAnimationPath != null)
              ScaleTransition(
                scale: _scaleAnimation,
                child: Lottie.asset(
                  widget.lottieAnimationPath!,
                  height: 200,
                  repeat: true,
                ),
              ),
      
            const SizedBox(height: 32),
      
            // Error Icon with Pulse Animation
            FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.2),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.error_outline_rounded,
                  color: Colors.red,
                  size: 48,
                ),
              ),
            ),
      
            const SizedBox(height: 24),
      
            // Error Title with Gradient
            FadeTransition(
              opacity: _fadeAnimation,
              child: ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [
                    Colors.red,
                    Colors.red.shade800,
                  ],
                ).createShader(bounds),
                child: Text(
                  widget.title!.tr(),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
      
            const SizedBox(height: 16),
      
            // Error Message
            FadeTransition(
              opacity: _fadeAnimation,
              child: Text(
                widget.message!,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ),
      
            const SizedBox(height: 32),
      
            // Action Buttons
            FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  if (widget.onRetry != null)
                    ElevatedButton(
                      onPressed: widget.onRetry,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.refresh),
                          const SizedBox(width: 8),
                          Text(widget.buttonText!),
                        ],
                      ),
                    ),
                  if (widget.onContactSupport != null) ...[
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: widget.onContactSupport,
                      child: const Text('Contact Support'),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Usage Example:
class MyErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomErrorWidget(
          title: "Network Error",
          message: "Please check your internet connection and try again.",
          imagePath: "assets/images/network_error.png",
          onRetry: () {
            // Implement retry logic
          },
        ),
      ),
    );
  }
}

// Usage Example with Animation:
class MyAnimatedErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedErrorWidget(
          title: "Network Error",
          message: "Please check your internet connection and try again.",
          lottieAnimationPath: "assets/animations/network_error.json",
          onRetry: () {
            // Implement retry logic
          },
          onContactSupport: () {
            // Implement contact support logic
          },
        ),
      ),
    );
  }
}