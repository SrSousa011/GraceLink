import 'package:flutter/material.dart';
import 'package:churchapp/views/courses/courses_service.dart';

class SubscriberViewer extends StatefulWidget {
  final String userId;
  final String userName;
  final bool status;
  final DateTime registrationDate;
  final String courseName;

  const SubscriberViewer({
    super.key,
    required this.userId,
    required this.userName,
    required this.status,
    required this.registrationDate,
    required this.courseName,
  });

  @override
  State<SubscriberViewer> createState() => _SubscriberViewerState();
}

class _SubscriberViewerState extends State<SubscriberViewer> {
  final CoursesService _coursesService = CoursesService();
  bool? _status;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _status = widget.status;
  }

  Future<void> _toggleStatus() async {
    setState(() {
      _loading = true;
    });

    try {
      await _coursesService.updateUserStatus(
        userId: widget.userId,
        courseId: widget.courseName, // Adjust field if necessary
        status: !_status!,
      );

      setState(() {
        _status = !_status!;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_status! ? 'Marked as Paid' : 'Marked as Not Paid'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error updating status'),
        ),
      );
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor =
        theme.brightness == Brightness.dark ? Colors.blueGrey : Colors.blue;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscriber Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.person, size: 40, color: primaryColor),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Text(
                            widget.userName,
                            style: theme.textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Course: ${widget.courseName}',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Registration Date: ${widget.registrationDate.toLocal()}',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      'Status:',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8.0),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: _status! ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        _status! ? 'Paid' : 'Not Paid',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text('Back to List',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _loading ? null : _toggleStatus,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: _loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(_status! ? 'Mark as Not Paid' : 'Mark as Paid',
                            style: const TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
