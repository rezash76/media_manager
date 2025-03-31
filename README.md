# Media Manager Plugin

A Flutter plugin for managing media files and directories across multiple platforms. This plugin provides a comprehensive set of features for browsing directories, accessing media files, and managing file operations.

## Features


- Directory browsing and navigation
- File type detection and categorization
- Image preview with caching
- Media file organization (Images, Videos, Audio, Documents, Archives)
- File size formatting
- Storage permission handling
- Cross-platform support (Android, iOS, Windows, Linux, macOS)

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  media_manager: ^0.0.1
```

## Usage

### Initialize the Plugin

```dart
import 'package:media_manager/media_manager.dart';

final mediaManager = MediaManager();
```

### Request Storage Permission

```dart
// Request storage permission (Android/iOS only)
final hasPermission = await mediaManager.requestStoragePermission();
if (hasPermission) {
  // Permission granted, proceed with operations
} else {
  // Handle permission denied
}
```

### Get Directories

```dart
// Get list of directories
final directories = await mediaManager.getDirectories();
for (final directory in directories) {
  print('Name: ${directory['name']}');
  print('Path: ${directory['path']}');
}
```

### Get Directory Contents

```dart
// Get contents of a specific directory
final contents = await mediaManager.getDirectoryContents('/path/to/directory');
for (final item in contents) {
  print('Name: ${item['name']}');
  print('Type: ${item['type']}');
  print('Size: ${item['readableSize']}');
  print('Is Directory: ${item['isDirectory']}');
  print('Extension: ${item['extension']}');
}
```

### Get Image Preview

```dart
// Get image preview with caching
final imageData = await mediaManager.getImagePreview('/path/to/image.jpg');
if (imageData != null) {
  // Display image using Image.memory
  Image.memory(
    imageData,
    fit: BoxFit.cover,
  );
}
```

### Clear Image Cache

```dart
// Clear the image preview cache
await mediaManager.clearImageCache();
```

### Get Media Files by Type

```dart
// Get all images
final images = await mediaManager.getAllImages();

// Get all videos
final videos = await mediaManager.getAllVideos();

// Get all audio files
final audioFiles = await mediaManager.getAllAudio();

// Get all documents
final documents = await mediaManager.getAllDocuments();

// Get all archive files
final archives = await mediaManager.getAllZipFiles();

// Get all code files
final codeFiles = await mediaManager.getAllCodeFiles();

// Get all CAD files
final cadFiles = await mediaManager.getAllCADFiles();
```

## Complete Example

Here's a complete example showing how to use the plugin in a Flutter app:

```dart
import 'package:flutter/material.dart';
import 'package:media_manager/media_manager.dart';

class MediaManagerScreen extends StatefulWidget {
  @override
  _MediaManagerScreenState createState() => _MediaManagerScreenState();
}

class _MediaManagerScreenState extends State<MediaManagerScreen> {
  final _mediaManager = MediaManager();
  bool _hasPermission = false;
  List<Map<String, dynamic>> _directories = [];

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final hasPermission = await _mediaManager.requestStoragePermission();
    setState(() {
      _hasPermission = hasPermission;
    });
    if (hasPermission) {
      _loadDirectories();
    }
  }

  Future<void> _loadDirectories() async {
    try {
      final directories = await _mediaManager.getDirectories();
      setState(() {
        _directories = directories;
      });
    } catch (e) {
      print('Error loading directories: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasPermission) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Storage permission is required'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _checkPermission,
                child: Text('Request Permission'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Media Manager Demo'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadDirectories,
          ),
        ],
      ),
      body: _directories.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _directories.length,
              itemBuilder: (context, index) {
                final directory = _directories[index];
                return ListTile(
                  leading: Icon(Icons.folder),
                  title: Text(directory['name']),
                  subtitle: Text(directory['path']),
                );
              },
            ),
    );
  }
}
```

## Supported File Types

### Images
- jpg, jpeg, png, gif, bmp, webp, tiff, ico, svg, heif, heic

### Videos
- mp4, mov, mkv, avi, wmv, flv, webm, m4v, 3gp, f4v, ogv

### Audio
- mp3, wav, m4a, ogg, flac, aac, wma, aiff, opus

### Documents
- pdf, doc, docx, txt, rtf, odt, xls, xlsx, ppt, pptx, csv, html, xml, json

### Archives
- zip, rar, tar, gz, 7z, bz2, xz, lzma, cab, iso, dmg

### Code Files
- c, cpp, h, hpp, cs, java, kt, swift, dart, py, js, jsx, ts, tsx, php, rb, sh, bat, cmd, pl, lua, sql, json, yaml, xml, ini, cfg, toml

### CAD Files
- dwg, dxf, stl, obj, 3ds, max, blend, skp, ai, eps, svg, fig, xd, cdr, ifc, step, iges, bim

## Platform Specific Notes

### Android
- Requires `READ_EXTERNAL_STORAGE` permission
- Supports all file types and operations
- Full access to external storage

### iOS
- Uses Photos framework for media access
- Limited to user's media library
- Some file operations may be restricted
- Requires photo library access permission

### Windows
- Uses Windows GDI+ for image processing
- Full access to file system
- No storage permission required
- Supports all file types and operations
- Uses Windows-specific path handling

### Linux
- Uses GTK/GIO for file operations
- Uses GDK-Pixbuf for image processing
- Full access to file system
- No storage permission required
- Supports all file types and operations
- Uses Linux-specific path handling

### macOS
- Uses AppKit/NSImage for image processing
- Uses FileManager for file operations
- Full access to file system
- No storage permission required
- Supports all file types and operations
- Uses macOS-specific path handling
- Supports sandboxed and non-sandboxed environments
- Handles macOS-specific file attributes and metadata

## Error Handling

The plugin provides detailed error messages for common scenarios:

```dart
try {
  final directories = await mediaManager.getDirectories();
} catch (e) {
  if (e is PlatformException) {
    switch (e.code) {
      case 'DIRECTORY_ACCESS_ERROR':
        // Handle directory access error
        break;
      case 'INVALID_PATH':
        // Handle invalid path error
        break;
      case 'FILE_ACCESS_ERROR':
        // Handle file access error
        break;
      case 'IMAGE_LOAD_ERROR':
        // Handle image loading error
        break;
      case 'HOME_NOT_FOUND':
        // Handle home directory not found error
        break;
      default:
        // Handle other errors
    }
  }
}
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.