import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http_client_helper/http_client_helper.dart';
import 'package:loading_more_list_library/loading_more_list_library.dart';

import 'mock_data.dart';
import 'tu_chong_source.dart';

Future<bool> onLikeButtonTap(bool isLiked, TuChongItem item) {
  ///send your request here
  return Future<bool>.delayed(const Duration(milliseconds: 50), () {
    item.isFavorite = !item.isFavorite!;
    item.favorites =
        item.isFavorite! ? item.favorites! + 1 : item.favorites! - 1;
    return item.isFavorite!;
  });
}

class TuChongRepository extends LoadingMoreBase<TuChongItem> {
  TuChongRepository({this.maxLength = 300});
  int _pageIndex = 1;
  bool _hasMore = true;
  @override
  bool get hasMore => _hasMore && length < maxLength;
  final int maxLength;

  @override
  Future<bool> refresh([bool notifyStateChanged = false]) async {
    _hasMore = true;
    _pageIndex = 1;

    final bool result = await super.refresh(true);
    return result;
  }

  @override
  Future<bool> loadData([bool isLoadMoreAction = false]) async {
    String url = '';
    if (isEmpty) {
      url = 'https://api.tuchong.com/feed-app';
    } else {
      final int? lastPostId = this[length - 1].postId;
      url =
          'https://api.tuchong.com/feed-app?post_id=$lastPostId&page=$_pageIndex&type=loadmore';
    }
    bool isSuccess = false;
    try {
      //to show loading more clearly, in your app,remove this
      // await Future<void>.delayed(const Duration(seconds: 2));
      List<TuChongItem>? feedList;
      if (!kIsWeb) {
        final Response result =
            await HttpClientHelper.get(Uri.parse(url)) as Response;
        feedList = TuChongSource.fromJson(
                json.decode(result.body) as Map<String, dynamic>)
            .feedList;
      } else {
        feedList = mockSource.feedList!.getRange(length, length + 20).toList();
      }

      if (_pageIndex == 1) {
        clear();
      }

      for (final TuChongItem item in feedList!) {
        if (item.hasImage && !contains(item) && hasMore) {
          add(item);
        }
      }

      _hasMore = feedList.isNotEmpty;
      _pageIndex++;
      isSuccess = true;
    } catch (exception, stack) {
      isSuccess = false;
      if (kDebugMode) {
        print(exception);

        print(stack);
      }
    }
    return isSuccess;
  }

  // @override
  // Iterable<TuChongItem> wrapData(Iterable<TuChongItem> source) {
  //   return source.where((TuChongItem element) => element.imageCount == 1);
  // }
}
