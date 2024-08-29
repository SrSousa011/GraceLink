import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SubscriberInfo extends StatefulWidget {
  final String userId;
  final bool status;
  final String userName;
  final DateTime registrationDate;
  final String courseName;
  final String imagePath;

  const SubscriberInfo({
    super.key,
    required this.userId,
    required this.status,
    required this.userName,
    required this.registrationDate,
    required this.courseName,
    required this.imagePath,
  });

  @override
  State<SubscriberInfo> createState() => _SubscriberInfoState();
}

class _SubscriberInfoState extends State<SubscriberInfo> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _updateStatus(bool newStatus) async {
    try {
      await _firestore
          .collection('courseRegistration')
          .doc(widget.userId)
          .update({'status': newStatus});
      setState(() {});
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar status: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Informações do Assinante'),
        backgroundColor: isDarkMode
            ? Colors.grey[850]
            : const Color.fromARGB(255, 255, 255, 255),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: isDarkMode ? Colors.white : Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4.0,
              color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: widget.imagePath.isNotEmpty
                              ? NetworkImage(widget.imagePath)
                              : null,
                          backgroundColor:
                              isDarkMode ? Colors.grey[700] : Colors.grey[300],
                          child: widget.imagePath.isEmpty
                              ? Icon(
                                  Icons.person,
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                )
                              : null,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.userName,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Curso: ${widget.courseName}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: isDarkMode
                                      ? Colors.grey[300]
                                      : Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Data de Inscrição: ${DateFormat('d MMMM yyyy').format(widget.registrationDate)}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: isDarkMode
                                      ? Colors.grey[300]
                                      : Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Status:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16.0),
                                decoration: BoxDecoration(
                                  color: widget.status
                                      ? Colors.green[700]
                                      : Colors.red[700],
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Text(
                                  widget.status ? 'Pago' : 'Não Pago',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDarkMode ? Colors.blueGrey : Colors.blue,
                  ),
                  child: const Text(
                    'Voltar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _updateStatus(!widget.status),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.status ? Colors.red : Colors.green,
                  ),
                  child: Text(
                    widget.status ? 'Não Pago' : 'Pago',
                    style: const TextStyle(color: Colors.white),
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
