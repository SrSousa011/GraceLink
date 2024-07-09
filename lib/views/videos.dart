import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as YT;

class Videos extends StatefulWidget {
  const Videos({super.key});

  @override
  State<Videos> createState() => _VideosState();
}

class _VideosState extends State<Videos> {
  final List<String> youtubeLinks = [
    'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
    'https://www.youtube.com/watch?v=3JZ_D3ELwOQ',
    'https://www.youtube.com/watch?v=L_jWHffIx5E',
  ];

  final TextEditingController _controller = TextEditingController();

  Future<YT.Video> _fetchVideo(String url) async {
    var yt = YT.YoutubeExplode();
    var videoId = YT.VideoId.parseVideoId(url);
    var video = await yt.videos.get(videoId!);
    yt.close();
    return video;
  }

  void _launchURL(String url) async {
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
  }

  void _addLink() {
    final String url = _controller.text.trim();
    if (url.isNotEmpty && url.startsWith('https://www.youtube.com/')) {
      setState(() {
        youtubeLinks.add(url);
      });
      _controller.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, insira um link válido do YouTube'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('YouTube Links'),
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
          Expanded(
            child: youtubeLinks.isEmpty
                ? Center(
                    child: Text(
                      'Nenhum link adicionado ainda.',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  )
                : ListView.builder(
                    itemCount: youtubeLinks.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () => _launchURL(youtubeLinks[index]),
                        child: Card(
                          margin: const EdgeInsets.all(8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                FutureBuilder<YT.Video>(
                                  future: _fetchVideo(youtubeLinks[index]),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const SizedBox(
                                        height: 200,
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    } else if (snapshot.hasError) {
                                      return const Icon(Icons.error_outline);
                                    } else if (snapshot.hasData) {
                                      var video = snapshot.data!;
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Image.network(
                                            'https://i.ytimg.com/vi/${video.id.value}/hqdefault.jpg',
                                            height: 200,
                                            fit: BoxFit.cover,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            video.title,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            youtubeLinks[index],
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall,
                                          ),
                                        ],
                                      );
                                    } else {
                                      return const SizedBox.shrink();
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
