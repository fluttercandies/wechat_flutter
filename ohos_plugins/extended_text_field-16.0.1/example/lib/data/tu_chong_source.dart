import 'dart:convert' show json;
import 'dart:math';
import 'package:flutter/rendering.dart';

void tryCatch(Function f) {
  try {
    f.call();
  } catch (e, stack) {
    debugPrint('$e');
    debugPrint('$stack');
  }
}

T? asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }
  if (value != null) {
    final String valueS = value.toString();
    if (0 is T) {
      return int.tryParse(valueS) as T?;
    } else if (0.0 is T) {
      return double.tryParse(valueS) as T?;
    } else if ('' is T) {
      return valueS as T;
    } else if (false is T) {
      if (valueS == '0' || valueS == '1') {
        return (valueS == '1') as T;
      }
      return (valueS == 'true') as T;
    }
  }
  return null;
}

class TuChongSource {
  TuChongSource({
    this.counts,
    this.feedList,
    this.isHistory,
    this.message,
    this.more,
    this.result,
  });

  factory TuChongSource.fromJson(Map<String, dynamic> jsonRes) {
    final List<TuChongItem>? feedList =
        jsonRes['feedList'] is List ? <TuChongItem>[] : null;
    if (feedList != null) {
      for (final dynamic item in jsonRes['feedList']) {
        if (item != null) {
          tryCatch(() {
            feedList
                .add(TuChongItem.fromJson(asT<Map<String, dynamic>>(item)!));
          });
        }
      }
    }

    return TuChongSource(
      counts: asT<int>(jsonRes['counts']),
      feedList: feedList,
      isHistory: asT<bool>(jsonRes['is_history']),
      message: asT<String>(jsonRes['message']),
      more: asT<bool>(jsonRes['more']),
      result: asT<String>(jsonRes['result']),
    );
  }

  final int? counts;
  final List<TuChongItem>? feedList;
  final bool? isHistory;
  final String? message;
  final bool? more;
  final String? result;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'counts': counts,
        'feedList': feedList,
        'is_history': isHistory,
        'message': message,
        'more': more,
        'result': result,
      };

  @override
  String toString() {
    return json.encode(this);
  }
}

class TuChongItem {
  TuChongItem({
    this.authorId,
    this.collected,
    this.commentListPrefix,
    this.comments,
    this.content,
    this.createdAt,
    this.dataType,
    this.delete,
    this.eventTags,
    this.excerpt,
    this.favoriteListPrefix,
    this.favorites,
    this.imageCount,
    this.images,
    this.isFavorite,
    this.parentComments,
    this.passedTime,
    this.postId,
    this.publishedAt,
    this.recommend,
    this.recomType,
    this.rewardable,
    this.rewardListPrefix,
    this.rewards,
    this.rqtId,
    this.shares,
    this.site,
    this.siteId,
    this.sites,
    this.tags,
    this.title,
    this.titleImage,
    this.type,
    this.update,
    this.url,
    this.views,
    this.tagColors,
  });

