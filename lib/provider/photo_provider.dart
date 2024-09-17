import 'package:flutter/material.dart';
import 'package:churchapp/data/model/photos_data.dart';
import 'package:churchapp/views/photos/photos_service.dart';

class PhotoProvider with ChangeNotifier {
  List<PhotoData> _photos = [];
  final PhotosService _photosService = PhotosService();

  List<PhotoData> get photos => _photos;

  Future<void> fetchPhotos() async {
    _photos =
        (_photosService.getPhotosWithLocationsStream()) as List<PhotoData>;

    _photos.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    notifyListeners();
  }

  Future<void> updatePhoto(
      PhotoData photo, String newLocation, List<String> newUrls) async {
    await _photosService.savePhotoData(newLocation, newUrls);
    await fetchPhotos();
  }
}
