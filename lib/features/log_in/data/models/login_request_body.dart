class LoginRequestBody {
  String? email;
  String? password;

  LoginRequestBody({this.email, this.password});

  LoginRequestBody.fromJson(Map<String, dynamic> json, this.email, this.password) {
    email = json['email'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = email;
    data['password'] = password;
    return data;
  }
}