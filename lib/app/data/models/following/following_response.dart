class FollowingResponse {
  FollowingResponse({
      this.success,
      this.total,
      this.page,
      this.limit,
      this.totalPage,
      this.followings,});

  FollowingResponse.fromJson(dynamic json) {
    success = json['success'];
    total = json['total'];
    page = json['page'];
    limit = json['limit'];
    totalPage = json['totalPage'];
    if (json['followings'] != null) {
      followings = [];
      json['followings'].forEach((v) {
        followings?.add(Followings.fromJson(v));
      });
    }
  }
  bool? success;
  num? total;
  num? page;
  num? limit;
  num? totalPage;
  List<Followings>? followings;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['total'] = total;
    map['page'] = page;
    map['limit'] = limit;
    map['totalPage'] = totalPage;
    if (followings != null) {
      map['followings'] = followings?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Followings {
  Followings({
      this.id,
      this.following,
      this.createdAt,
      this.updatedAt,
      this.v,});

  Followings.fromJson(dynamic json) {
    id = json['_id'];
    following = json['following'] != null ? Following.fromJson(json['following']) : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
  }
  String? id;
  Following? following;
  String? createdAt;
  String? updatedAt;
  num? v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    if (following != null) {
      map['following'] = following?.toJson();
    }
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['__v'] = v;
    return map;
  }

}

class Following {
  Following({
      this.id,
      this.name,
      this.avatar,
      this.username,
      this.isFollowing,
      this.isFollowBack,
  });

  Following.fromJson(dynamic json) {
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