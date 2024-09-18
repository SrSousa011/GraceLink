import 'package:churchapp/data/model/photos_data.dart';
import 'package:churchapp/views/photos/photos_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:intl/intl.dart';

const String tEditLocation = 'Editar Localização';
const String tEditLocationButton = 'Salvar';
const double tDefaultSize = 16.0;
const double tFormHeight = 20.0;
const String tLocation = 'Localização';
const String tDelete = 'Excluir';
const String tJoined = 'Adicionado em: '; // Corrigido para incluir algum texto

class UpdatePhotos extends StatefulWidget {
  final PhotoData photoData;

  const UpdatePhotos({super.key, required this.photoData});

  @override
  State<UpdatePhotos> createState() => _UpdatePhotosState();
}

class _UpdatePhotosState extends State<UpdatePhotos> {
  late TextEditingController _locationController;

  @override
  void initState() {
    super.initState();
    _locationController =
        TextEditingController(text: widget.photoData.location);
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return 'Data não disponível';
    final date = timestamp.toDate();
    return DateFormat('d MMM yyyy').format(date);
  }

  void _saveLocationChanges() {
    String location = _locationController.text;

    PhotosService photosService = PhotosService();

    photosService.updateLocation(widget.photoData.uploadId, location).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Localização atualizada com sucesso')),
      );

      Navigator.of(context).pop();
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao atualizar a localização: $error')),
      );
    });
  }

  void _clearFields() {
    setState(() {
      _locationController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color buttonColor =
        theme.brightness == Brightness.light ? Colors.blue : Colors.grey;

    final Color buttonTextColor =
        theme.brightness == Brightness.light ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(LineAwesomeIcons.angle_left_solid),
        ),
        title: Text(
          tEditLocation,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(tDefaultSize),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 50),
            Form(
              child: Column(
                children: [
                  TextFormField(
                    controller: _locationController,
                    decoration: const InputDecoration(
                      labelText: tLocation,
                      prefixIcon: Icon(LineAwesomeIcons.map_marker_alt_solid),
                    ),
                  ),
                  const SizedBox(height: tFormHeight),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveLocationChanges,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        shape: const StadiumBorder(),
                      ),
                      child: Text(
                        tEditLocationButton,
                        style: TextStyle(color: buttonTextColor),
                      ),
                    ),
                  ),
                  const SizedBox(height: tFormHeight),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: tJoined,
                          style: const TextStyle(fontSize: 12),
                          children: [
                            TextSpan(
                              text:
                                  _formatTimestamp(widget.photoData.createdAt),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _clearFields,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.brightness == Brightness.light
                              ? Colors.redAccent.withOpacity(0.1)
                              : Colors.grey,
                          elevation: 0,
                          foregroundColor: theme.brightness == Brightness.light
                              ? Colors.red
                              : Colors.black,
                          shape: const StadiumBorder(),
                        ),
                        child: const Text(tDelete),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
