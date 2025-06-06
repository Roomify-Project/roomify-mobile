class ImageActionsState {
  final bool isBookmarked;
  final bool isFavorited;
  final bool isDownloaded;

  const ImageActionsState({
    this.isBookmarked = false,
    this.isFavorited = false,
    this.isDownloaded = false,
  });

  ImageActionsState copyWith({
    bool? isBookmarked,
    bool? isFavorited,
    bool? isDownloaded,
  }) {
    return ImageActionsState(
      isBookmarked: isBookmarked ?? this.isBookmarked,
      isFavorited: isFavorited ?? this.isFavorited,
      isDownloaded: isDownloaded ?? this.isDownloaded,
    );
  }
}
