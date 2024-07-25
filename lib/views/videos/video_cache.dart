import 'package:churchapp/views/videos/extended_video.dart';

class VideoCache {
  final Map<String, ExtendedVideo> _cache = {};

  bool contains(String url) => _cache.containsKey(url);

  ExtendedVideo? get(String url) => _cache[url];

  void add(String url, ExtendedVideo video) {
    _cache[url] = video;
  }
}
