import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class ImageService {
  final ImagePicker _picker = ImagePicker();

  Future<XFile?> pickFromGallery() async {
    try {
      final file = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 92,
        maxWidth: 1920,
      );
      return file;
    } catch (e) {
      debugPrint('Error picking from gallery: $e');
      return null;
    }
  }

  Future<XFile?> captureFromCamera() async {
    try {
      final file = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 92,
        maxWidth: 1920,
      );
      return file;
    } catch (e) {
      debugPrint('Error capturing from camera: $e');
      return null;
    }
  }

  Future<void> shareResultImage({
    required String imageUrl,
    required String garmentName,
  }) async {
    try {
      if (kIsWeb) {
        await SharePlus.instance.share(
          ShareParams(
            text: 'Check out my new outfit "$garmentName" created with AI Outfit: Try On Clothes! $imageUrl',
          ),
        );
        return;
      }

      // Download temporary file to share
      final response = await http.get(Uri.parse(imageUrl));
      final bytes = response.bodyBytes;
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/ai_outfit_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await tempFile.writeAsBytes(bytes);

      await SharePlus.instance.share(
        ShareParams(
          text: 'Check out my new outfit "$garmentName" styled with AI Outfit: Try On Clothes!',
          files: [XFile(tempFile.path)],
        ),
      );
    } catch (e) {
      debugPrint('Error sharing image: $e');
      await SharePlus.instance.share(
        ShareParams(
          text: 'Check out my new outfit "$garmentName" styled with AI Outfit: Try On Clothes! $imageUrl',
        ),
      );
    }
  }

  Future<String?> saveImageToLocalFile(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      final bytes = response.bodyBytes;
      final appDir = await getApplicationDocumentsDirectory();
      final savedFile = File('${appDir.path}/saved_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await savedFile.writeAsBytes(bytes);
      return savedFile.path;
    } catch (e) {
      debugPrint('Error saving image: $e');
      return null;
    }
  }
}
