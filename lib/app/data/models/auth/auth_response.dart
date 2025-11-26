import '../user/user.dart';

class AuthResponse {
  AuthResponse({
    this.success,
    this.message,
    this.token,
    this.user,
    this.suggestions,
  });

  AuthResponse.fromJson(dynamic json) {
    success = json['success'];
    message = json['message'];
    token = json['token'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    suggestions = json['suggestions'] != null
        ? List<String>.from(json['suggestions'])
        : null;
  }

  bool? success;
  String? message;
  String? token;
  User? user;
  List<String>? suggestions;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    map['token'] = token;
    if (user != null) {
      map['user'] = user?.toJson();
    }
    if (suggestions != null) {
      map['suggestions'] = suggestions?.map((v) => v).toList();
    }
    return map;
  }
}

/*
class User {
  User({
      this.name,
      this.email,
      this.phone,
      this.password,
      this.role,
      this.avatar,
      this.avatarId,
      this.bio,
      this.isPrivate,
      this.isOnline,
      this.lastSeen,
      this.deleted,
      this.deleteAt,
      this.id,
      this.createdAt,
      this.updatedAt,
      this.v,});

  User.fromJson(dynamic json) {
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    password = json['password'];
    role = json['role'];
    avatar = json['avatar'];
    avatarId = json['avatarId'];
    bio = json['bio'];
    isPrivate = json['isPrivate'];
    isOnline = json['isOnline'];
    lastSeen = json['lastSeen'];
    deleted = json['deleted'];
    deleteAt = json['deleteAt'];
    id = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
  }
  String? name;
  String? email;
  String? phone;
  String? password;
  String? role;
  String? avatar;
  String? avatarId;
  String? bio;
  bool? isPrivate;
  bool? isOnline;
  dynamic lastSeen;
  bool? deleted;
  dynamic deleteAt;
  String? id;
  String? createdAt;
  String? updatedAt;
  num? v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['email'] = email;
    map['phone'] = phone;
    map['password'] = password;
    map['role'] = role;
    map['avatar'] = avatar;
    map['avatarId'] = avatarId;
    map['bio'] = bio;
    map['isPrivate'] = isPrivate;
    map['isOnline'] = isOnline;
    map['lastSeen'] = lastSeen;
    map['deleted'] = deleted;
    map['deleteAt'] = deleteAt;
    map['_id'] = id;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['__v'] = v;
    return map;
  }
}*/
