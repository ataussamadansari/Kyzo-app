

import 'user.dart';

class UserResponse {
  UserResponse({
      this.success, 
      this.message, 
      this.user,});

  UserResponse.fromJson(dynamic json) {
    success = json['success'];
    message = json['message'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }
  bool? success;
  String? message;
  User? user;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    if (user != null) {
      map['user'] = user?.toJson();
    }
    return map;
  }

}
