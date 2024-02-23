// ignore: file_names
import 'package:flutter/material.dart';
import 'package:churchapp/Login.dart';
import 'package:churchapp/SignUp/SignUp.dart';

class Welcome extends StatelessWidget {
  const Welcome({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/imagens/background_image.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Spacer(), // Adiciona espaço para empurrar para baixo o logotipo e a escrita
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icons/logo.png',
                  height: 400,
                  width: 4000,
                ),
              ],
            ),
            const Spacer(), // Adiciona outro espaço para centralizar os botões de login/cadastro
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
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
                      foregroundColor: const Color(0xFF1E88E5),
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Color(0xFF1E88E5)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: const Text('Login'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUp()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: const Color.fromARGB(255, 90, 175, 249),
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: const Text('Sign Up'),
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
