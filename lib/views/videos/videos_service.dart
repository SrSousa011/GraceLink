import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class VideosService {
  final CollectionReference _videosCollection =
      FirebaseFirestore.instance.collection('videos');

  Future<void> addVideo(String id, String url) async {
    try {
      await _videosCollection.doc(id).set({
        'id': id,
        'url': url,
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
      QuerySnapshot querySnapshot = await _videosCollection.get();
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
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
        print('Error adding video: $e');
      }
      rethrow;
    }
  }
}
