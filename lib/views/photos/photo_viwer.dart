import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FullScreenPhotoPage extends StatefulWidget {
  final List<String> photoUrls;
  final int initialIndex;

  const FullScreenPhotoPage({
    super.key,
    required this.photoUrls,
    required this.initialIndex,
  });

  @override
  State<FullScreenPhotoPage> createState() => _FullScreenPhotoPageState();
}

class _FullScreenPhotoPageState extends State<FullScreenPhotoPage> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            itemCount: widget.photoUrls.length,
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemBuilder: (context, index) {
              return Center(
                child: SizedBox(
                  width: 600,
                  height: 600,
                  child: CachedNetworkImage(
                    imageUrl: widget.photoUrls[index],
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              );
            },
          ),
          Positioned(
            top: 130,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                '${_currentIndex + 1}/${widget.photoUrls.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
