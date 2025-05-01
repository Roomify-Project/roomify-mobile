class GetFollowCountModel {
  final int followers;
  final int following;

  GetFollowCountModel({
    required this.followers,
    required this.following,
  });

  // Factory method to create object from JSON
  factory GetFollowCountModel.fromJson(Map<String, dynamic> json) {
    return GetFollowCountModel(
      followers: json['followers'],
      following: json['following'],
    );
  }

  // Convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      'followers': followers,
      'following': following,
    };
  }
}
