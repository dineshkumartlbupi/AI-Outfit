import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../state/tryon_provider.dart';
import '../widgets/garment_card.dart';
import 'garment_detail_modal.dart';
import 'photo_upload_screen.dart';

class TemplatesScreen extends StatefulWidget {
  const TemplatesScreen({super.key});

  @override
  State<TemplatesScreen> createState() => _TemplatesScreenState();
}

class _TemplatesScreenState extends State<TemplatesScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TryOnProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover Templates'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: AppTheme.cardDark,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.strokeDark),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (val) => provider.setSearchQuery(val),
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Search dresses, shirts, sarees...',
                  hintStyle: const TextStyle(color: Colors.white38, fontSize: 13),
                  prefixIcon: const Icon(Icons.search, color: Colors.white38, size: 20),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.white38, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            provider.setSearchQuery('');
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Filter Chips
          Container(
            height: 46,
            padding: const EdgeInsets.symmetric(vertical: 6),
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
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: isSelected ? AppTheme.primary : AppTheme.strokeDark,
                    ),
                  ),
                );
              },
            ),
          ),

          // Main Grid
          Expanded(
            child: provider.isLoadingTemplates
                ? const Center(child: CircularProgressIndicator(color: AppTheme.primary))
                : provider.templates.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.checkroom_outlined, size: 64, color: Colors.white24),
                            const SizedBox(height: 12),
                            const Text(
                              'No outfits match your search',
                              style: TextStyle(color: Colors.white60, fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () {
                                _searchController.clear();
                                provider.setSearchQuery('');
                                provider.selectCategory('all');
                              },
                              child: const Text('Reset Filters', style: TextStyle(color: AppTheme.primaryLight)),
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 14,
                          crossAxisSpacing: 14,
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
        ],
      ),
    );
  }
}
