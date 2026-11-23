import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../core/theme.dart';
import '../state/tryon_provider.dart';
import '../widgets/split_slider.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _isSaved = false;

  void _showBackgroundPicker(BuildContext context, TryOnProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.cardDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'AI Background Remover & Switcher',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white54, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'Erase background clutter and place your look in aesthetic backdrops:',
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 110,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: provider.backgrounds.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final bg = provider.backgrounds[index];
                    final isSelected = provider.selectedBackground?.id == bg.id;

                    return GestureDetector(
                      onTap: () {
                        provider.applyBackground(bg);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Switched background to ${bg.name}!'),
                            backgroundColor: AppTheme.primary,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 75,
                            height: 75,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected ? AppTheme.primary : AppTheme.strokeDark,
                                width: isSelected ? 2.5 : 1,
                              ),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: CachedNetworkImage(
                              imageUrl: bg.previewUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            bg.name.split(' ')[0],
                            style: TextStyle(
                              color: isSelected ? AppTheme.primaryLight : Colors.white70,
                              fontSize: 11,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TryOnProvider>();
    final job = provider.currentJob;

    if (job == null || job.resultImageUrl == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Result')),
        body: const Center(
          child: Text('No result available', style: TextStyle(color: Colors.white60)),
        ),
      );
    }

    final beforeUrl = job.beforeImageUrl;
    final afterUrl = job.resultImageUrl!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Style Transformation'),
        actions: [
          IconButton(
            icon: Icon(
              _isSaved ? Icons.bookmark : Icons.bookmark_border,
              color: _isSaved ? AppTheme.primary : Colors.white,
            ),
            onPressed: () async {
              await provider.saveCurrentLook();
              setState(() {
                _isSaved = true;
              });
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Saved to My Looks!'),
                    backgroundColor: AppTheme.primary,
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.white),
            onPressed: () => provider.shareCurrentLook(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Subtitle instruction & AI Toolbar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.swipe, color: Colors.white54, size: 16),
                    SizedBox(width: 6),
                    Text(
                      'Drag slider to compare',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
                Row(
                  children: [
                    // AI Enhance Toggle (App 2 Feature)
                    InkWell(
                      onTap: () {
                        provider.toggleHDEnhance();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(provider.isHDEnhanced
                                ? 'AI HD Enhancer Activated!'
                                : 'AI Enhance turned off'),
                            backgroundColor: AppTheme.primary,
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: provider.isHDEnhanced
                              ? AppTheme.primary.withValues(alpha: 0.25)
                              : AppTheme.surfaceDark,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: provider.isHDEnhanced ? AppTheme.primary : AppTheme.strokeDark,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.auto_fix_high,
                              size: 14,
                              color: provider.isHDEnhanced ? AppTheme.primaryLight : Colors.white70,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'HD Boost',
                              style: TextStyle(
                                color: provider.isHDEnhanced ? AppTheme.primaryLight : Colors.white70,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // BG Switcher (App 2 Feature)
                    InkWell(
                      onTap: () => _showBackgroundPicker(context, provider),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceDark,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.strokeDark),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.wallpaper_rounded, size: 14, color: Colors.white70),
                            SizedBox(width: 4),
                            Text(
                              'BG Switch',
                              style: TextStyle(color: Colors.white70, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Main Interactive Comparison Canvas
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: SplitSlider(
                beforeImageUrl: beforeUrl,
                afterImageUrl: afterUrl,
                initialPosition: 0.5,
              ),
            ),
          ),

          // Bottom Action Bar
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: const BoxDecoration(
                color: AppTheme.cardDark,
                border: Border(top: BorderSide(color: AppTheme.strokeDark, width: 0.8)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      // Save Button
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            await provider.saveCurrentLook();
                            await provider.downloadCurrentLook();
                            setState(() {
                              _isSaved = true;
                            });
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Saved HD Image to Device & Wardrobe!'),
                                  backgroundColor: AppTheme.primary,
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.file_download_outlined, color: Colors.white),
                          label: Text(_isSaved ? 'Saved Look ✓' : 'Save HD Look'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isSaved ? AppTheme.surfaceDark : AppTheme.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 4,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Share Button
                      OutlinedButton.icon(
                        onPressed: () => provider.shareCurrentLook(),
                        icon: const Icon(Icons.share_rounded, color: Colors.white, size: 20),
                        label: const Text('Share', style: TextStyle(color: Colors.white)),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                          side: const BorderSide(color: AppTheme.strokeDark),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                    child: const Text(
                      'Try Another Look ✨',
                      style: TextStyle(color: AppTheme.primaryLight, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
