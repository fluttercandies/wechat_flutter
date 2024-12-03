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
      username: map['username'],
      userAvatar: map['userAvatar'],
      desc: map['desc'],
      address: map['address'],
      datetime: map['datetime'],
      isSelf: map['isSelf'],
      id: map['id'],
      video: map['video'] == null ? null : VideoBean.fromMap(map['video']),
      images: map['images'] == null ? [] : ImagesListBean.fromMapList(map['images']),
    );
  }

  static List<FriendsDynamic> fromMapList(List<dynamic> mapList) {
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
      url: map['url'],
      image: map['image'],
      id: map['id'],
    );
  }

  static List<VideoBean> fromMapList(List<dynamic> mapList) {
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
      image: map['image'],
      id: map['id'],
    );
  }

  static List<ImagesListBean> fromMapList(List<dynamic> mapList) {
    return mapList.map((map) => fromMap(map)).toList();
  }
}