import 'package:flutter/material.dart';
import 'package:churchapp/Login.dart';
import 'package:churchapp/SignUp.dart';

class Welcome extends StatelessWidget {
  const Welcome({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Container(
        color: Colors.lightBlue[100], // Cor de pele
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Spacer(),
            Text(
              'Resplandecendo',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'as',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'Naçoes - Athus',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Spacer(),
            Container(
              color: Colors.white, // Faixa branca
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Login()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white, // Cor de fundo branca
                      onPrimary: Color(0xFF1E88E5), // Cor do texto azul
                      side: BorderSide(color: Color(0xFF1E88E5)), // Borda azul
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: Text('Login'),
                  ),
                  SizedBox(width: 20), // Espaçamento entre os botões
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUp()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(
                          255, 90, 175, 249), // Cor de fundo azul
                      onPrimary: Colors.white, // Cor do texto branco
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: Text('Sign Up'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
