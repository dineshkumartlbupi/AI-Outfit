class CategoryItem {
  final String id;
  final String name;
  final int count;

  CategoryItem({
    required this.id,
    required this.name,
    required this.count,
  });

  factory CategoryItem.fromJson(Map<String, dynamic> json) {
    return CategoryItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      count: json['count'] ?? 0,
    );
  }
}
