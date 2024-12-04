// class ChatListEntity {
//   String? peer;
//   String? type;
//   String? chatName;
//   String? chatAvatar;
//   int? unreadCount;
//   String? lastMessage;
//   int? lastMessageTime;
//   int? chatType;
//   int? isPinned;
//   int? isMuted;
//   int? isHidden;
//   int? isDeleted;
//
//   ChatListEntity({
//     this.peer,
//     this.type,
//     this.chatName,
//     this.chatAvatar,
//     this.unreadCount,
//     this.lastMessage,
//     this.lastMessageTime,
//     this.chatType,
//     this.isPinned,
//     this.isMuted,
//     this.isHidden,
//     this.isDeleted,
//   });
//
//   ChatListEntity.fromJson(Map<String, dynamic> json) {
//     peer = json['peer'];
//     type = json['type'];
//     chatName = json['chatName'];
//     chatAvatar = json['chatAvatar'];
//     unreadCount = json['unreadCount'];
//     lastMessage = json['lastMessage'];
//     lastMessageTime = json['lastMessageTime'];
//     chatType = json['chatType'];
//     isPinned = json['isPinned'];
//     isMuted = json['isMuted'];
//     isHidden = json['isHidden'];
//     isDeleted = json['isDeleted'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['peer'] = peer;
//     data['type'] = type;
//     data['chatName'] = chatName;
//     data['chatAvatar'] = chatAvatar;
//     data['unreadCount'] = unreadCount;
//     data['lastMessage'] = lastMessage;
//     data['lastMessageTime'] = lastMessageTime;
//     data['chatType'] = chatType;
//     data['isPinned'] = isPinned;
//     data['isMuted'] = isMuted;
//     data['isHidden'] = isHidden;
//     data['isDeleted'] = isDeleted;
//     return data;
//   }
// }
