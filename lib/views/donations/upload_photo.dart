import 'dart:io';

import 'package:churchapp/views/donations/donations.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StoragePage extends StatefulWidget {
  final String donationType;
  final String donationValue;
  final String fullName;

  const StoragePage({
    super.key,
    required this.donationType,
    required this.donationValue,
    required this.fullName,
  });

  @override
  State<StoragePage> createState() => _StoragePageState();
}

class _StoragePageState extends State<StoragePage> {
  final ImagePicker _picker = ImagePicker();
  String? _uploadedImageUrl;

  Future<void> _uploadImage() async {
    XFile? file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null && context.mounted) {
      try {
        // Example of how to use the picked image (not uploading it)
        setState(() {
          _uploadedImageUrl = file.path; // Use the local file path
        });
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error uploading image')),
          );
        }
      }
    }
  }

  void _removeImage() {
    setState(() {
      _uploadedImageUrl = null;
    });
  }

  Future<void> _confirmAndNavigateBack() async {
    if (_uploadedImageUrl != null) {
      try {
        // Save donation details to Firestore
        await FirebaseFirestore.instance.collection('donations').add({
          'userId': FirebaseAuth.instance.currentUser!.uid,
          'fullName': widget.fullName,
          'donationType': widget.donationType,
          'donationValue': widget.donationValue,
          'photoURL': _uploadedImageUrl,
          'timestamp': FieldValue.serverTimestamp(),
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Donation successfully completed')),
          );
        }

        if (mounted) {
          // Navigate back to DonationsPage and replace the current page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Donations()),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to complete donation: $e'),
            ),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload an image before confirming.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) {
          return;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Donation Details'),
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.upload),
              onPressed: _uploadedImageUrl != null ? null : _uploadImage,
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (_uploadedImageUrl != null)
                Card(
                  margin: const EdgeInsets.all(16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 5,
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(10.0)),
                        child: Image.file(
                          File(_uploadedImageUrl!),
                          width: double.infinity,
                          height: 300,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            ElevatedButton(
                              onPressed: _confirmAndNavigateBack,
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              child: const Text('Confirm'),
                            ),
                            ElevatedButton(
                              onPressed: _removeImage,
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              child: const Text('Remove'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              if (_uploadedImageUrl == null)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Please upload an image.'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
