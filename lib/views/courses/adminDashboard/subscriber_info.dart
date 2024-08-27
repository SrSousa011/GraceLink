import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SubscriberInfo extends StatefulWidget {
  final String userId;
  final String userName;
  final DateTime registrationDate;
  final String courseName;
  final String imagePath;

  const SubscriberInfo({
    super.key,
    required this.userId,
    required this.userName,
    required this.registrationDate,
    required this.courseName,
    required this.imagePath,
  });

  @override
  State<SubscriberInfo> createState() => _SubscriberInfoState();
}

class _SubscriberInfoState extends State<SubscriberInfo> {
  bool? _status;
  late DocumentReference<Map<String, dynamic>> _docRef;
  late Stream<DocumentSnapshot<Map<String, dynamic>>> _statusStream;

  @override
  void initState() {
    super.initState();

    _docRef = FirebaseFirestore.instance
        .collection('courseRegistration')
        .doc(widget.userId);

    _statusStream = _docRef.snapshots();

    _statusStream.listen((docSnapshot) {
      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null) {
          setState(() {
            _status = data['status'] ?? false;
          });
        } else {
          setState(() {
            _status = false;
          });
        }
      } else {
        setState(() {
          _status = false;
        });
      }
    });
  }

  Future<void> _toggleStatus() async {
    if (_status == null) return;

    try {
      final newStatus = !_status!;
      await _docRef.update({'status': newStatus});
      setState(() {
        _status = newStatus;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating status: $e'),
        ),
      );
    }
  }

  Color _getBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[900]!
        : Colors.white;
  }

  Color _getAppBarColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[850]!
        : const Color.fromARGB(255, 255, 255, 255);
  }

  Color _getCardColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[800]!
        : Colors.grey[100]!;
  }

  Color _getTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
  }

  Color _getSubtitleColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[300]!
        : Colors.grey[600]!;
  }

  Color _getStatusColor() {
    if (_status == null) return Colors.grey;
    return _status! ? Colors.green[700]! : Colors.red[700]!;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor =
        theme.brightness == Brightness.dark ? Colors.blueGrey : Colors.blue;

    String formattedDate =
        '${widget.registrationDate.day.toString().padLeft(2, '0')}/'
        '${widget.registrationDate.month.toString().padLeft(2, '0')}/'
        '${widget.registrationDate.year}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Assinante'),
        backgroundColor: _getAppBarColor(context),
      ),
      backgroundColor: _getBackgroundColor(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: _getCardColor(context),
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: widget.imagePath.isNotEmpty
                              ? NetworkImage(widget.imagePath)
                              : null,
                          radius: 30,
                          child: widget.imagePath.isEmpty
                              ? Icon(Icons.person,
                                  color: _getTextColor(context))
                              : null,
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Text(
                            widget.userName,
                            style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: _getTextColor(context)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Curso: ${widget.courseName}',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(color: _getSubtitleColor(context)),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Data de Inscrição: $formattedDate',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(color: _getSubtitleColor(context)),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      'Status:',
                      style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: _getTextColor(context)),
                    ),
                    const SizedBox(height: 8.0),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: _getStatusColor(),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Text(
                        _status == null
                            ? 'Carregando...'
                            : (_status! ? 'Pago' : 'Não Pago'),
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 150.0,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: const Text('Voltar',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 16.0),
                SizedBox(
                  width: 150.0,
                  child: ElevatedButton(
                    onPressed: _toggleStatus,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: Text(
                      _status == null
                          ? 'Carregando...'
                          : (_status! ? 'Não Pago' : 'Pago'),
                      style: const TextStyle(color: Colors.white),
                    ),
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
