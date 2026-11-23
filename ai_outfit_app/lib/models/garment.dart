enum FocusArea {
  upperBody,
  lowerBody,
  fullBody;

  String get apiValue {
    switch (this) {
      case FocusArea.upperBody:
        return 'upper_body';
      case FocusArea.lowerBody:
        return 'lower_body';
      case FocusArea.fullBody:
        return 'full_body';
    }
  }

  String get displayName {
    switch (this) {
      case FocusArea.upperBody:
        return 'Upper Body';
      case FocusArea.lowerBody:
        return 'Lower Body';
      case FocusArea.fullBody:
        return 'Full Body';
    }
  }

  String get subtitle {
    switch (this) {
      case FocusArea.upperBody:
        return 'Shirts, Tops, Jackets & Blazers';
      case FocusArea.lowerBody:
        return 'Pants, Skirts, Jeans & Shorts';
      case FocusArea.fullBody:
        return 'Dresses, Jumpsuits, Sarees & Suits';
    }
  }

  static FocusArea fromString(String val) {
    if (val == 'upper_body' || val == 'upper') return FocusArea.upperBody;
    if (val == 'lower_body' || val == 'lower') return FocusArea.lowerBody;
    return FocusArea.fullBody;
  }
}

class GarmentTemplate {
  final String id;
  final String name;
  final String category;
  final FocusArea focusArea;
  final String imageUrl;
  final String thumbnailUrl;
  final String description;
  final List<String> tags;
  final bool isTrending;
  final bool isNew;
  final bool isPremium;
  final String? color;
  final String? fabric;

  GarmentTemplate({
    required this.id,
    required this.name,
    required this.category,
    required this.focusArea,
    required this.imageUrl,
    required this.thumbnailUrl,
    required this.description,
    required this.tags,
    this.isTrending = false,
    this.isNew = false,
    this.isPremium = false,
    this.color,
    this.fabric,
  });

  factory GarmentTemplate.fromJson(Map<String, dynamic> json) {
    return GarmentTemplate(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      focusArea: FocusArea.fromString(json['focusArea'] ?? 'full_body'),
      imageUrl: json['imageUrl'] ?? '',
      thumbnailUrl: json['thumbnailUrl'] ?? json['imageUrl'] ?? '',
      description: json['description'] ?? '',
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      isTrending: json['isTrending'] == true,
      isNew: json['isNew'] == true,
      isPremium: json['isPremium'] == true,
      color: json['color'],
      fabric: json['fabric'],
    );
  }
}
