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

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.location,
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
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'date': date,
      'time': '${time.hour}:${time.minute}',
      'location': location,
    };
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
