class GenerateBodyModel {
  final String userId;
  final String roomType;
  final String roomStyle;
  final String descriptionText;

  GenerateBodyModel({
    required this.userId,
    required this.roomType,
    required this.roomStyle,
    required this.descriptionText,
  });

  // لتحويل من JSON إلى كائن GenerateBodyModel
  factory GenerateBodyModel.fromJson(Map<String, dynamic> json) {
    return GenerateBodyModel(
      userId: json['userId'] as String,
      roomType: json['roomType'] as String,
      roomStyle: json['roomStyle'] as String,
      descriptionText: json['descriptionText'] as String,
    );
  }

  // لتحويل من كائن GenerateBodyModel إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'roomType': roomType,
      'roomStyle': roomStyle,
      'descriptionText': descriptionText,
    };
  }
}
