import 'package:cloud_firestore/cloud_firestore.dart';

class PhotoData {
  final String url;
  final String uploadId;
  final String location;

  PhotoData({
    required this.url,
    required this.uploadId,
    required this.location,
  });

  factory PhotoData.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PhotoData(
      url: data['url'] as String,
      uploadId: data['uploadId'] as String,
      location: data['location'] as String,
    );
  }

  factory PhotoData.fromMap(Map<String, dynamic> map) {
    return PhotoData(
      url: map['url'] as String,
      uploadId: map['uploadId'] as String,
      location: map['location'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'uploadId': uploadId,
      'location': location,
    };
  }
}
