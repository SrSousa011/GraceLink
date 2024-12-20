import 'package:cached_network_image/cached_network_image.dart';
import 'package:churchapp/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:churchapp/views/nav_bar/nav_bar.dart';
import 'package:churchapp/views/videos/video_provider.dart';
import 'package:churchapp/views/videos/videos_service.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as YT;

class Videos extends StatefulWidget {
  const Videos({super.key});

  @override
  State<Videos> createState() => _VideosState();
}

class _VideosState extends State<Videos> {
  final AuthenticationService _auth = AuthenticationService();
  final VideosService _videosService = VideosService();
  final TextEditingController _controller = TextEditingController();
  bool _showAddLinkField = false;
  bool _isSearching = false;
  bool _isAdmin = false;
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
      _checkIfAdmin();
    });
  }

  Future<void> _checkIfAdmin() async {
    final bool isAdmin = await _shouldShowIcons();
    if (mounted) {
      setState(() {
        _isAdmin = isAdmin;
      });
    }
  }

  Future<bool> _shouldShowIcons() async {
    return _auth.isAdmin();
  }

  @override
  Widget build(BuildContext context) {
    final videosProvider = Provider.of<VideosProvider>(context);
    List<Map<String, dynamic>> filteredVideos = videosProvider.videos
        .where((video) => (video['title'] ?? '')
            .toString()
            .toLowerCase()
            .contains(_searchQuery.toLowerCase()))
        .toList();

    filteredVideos.sort((a, b) {
      DateTime aDate =
          a['uploadDate'] ?? DateTime.fromMillisecondsSinceEpoch(0);
      DateTime bDate =
          b['uploadDate'] ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bDate.compareTo(aDate);
    });

    return Scaffold(
      drawer: const NavBar(),
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
                _searchQuery = '';
              });
            },
          ),
          if (_isAdmin) ...[
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                setState(() {
                  _showAddLinkField = !_showAddLinkField;
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  _showDeleteIcons = !_showDeleteIcons;
                });
              },
            ),
          ],
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
                        title: Stack(
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
                            Positioned(
                              bottom: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4.0, horizontal: 6.0),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  _formatDuration(_parseDuration(
                                      video['duration'] ?? '0:00')),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                '${video['author'] ?? 'Desconhecido'} • ${_timeAgo(video['uploadDate'])}',
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

  Future<void> _deleteVideo(
      VideosProvider videosProvider, String videoId) async {
    try {
      await _videosService.deleteVideo(videoId);
      if (!mounted) return;
      videosProvider.fetchVideos();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vídeo excluído com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao excluir vídeo: $e')),
      );
    }
  }

  Duration _parseDuration(String duration) {
    final parts = duration.split(':');
    if (parts.length == 3) {
      final hours = int.tryParse(parts[0]) ?? 0;
      final minutes = int.tryParse(parts[1]) ?? 0;
      final seconds = int.tryParse(parts[2]) ?? 0;
      return Duration(hours: hours, minutes: minutes, seconds: seconds);
    } else if (parts.length == 2) {
      final minutes = int.tryParse(parts[0]) ?? 0;
      final seconds = int.tryParse(parts[1]) ?? 0;
      return Duration(minutes: minutes, seconds: seconds);
    }
    return Duration.zero;
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String _timeAgo(DateTime? date) {
    if (date == null) return '';
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays >= 365) {
      final years = difference.inDays ~/ 365;
      return years == 1 ? '1 ano atrás' : '$years anos atrás';
    } else if (difference.inDays >= 30) {
      final months = difference.inDays ~/ 30;
      return months == 1 ? '1 mês atrás' : '$months meses atrás';
    } else if (difference.inDays > 0) {
      final days = difference.inDays;
      return days == 1 ? '1 dia atrás' : '$days dias atrás';
    } else if (difference.inHours > 0) {
      final hours = difference.inHours;
      return hours == 1 ? '1 hora atrás' : '$hours horas atrás';
    } else if (difference.inMinutes > 0) {
      final minutes = difference.inMinutes;
      return minutes == 1 ? '1 minuto atrás' : '$minutes minutos atrás';
    } else {
      return 'Agora mesmo';
    }
  }
}
