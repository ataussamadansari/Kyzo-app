class UserSuggest {
  UserSuggest({
    this.success,
    this.message,
    this.page,
    this.limit,
    this.count,
    this.totalPage,
    this.users,
  });

  UserSuggest.fromJson(dynamic json) {
    success = json['success'];
    message = json['message'];
    page = json['page'];
    limit = json['limit'];
    count = json['count'];
    totalPage = json['totalPage'];
    if (json['users'] != null) {
      users = [];
      json['users'].forEach((v) {
        users?.add(Users.fromJson(v));
      });
    }
  }

  bool? success;
  String? message;
  int? page;
  int? limit;
  int? count;
  int? totalPage;
  List<Users>? users;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    map['page'] = page;
    map['limit'] = limit;
    map['count'] = count;
    map['totalPage'] = totalPage;
    if (users != null) {
      map['users'] = users?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Users {
  Users({
    this.id,
    this.name,
    this.username,
    this.avatar,
    this.bio,
    this.isFollowing,
    this.isFollowBack,
  });

  Users.fromJson(dynamic json) {
    id = json['_id'];
    name = json['name'];
    username = json['username'];
    avatar = json['avatar'];
    bio = json['bio'];
    isFollowing = json['isFollowing'];
    isFollowBack = json['isFollowBack'];
  }

  String? id;
  String? name;
  String? username;
  String? avatar;
  String? bio;
  bool? isFollowing;
  bool? isFollowBack;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['name'] = name;
    map['username'] = username;
    map['avatar'] = avatar;
    map['bio'] = bio;
    map['isFollowing'] = isFollowing;
    map['isFollowBack'] = isFollowBack;
    return map;
  }
}
