import 'package:flutter/foundation.dart';
import 'videos_service.dart';

class VideosProvider extends ChangeNotifier {
  final VideosService _service = VideosService();
  List<Map<String, dynamic>> _videos = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get videos => _videos;
  bool get isLoading => _isLoading;

  Future<void> fetchVideos() async {
    _isLoading = true;
    notifyListeners();

    try {
      _videos = await _service.getVideos();
      _sortVideosByDate();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching videos: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addVideo(String videoId, String url, String title, String author,
      String thumbnailUrl, Duration? duration, DateTime? uploadDate) async {
    try {
      _videos.add({
        'id': videoId,
        'url': url,
        'title': title,
        'author': author,
        'thumbnailUrl': thumbnailUrl,
        'duration': duration?.inSeconds,
        'uploadDate': uploadDate?.toIso8601String(),
      });

      _sortVideosByDate();
      notifyListeners();

      await _service.addVideo(
        videoId,
        url,
        title,
        author,
        thumbnailUrl,
        duration,
        uploadDate,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error adding video: $e');
      }
    }
  }

  Future<void> deleteVideo(String id) async {
    try {
      await _service.deleteVideo(id);
      _videos.removeWhere((video) => video['id'] == id);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting video: $e');
      }
    }
  }

  void _sortVideosByDate() {
    _videos.sort((a, b) {
      DateTime? aDate = a['uploadDate'];
      DateTime? bDate = b['uploadDate'];
      if (aDate == null || bDate == null) return 0;
      return bDate.compareTo(aDate);
    });
  }
}
