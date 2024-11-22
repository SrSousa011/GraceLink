import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class EventService {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final TimeOfDay time;
  final String location;
  final String createdBy;
  final String? imageUrl;

  EventService({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.location,
    required this.createdBy,
    this.imageUrl,
  });

  factory EventService.fromFirestore(String id, Map<String, dynamic> data) {
    DateTime eventDate;

    if (data['date'] is Timestamp) {
      eventDate = (data['date'] as Timestamp).toDate();
    } else if (data['date'] is String) {
      final parts = data['date'].split('/');
      eventDate = DateTime(
        int.parse(parts[2]),
        int.parse(parts[1]),
        int.parse(parts[0]),
      );
    } else {
      throw Exception('Invalid date format');
    }

    TimeOfDay eventTime;
    if (data['time'] is String) {
      final parts = data['time'].split(':');
      eventTime = TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      );
    } else {
      throw Exception('Invalid time format');
    }

    return EventService(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      date: eventDate,
      time: eventTime,
      location: data['location'] ?? '',
      createdBy: data['createdBy'] ?? '',
      imageUrl: data['imageUrl'],
    );
  }

  factory EventService.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return EventService.fromFirestore(snapshot.id, data);
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'date': Timestamp.fromDate(date),
      'time': '${time.hour}:${time.minute}',
      'location': location,
      'createdBy': createdBy,
      'imageUrl': imageUrl,
    };
  }
}

Future<void> addEvent(EventService event) async {
  try {
    CollectionReference events =
        FirebaseFirestore.instance.collection('events');
    await events.add(event.toMap());
  } catch (e) {
    if (kDebugMode) {
      print('Error adding event: $e');
    }
    rethrow;
  }
}

Future<void> updateEvent(EventService event, String eventId) async {
  try {
    CollectionReference events =
        FirebaseFirestore.instance.collection('events');
    await events.doc(eventId).update(event.toMap());
  } catch (e) {
    if (kDebugMode) {
      print('Error updating event: $e');
    }
    rethrow;
  }
}

Future<void> deleteEvent(String eventId) async {
  try {
    CollectionReference events =
        FirebaseFirestore.instance.collection('events');
    await events.doc(eventId).delete();
  } catch (e) {
    if (kDebugMode) {
      print('Error deleting event: $e');
    }
    rethrow;
  }
}

Future<EventService> getEventById(String eventId) async {
  try {
    DocumentReference eventRef =
        FirebaseFirestore.instance.collection('events').doc(eventId);
    DocumentSnapshot snapshot = await eventRef.get();

    if (snapshot.exists) {
      return EventService.fromFirestore(
          eventId, snapshot.data() as Map<String, dynamic>);
    } else {
      throw Exception('Event not found');
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error fetching event: $e');
    }
    rethrow;
  }
}

Future<List<EventService>> getAllEvents() async {
  try {
    CollectionReference events =
        FirebaseFirestore.instance.collection('events');
    QuerySnapshot snapshot = await events.get();

    if (snapshot.docs.isEmpty) {
      return [];
    } else {
      return snapshot.docs.map((doc) {
        return EventService.fromFirestore(
            doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error fetching events: $e');
    }
    rethrow;
  }
}
