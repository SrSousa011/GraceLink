import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class EventService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = 'events';

  Future<void> addEvent(Event event) async {
    try {
      await _firestore.collection(_collectionPath).add(event.toMap());
    } catch (e) {
      if (kDebugMode) {
        print('Error adding event: $e');
      }
    }
  }

  Stream<List<Event>> getEvents() {
    return _firestore.collection(_collectionPath).snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Event.fromMap(doc.id, doc.data())).toList());
  }

  Future<void> updateEvent(Event event) async {
    try {
      await _firestore
          .collection(_collectionPath)
          .doc(event.id)
          .update(event.toMap());
    } catch (e) {
      if (kDebugMode) {
        print('Error updating event: $e');
      }
    }
  }

  Stream<List<Event>> searchEventsByTitle(String title) {
    return _firestore
        .collection(_collectionPath)
        .where('title', isEqualTo: title)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Event.fromMap(doc.id, doc.data()))
            .toList());
  }

  Stream<List<Event>> searchEventsByLocation(String location) {
    return _firestore
        .collection(_collectionPath)
        .where('location', isEqualTo: location)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Event.fromMap(doc.id, doc.data()))
            .toList());
  }

  Stream<List<Event>> filterEventsByDateRange(
      DateTime startDate, DateTime endDate) {
    return _firestore
        .collection(_collectionPath)
        .where('date',
            isGreaterThanOrEqualTo: startDate, isLessThanOrEqualTo: endDate)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Event.fromMap(doc.id, doc.data()))
            .toList());
  }
}

class Event {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final TimeOfDay time;
  final String location;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.location,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'date': date,
      'time': time,
      'location': location,
    };
  }

  factory Event.fromMap(String id, Map<String, dynamic> map) {
    return Event(
      id: id,
      title: map['title'],
      description: map['description'],
      date: map['date'].toDate(),
      // Assumindo que o campo 'time' é um timestamp no Firestore
      time: TimeOfDay.fromDateTime(map['time'].toDate()),
      location: map['location'],
    );
  }
}
