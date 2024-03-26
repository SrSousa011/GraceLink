import 'package:churchapp/views/nav_bar.dart';
import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre Nós'),
      ),
      drawer: const NavBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              'assets/aboutUs/aboutus.jpg',
              fit: BoxFit.cover,
              height: 100, // Ajuste aqui
              width: double.infinity,
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Unidos pelo Amor e Serviço',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Somos uma igreja evangélica missionária comprometida em levar a Palavra de Deus e o amor de Cristo para além de nossas fronteiras. Acreditamos que nossa missão vai além de nossas paredes e que precisamos ser instrumentos de transformação nas comunidades carentes. Nosso objetivo é ser uma igreja acolhedora, que vive e prega o amor e a compaixão, buscando fazer a diferença nas vidas das pessoas.',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 12),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 16.0),
                        child: Text(
                          'Conheça os Pastores que Lideram e Cuidam de Nossa Igreja',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Image.asset(
                                    'assets/aboutUs/antonio.jpg',
                                    height: 200, // Ajuste aqui
                                    width: double.infinity,
                                  ),
                                ),
                                const Expanded(
                                  flex: 3,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Antônio Carlos Macedo',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'O Pastor Antônio Macedo é um homem de fé dedicado ao serviço de Deus e ao cuidado das pessoas em nossa igreja. Com profunda sabedoria bíblica e uma paixão contagiante, ele lidera com integridade, amor e compromisso. Sua visão é inspirar e capacitar cada membro a crescer espiritualmente, alcançar seu potencial e impactar positivamente o mundo ao seu redor. O Pastor Antonio é uma bênção para nossa comunidade, orientando-nos no caminho da verdade e servindo como exemplo de fé inabalável.',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.normal,
                                          ),
                                          textAlign: TextAlign.justify,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                const Expanded(
                                  flex: 3,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Joaldo dos Santos',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'O Pastor Joaldo dos Santos é um homem de profunda sabedoria, cujo o amor pelo Evangelho é evidente. Sua liderança é marcada por uma integridade impecável e um amor incondicional pelas pessoas. Ele é um exemplo inspirador de como viver os princípios cristãos no dia a dia. Sua liderança sábia, sua empatia sincera e seu compromisso com a Palavra de Deus têm tocado vidas e transformado corações. Sua mensagem de esperança, amor e redenção ressoa em nossos encontros, inspirando-nos a buscar uma vida de propósito e significado.',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.normal,
                                          ),
                                          textAlign: TextAlign.justify,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Image.asset(
                                    'assets/aboutUs/joaldo.jpg',
                                    height: 170, // Ajuste aqui
                                    width: double.infinity,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rumo a um Propósito Maior',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Nossa missão',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Nossa visão como igreja e transformação nas vidas das pessoas, compartilhando o amor de Cristo através de ações práticas e relevantes. Buscamos alcançar aqueles que estão em situações de necessidade, levando-lhes conforto espiritual, suprindo suas necessidades físicas e capacitando-os para uma vida plena.',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Nossa visão',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'A missão da nossa igreja é glorificar a Deus, levar o amor de Cristo ao mundo e fazer discípulos de todas as nações. Buscamos cumprir a vontade de Deus ao pregar o Evangelho, ensinar as Escrituras, edificar a comunidade de fé e servir a humanidade. Em essência, nossa missão é amar a Deus sobre todas as coisas e amar ao próximo como a nós mesmos.',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
            Image.asset(
              'assets/aboutUs/hands.jpg',
              fit: BoxFit.cover,
              height: 100, // Ajuste aqui
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}
