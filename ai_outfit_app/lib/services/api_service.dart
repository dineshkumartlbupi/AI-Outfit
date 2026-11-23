import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants.dart';
import '../core/mock_data.dart';
import '../models/category.dart';
import '../models/garment.dart';
import '../models/sample_model.dart';
import '../models/tryon_job.dart';
import '../models/styling_options.dart';

class ApiService {
  final String baseUrl = AppConstants.apiBaseUrl;

  Future<List<CategoryItem>> getCategories() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/categories')).timeout(const Duration(seconds: 4));
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        if (body['success'] == true) {
          final list = body['data'] as List;
          return list.map((e) => CategoryItem.fromJson(e)).toList();
        }
      }
    } catch (_) {}
    return MockData.categories;
  }

  Future<List<GarmentTemplate>> getTemplates({
    String? category,
    String? search,
    FocusArea? focusArea,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (category != null && category != 'all') queryParams['category'] = category;
      if (search != null && search.isNotEmpty) queryParams['search'] = search;
      if (focusArea != null) queryParams['focusArea'] = focusArea.apiValue;

      final uri = Uri.parse('$baseUrl/templates').replace(queryParameters: queryParams);
      final res = await http.get(uri).timeout(const Duration(seconds: 4));

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        if (body['success'] == true) {
          final list = body['data'] as List;
          return list.map((e) => GarmentTemplate.fromJson(e)).toList();
        }
      }
    } catch (_) {}

    // Offline fallback
    var list = MockData.garments;
    if (category != null && category != 'all') {
      list = list.where((g) => g.category == category).toList();
    }
    if (focusArea != null) {
      list = list.where((g) => g.focusArea == focusArea).toList();
    }
    if (search != null && search.isNotEmpty) {
      final q = search.toLowerCase();
      list = list.where((g) =>
          g.name.toLowerCase().contains(q) ||
          g.description.toLowerCase().contains(q) ||
          g.tags.any((t) => t.toLowerCase().contains(q))).toList();
    }
    return list;
  }

  Future<List<SampleModel>> getSampleModels() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/sample-models')).timeout(const Duration(seconds: 4));
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        if (body['success'] == true) {
          final list = body['data'] as List;
          return list.map((e) => SampleModel.fromJson(e)).toList();
        }
      }
    } catch (_) {}
    return MockData.sampleModels;
  }

  Future<List<HairstyleOption>> getHairstyles() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/hairstyles')).timeout(const Duration(seconds: 4));
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        if (body['success'] == true) {
          final list = body['data'] as List;
          return list.map((e) => HairstyleOption.fromJson(e)).toList();
        }
      }
    } catch (_) {}
    return MockData.hairstyles;
  }

  Future<List<BeardOption>> getBeards() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/beards')).timeout(const Duration(seconds: 4));
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        if (body['success'] == true) {
          final list = body['data'] as List;
          return list.map((e) => BeardOption.fromJson(e)).toList();
        }
      }
    } catch (_) {}
    return MockData.beards;
  }

  Future<List<BackgroundOption>> getBackgrounds() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/backgrounds')).timeout(const Duration(seconds: 4));
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        if (body['success'] == true) {
          final list = body['data'] as List;
          return list.map((e) => BackgroundOption.fromJson(e)).toList();
        }
      }
    } catch (_) {}
    return MockData.backgrounds;
  }

  Future<String?> uploadImage(dynamic file) async {
    try {
      final uri = Uri.parse('$baseUrl/upload');
      final request = http.MultipartRequest('POST', uri);
      request.files.add(await http.MultipartFile.fromPath('photo', file.path));
      final streamedResponse = await request.send().timeout(const Duration(seconds: 15));
      final res = await http.Response.fromStream(streamedResponse);
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        if (body['success'] == true && body['imageUrl'] != null) {
          return body['imageUrl'] as String;
        }
      }
    } catch (_) {
      try {
        final bytes = await file.readAsBytes();
        return 'data:image/jpeg;base64,${base64Encode(bytes)}';
      } catch (_) {}
    }
    return null;
  }

  Future<TryOnJob> submitTryOn({
    required String userImageUrl,
    String? mode,
    String? garmentId,
    String? garmentImageUrl,
    String? customGarmentUrl,
    required FocusArea focusArea,
    String? hairstyleId,
    String? beardId,
    String? backgroundId,
    bool? enhanceHD,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/tryon'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userImageUrl': userImageUrl,
          'mode': mode,
          'garmentId': garmentId,
          'garmentImageUrl': garmentImageUrl,
          'customGarmentUrl': customGarmentUrl,
          'focusArea': focusArea.apiValue,
          'hairstyleId': hairstyleId,
          'beardId': beardId,
          'backgroundId': backgroundId,
          'enhanceHD': enhanceHD,
        }),
      ).timeout(const Duration(seconds: 8));

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        if (body['success'] == true) {
          return TryOnJob.fromJson(body['data']);
        }
      }
    } catch (_) {}

    return TryOnJob(
      id: 'local-${DateTime.now().millisecondsSinceEpoch}',
      status: JobStatus.queued,
      userImageUrl: userImageUrl,
      garmentId: garmentId,
      garmentImageUrl: customGarmentUrl ?? garmentImageUrl ?? userImageUrl,
      focusArea: focusArea,
      beforeImageUrl: userImageUrl,
      progress: 10,
      message: 'Processing style transformation...',
      createdAt: DateTime.now().toIso8601String(),
    );
  }

  Future<TryOnJob?> getJobStatus(String jobId) async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/tryon/status/$jobId')).timeout(const Duration(seconds: 4));
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        if (body['success'] == true) {
          return TryOnJob.fromJson(body['data']);
        }
      }
    } catch (_) {}
    return null;
  }

  Future<bool> enhancePhoto(String jobId) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/enhance'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'jobId': jobId}),
      ).timeout(const Duration(seconds: 4));
      return res.statusCode == 200;
    } catch (_) {
      return true;
    }
  }

  Future<bool> changeBackground(String jobId, String backgroundId) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/change-background'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'jobId': jobId, 'backgroundId': backgroundId}),
      ).timeout(const Duration(seconds: 4));
      return res.statusCode == 200;
    } catch (_) {
      return true;
    }
  }

  Future<bool> saveLookToWardrobe({
    required String jobId,
    required String originalImageUrl,
    required String resultImageUrl,
    required String garmentName,
    required String category,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/wardrobe/save'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'jobId': jobId,
          'originalImageUrl': originalImageUrl,
          'resultImageUrl': resultImageUrl,
          'garmentName': garmentName,
          'category': category,
        }),
      ).timeout(const Duration(seconds: 5));

      return res.statusCode == 200;
    } catch (_) {
      return true;
    }
  }

  Future<List<WardrobeItem>> getWardrobe() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/wardrobe')).timeout(const Duration(seconds: 4));
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        if (body['success'] == true) {
          final list = body['data'] as List;
          return list.map((e) => WardrobeItem.fromJson(e)).toList();
        }
      }
    } catch (_) {}
    return [];
  }
}
