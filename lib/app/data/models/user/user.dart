class User {
  User({
    this.name,
    this.email,
    this.username,
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
    this.v,
  });

  User.fromJson(dynamic json) {
    name = json['name']?.toString();
    email = json['email']?.toString();
    username = json['username']?.toString();
    phone = json['phone']?.toString();
    password = json['password']?.toString();
    role = json['role']?.toString();
    avatar = json['avatar']?.toString();
    avatarId = json['avatarId']?.toString();
    bio = json['bio']?.toString();
    isPrivate = json['isPrivate'] as bool? ?? false;
    isOnline = json['isOnline'] as bool? ?? false;
    lastSeen = json['lastSeen']?.toString(); // Handle null
    deleted = json['deleted'] as bool? ?? false;
    deleteAt = json['deleteAt']?.toString(); // Handle null
    id = json['_id']?.toString();
    createdAt = json['createdAt']?.toString();
    updatedAt = json['updatedAt']?.toString();
    v = json['__v'] as num? ?? 0;
  }

  String? name;
  String? email;
  String? username;
  String? phone;
  String? password;
  String? role;
  String? avatar;
  String? avatarId;
  String? bio;
  bool? isPrivate;
  bool? isOnline;
  String? lastSeen; // Changed from dynamic to String?
  bool? deleted;
  String? deleteAt; // Changed from dynamic to String?
  String? id;
  String? createdAt;
  String? updatedAt;
  num? v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['email'] = email;
    map['username'] = username;
    map['phone'] = phone;
    map['password'] = password;
    map['role'] = role;
    map['avatar'] = avatar;
    map['avatarId'] = avatarId;
    map['bio'] = bio;
    map['isPrivate'] = isPrivate;
    map['isOnline'] = isOnline;
    map['lastSeen'] = lastSeen; // This can be null, but it's safe
    map['deleted'] = deleted;
    map['deleteAt'] = deleteAt; // This can be null, but it's safe
    map['_id'] = id;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['__v'] = v;
    return map;
  }
}