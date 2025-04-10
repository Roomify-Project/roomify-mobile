class GetAllPostsResponse {
  String? id;
  String? imagePath;
  String? description;
  String? createdAt;
  String? applicationUserId;

  GetAllPostsResponse(
      {this.id,
        this.imagePath,
        this.description,
        this.createdAt,
        this.applicationUserId});

  GetAllPostsResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imagePath = json['imagePath'];
    description = json['description'];
    createdAt = json['createdAt'];
    applicationUserId = json['applicationUserId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['imagePath'] = this.imagePath;
    data['description'] = this.description;
    data['createdAt'] = this.createdAt;
    data['applicationUserId'] = this.applicationUserId;
    return data;
  }
}