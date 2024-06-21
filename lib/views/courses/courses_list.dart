class Course {
  final String title;
  final String instructor;
  final String description;
  final String descriptionDetails;
  final double price;
  String registrationDeadline;
  final String image;

  Course({
    required this.title,
    required this.instructor,
    required this.description,
    required this.descriptionDetails,
    required this.price,
    required this.registrationDeadline,
    required this.image,
  });
}

final List<Course> coursesList = [
  Course(
    title: 'Mulher Única',
    instructor: 'Para Mulheres | ministrado por pessoa fulana',
    description: 'Elevando sua autoestima e maximizando a adição das mulheres.',
    descriptionDetails:
        'Este curso visa elevar a autoestima e maximizar a adição das mulheres. Ao longo do programa, os participantes serão guiados através de uma jornada de autoexploração e desenvolvimento pessoal, onde aprenderão a reconhecer e abraçar sua singularidade, cultivar uma mentalidade positiva, fortalecer suas habilidades de comunicação e liderança, e estabelecer metas claras para alcançar o sucesso em suas vidas pessoais e profissionais. O curso é ministrado por instrutores experientes e oferece uma combinação de palestras, exercícios práticos, discussões em grupo e suporte individualizado para garantir uma experiência de aprendizado enriquecedora e transformadora para todas as participantes.',
    price: 100,
    registrationDeadline: '31/12/2024',
    image: 'assets/imagens/mulher-unica.jpg',
  ),
  Course(
    title: 'Homem ao Máximo',
    instructor: 'Para Homens | ministrado por pessoa fulana',
    description:
        'Elevando o nível máximo de sua hombridade e potencializando o sucesso familiar.',
    descriptionDetails:
        'O curso Homem ao Máximo é uma jornada de autodescoberta e desenvolvimento pessoal projetada para elevar o nível máximo de hombridade e potencializar o sucesso familiar. Durante este curso, os participantes explorarão diversos aspectos da masculinidade, incluindo habilidades de liderança, comunicação eficaz, construção de relacionamentos saudáveis e gestão de conflitos. Ao longo do programa, os participantes serão capacitados a identificar seus pontos fortes, superar desafios pessoais e alcançar seu pleno potencial como homens, contribuindo assim para o crescimento e prosperidade de suas famílias.',
    price: 100,
    registrationDeadline: '31/12/2024',
    image: 'assets/imagens/homen-ao-maximo.jpg',
  ),
  Course(
    title: 'Casados para sempre',
    instructor: 'Para casados | ministrado por pessoa fulana',
    description:
        'Um manual de instruções bíblicas para a saúde do seu casamento promovendo a alegria familiar.',
    descriptionDetails:
        'Casados para Sempre é um curso baseado em princípios bíblicos projetado para fortalecer a saúde do casamento e promover a alegria familiar. Os participantes aprendem a aplicar ensinamentos da Bíblia para resolver conflitos, melhorar a comunicação e construir um casamento duradouro e feliz. Ministrado por instrutores experientes, o curso oferece uma jornada de aprendizado enriquecedora e transformadora para casais comprometidos.',
    price: 100,
    registrationDeadline: '31/12/2024',
    image: 'assets/imagens/casados-para-sempre.jpg',
  ),
];
