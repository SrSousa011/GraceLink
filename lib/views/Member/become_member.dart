import 'package:churchapp/views/nav_bar.dart';
import 'package:flutter/material.dart';

class BecomeMember extends StatefulWidget {
  const BecomeMember({Key? key}) : super(key: key);

  @override
  _BecomeMemberState createState() => _BecomeMemberState();
}

class _BecomeMemberState extends State<BecomeMember> {
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController dddController = TextEditingController();
  TextEditingController churchController = TextEditingController();
  TextEditingController maritalStatusController = TextEditingController();
  TextEditingController reasonController = TextEditingController();
  TextEditingController referenceController = TextEditingController();

  String selectedCivilState = 'Single';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tornar-se Membro'),
        centerTitle: true,
      ),
      drawer: const NavBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Adress'),
            ),
            const SizedBox(height: 20.0),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: dddController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'DDD'),
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Telefone'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: churchController,
              decoration:
                  const InputDecoration(labelText: 'Última igreja visitada?'),
            ),
            const SizedBox(height: 20.0),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Estado Civil?',
              ),
              value: selectedCivilState,
              onChanged: (value) {
                setState(() {
                  selectedCivilState = value!;
                });
              },
              items: const [
                DropdownMenuItem<String>(
                  value: 'Single',
                  child: Text('Single'),
                ),
                DropdownMenuItem<String>(
                  value: 'Married',
                  child: Text('Married'),
                ),
                DropdownMenuItem<String>(
                  value: 'Divorced',
                  child: Text('Divorced'),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                  labelText: 'Porque deseja se tornar um membro?'),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: referenceController,
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
