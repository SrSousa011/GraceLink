import 'package:cloud_firestore/cloud_firestore.dart';

class PhotoData {
  final String url;
  final String uploadId;
  final String location;
  final Timestamp createdAt;

  PhotoData({
    required this.url,
    required this.uploadId,
    required this.location,
    required this.createdAt,
  });

  factory PhotoData.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PhotoData(
      url: data['url'] as String,
      uploadId: data['uploadId'] as String,
      location: data['location'] as String,
      createdAt: data['createdAt'] as Timestamp,
    );
  }

  factory PhotoData.fromMap(Map<String, dynamic> map) {
    return PhotoData(
      url: map['url'] as String,
      uploadId: map['uploadId'] as String,
      location: map['location'] as String,
      createdAt: map['createdAt'] as Timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'uploadId': uploadId,
      'location': location,
      'createdAt': createdAt,
    };
  }
}
