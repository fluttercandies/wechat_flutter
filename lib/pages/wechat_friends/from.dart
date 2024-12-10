class FriendsDynamic {
  String? username;
  String? userAvatar;
  String? desc;
  String? address;
  String? datetime;
  bool? isSelf;
  int? id;
  VideoBean? video;
  List<ImagesListBean>? images;

  FriendsDynamic({
    this.username,
    this.userAvatar,
    this.desc,
    this.address,
    this.datetime,
    this.isSelf,
    this.id,
    this.video,
    this.images,
  });

  static FriendsDynamic fromMap(Map<String, dynamic> map) {
    return FriendsDynamic(
      username: map['username'] as String?,
      userAvatar: map['userAvatar'] as String?,
      desc: map['desc'] as String?,
      address: map['address'] as String?,
      datetime: map['datetime'] as String?,
      isSelf: map['isSelf'] as bool?,
      id: map['id'] as int?,
      video: map['video'] == null
          ? null
          : VideoBean.fromMap(map['video'] as Map<String, dynamic>),
      images: map['images'] == null
          ? []
          : ImagesListBean.fromMapList(
              map['images'] as List<Map<String, dynamic>>),
    );
  }

  static List<FriendsDynamic> fromMapList(List<Map<String, dynamic>> mapList) {
    return mapList.map((map) => fromMap(map)).toList();
  }
}

class VideoBean {
  String? url;
  String? image;
  int? id;

  VideoBean({
    this.url,
    this.image,
    this.id,
  });

  static VideoBean fromMap(Map<String, dynamic> map) {
    return VideoBean(
      url: map['url'] as String?,
      image: map['image'] as String?,
      id: map['id'] as int?,
    );
  }

  static List<VideoBean> fromMapList(List<Map<String, dynamic>> mapList) {
    return mapList.map((map) => fromMap(map)).toList();
  }
}

class ImagesListBean {
  String? image;
  int? id;

  ImagesListBean({
    this.image,
    this.id,
  });

  static ImagesListBean fromMap(Map<String, dynamic> map) {
    return ImagesListBean(
      image: map['image'] as String?,
      id: map['id'] as int?,
    );
  }

  static List<ImagesListBean> fromMapList(List<Map<String, dynamic>> mapList) {
    return mapList.map((map) => fromMap(map)).toList();
  }
}
