

class ApiErrorModel {
  String? title;
   int? status;

  ApiErrorModel({
    required this.title,
    this.status,
  });

   ApiErrorModel.fromJson(Map<String, dynamic> json, this.title, this.status){
     title = json['title'];
     status = json['status'];
  }

  // Map<String, dynamic> toJson() => _$ApiErrorModelToJson(this);
}