import 'dart:io';
import 'package:flutter/foundation.dart';

class AppConstants {
  static const String appName = 'AI Outfit';
  static const String appTagline = 'Transform Your Style In Seconds';

  // If you deploy your backend to Render, Railway, or VPS, set it here (e.g. https://your-app.onrender.com/api)
  static String customBackendUrl = '';

  static String get apiBaseUrl {
    if (customBackendUrl.isNotEmpty) {
      return customBackendUrl;
    }
    if (kIsWeb) {
      return 'http://localhost:3000/api';
    }
    if (Platform.isAndroid) {
      // Direct LAN IP of development Mac (accessible from physical Android phone on the same Wi-Fi)
      return 'http://192.168.1.12:3000/api';
    }
    return 'http://localhost:3000/api';
  }
}
