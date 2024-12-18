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
      final newVideo = {
        'id': videoId,
        'url': url,
        'title': title,
        'author': author,
        'thumbnailUrl': thumbnailUrl,
        'duration': duration != null ? _formatDuration(duration) : '00:00',
        'uploadDate': uploadDate ?? DateTime.now(),
      };

      _videos.add(newVideo);
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
      final aDate = a['uploadDate'] as DateTime?;
      final bDate = b['uploadDate'] as DateTime?;
      if (aDate == null || bDate == null) return 0;
      return bDate.compareTo(aDate);
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    if (hours > 0) {
      return '${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}';
    } else {
      return '${twoDigits(minutes)}:${twoDigits(seconds)}';
    }
  }
}
