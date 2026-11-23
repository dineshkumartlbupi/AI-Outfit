import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../core/theme.dart';
import '../models/garment.dart';
import '../state/tryon_provider.dart';
import 'photo_upload_screen.dart';

class GarmentDetailModal extends StatelessWidget {
  final GarmentTemplate garment;

  const GarmentDetailModal({super.key, required this.garment});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<TryOnProvider>();

    return Container(
      height: MediaQuery.of(context).size.height * 0.82,
      decoration: const BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // High-Res Image Card
                  Container(
                    height: 320,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppTheme.surfaceDark,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: CachedNetworkImage(
                      imageUrl: garment.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, _) => const Center(
                        child: CircularProgressIndicator(color: AppTheme.primary),
                      ),
                      errorWidget: (context, _, __) => const Center(
                        child: Icon(Icons.broken_image, color: Colors.white30, size: 48),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Title & Focus badge
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          garment.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.primary.withOpacity(0.4)),
                        ),
                        child: Text(
                          garment.focusArea.displayName,
                          style: const TextStyle(
                            color: AppTheme.primaryLight,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Fabric & Color pills
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (garment.fabric != null)
                        _buildChip(Icons.texture, garment.fabric!),
                      if (garment.color != null)
                        _buildChip(Icons.palette_outlined, garment.color!),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Description
                  Text(
                    garment.description,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Tags
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: garment.tags.map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceDark,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppTheme.strokeDark),
                        ),
                        child: Text(
                          '#$tag',
                          style: const TextStyle(color: Colors.white60, fontSize: 11),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),

          // Bottom Action Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppTheme.surfaceDark,
              border: Border(top: BorderSide(color: AppTheme.strokeDark, width: 0.8)),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  provider.selectGarment(garment);
                  Navigator.pop(context); // close modal
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PhotoUploadScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 6,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.auto_awesome, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Try On This Outfit',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.strokeDark),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white54),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
