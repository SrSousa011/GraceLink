import 'package:flutter/material.dart';

class BecomeMember extends StatefulWidget {
  const BecomeMember({Key? key}) : super(key: key);

  @override
  _BecomeMemberState createState() => _BecomeMemberState();
}

class _BecomeMemberState extends State<BecomeMember> {
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController churchController = TextEditingController();
  TextEditingController maritalStatusController = TextEditingController();
  TextEditingController reasonController = TextEditingController();
  TextEditingController referenceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tornar-se Membro'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: phoneController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Telefone'),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: churchController,
              obscureText: true,
              decoration:
                  const InputDecoration(labelText: 'Última igreja visitada?'),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: maritalStatusController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Estado Civil?'),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: reasonController,
              obscureText: true,
              decoration: const InputDecoration(
                  labelText: 'Porque deseja se tornar um membro?'),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: referenceController,
              obscureText: true,
              decoration: const InputDecoration(
                  labelText: 'Referência de um membro atual'),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Confirmação'),
                      content:
                          const Text('Você tornou-se um membro com sucesso!'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Fechar'),
                        ),
                      ],
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue, // Text color white
              ),
              child: const Text('Tornar-se Membro'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: BecomeMember(),
  ));
}
