import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../core/theme.dart';
import '../state/tryon_provider.dart';
import '../widgets/split_slider.dart';

class WardrobeScreen extends StatelessWidget {
  const WardrobeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TryOnProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Saved Looks'),
      ),
      body: provider.wardrobe.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceDark,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppTheme.strokeDark),
                      ),
                      child: const Icon(
                        Icons.favorite_border_rounded,
                        size: 48,
                        color: AppTheme.primaryLight,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'No Saved Looks Yet',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Try on your favorite outfits and tap the bookmark or save button to build your personal style lookbook.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white60, fontSize: 13, height: 1.4),
                    ),
                  ],
                ),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 0.72,
              ),
              itemCount: provider.wardrobe.length,
              itemBuilder: (context, index) {
                final item = provider.wardrobe[index];
                return GestureDetector(
                  onTap: () {
                    // Open full comparison preview
                    showDialog(
                      context: context,
                      builder: (context) => Dialog.fullscreen(
                        child: Scaffold(
                          appBar: AppBar(
                            title: Text(item.title),
                            leading: IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                          body: SplitSlider(
                            beforeImageUrl: item.originalImageUrl,
                            afterImageUrl: item.resultImageUrl,
                          ),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.cardDark,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.strokeDark),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: CachedNetworkImage(
                            imageUrl: item.resultImageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            placeholder: (context, _) => Container(color: AppTheme.surfaceDark),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.category,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 11,
                                ),
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
    );
  }
}
