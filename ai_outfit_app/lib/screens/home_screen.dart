import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../state/tryon_provider.dart';
import '../widgets/garment_card.dart';
import 'photo_upload_screen.dart';
import 'garment_detail_modal.dart';
import 'ai_studio_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TryOnProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.style, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 10),
            const Text('TRY ON AI'),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.strokeDark),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.bolt, color: Colors.amber, size: 16),
                const SizedBox(width: 4),
                Text(
                  '${provider.credits} Free',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => provider.init(),
        color: AppTheme.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Hero Banner: "CHANGE OUTFITS IN SECONDS"
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2C103A), Color(0xFF140D26)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: AppTheme.primary.withValues(alpha: 0.3),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primary.withValues(alpha: 0.15),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          '⚡ ALL-IN-ONE VIRTUAL STYLING SUITE',
                          style: TextStyle(
                            color: AppTheme.primaryLight,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Change Outfits\nIn Seconds',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Browse 3,000+ trending styles, upload your own clothes, or experiment with AI hairstyles and beards.',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
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
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 4,
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Try On Now',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward_rounded, size: 16),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 2. AI Quick Suite Tools (Reference Apps Features)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: const Text(
                  'AI Styling Studio Tools',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 105,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildToolTile(
                      context: context,
                      icon: Icons.upload_file,
                      title: 'Upload Clothes',
                      subtitle: 'Your garments',
                      color: const Color(0xFF6366F1),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AIStudioScreen()),
                        );
                      },
                    ),
                    const SizedBox(width: 10),
                    _buildToolTile(
                      context: context,
                      icon: Icons.face_retouching_natural,
                      title: 'Hair & Color',
                      subtitle: 'Trendy styles',
                      color: const Color(0xFFEC4899),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AIStudioScreen()),
                        );
                      },
                    ),
                    const SizedBox(width: 10),
                    _buildToolTile(
                      context: context,
                      icon: Icons.face,
                      title: 'Beard Grooming',
                      subtitle: "Men's looks",
                      color: const Color(0xFFF59E0B),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AIStudioScreen()),
                        );
                      },
                    ),
                    const SizedBox(width: 10),
                    _buildToolTile(
                      context: context,
                      icon: Icons.wallpaper_rounded,
                      title: 'BG Switcher',
                      subtitle: 'Erase & replace',
                      color: const Color(0xFF10B981),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PhotoUploadScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 3. Categories Horizontal Scroll
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Explore Outfits',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${provider.templates.length} Styles',
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 38,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: provider.categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final cat = provider.categories[index];
                    final isSelected = cat.id == provider.selectedCategoryId;
                    return ChoiceChip(
                      label: Text(cat.name),
                      selected: isSelected,
                      onSelected: (_) => provider.selectCategory(cat.id),
                      selectedColor: AppTheme.primary,
                      backgroundColor: AppTheme.cardDark,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.white60,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected ? AppTheme.primary : AppTheme.strokeDark,
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // 4. Trending Styles Carousel
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Text(
                      'Trending This Week 🔥',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () => provider.selectCategory('all'),
                      child: const Text(
                        'See All',
                        style: TextStyle(color: AppTheme.primaryLight, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 260,
                child: provider.isLoadingTemplates
                    ? const Center(child: CircularProgressIndicator(color: AppTheme.primary))
                    : ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: provider.templates.take(6).length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final item = provider.templates[index];
                          return SizedBox(
                            width: 170,
                            child: GarmentCard(
                              garment: item,
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (_) => GarmentDetailModal(garment: item),
                                );
                              },
                              onTryOn: () {
                                provider.selectGarment(item);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const PhotoUploadScreen(),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
              ),

              const SizedBox(height: 24),

              // 5. Indian Ethnic Special Banner
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF381414), Color(0xFF1F0B18)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.amber.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text('🇮🇳', style: TextStyle(fontSize: 26)),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Indian Fashion & Sarees',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Explore Banarasi, Kanjivaram & Anarkali suits',
                              style: TextStyle(color: Colors.white60, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          provider.selectCategory('indian_ethnic');
                        },
                        icon: const Icon(Icons.arrow_forward_ios, color: Colors.amber, size: 16),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 6. Featured Wardrobe Grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: const Text(
                  'Curated Outfits',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.62,
                  ),
                  itemCount: provider.templates.length,
                  itemBuilder: (context, index) {
                    final item = provider.templates[index];
                    return GarmentCard(
                      garment: item,
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => GarmentDetailModal(garment: item),
                        );
                      },
                      onTryOn: () {
                        provider.selectGarment(item);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PhotoUploadScreen(),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToolTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 130,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.cardDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.strokeDark),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
            ),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white54, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
