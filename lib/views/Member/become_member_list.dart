import 'package:churchapp/views/member/member.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BecomeMemberList extends StatefulWidget {
  const BecomeMemberList({super.key});

  @override
  State<BecomeMemberList> createState() => _BecomeMemberListState();
}

class _BecomeMemberListState extends State<BecomeMemberList> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Member> _members = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchMembers();
  }

  Future<void> _fetchMembers() async {
    try {
      QuerySnapshot snapshot =
          await _firestore.collection('becomeMember').get();
      setState(() {
        _members =
            snapshot.docs.map((doc) => Member.fromDocument(doc)).toList();
        _loading = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching members: $e');
      }
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Membership Applications'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _members.length,
              itemBuilder: (context, index) {
                final member = _members[index];
                return ListTile(
                  title: Text(member.fullName),
                  subtitle: Text(
                      'Phone: ${member.phoneNumber}\nAddress: ${member.address}'),
                  trailing: ElevatedButton(
                    onPressed: () {},
                    child: const Text('View Details'),
                  ),
                );
              },
            ),
    );
  }
}
