import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class VideosService {
  final CollectionReference _videosCollection =
      FirebaseFirestore.instance.collection('videos');

  Future<void> addVideo(String id, String url, String title, String author,
      String thumbnailUrl, Duration? duration, DateTime? uploadDate) async {
    try {
      final formattedDuration = _formatDuration(duration ?? Duration.zero);

      await _videosCollection.doc(id).set({
        'id': id,
        'url': url,
        'title': title,
        'author': author,
        'thumbnailUrl': thumbnailUrl,
        'duration': formattedDuration,
        'uploadDate': uploadDate ?? FieldValue.serverTimestamp(),
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error adding video: $e');
      }
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getVideos() async {
    try {
      var snapshot =
          await _videosCollection.orderBy('uploadDate', descending: true).get();
      return snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;

        if (data['uploadDate'] != null) {
          data['uploadDate'] = (data['uploadDate'] as Timestamp).toDate();
        }
        if (data['duration'] != null && data['duration'] is int) {
          data['duration'] = _secondsToDuration(data['duration']);
        }
        return data;
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting videos: $e');
      }
      rethrow;
    }
  }

  Future<void> deleteVideo(String id) async {
    try {
      await _videosCollection.doc(id).delete();
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting video: $e');
      }
      rethrow;
    }
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

  Duration _secondsToDuration(int seconds) {
    return Duration(seconds: seconds);
  }
}
