import 'package:cached_network_image/cached_network_image.dart';
import 'package:churchapp/views/videos/video_provider.dart';
import 'package:churchapp/views/videos/videos_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
// ignore: library_prefixes
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as YT;

class Videos extends StatefulWidget {
  const Videos({super.key});

  @override
  State<Videos> createState() => _VideosState();
}

class _VideosState extends State<Videos> {
  final VideosService _videosService = VideosService();
  final TextEditingController _controller = TextEditingController();
  bool _showAddLinkField = false;
  bool _isSearching = false;
  bool _showDeleteIcons = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final videosProvider =
          Provider.of<VideosProvider>(context, listen: false);
      if (videosProvider.videos.isEmpty) {
        videosProvider.fetchVideos();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final videosProvider = Provider.of<VideosProvider>(context);
    List<Map<String, dynamic>> filteredVideos = videosProvider.videos
        .where((video) => video['title']
            .toString()
            .toLowerCase()
            .contains(_searchQuery.toLowerCase()))
        .toList();

    filteredVideos.sort((a, b) {
      DateTime? aDate = a['uploadDate'];
      DateTime? bDate = b['uploadDate'];
      if (aDate == null || bDate == null) return 0;
      return bDate.compareTo(aDate);
    });

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _controller,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Pesquisar vídeos...',
                  border: InputBorder.none,
                ),
                autofocus: true,
              )
            : const Text('Videos'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                _controller.clear();
                _searchQuery = '';
              });
            },
          ),
          IconButton(
            icon: Icon(_showAddLinkField ? Icons.close : Icons.add),
            onPressed: () {
              setState(() {
                _showAddLinkField = !_showAddLinkField;
              });
            },
          ),
          IconButton(
            icon: Icon(_showDeleteIcons ? Icons.close : Icons.delete),
            onPressed: () {
              setState(() {
                _showDeleteIcons = !_showDeleteIcons;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (_showAddLinkField)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        labelText: 'Enter YouTube link',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => _addVideo(),
                    icon: const Icon(Icons.add),
                    iconSize: 30,
                    padding: const EdgeInsets.all(0),
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
          Expanded(
            child: videosProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: filteredVideos.length,
                    itemBuilder: (context, index) {
                      final video = filteredVideos[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CachedNetworkImage(
                              imageUrl: video['thumbnailUrl'] ?? '',
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) => const Icon(
                                  Icons.image_not_supported,
                                  size: 200,
                                  color: Colors.grey),
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4.0, horizontal: 16.0),
                              child: Text(
                                video['title'] ?? 'No title',
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4.0, horizontal: 16.0),
                              child: Text(
                                '${video['author'] ?? 'Unknown'} • ${_timeAgo(video['uploadDate'])}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                        trailing: _showDeleteIcons
                            ? IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () =>
                                    _deleteVideo(videosProvider, video['id']),
                              )
                            : null,
                        onTap: () => _launchURL(video['url'] ?? ''),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _addVideo() async {
    final String url = _controller.text.trim();
    String? videoId;

    try {
      if (url.startsWith('https://www.youtube.com/')) {
        Uri parsedUrl = Uri.parse(url);

        if (parsedUrl.queryParameters.containsKey('v')) {
          videoId = parsedUrl.queryParameters['v'];
        } else if (parsedUrl.pathSegments.contains('live')) {
          videoId = parsedUrl.pathSegments.last;
        }
      } else if (url.startsWith('https://youtu.be/')) {
        videoId = url.substring(url.lastIndexOf('/') + 1).split('?').first;
      }

      if (videoId == null || videoId.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'ID do vídeo não encontrado. Por favor, insira um link válido do YouTube.',
            ),
          ),
        );
        return;
      }

      var yt = YT.YoutubeExplode();
      var video = await yt.videos.get(YT.VideoId(videoId));
      yt.close();

      String title = video.title;
      String author = video.author;
      String thumbnailUrl = video.thumbnails.highResUrl;
      Duration? duration = video.duration ?? Duration.zero;
      DateTime? uploadDate = video.uploadDate;

      await _videosService.addVideo(
        videoId,
        url,
        title,
        author,
        thumbnailUrl,
        duration,
        uploadDate,
      );

      if (!mounted) return;
      await Provider.of<VideosProvider>(context, listen: false).fetchVideos();

      setState(() {
        _controller.clear();
        _showAddLinkField = false;
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vídeo adicionado com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao adicionar vídeo: $e')),
      );
    }
  }

  Future<void> _launchURL(String url) async {
    if (url.isEmpty) return;
    final url0 = Uri.parse(url);
    if (!await launchUrl(url0, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url0');
    }
  }

  Future<void> _deleteVideo(VideosProvider provider, String id) async {
    try {
      await provider.deleteVideo(id);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error deleting video')),
        );
      }
    }
  }

  String _timeAgo(DateTime? dateTime) {
    if (dateTime == null) return 'Desconhecido';
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    if (difference.inDays >= 365) {
      return '${(difference.inDays / 365).floor()} anos atrás';
    }
    if (difference.inDays >= 30) {
      return '${(difference.inDays / 30).floor()} meses atrás';
    }
    if (difference.inDays > 1) return '${difference.inDays} dias atrás';
    if (difference.inDays == 1) return '1 dia atrás';
    if (difference.inHours > 1) return '${difference.inHours} horas atrás';
    if (difference.inHours == 1) return '1 hora atrás';
    if (difference.inMinutes > 1) {
      return '${difference.inMinutes} minutos atrás';
    }
    if (difference.inMinutes == 1) return '1 minuto atrás';
    return 'Agora';
  }
}
