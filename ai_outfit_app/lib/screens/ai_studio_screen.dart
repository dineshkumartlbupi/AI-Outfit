import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../core/theme.dart';
import '../state/tryon_provider.dart';
import 'photo_upload_screen.dart';

class AIStudioScreen extends StatefulWidget {
  const AIStudioScreen({super.key});

  @override
  State<AIStudioScreen> createState() => _AIStudioScreenState();
}

class _AIStudioScreenState extends State<AIStudioScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TryOnProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Beauty & Styling Studio'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.primary,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white54,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: const [
            Tab(icon: Icon(Icons.face_retouching_natural, size: 20), text: 'Hairstyles'),
            Tab(icon: Icon(Icons.face, size: 20), text: 'Beards'),
            Tab(icon: Icon(Icons.upload_file, size: 20), text: 'Custom Clothes'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 1. Hairstyles & Colors
          _buildHairstylesTab(provider),

          // 2. Beard Styles
          _buildBeardsTab(provider),

          // 3. Custom Garment Uploader
          _buildCustomGarmentTab(provider),
        ],
      ),
    );
  }

  Widget _buildHairstylesTab(TryOnProvider provider) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'AI Hairstyle & Hair Color Changer',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        const Text(
          'Test trendy cuts and bold shades before visiting the salon:',
          style: TextStyle(color: Colors.white60, fontSize: 13),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 0.70,
          ),
          itemCount: provider.hairstyles.length,
          itemBuilder: (context, index) {
            final hair = provider.hairstyles[index];
            final isSelected = provider.selectedHairstyle?.id == hair.id;

            return GestureDetector(
              onTap: () {
                provider.selectHairstyle(hair);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PhotoUploadScreen()),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.cardDark,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? AppTheme.primary : AppTheme.strokeDark,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CachedNetworkImage(
                        imageUrl: hair.previewUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hair.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            hair.type.toUpperCase(),
                            style: const TextStyle(color: AppTheme.primaryLight, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildBeardsTab(TryOnProvider provider) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          "Men's AI Beard & Facial Hair Looks",
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        const Text(
          'See how stubble, full beards, and goatees contour your jawline:',
          style: TextStyle(color: Colors.white60, fontSize: 13),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 0.70,
          ),
          itemCount: provider.beards.length,
          itemBuilder: (context, index) {
            final beard = provider.beards[index];
            final isSelected = provider.selectedBeard?.id == beard.id;

            return GestureDetector(
              onTap: () {
                provider.selectBeard(beard);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PhotoUploadScreen()),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.cardDark,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? AppTheme.primary : AppTheme.strokeDark,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CachedNetworkImage(
                        imageUrl: beard.previewUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        beard.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCustomGarmentTab(TryOnProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Upload Your Own Clothes',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          const Text(
            'Found an outfit on Zara, Amazon, Instagram, or in your closet? Upload a photo of the clothing item to try it on your body!',
            style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
          ),
          const SizedBox(height: 24),

          // Upload Box
          InkWell(
            onTap: () => provider.pickCustomGarment(),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              height: 240,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: provider.customGarmentFile != null ? AppTheme.primary : AppTheme.strokeDark,
                  width: 2,
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: provider.customGarmentFile != null
                  ? Image.file(provider.customGarmentFile!, fit: BoxFit.cover)
                  : const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_photo_alternate_outlined, size: 48, color: AppTheme.primaryLight),
                        SizedBox(height: 12),
                        Text(
                          'Tap to Upload Clothing Item',
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Supports dresses, tops, jackets, sarees & pants',
                          style: TextStyle(color: Colors.white54, fontSize: 12),
                        ),
                      ],
                    ),
            ),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => provider.captureCustomGarment(),
                  icon: const Icon(Icons.camera_alt, color: Colors.white),
                  label: const Text('Capture Clothes', style: TextStyle(color: Colors.white)),
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
                  onPressed: () => provider.pickCustomGarment(),
                  icon: const Icon(Icons.photo_library, color: Colors.white),
                  label: const Text('Choose Photo', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          if (provider.customGarmentFile != null)
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PhotoUploadScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Continue to Person Photo', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
