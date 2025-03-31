import 'dart:typed_data';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'media_manager_method_channel.dart';

abstract class MediaManagerPlatform extends PlatformInterface {
  /// Constructs a MediaManagerPlatform.
  MediaManagerPlatform() : super(token: _token);

  static final Object _token = Object();

  static MediaManagerPlatform _instance = MethodChannelMediaManager();

  /// The default instance of [MediaManagerPlatform] to use.
  ///
  /// Defaults to [MethodChannelMediaManager].
  static MediaManagerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [MediaManagerPlatform] when
  /// they register themselves.
  static set instance(MediaManagerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<List<Map<String, dynamic>>> getDirectories() {
    throw UnimplementedError('getDirectories() has not been implemented.');
  }

  Future<List<Map<String, dynamic>>> getDirectoryContents(String path) {
    throw UnimplementedError(
      'getDirectoryContents() has not been implemented.',
    );
  }

  Future<Uint8List?> getImagePreview(String path) {
    throw UnimplementedError('getImagePreview() has not been implemented.');
  }

  Future<bool> clearImageCache() {
    throw UnimplementedError('clearImageCache() has not been implemented.');
  }

  Future<bool> requestStoragePermission() {
    throw UnimplementedError(
      'requestStoragePermission() has not been implemented.',
    );
  }

  Future<List<String>> getAllImages() {
    throw UnimplementedError('getAllImages() has not been implemented.');
  }

  Future<List<String>> getAllVideos() {
    throw UnimplementedError('getAllVideos() has not been implemented.');
  }

  Future<List<String>> getAllAudio() {
    throw UnimplementedError('getAllAudio() has not been implemented.');
  }

  Future<List<String>> getAllDocuments() {
    throw UnimplementedError('getAllDocuments() has not been implemented.');
  }

  Future<List<String>> getAllZipFiles() {
    throw UnimplementedError('getAllZipFiles() has not been implemented.');
  }
}
