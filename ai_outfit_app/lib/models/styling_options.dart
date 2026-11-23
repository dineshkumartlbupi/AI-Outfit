class HairstyleOption {
  final String id;
  final String name;
  final String gender;
  final String type; // 'cut' | 'color'
  final String value;
  final String previewUrl;

  HairstyleOption({
    required this.id,
    required this.name,
    required this.gender,
    required this.type,
    required this.value,
    required this.previewUrl,
  });

  factory HairstyleOption.fromJson(Map<String, dynamic> json) {
    return HairstyleOption(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      gender: json['gender'] ?? 'female',
      type: json['type'] ?? 'cut',
      value: json['value'] ?? '',
      previewUrl: json['previewUrl'] ?? '',
    );
  }
}

class BeardOption {
  final String id;
  final String name;
  final String type;
  final String previewUrl;

  BeardOption({
    required this.id,
    required this.name,
    required this.type,
    required this.previewUrl,
  });

  factory BeardOption.fromJson(Map<String, dynamic> json) {
    return BeardOption(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      previewUrl: json['previewUrl'] ?? '',
    );
  }
}

class BackgroundOption {
  final String id;
  final String name;
  final String category;
  final String previewUrl;

  BackgroundOption({
    required this.id,
    required this.name,
    required this.category,
    required this.previewUrl,
  });

  factory BackgroundOption.fromJson(Map<String, dynamic> json) {
    return BackgroundOption(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? 'Studio',
      previewUrl: json['previewUrl'] ?? '',
    );
  }
}
