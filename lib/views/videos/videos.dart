import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as YT;

import 'videos_service.dart';
import 'package:churchapp/services/auth_service.dart';
import 'package:churchapp/views/nav_bar/nav_bar.dart';

class Videos extends StatefulWidget {
  const Videos({super.key});

  @override
  State<Videos> createState() => _VideosState();
}

class _VideosState extends State<Videos> {
  final VideosService _videosService = VideosService();
  final TextEditingController _controller = TextEditingController();

  Future<YT.Video> _fetchVideo(String url) async {
    var yt = YT.YoutubeExplode();
    var videoId = YT.VideoId.parseVideoId(url);
    var video = await yt.videos.get(videoId!);
    yt.close();
    return video;
  }

  void _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    try {
      if (await canLaunch(uri.toString())) {
        await launch(uri.toString());
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
  }

  void _addLink() async {
    final String url = _controller.text.trim();
    String videoId = '';

    // Verifica se o URL corresponde ao formato https://www.youtube.com/
    if (url.startsWith('https://www.youtube.com/')) {
      // Extrai o ID do vídeo
      videoId = YT.VideoId.parseVideoId(url)!;
    }
    // Verifica se o URL corresponde ao formato https://youtu.be/
    else if (url.startsWith('https://youtu.be/')) {
      // Extrai o ID do vídeo
      videoId = url.substring(url.lastIndexOf('/') + 1).split('?').first;
    }

    if (videoId.isNotEmpty) {
      try {
        await _videosService.addVideo(videoId, url);

        // Após adicionar o vídeo, atualiza a lista de vídeos
        setState(() {
          _controller.clear();
        });
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao adicionar vídeo.'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, insira um link válido do YouTube.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) {
          return;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('YouTube Links'),
        ),
        drawer: NavBar(
          auth: AuthenticationService(),
          authService: AuthenticationService(),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        labelText: 'Insira o link do YouTube',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _addLink,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: const Text(
                      'Adicionar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
                height: 16), // Espaço entre o cabeçalho e o primeiro vídeo
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _videosService.getVideos(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Erro: ${snapshot.error}'),
                    );
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    // Ordena os vídeos do mais antigo para o mais novo adicionado
                    List<Map<String, dynamic>> sortedList = snapshot.data!;

                    return ListView.builder(
                      itemCount: sortedList.length,
                      itemBuilder: (context, index) {
                        var videoData = sortedList[index];
                        return Column(
                          children: [
                            InkWell(
                              onTap: () => _launchURL(videoData['url']),
                              child: SizedBox(
                                width: double.infinity,
                                child: FutureBuilder<YT.Video>(
                                  future: _fetchVideo(videoData['url']),
                                  builder: (context, videoSnapshot) {
                                    if (videoSnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const SizedBox(
                                        height: 200,
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    } else if (videoSnapshot.hasError) {
                                      return const Icon(Icons.error_outline);
                                    } else if (videoSnapshot.hasData) {
                                      var video = videoSnapshot.data!;
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Image.network(
                                            'https://i.ytimg.com/vi/${video.id}/hqdefault.jpg',
                                            height:
                                                180, // Ajusta a altura da imagem para um formato mais retangular
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                          const SizedBox(height: 8),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Text(
                                              video.title,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6!
                                                  .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        16, // Diminui o tamanho do título
                                                  ),
                                            ),
                                          ),
                                        ],
                                      );
                                    } else {
                                      return const SizedBox.shrink();
                                    }
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 8), // Espaço entre os vídeos
                          ],
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: Text('Nenhum vídeo adicionado ainda.'),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
