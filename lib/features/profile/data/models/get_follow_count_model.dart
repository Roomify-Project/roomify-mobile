class GetFollowCountModel {
  final int followers;
  final int following;

  GetFollowCountModel({
    required this.followers,
    required this.following,
  });

  factory GetFollowCountModel.fromJson(Map<String, dynamic> json) {
    return GetFollowCountModel(
      followers: json['followers'],
      following: json['following'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'followers': followers,
      'following': following,
    };
  }

  // ✅ copyWith method
  GetFollowCountModel copyWith({
    int? followers,
    int? following,
  }) {
    return GetFollowCountModel(
      followers: followers ?? this.followers,
      following: following ?? this.following,
    );
  }
}
