import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Event {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final TimeOfDay time;
  final String location;
  final String createdBy;
  final String? imageUrl;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.location,
    required this.createdBy,
    this.imageUrl,
  });

  factory Event.fromFirestore(String id, Map<String, dynamic> data) {
    DateTime eventDate;

    if (data['date'] is Timestamp) {
      eventDate = (data['date'] as Timestamp).toDate();
    } else if (data['date'] is String) {
      final parts = data['date'].split('/');
      eventDate = DateTime(
        int.parse(parts[2]), // Year
        int.parse(parts[1]), // Month
        int.parse(parts[0]), // Day
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

    return Event(
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

  factory Event.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Event.fromFirestore(snapshot.id, data);
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

Future<void> addEvent(Event event) async {
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

Future<void> updateEvent(Event event, String eventId) async {
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

Future<Event> getEventById(String eventId) async {
  try {
    DocumentReference eventRef =
        FirebaseFirestore.instance.collection('events').doc(eventId);
    DocumentSnapshot snapshot = await eventRef.get();

    if (snapshot.exists) {
      return Event.fromFirestore(
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

Future<List<Event>> getAllEvents() async {
  try {
    CollectionReference events =
        FirebaseFirestore.instance.collection('events');
    QuerySnapshot snapshot = await events.get();

    if (snapshot.docs.isEmpty) {
      return [];
    } else {
      return snapshot.docs.map((doc) {
        return Event.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error fetching events: $e');
    }
    rethrow;
  }
}