  factory TuChongItem.fromJson(Map<String, dynamic> jsonRes) {
    final List<Object?>? commentListPrefix =
        jsonRes['comment_list_prefix'] is List ? <Object?>[] : null;
    if (commentListPrefix != null) {
      for (final dynamic item in jsonRes['comment_list_prefix']) {
        if (item != null) {
          tryCatch(() {
            commentListPrefix.add(asT<Object>(item));
          });
        }
      }
    }

    final List<String?>? eventTags =
        jsonRes['event_tags'] is List ? <String?>[] : null;
    if (eventTags != null) {
      for (final dynamic item in jsonRes['event_tags']) {
        if (item != null) {
          tryCatch(() {
            eventTags.add(asT<String>(item));
          });
        }
      }
    }

    final List<Object?>? favoriteListPrefix =
        jsonRes['favorite_list_prefix'] is List ? <Object?>[] : null;
    if (favoriteListPrefix != null) {
      for (final dynamic item in jsonRes['favorite_list_prefix']) {
        if (item != null) {
          tryCatch(() {
            favoriteListPrefix.add(asT<Object>(item));
          });
        }
      }
    }

    final List<ImageItem>? images =
        jsonRes['images'] is List ? <ImageItem>[] : null;
    if (images != null) {
      for (final dynamic item in jsonRes['images']) {
        if (item != null) {
          tryCatch(() {
            images.add(ImageItem.fromJson(asT<Map<String, dynamic>>(item)!));
          });
        }
      }
    }

    final List<Object?>? rewardListPrefix =
        jsonRes['reward_list_prefix'] is List ? <Object?>[] : null;
    if (rewardListPrefix != null) {
      for (final dynamic item in jsonRes['reward_list_prefix']) {
        if (item != null) {
          tryCatch(() {
            rewardListPrefix.add(asT<Object>(item));
          });
        }
      }
    }

    final List<Object?>? sites = jsonRes['sites'] is List ? <Object?>[] : null;
    if (sites != null) {
      for (final dynamic item in jsonRes['sites']) {
        if (item != null) {
          tryCatch(() {
            sites.add(asT<Object>(item));
          });
        }
      }
    }
    final List<Color> tagColors = <Color>[];
    final List<String?>? tags = jsonRes['tags'] is List ? <String?>[] : null;
    if (tags != null) {
      const int maxNum = 6;
      for (final dynamic item in jsonRes['tags']) {
        if (item != null) {
          tryCatch(() {
            tags.add(asT<String>(item));
            tagColors.add(Color.fromARGB(255, Random.secure().nextInt(255),
                Random.secure().nextInt(255), Random.secure().nextInt(255)));
          });
        }
        if (tags.length == maxNum) {
          break;
        }
      }
    }

    return TuChongItem(
      authorId: asT<String>(jsonRes['author_id']),
      collected: asT<bool>(jsonRes['collected']),
      commentListPrefix: commentListPrefix,
      comments: asT<int>(jsonRes['comments']),
      content: asT<String>(jsonRes['content']),
      createdAt: asT<String>(jsonRes['created_at']),
      dataType: asT<String>(jsonRes['data_type']),
      delete: asT<bool>(jsonRes['delete']),
      eventTags: eventTags,
      excerpt: asT<String>(jsonRes['excerpt']),
      favoriteListPrefix: favoriteListPrefix,
      favorites: asT<int>(jsonRes['favorites']),
      imageCount: asT<int>(jsonRes['image_count']),
      images: images,
      isFavorite: asT<bool>(jsonRes['is_favorite']),
      parentComments: asT<String>(jsonRes['parent_comments']),
      passedTime: asT<String>(jsonRes['passed_time']),
      postId: asT<int>(jsonRes['post_id']),
      publishedAt: asT<String>(jsonRes['published_at']),
      recommend: asT<bool>(jsonRes['recommend']),
      recomType: asT<String>(jsonRes['recom_type']),
      rewardable: asT<bool>(jsonRes['rewardable']),
      rewardListPrefix: rewardListPrefix,
      rewards: asT<String>(jsonRes['rewards']),
      rqtId: asT<String>(jsonRes['rqt_id']),
      shares: asT<int>(jsonRes['shares']),
      site: Site.fromJson(asT<Map<String, dynamic>>(jsonRes['site'])!),
      siteId: asT<String>(jsonRes['site_id']),
      sites: sites,
      tags: tags,
      tagColors: tagColors,
      title: asT<String>(jsonRes['title']),
      titleImage: asT<Object>(jsonRes['title_image']),
      type: asT<String>(jsonRes['type']),
      update: asT<bool>(jsonRes['update']),
      url: asT<String>(jsonRes['url']),
      views: asT<int>(jsonRes['views']),
    );
  }

  final String? authorId;
  final bool? collected;
  final List<Object?>? commentListPrefix;
  final int? comments;
  final String? content;
  final String? createdAt;
  final String? dataType;
  final bool? delete;
  final List<String?>? eventTags;
  final String? excerpt;
  final List<Object?>? favoriteListPrefix;
  int? favorites;
  final int? imageCount;
  final List<ImageItem>? images;
  bool? isFavorite;
  final String? parentComments;
  final String? passedTime;
  final int? postId;
  final String? publishedAt;
  final bool? recommend;
  final String? recomType;
  final bool? rewardable;
  final List<Object?>? rewardListPrefix;
  final String? rewards;
  final String? rqtId;
  final int? shares;
  final Site? site;
  final String? siteId;
  final List<Object?>? sites;
  final List<String?>? tags;
  final String? title;
  final Object? titleImage;
  final String? type;
  final bool? update;
  final String? url;
  final int? views;
  final List<Color>? tagColors;
  bool get hasImage {
    return images != null && images!.isNotEmpty;
  }

  Size? imageRawSize;

  Size get imageSize {
    if (!hasImage) {
      return const Size(0, 0);
    }
    return Size(images![0].width!.toDouble(), images![0].height!.toDouble());
  }

  String get imageUrl {
    if (!hasImage) {
      return '';
    }
    return 'https://photo.tuchong.com/${images![0].userId}/f/${images![0].imgId}.jpg';
  }

  String? get avatarUrl => site!.icon;

  String? get imageTitle {
    if (!hasImage) {
      return title;
    }

    return images![0].title;
  }

  String? get imageDescription {
    if (!hasImage) {
      return content;
    }

    return images![0].description;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'author_id': authorId,
        'collected': collected,
        'comment_list_prefix': commentListPrefix,
        'comments': comments,
        'content': content,
        'created_at': createdAt,
        'data_type': dataType,
        'delete': delete,
        'event_tags': eventTags,
        'excerpt': excerpt,
        'favorite_list_prefix': favoriteListPrefix,
        'favorites': favorites,
        'image_count': imageCount,
        'images': images,
        'is_favorite': isFavorite,
        'parent_comments': parentComments,
        'passed_time': passedTime,
        'post_id': postId,
        'published_at': publishedAt,
        'recommend': recommend,
        'recom_type': recomType,
        'rewardable': rewardable,
        'reward_list_prefix': rewardListPrefix,
        'rewards': rewards,
        'rqt_id': rqtId,
        'shares': shares,
        'site': site,
        'site_id': siteId,
        'sites': sites,
        'tags': tags,
        'title': title,
        'title_image': titleImage,
        'type': type,
        'update': update,
        'url': url,
        'views': views,
      };

