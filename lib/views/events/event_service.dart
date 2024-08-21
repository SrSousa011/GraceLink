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
    return Event(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      time: TimeOfDay(
        hour: int.parse(data['time'].split(':')[0]),
        minute: int.parse(data['time'].split(':')[1]),
      ),
      location: data['location'] ?? '',
      createdBy: data['createdBy'] ?? '',
      imageUrl: data['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'date': date,
      'time': '${time.hour}:${time.minute}',
      'location': location,
      'createdBy': createdBy,
      'imageUrl': imageUrl,
    };
  }

  Event copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    TimeOfDay? time,
    String? location,
    String? createdBy,
    String? imageUrl,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      time: time ?? this.time,
      location: location ?? this.location,
      createdBy: createdBy ?? this.createdBy,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}

Future<void> addEvent(Event event) async {
  try {
    CollectionReference events =
        FirebaseFirestore.instance.collection('events');
    await events.add({
      'title': event.title,
      'description': event.description,
      'date': Timestamp.fromDate(event.date),
      'time': '${event.time.hour}:${event.time.minute}',
      'location': event.location,
      'createdBy': event.createdBy,
      'imageUrl': event.imageUrl,
    });
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
    await events.doc(eventId).update({
      'title': event.title,
      'description': event.description,
      'date': Timestamp.fromDate(event.date),
      'time': '${event.time.hour}:${event.time.minute}',
      'location': event.location,
      'createdBy': event.createdBy,
      'imageUrl': event.imageUrl,
    });
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
