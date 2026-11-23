class SampleModel {
  final String id;
  final String name;
  final String gender;
  final String imageUrl;
  final String thumbnailUrl;
  final String poseDescription;

  SampleModel({
    required this.id,
    required this.name,
    required this.gender,
    required this.imageUrl,
    required this.thumbnailUrl,
    required this.poseDescription,
  });

  factory SampleModel.fromJson(Map<String, dynamic> json) {
    return SampleModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      gender: json['gender'] ?? 'female',
      imageUrl: json['imageUrl'] ?? '',
      thumbnailUrl: json['thumbnailUrl'] ?? json['imageUrl'] ?? '',
      poseDescription: json['poseDescription'] ?? '',
    );
  }
}
