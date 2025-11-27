class FollowerResponse {
  FollowerResponse({
      this.success, 
      this.total, 
      this.page, 
      this.limit, 
      this.totalPage, 
      this.followers,});

  FollowerResponse.fromJson(dynamic json) {
    success = json['success'];
    total = json['total'];
    page = json['page'];
    limit = json['limit'];
    totalPage = json['totalPage'];
    if (json['followers'] != null) {
      followers = [];
      json['followers'].forEach((v) {
        followers?.add(Followers.fromJson(v));
      });
    }
  }
  bool? success;
  num? total;
  num? page;
  num? limit;
  num? totalPage;
  List<Followers>? followers;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['total'] = total;
    map['page'] = page;
    map['limit'] = limit;
    map['totalPage'] = totalPage;
    if (followers != null) {
      map['followers'] = followers?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Followers {
  Followers({
      this.id, 
      this.follower, 
      this.createdAt, 
      this.updatedAt, 
      this.v,});

  Followers.fromJson(dynamic json) {
    id = json['_id'];
    follower = json['follower'] != null ? Follower.fromJson(json['follower']) : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
  }
  String? id;
  Follower? follower;
  String? createdAt;
  String? updatedAt;
  num? v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    if (follower != null) {
      map['follower'] = follower?.toJson();
    }
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['__v'] = v;
    return map;
  }

}

class Follower {
  Follower({
      this.id, 
      this.name, 
      this.avatar, 
      this.username,
      this.isFollowing,
      this.isFollowBack,
  });

  Follower.fromJson(dynamic json) {
    id = json['_id'];
    name = json['name'];
    avatar = json['avatar'];
    username = json['username'];
    isFollowing = json['isFollowing'];
    isFollowBack = json['isFollowBack'];
  }
  String? id;
  String? name;
  String? avatar;
  String? username;
  bool? isFollowing;
  bool? isFollowBack;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['name'] = name;
    map['avatar'] = avatar;
    map['username'] = username;
    map['isFollowing'] = isFollowing;
    map['isFollowBack'] = isFollowBack;
    return map;
  }

}