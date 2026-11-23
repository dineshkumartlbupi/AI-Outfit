import 'garment.dart';

enum JobStatus {
  queued,
  processing,
  completed,
  failed;

  static JobStatus fromString(String val) {
    switch (val.toUpperCase()) {
      case 'QUEUED':
        return JobStatus.queued;
      case 'PROCESSING':
        return JobStatus.processing;
      case 'COMPLETED':
        return JobStatus.completed;
      case 'FAILED':
      default:
        return JobStatus.failed;
    }
  }
}

class TryOnJob {
  final String id;
  final JobStatus status;
  final String userImageUrl;
  final String? garmentId;
  final String garmentImageUrl;
  final FocusArea focusArea;
  final String beforeImageUrl;
  final String? resultImageUrl;
  final int progress;
  final String? message;
  final String createdAt;
  final String? completedAt;

  TryOnJob({
    required this.id,
    required this.status,
    required this.userImageUrl,
    this.garmentId,
    required this.garmentImageUrl,
    required this.focusArea,
    required this.beforeImageUrl,
    this.resultImageUrl,
    required this.progress,
    this.message,
    required this.createdAt,
    this.completedAt,
  });

  factory TryOnJob.fromJson(Map<String, dynamic> json) {
    return TryOnJob(
      id: json['id'] ?? '',
      status: JobStatus.fromString(json['status'] ?? 'QUEUED'),
      userImageUrl: json['userImageUrl'] ?? '',
      garmentId: json['garmentId'],
      garmentImageUrl: json['garmentImageUrl'] ?? '',
      focusArea: FocusArea.fromString(json['focusArea'] ?? 'full_body'),
      beforeImageUrl: json['beforeImageUrl'] ?? json['userImageUrl'] ?? '',
      resultImageUrl: json['resultImageUrl'],
      progress: (json['progress'] as num?)?.toInt() ?? 0,
      message: json['message'],
      createdAt: json['createdAt'] ?? '',
      completedAt: json['completedAt'],
    );
  }
}

class WardrobeItem {
  final String id;
  final String jobId;
  final String title;
  final String category;
  final String originalImageUrl;
  final String resultImageUrl;
  final String garmentName;
  final String createdAt;
  final bool isFavorite;

  WardrobeItem({
    required this.id,
    required this.jobId,
    required this.title,
    required this.category,
    required this.originalImageUrl,
    required this.resultImageUrl,
    required this.garmentName,
    required this.createdAt,
    this.isFavorite = false,
  });

  factory WardrobeItem.fromJson(Map<String, dynamic> json) {
    return WardrobeItem(
      id: json['id'] ?? '',
      jobId: json['jobId'] ?? '',
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      originalImageUrl: json['originalImageUrl'] ?? '',
      resultImageUrl: json['resultImageUrl'] ?? '',
      garmentName: json['garmentName'] ?? '',
      createdAt: json['createdAt'] ?? '',
      isFavorite: json['isFavorite'] == true,
    );
  }
}
