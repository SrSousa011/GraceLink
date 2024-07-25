import 'package:churchapp/views/videos/video_cache.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as YT;
import 'package:cached_network_image/cached_network_image.dart';

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
  bool _isSelectionMode = false;
  final List<String> _selectedVideos = [];
  bool _showAddLinkField = false;

  final VideoCache _videoCache = VideoCache();

  Future<YT.Video> _fetchVideo(String url) async {
    if (_videoCache.contains(url)) {
      return _videoCache.get(url)!;
    }

    var yt = YT.YoutubeExplode();
    var videoId = YT.VideoId.parseVideoId(url);
    if (videoId == null) {
      throw Exception('Invalid video URL');
    }
    var video = await yt.videos.get(videoId);
    yt.close();

    _videoCache.add(url, video);

    return video;
  }

  Future<void> _launchURL(String url) async {
    final url0 = Uri.parse(url);
    if (!await launchUrl(url0, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url0');
    }
  }

  void _toggleSelectionMode() {
    setState(() {
      _isSelectionMode = !_isSelectionMode;
      if (!_isSelectionMode) {
        _selectedVideos.clear();
      }
    });
  }

  void _toggleVideoSelection(String videoId) {
    setState(() {
      if (_selectedVideos.contains(videoId)) {
        _selectedVideos.remove(videoId);
      } else {
        _selectedVideos.add(videoId);
      }
    });
  }

  Future<void> _deleteSelectedVideos(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: const Text(
              'Tem certeza que deseja excluir os vídeos selecionados?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Excluir'),
              onPressed: () async {
                try {
                  for (var videoId in _selectedVideos) {
                    await _videosService.deleteVideo(videoId);
                  }
                  setState(() {
                    _selectedVideos.clear();
                    _isSelectionMode = false;
                  });
                  if (!context.mounted) return;
                  Navigator.of(context).pop();
                } catch (e) {
                  debugPrint('Error deleting videos: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Erro ao deletar vídeos.'),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _addLink() async {
    final String url = _controller.text.trim();
    String videoId = '';

    if (url.startsWith('https://www.youtube.com/')) {
      videoId = YT.VideoId.parseVideoId(url)!;
    } else if (url.startsWith('https://youtu.be/')) {
      videoId = url.substring(url.lastIndexOf('/') + 1).split('?').first;
    }

    if (videoId.isNotEmpty) {
      try {
        await _videosService.addVideo(videoId, url);
        setState(() {
          _controller.clear();
          _showAddLinkField = false;
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

  String _formatDuration(Duration? duration) {
    if (duration == null) {
      return 'Desconhecido';
    }
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes}m ${seconds}s';
  }

  String _timeAgo(DateTime? dateTime) {
    if (dateTime == null) {
      return 'Desconhecido';
    }
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays >= 365) {
      final years = (difference.inDays / 365).floor();
      return '$years ano${years > 1 ? 's' : ''} atrás';
    } else if (difference.inDays >= 30) {
      final months = (difference.inDays / 30).floor();
      return '$months mês${months > 1 ? 'es' : ''} atrás';
    } else if (difference.inDays > 1) {
      return '${difference.inDays} dias atrás';
    } else if (difference.inDays == 1) {
      return '1 dia atrás';
    } else if (difference.inHours > 1) {
      return '${difference.inHours} horas atrás';
    } else if (difference.inHours == 1) {
      return '1 hora atrás';
    } else if (difference.inMinutes > 1) {
      return '${difference.inMinutes} minutos atrás';
    } else if (difference.inMinutes == 1) {
      return '1 minuto atrás';
    } else {
      return 'Agora';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('YouTube Links'),
        actions: [
          IconButton(
            onPressed: _isSelectionMode
                ? null
                : () {
                    setState(() {
                      _showAddLinkField = !_showAddLinkField;
                    });
                  },
            icon: const Icon(Icons.add_outlined),
          ),
          IconButton(
            onPressed: _isSelectionMode
                ? () => _deleteSelectedVideos(context)
                : _toggleSelectionMode,
            icon: Icon(_isSelectionMode ? Icons.delete : Icons.list),
          ),
        ],
      ),
      drawer: NavBar(
        auth: AuthenticationService(),
        authService: AuthenticationService(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState: _showAddLinkField
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
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
          ),
          const SizedBox(height: 16),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _videosService.getVideos(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Erro: ${snapshot.error}'),
                  );
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  List<Map<String, dynamic>> sortedList = snapshot.data!;
                  return ListView.builder(
                    itemCount: sortedList.length,
                    itemBuilder: (context, index) {
                      var videoData = sortedList[index];
                      var videoId = videoData['id'] as String;
                      var videoUrl = videoData['url'] as String;
                      return Column(
                        children: [
                          InkWell(
                            onTap: _isSelectionMode
                                ? () => _toggleVideoSelection(videoId)
                                : () => _launchURL(videoUrl),
                            child: SizedBox(
                              width: double.infinity,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (_isSelectionMode)
                                    Checkbox(
                                      value: _selectedVideos.contains(videoId),
                                      onChanged: (_) =>
                                          _toggleVideoSelection(videoId),
                                    ),
                                  Expanded(
                                    child: FutureBuilder<YT.Video>(
                                      future: _fetchVideo(videoUrl),
                                      builder: (context, videoSnapshot) {
                                        if (videoSnapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const SizedBox(
                                            height: 180, // Increased height
                                            child: Center(
                                                child:
                                                    CircularProgressIndicator()),
                                          );
                                        } else if (videoSnapshot.hasError) {
                                          return const Icon(
                                              Icons.error_outline);
                                        } else if (videoSnapshot.hasData) {
                                          var video = videoSnapshot.data!;
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Stack(
                                                children: [
                                                  CachedNetworkImage(
                                                    imageUrl:
                                                        'https://i.ytimg.com/vi/${video.id}/hqdefault.jpg',
                                                    height:
                                                        180, // Increased height
                                                    width: double.infinity,
                                                    fit: BoxFit.cover,
                                                    placeholder: (context,
                                                            url) =>
                                                        const Center(
                                                            child:
                                                                CircularProgressIndicator()),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const Icon(Icons.error),
                                                  ),
                                                  Positioned(
                                                    bottom: 8,
                                                    right: 8,
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 6,
                                                          vertical: 2),
                                                      color: Colors.black
                                                          .withOpacity(0.7),
                                                      child: Text(
                                                        _formatDuration(
                                                            video.duration),
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 8),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0, right: 8.0),
                                                child: Text(
                                                  video.title,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium!
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10.0, right: 10.0),
                                                child: Text(
                                                  '${video.author} • ${_timeAgo(video.uploadDate)}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall,
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
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
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
    );
  }
}