  @override
  String toString() {
    return json.encode(this);
  }
}

class ImageItem {
  ImageItem({
    this.description,
    this.excerpt,
    this.height,
    this.imgId,
    this.imgIdStr,
    this.title,
    this.userId,
    this.width,
  });

  factory ImageItem.fromJson(Map<String, dynamic> jsonRes) => ImageItem(
        description: asT<String>(jsonRes['description']),
        excerpt: asT<String>(jsonRes['excerpt']),
        height: asT<int>(jsonRes['height']),
        imgId: asT<int>(jsonRes['img_id']),
        imgIdStr: asT<String>(jsonRes['img_id_str']),
        title: asT<String>(jsonRes['title']),
        userId: asT<int>(jsonRes['user_id']),
        width: asT<int>(jsonRes['width']),
      );

  final String? description;
  final String? excerpt;
  final int? height;
  final int? imgId;
  final String? imgIdStr;
  final String? title;
  final int? userId;
  final int? width;
  String get imageUrl {
    return 'https://photo.tuchong.com/$userId/f/$imgId.jpg';
  }
  // ImageProvider createNetworkImage() {
  //   return ExtendedNetworkImageProvider(imageUrl);
  // }

  // ImageProvider createResizeImage() {
  //   return ResizeImage(ExtendedNetworkImageProvider(imageUrl),
  //       width: width ~/ 5, height: height ~/ 5);
  // }

  // void clearCache() {
  //   createNetworkImage().evict();
  //   createResizeImage().evict();
  // }
  Map<String, dynamic> toJson() => <String, dynamic>{
        'description': description,
        'excerpt': excerpt,
        'height': height,
        'img_id': imgId,
        'img_id_str': imgIdStr,
        'title': title,
        'user_id': userId,
        'width': width,
      };

  @override
  String toString() {
    return json.encode(this);
  }
}

class Site {
  Site({
    this.description,
    this.domain,
    this.followers,
    this.hasEverphotoNote,
    this.icon,
    this.isBindEverphoto,
    this.isFollowing,
    this.name,
    this.siteId,
    this.type,
    this.url,
    this.verificationList,
    this.verifications,
    this.verified,
  });

  factory Site.fromJson(Map<String, dynamic> jsonRes) {
    final List<VerificationList>? verificationList =
        jsonRes['verification_list'] is List ? <VerificationList>[] : null;
    if (verificationList != null) {
      for (final dynamic item in jsonRes['verification_list']) {
        if (item != null) {
          tryCatch(() {
            verificationList.add(
                VerificationList.fromJson(asT<Map<String, dynamic>>(item)!));
          });
        }
      }
    }

    return Site(
      description: asT<String>(jsonRes['description']),
      domain: asT<String>(jsonRes['domain']),
      followers: asT<int>(jsonRes['followers']),
      hasEverphotoNote: asT<bool>(jsonRes['has_everphoto_note']),
      icon: asT<String>(jsonRes['icon']),
      isBindEverphoto: asT<bool>(jsonRes['is_bind_everphoto']),
      isFollowing: asT<bool>(jsonRes['is_following']),
      name: asT<String>(jsonRes['name']),
      siteId: asT<String>(jsonRes['site_id']),
      type: asT<String>(jsonRes['type']),
      url: asT<String>(jsonRes['url']),
      verificationList: verificationList,
      verifications: asT<int>(jsonRes['verifications']),
      verified: asT<bool>(jsonRes['verified']),
    );
  }

  final String? description;
  final String? domain;
  int? followers;
  final bool? hasEverphotoNote;
  final String? icon;
  final bool? isBindEverphoto;
  bool? isFollowing;
  final String? name;
  final String? siteId;
  final String? type;
  final String? url;
  final List<VerificationList>? verificationList;
  final int? verifications;
  final bool? verified;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'description': description,
        'domain': domain,
        'followers': followers,
        'has_everphoto_note': hasEverphotoNote,
        'icon': icon,
        'is_bind_everphoto': isBindEverphoto,
        'is_following': isFollowing,
        'name': name,
        'site_id': siteId,
        'type': type,
        'url': url,
        'verification_list': verificationList,
        'verifications': verifications,
        'verified': verified,
      };

  @override
  String toString() {
    return json.encode(this);
  }
}

class VerificationList {
  VerificationList({
    this.verificationReason,
    this.verificationType,
  });

  factory VerificationList.fromJson(Map<String, dynamic> jsonRes) =>
      VerificationList(
        verificationReason: asT<String>(jsonRes['verification_reason']),
        verificationType: asT<int>(jsonRes['verification_type']),
      );

  final String? verificationReason;
  final int? verificationType;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'verification_reason': verificationReason,
        'verification_type': verificationType,
      };

  @override
  String toString() {
    return json.encode(this);
  }
}
