import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            CircleAvatar(
              radius: 80,
              backgroundImage: AssetImage('caminho/para/a/imagem.jpg'),
            ),
            SizedBox(height: 10),
            Text(
              'Nome da Pessoa',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Localização - Sigla do País',
              style: TextStyle(
                fontSize: 18,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Ação para seguir a pessoa
              },
              child: Text('Seguir'),
            ),
            SizedBox(height: 20),
            Text(
              'Fotos da Pessoa',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('caminho/para/a/imagem1.jpg',
                    width: 100, height: 100),
                SizedBox(width: 10),
                Image.asset('caminho/para/a/imagem2.jpg',
                    width: 100, height: 100),
                SizedBox(width: 10),
                Image.asset('caminho/para/a/imagem3.jpg',
                    width: 100, height: 100),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
