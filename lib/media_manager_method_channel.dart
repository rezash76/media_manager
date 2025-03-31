import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'media_manager_platform_interface.dart';

/// An implementation of [MediaManagerPlatform] that uses method channels.
class MethodChannelMediaManager extends MediaManagerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('media_manager');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }

  @override
  Future<List<Map<String, dynamic>>> getDirectories() async {
    // When receiving the data from the platform channel:
    final List<dynamic> rawDirectories = await methodChannel.invokeMethod(
      'getDirectories',
    );
    final List<Map<String, dynamic>> directories =
        rawDirectories
            .map((item) => Map<String, dynamic>.from(item as Map))
            .toList();
    return directories;
  }

  @override
  Future<List<Map<String, dynamic>>> getDirectoryContents(String path) async {
    final List<dynamic> rawContents = await methodChannel.invokeMethod(
      'getDirectoryContents',
      {'path': path},
    );
    final List<Map<String, dynamic>> contents =
        rawContents
            .map((item) => Map<String, dynamic>.from(item as Map))
            .toList();
    return contents;
  }

  @override
  Future<Uint8List?> getImagePreview(String path) async {
    final Uint8List? data = await methodChannel.invokeMethod(
      'getImagePreview',
      {'path': path},
    );
    return data;
  }

  @override
  Future<bool> clearImageCache() async {
    final bool result = await methodChannel.invokeMethod('clearImageCache');
    return result;
  }

  @override
  Future<bool> requestStoragePermission() async {
    final bool result = await methodChannel.invokeMethod(
      'requestStoragePermission',
    );
    return result;
  }

  @override
  Future<List<String>> getAllImages() async {
    final List<dynamic> result = await methodChannel.invokeMethod(
      'getAllImages',
    );
    return result.cast<String>();
  }

  @override
  Future<List<String>> getAllVideos() async {
    final List<dynamic> result = await methodChannel.invokeMethod(
      'getAllVideos',
    );
    return result.cast<String>();
  }

  @override
  Future<List<String>> getAllAudio() async {
    final List<dynamic> result = await methodChannel.invokeMethod(
      'getAllAudio',
    );
    return result.cast<String>();
  }

  @override
  Future<List<String>> getAllDocuments() async {
    final List<dynamic> result = await methodChannel.invokeMethod(
      'getAllDocuments',
    );
    return result.cast<String>();
  }

  @override
  Future<List<String>> getAllZipFiles() async {
    final List<dynamic> result = await methodChannel.invokeMethod(
      'getAllZipFiles',
    );
    return result.cast<String>();
  }
}
