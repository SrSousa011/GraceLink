import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:churchapp/data/model/photos_data.dart';
import 'package:churchapp/views/photos/photos_service.dart';

class EditPhotoScreen extends StatefulWidget {
  final PhotoData photo;

  const EditPhotoScreen({super.key, required this.photo});

  @override
  State<EditPhotoScreen> createState() => _EditPhotoScreenState();
}

class _EditPhotoScreenState extends State<EditPhotoScreen> {
  final _locationController = TextEditingController();
  late List<String> _photoUrls;
  final PhotosService _photosService = PhotosService();

  @override
  void initState() {
    super.initState();
    _locationController.text = widget.photo.location;
    _photoUrls = List.from(widget.photo.urls);
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }


  void _updatePhoto() async {
  final newLocation = _locationController.text.trim();

  if (newLocation.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Location cannot be empty')),
    );
    return;
  }

  try {
    await _photosService.savePhotoData(newLocation, _photoUrls);
    Navigator.of(context).pop(true);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error updating photo: $e')),
    );
  }
}


  void _reorderPhotos(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final movedUrl = _photoUrls.removeAt(oldIndex);
      _photoUrls.insert(newIndex, movedUrl);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Photo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _updatePhoto,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: 'Location'),
            ),
            const SizedBox(height: 16.0),
            const Text('Reorder Photos'),
            Expanded(
              child: ReorderableListView(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                onReorder: _reorderPhotos,
                children: _photoUrls.asMap().entries.map((entry) {
                  final index = entry.key;
                  final url = entry.value;
                  return Padding(
                    key: ValueKey(
                        '$index-$url'), // Chave única baseada no índice e URL
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: CachedNetworkImage(
                        imageUrl: url,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                      title: Text(
                          'Photo $index'), // Opcionalmente inclua o índice no título
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
