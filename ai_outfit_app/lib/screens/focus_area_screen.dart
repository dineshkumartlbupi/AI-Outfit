import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../core/theme.dart';
import '../models/garment.dart';
import '../state/tryon_provider.dart';
import 'processing_screen.dart';

class FocusAreaScreen extends StatelessWidget {
  const FocusAreaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TryOnProvider>();
    final selectedGarment = provider.selectedGarment;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Focus Area'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Body Framing',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Select whether to fit tops, pants, or the complete outfit for realistic alignment:',
              style: TextStyle(color: Colors.white60, fontSize: 13),
            ),
            const SizedBox(height: 18),

            // Photo Preview with Interactive Target Zone Overlay
            Center(
              child: Container(
                height: 300,
                width: 220,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppTheme.surfaceDark,
                  border: Border.all(color: AppTheme.strokeDark),
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Photo
                    if (provider.userImageFile != null)
                      Image.file(provider.userImageFile!, fit: BoxFit.cover)
                    else if (provider.userImageUrl != null)
                      CachedNetworkImage(
                        imageUrl: provider.userImageUrl!,
                        fit: BoxFit.cover,
                      ),

                    // Focus Area Target Highlight Box
                    _buildFocusOverlay(provider.focusArea),

                    // Floating target tag
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          provider.focusArea.displayName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 3 Focus Area Option Cards
            _buildAreaCard(
              context: context,
              area: FocusArea.upperBody,
              icon: Icons.checkroom,
              title: 'Upper Body',
              subtitle: 'Shirts, tops, blouses, t-shirts, blazers & jackets',
              isSelected: provider.focusArea == FocusArea.upperBody,
              onTap: () => provider.setFocusArea(FocusArea.upperBody),
            ),
            const SizedBox(height: 10),
            _buildAreaCard(
              context: context,
              area: FocusArea.lowerBody,
              icon: Icons.accessibility_new,
              title: 'Lower Body',
              subtitle: 'Trousers, denim jeans, shorts & skirts',
              isSelected: provider.focusArea == FocusArea.lowerBody,
              onTap: () => provider.setFocusArea(FocusArea.lowerBody),
            ),
            const SizedBox(height: 10),
            _buildAreaCard(
              context: context,
              area: FocusArea.fullBody,
              icon: Icons.person_outline,
              title: 'Full Body',
              subtitle: 'Dresses, sarees, jumpsuits, evening gowns & full suits',
              isSelected: provider.focusArea == FocusArea.fullBody,
              onTap: () => provider.setFocusArea(FocusArea.fullBody),
            ),
            const SizedBox(height: 20),
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
            height: 54,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProcessingScreen(),
                  ),
                );
                provider.startTryOn();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 6,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      selectedGarment != null
                          ? 'Try On ${selectedGarment.name}'
                          : 'Generate Virtual Try-On',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFocusOverlay(FocusArea area) {
    switch (area) {
      case FocusArea.upperBody:
        return Positioned(
          top: 40,
          left: 20,
          right: 20,
          height: 130,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.primary, width: 2),
              borderRadius: BorderRadius.circular(12),
              color: AppTheme.primary.withOpacity(0.15),
            ),
          ),
        );
      case FocusArea.lowerBody:
        return Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          height: 150,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.primary, width: 2),
              borderRadius: BorderRadius.circular(12),
              color: AppTheme.primary.withOpacity(0.15),
            ),
          ),
        );
      case FocusArea.fullBody:
        return Positioned.fill(
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.primary, width: 2),
              borderRadius: BorderRadius.circular(14),
              color: AppTheme.primary.withOpacity(0.12),
            ),
          ),
        );
    }
  }

  Widget _buildAreaCard({
    required BuildContext context,
    required FocusArea area,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.surfaceDark : AppTheme.cardDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppTheme.primary : AppTheme.strokeDark,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primary.withOpacity(0.2) : Colors.white10,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: isSelected ? AppTheme.primaryLight : Colors.white70, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? AppTheme.primary : Colors.white38,
            ),
          ],
        ),
      ),
    );
  }
}
