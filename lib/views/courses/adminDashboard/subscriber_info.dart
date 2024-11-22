import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SubscriberInfo extends StatefulWidget {
  final String userId;
  final bool status;
  final String userName;
  final DateTime registrationDate;
  final String courseName;
  final String courseId;
  final String imagePath;

  const SubscriberInfo({
    super.key,
    required this.userId,
    required this.status,
    required this.userName,
    required this.registrationDate,
    required this.courseName,
    required this.courseId,
    required this.imagePath,
  });

  @override
  State<SubscriberInfo> createState() => _SubscriberInfoState();
}

class _SubscriberInfoState extends State<SubscriberInfo> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late bool _status;

  @override
  void initState() {
    super.initState();
    _status = widget.status;
  }

  Future<void> _updateStatus(bool newStatus) async {
    try {
      await _firestore
          .collection('courseRegistration')
          .where('userId', isEqualTo: widget.userId)
          .where('courseId', isEqualTo: widget.courseId)
          .get()
          .then((querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          querySnapshot.docs.first.reference.update({'status': newStatus});
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Curso não encontrado para este usuário.')),
          );
        }
      });

      setState(() {
        _status = newStatus;
      });
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
    final Color themeColor = isDarkMode ? Colors.white : Colors.black;
    final Color buttonBackgroundColor =
        isDarkMode ? Colors.blueGrey : Colors.blue;

    final buttonStyle = ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: buttonBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
      side: BorderSide.none,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Informações do Assinante',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        backgroundColor: isDarkMode
            ? Colors.grey[850]
            : const Color.fromARGB(255, 255, 255, 255),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: themeColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4.0,
              color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: widget.imagePath.isNotEmpty
                          ? NetworkImage(widget.imagePath)
                          : null,
                      backgroundColor:
                          isDarkMode ? Colors.grey[700] : Colors.grey[300],
                      child: widget.imagePath.isEmpty
                          ? Icon(
                              Icons.person,
                              color: themeColor,
                              size: 32,
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
                              color: themeColor,
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
                              color: themeColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            decoration: BoxDecoration(
                              color: _status
                                  ? (isDarkMode
                                      ? Colors.grey[800]
                                      : Colors.green)
                                  : (isDarkMode
                                      ? Colors.grey[800]
                                      : Colors.red),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Text(
                              _status ? 'Pago' : 'Não Pago',
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
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: buttonStyle,
                  child: const Text('Voltar'),
                ),
                ElevatedButton(
                  onPressed: () => _updateStatus(!_status),
                  style: buttonStyle,
                  child: Text(
                    _status ? 'Não Pago' : 'Pago',
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
