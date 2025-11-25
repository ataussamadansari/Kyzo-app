class AuthResponse {
  AuthResponse({
      String? message, 
      String? token, 
      User? user, 
      bool? scheduledForDeletion,}){
    _message = message;
    _token = token;
    _user = user;
    _scheduledForDeletion = scheduledForDeletion;
}

  AuthResponse.fromJson(dynamic json) {
    _message = json['message'];
    _token = json['token'];
    _user = json['user'] != null ? User.fromJson(json['user']) : null;
    _scheduledForDeletion = json['scheduledForDeletion'];
  }
  String? _message;
  String? _token;
  User? _user;
  bool? _scheduledForDeletion;
AuthResponse copyWith({  String? message,
  String? token,
  User? user,
  bool? scheduledForDeletion,
}) => AuthResponse(  message: message ?? _message,
  token: token ?? _token,
  user: user ?? _user,
  scheduledForDeletion: scheduledForDeletion ?? _scheduledForDeletion,
);
  String? get message => _message;
  String? get token => _token;
  User? get user => _user;
  bool? get scheduledForDeletion => _scheduledForDeletion;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = _message;
    map['token'] = _token;
    if (_user != null) {
      map['user'] = _user?.toJson();
    }
    map['scheduledForDeletion'] = _scheduledForDeletion;
    return map;
  }

}

class User {
  User({
      String? id, 
      String? name, 
      String? username, 
      String? email, 
      String? phone, 
      String? password, 
      String? role, 
      String? avatar, 
      String? bio, 
      bool? isPrivate, 
      bool? isOnline, 
      String? lastSeen, 
      bool? deleted, 
      String? deleteAt, 
      String? createdAt, 
      String? updatedAt, 
      num? v, 
      String? resetPasswordExpires, 
      String? resetPasswordExpire, 
      String? resetPasswordToken,}){
    _id = id;
    _name = name;
    _username = username;
    _email = email;
    _phone = phone;
    _password = password;
    _role = role;
    _avatar = avatar;
    _bio = bio;
    _isPrivate = isPrivate;
    _isOnline = isOnline;
    _lastSeen = lastSeen;
    _deleted = deleted;
    _deleteAt = deleteAt;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _v = v;
    _resetPasswordExpires = resetPasswordExpires;
    _resetPasswordExpire = resetPasswordExpire;
    _resetPasswordToken = resetPasswordToken;
}

  User.fromJson(dynamic json) {
    _id = json['_id'];
    _name = json['name'];
    _username = json['username'];
    _email = json['email'];
    _phone = json['phone'];
    _password = json['password'];
    _role = json['role'];
    _avatar = json['avatar'];
    _bio = json['bio'];
    _isPrivate = json['isPrivate'];
    _isOnline = json['isOnline'];
    _lastSeen = json['lastSeen'];
    _deleted = json['deleted'];
    _deleteAt = json['deleteAt'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _v = json['__v'];
    _resetPasswordExpires = json['resetPasswordExpires'];
    _resetPasswordExpire = json['resetPasswordExpire'];
    _resetPasswordToken = json['resetPasswordToken'];
  }
  String? _id;
  String? _name;
  String? _username;
  String? _email;
  String? _phone;
  String? _password;
  String? _role;
  String? _avatar;
  String? _bio;
  bool? _isPrivate;
  bool? _isOnline;
  String? _lastSeen;
  bool? _deleted;
  String? _deleteAt;
  String? _createdAt;
  String? _updatedAt;
  num? _v;
  String? _resetPasswordExpires;
  String? _resetPasswordExpire;
  String? _resetPasswordToken;
User copyWith({  String? id,
  String? name,
  String? username,
  String? email,
  String? phone,
  String? password,
  String? role,
  String? avatar,
  String? bio,
  bool? isPrivate,
  bool? isOnline,
  String? lastSeen,
  bool? deleted,
  String? deleteAt,
  String? createdAt,
  String? updatedAt,
  num? v,
  String? resetPasswordExpires,
  String? resetPasswordExpire,
  String? resetPasswordToken,
}) => User(  id: id ?? _id,
  name: name ?? _name,
  username: username ?? _username,
  email: email ?? _email,
  phone: phone ?? _phone,
  password: password ?? _password,
  role: role ?? _role,
  avatar: avatar ?? _avatar,
  bio: bio ?? _bio,
  isPrivate: isPrivate ?? _isPrivate,
  isOnline: isOnline ?? _isOnline,
  lastSeen: lastSeen ?? _lastSeen,
  deleted: deleted ?? _deleted,
  deleteAt: deleteAt ?? _deleteAt,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  v: v ?? _v,
  resetPasswordExpires: resetPasswordExpires ?? _resetPasswordExpires,
  resetPasswordExpire: resetPasswordExpire ?? _resetPasswordExpire,
  resetPasswordToken: resetPasswordToken ?? _resetPasswordToken,
);
  String? get id => _id;
  String? get name => _name;
  String? get username => _username;
  String? get email => _email;
  String? get phone => _phone;
  String? get password => _password;
  String? get role => _role;
  String? get avatar => _avatar;
  String? get bio => _bio;
  bool? get isPrivate => _isPrivate;
  bool? get isOnline => _isOnline;
  String? get lastSeen => _lastSeen;
  bool? get deleted => _deleted;
  String? get deleteAt => _deleteAt;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  num? get v => _v;
  String? get resetPasswordExpires => _resetPasswordExpires;
  String? get resetPasswordExpire => _resetPasswordExpire;
  String? get resetPasswordToken => _resetPasswordToken;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['name'] = _name;
    map['username'] = _username;
    map['email'] = _email;
    map['phone'] = _phone;
    map['password'] = _password;
    map['role'] = _role;
    map['avatar'] = _avatar;
    map['bio'] = _bio;
    map['isPrivate'] = _isPrivate;
    map['isOnline'] = _isOnline;
    map['lastSeen'] = _lastSeen;
    map['deleted'] = _deleted;
    map['deleteAt'] = _deleteAt;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['__v'] = _v;
    map['resetPasswordExpires'] = _resetPasswordExpires;
    map['resetPasswordExpire'] = _resetPasswordExpire;
    map['resetPasswordToken'] = _resetPasswordToken;
    return map;
  }

}