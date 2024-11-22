import 'package:youtube_explode_dart/youtube_explode_dart.dart' as YT;

class VideoCache {
  final Map<String, YT.Video> _cache = {};

  bool contains(String url) => _cache.containsKey(url);

  YT.Video? get(String url) => _cache[url];

  void add(String url, YT.Video video) {
    _cache[url] = video;
  }
}
