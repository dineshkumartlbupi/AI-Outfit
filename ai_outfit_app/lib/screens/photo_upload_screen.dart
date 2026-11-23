import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../core/theme.dart';
import '../state/tryon_provider.dart';
import 'focus_area_screen.dart';

class PhotoUploadScreen extends StatelessWidget {
  const PhotoUploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TryOnProvider>();
    final selectedGarment = provider.selectedGarment;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Start With Your Real Look'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Selected Garment Mini Card
            if (selectedGarment != null)
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.cardDark,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: selectedGarment.thumbnailUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'TRYING ON:',
                            style: TextStyle(
                              color: AppTheme.primaryLight,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            selectedGarment.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Change', style: TextStyle(color: Colors.white60, fontSize: 12)),
                    ),
                  ],
                ),
              ),

            // Guidelines Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.cardDark,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.strokeDark),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.tips_and_updates_outlined, color: Colors.amber, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Photo Guidelines for Best AI Fitting',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildGuidelineItem(Icons.check_circle_outline, 'Single person (solo) facing the camera directly'),
                  _buildGuidelineItem(Icons.check_circle_outline, 'Well-lit with clear facial and body contours'),
                  _buildGuidelineItem(Icons.check_circle_outline, 'Stand upright with arms slightly resting at sides'),
                  _buildGuidelineItem(Icons.check_circle_outline, 'Fitted clothing helps the AI wrap fabric naturally'),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Current Photo Preview (if selected)
            if (provider.userImageUrl != null || provider.userImageFile != null) ...[
              const Text(
                'Selected Photo',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                height: 220,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.primary, width: 2),
                ),
                clipBehavior: Clip.antiAlias,
                child: provider.userImageFile != null
                    ? Image.file(provider.userImageFile!, fit: BoxFit.cover)
                    : CachedNetworkImage(
                        imageUrl: provider.userImageUrl!,
                        fit: BoxFit.cover,
                      ),
              ),
              const SizedBox(height: 20),
            ],

            // Photo Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => provider.captureFromCamera(),
                    icon: const Icon(Icons.camera_alt_outlined, color: Colors.white),
                    label: const Text('Take Photo', style: TextStyle(color: Colors.white)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: AppTheme.strokeDark),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => provider.pickFromGallery(),
                    icon: const Icon(Icons.photo_library_outlined, color: Colors.white),
                    label: const Text('From Gallery', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.surfaceDark,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: const BorderSide(color: AppTheme.strokeDark),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // Sample Models (Quick Try)
            const Text(
              'Or Try With Sample Models',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              'Instant preview without uploading your photo:',
              style: TextStyle(color: Colors.white60, fontSize: 12),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: provider.sampleModels.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final model = provider.sampleModels[index];
                  final isSelected = provider.userImageUrl == model.imageUrl;
                  return GestureDetector(
                    onTap: () => provider.selectSampleModel(model),
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? AppTheme.primary : AppTheme.strokeDark,
                              width: isSelected ? 3 : 1.5,
                            ),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: CachedNetworkImage(
                            imageUrl: model.thumbnailUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          model.name.split(' ')[0],
                          style: TextStyle(
                            color: isSelected ? AppTheme.primaryLight : Colors.white70,
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: const BoxDecoration(
            color: AppTheme.cardDark,
            border: Border(top: BorderSide(color: AppTheme.strokeDark, width: 0.8)),
          ),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: (provider.userImageUrl != null || provider.userImageFile != null)
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FocusAreaScreen(),
                        ),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                disabledBackgroundColor: Colors.white12,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Continue to Focus Area', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_rounded, size: 18),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGuidelineItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF10B981), size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
