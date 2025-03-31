import 'dart:typed_data';
import 'media_manager_platform_interface.dart';

class MediaManager {
  Future<String?> getPlatformVersion() {
    return MediaManagerPlatform.instance.getPlatformVersion();
  }

  Future<List<Map<String, dynamic>>> getDirectories() {
    return MediaManagerPlatform.instance.getDirectories();
  }

  Future<List<Map<String, dynamic>>> getDirectoryContents(String path) {
    return MediaManagerPlatform.instance.getDirectoryContents(path);
  }

  Future<Uint8List?> getImagePreview(String path) {
    return MediaManagerPlatform.instance.getImagePreview(path);
  }

  Future<bool> clearImageCache() {
    return MediaManagerPlatform.instance.clearImageCache();
  }

  Future<bool> requestStoragePermission() {
    return MediaManagerPlatform.instance.requestStoragePermission();
  }

  Future<List<String>> getAllImages() {
    return MediaManagerPlatform.instance.getAllImages();
  }

  Future<List<String>> getAllVideos() {
    return MediaManagerPlatform.instance.getAllVideos();
  }

  Future<List<String>> getAllAudio() {
    return MediaManagerPlatform.instance.getAllAudio();
  }

  Future<List<String>> getAllDocuments() {
    return MediaManagerPlatform.instance.getAllDocuments();
  }

  Future<List<String>> getAllZipFiles() {
    return MediaManagerPlatform.instance.getAllZipFiles();
  }
}
