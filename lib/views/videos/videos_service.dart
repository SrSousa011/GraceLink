import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class VideosService {
  final CollectionReference _videosCollection =
      FirebaseFirestore.instance.collection('videos');

  Future<void> addVideo(String id, String url, String title, String author,
      String thumbnailUrl, Duration? duration, DateTime? uploadDate) async {
    try {
      await _videosCollection.doc(id).set({
        'id': id,
        'url': url,
        'title': title,
        'author': author,
        'thumbnailUrl': thumbnailUrl,
        'duration': duration?.inSeconds,
        'uploadDate': uploadDate?.toIso8601String(),
        'timestamp': DateTime.now(),
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
          await _videosCollection.orderBy('timestamp', descending: true).get();
      return snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        if (data['uploadDate'] != null) {
          data['uploadDate'] = DateTime.parse(data['uploadDate']);
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
}
