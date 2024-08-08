import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EventImage extends StatelessWidget {
  final String? imageUrl;
  final String? localImagePath;
  final double imageHeight; // Altura ajustável

  const EventImage({
    super.key,
    this.imageUrl,
    this.localImagePath,
    this.imageHeight = 400.0, // Altura padrão
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size; // Obtém a largura da tela

    return Container(
      width: screenSize.width, // Largura total da tela
      height: imageHeight, // Altura ajustável
      padding: EdgeInsets.zero, // Remove o padding
      margin: EdgeInsets.zero, // Remove a margem
      child: localImagePath != null
          ? ClipRRect(
              borderRadius: BorderRadius.zero, // Sem bordas arredondadas
              child: Image.file(
                File(localImagePath!),
                fit: BoxFit.cover, // Preenche a área disponível
              ),
            )
          : imageUrl != null && imageUrl!.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.zero, // Sem bordas arredondadas
                  child: CachedNetworkImage(
                    imageUrl: imageUrl!,
                    fit: BoxFit.cover, // Preenche a área disponível
                    errorWidget: (context, error, stackTrace) {
                      return const Center(child: Text('Error loading image'));
                    },
                    placeholder: (context, url) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                  ),
                )
              : const SizedBox.shrink(),
    );
  }
}
