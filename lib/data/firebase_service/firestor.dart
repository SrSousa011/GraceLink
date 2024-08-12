import 'package:churchapp/data/firebase_service/model/user_data.dart';
import 'package:churchapp/exceptions/firebase_exception_wrapper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class FirebaseService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserData> getUser({String? uid}) async {
    try {
      final userDoc = await _firebaseFirestore
          .collection('users')
          .doc(uid ?? _auth.currentUser!.uid)
          .get();
      return UserData.fromDocument(userDoc);
    } on FirebaseException catch (e) {
      throw FirebaseExceptionWrapper(e.message.toString());
    }
  }

  Future<bool> createPost({
    required String postImage,
    required String caption,
    required String location,
  }) async {
    try {
      var postId = const Uuid().v4();
      DateTime now = DateTime.now();
      UserData user = await getUser();
      await _firebaseFirestore.collection('events').doc(postId).set({
        'postImage': postImage,
        'username': user.fullName,
        'profileImage': user.imagePath,
        'caption': caption,
        'location': location,
        'uid': _auth.currentUser!.uid,
        'postId': postId,
        'time': now,
      });
      return true;
    } on FirebaseException catch (e) {
      throw FirebaseExceptionWrapper(e.message.toString());
    }
  }

  Future<bool> createEvent({
    required String eventImage,
    required String title,
    required String description,
    required String location,
  }) async {
    try {
      var eventId = Uuid().v4();
      DateTime now = DateTime.now();
      await _firebaseFirestore.collection('events').doc(eventId).set({
        'eventImage': eventImage,
        'title': title,
        'description': description,
        'location': location,
        'uid': _auth.currentUser!.uid,
        'eventId': eventId,
        'time': now,
      });
      return true;
    } on FirebaseException catch (e) {
      throw FirebaseExceptionWrapper(e.message.toString());
    }
  }

  Future<String> toggleLike({
    required List<dynamic> likes,
    required String type,
    required String uid,
    required String documentId,
  }) async {
    try {
      if (likes.contains(uid)) {
        await _firebaseFirestore.collection(type).doc(documentId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firebaseFirestore.collection(type).doc(documentId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
      return 'success';
    } on FirebaseException catch (e) {
      return e.message.toString();
    }
  }

  Future<String> like({
    required List like,
    required String type,
    required String uid,
    required String postId,
  }) async {
    String res = 'some error';
    try {
      if (like.contains(uid)) {
        _firebaseFirestore.collection(type).doc(postId).update({
          'like': FieldValue.arrayRemove([uid])
        });
      } else {
        _firebaseFirestore.collection(type).doc(postId).update({
          'like': FieldValue.arrayUnion([uid])
        });
      }
      res = 'seccess';
    } on Exception catch (e) {
      res = e.toString();
    }
    return res;
  }
}
