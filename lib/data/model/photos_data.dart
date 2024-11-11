import 'package:cloud_firestore/cloud_firestore.dart';

class PhotoData {
  final List<String> urls;
  final String uploadId;
  final String location;
  final Timestamp createdAt;
  final bool isUploading;

  PhotoData({
    required this.urls,
    required this.uploadId,
    required this.location,
    required this.createdAt,
    this.isUploading = false,
  });

  factory PhotoData.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PhotoData(
      urls: List<String>.from(data['urls'] ?? []),
      uploadId: data['uploadId'] as String,
      location: data['location'] as String,
      createdAt: data['createdAt'] as Timestamp,
      isUploading: data['isUploading'] ?? false,
    );
  }

  factory PhotoData.fromMap(Map<String, dynamic> map) {
    return PhotoData(
      urls: List<String>.from(map['urls'] ?? []),
      uploadId: map['uploadId'] as String,
      location: map['location'] as String,
      createdAt: map['createdAt'] as Timestamp,
      isUploading: map['isUploading'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'urls': urls,
      'uploadId': uploadId,
      'location': location,
      'createdAt': createdAt,
      'isUploading': isUploading,
    };
  }

  PhotoData copyWith({
    List<String>? urls,
    String? uploadId,
    String? location,
    Timestamp? createdAt,
    bool? isUploading,
  }) {
    return PhotoData(
      urls: urls ?? this.urls,
      uploadId: uploadId ?? this.uploadId,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
      isUploading: isUploading ?? this.isUploading,
    );
  }
}
