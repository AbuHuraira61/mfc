import 'dart:convert';
import 'package:flutter/foundation.dart';

class ImageService {
  // Decode once and cache
  static final Map<String, Uint8List> _cache = {};

  /// Decodes a Base64 string into bytes, only once per key
  static Future<Uint8List> decodeBase64(String key, String base64) async {
    if (_cache.containsKey(key)) return _cache[key]!;
    // expensive decode off the UI thread
    final bytes = await compute(_base64Decode, base64);
    _cache[key] = bytes;
    return bytes;
  }

  static Uint8List _base64Decode(String input) {
    return base64Decode(input);
  }
}