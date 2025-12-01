class NotificationResponse {
  NotificationResponse({
    this.success,
    this.total,
    this.unreadCount,
    this.page,
    this.limit,
    this.totalPage,
    this.notifications,
  });

  NotificationResponse.fromJson(dynamic json) {
    success = json['success'];
    total = json['total'];
    unreadCount = json['unreadCount'];
    page = json['page'];
    limit = json['limit'];
    totalPage = json['totalPage'];
    if (json['notifications'] != null) {
      notifications = [];
      json['notifications'].forEach((v) {
        notifications?.add(NotificationItem.fromJson(v));
      });
    }
  }

  bool? success;
  int? total;
  int? unreadCount;
  int? page;
  int? limit;
  int? totalPage;
  List<NotificationItem>? notifications;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['total'] = total;
    map['unreadCount'] = unreadCount;
    map['page'] = page;
    map['limit'] = limit;
    map['totalPage'] = totalPage;
    if (notifications != null) {
      map['notifications'] = notifications?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class NotificationItem {
  NotificationItem({
    this.id,
    this.user,
    this.sender,
    this.type,
    this.isRead,
    this.createdAt,
    this.updatedAt,
  });

  NotificationItem.fromJson(dynamic json) {
    id = json['_id'];
    user = json['user'];
    sender = json['sender'] != null ? Sender.fromJson(json['sender']) : null;
    type = json['type'];
    isRead = json['isRead'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  String? id;
  String? user;
  Sender? sender;
  String? type;
  bool? isRead;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['user'] = user;
    if (sender != null) {
      map['sender'] = sender?.toJson();
    }
    map['type'] = type;
    map['isRead'] = isRead;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }
}

class Sender {
  Sender({this.id, this.name, this.username, this.avatar});

  Sender.fromJson(dynamic json) {
    id = json['_id'];
    name = json['name'];
    username = json['username'];
    avatar = json['avatar'];
  }

  String? id;
  String? name;
  String? username;
  String? avatar;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['name'] = name;
    map['username'] = username;
    map['avatar'] = avatar;
    return map;
  }
}

class UnreadCountResponse {
  UnreadCountResponse({this.success, this.unreadCount});

  UnreadCountResponse.fromJson(dynamic json) {
    success = json['success'];
    unreadCount = json['unreadCount'];
  }

  bool? success;
  int? unreadCount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['unreadCount'] = unreadCount;
    return map;
  }
}
