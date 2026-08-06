import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// ImageCacheManager — Simple disk-backed image caching for ProfileForge.
///
/// Uses a temp-directory file cache + Flutter's built-in in-memory
/// `ImageCache`. Kept dependency-free (no flutter_cache_manager).
/// ────────────────────────────────────────────────────────────────────────────
class ImageCacheManager {
  static ImageCacheManager? _instance;
  static ImageCacheManager get instance => _instance ??= ImageCacheManager._();
  ImageCacheManager._();

  static const _maxAgeCache = Duration(days: 7);
  static const _maxCacheSize = 100 * 1024 * 1024; // 100MB
  static const _maxNrOfCacheObjects = 200;

  Directory? _dir;

  Future<Directory> _cacheDir() async {
    if (_dir != null) return _dir!;
    final base = await getTemporaryDirectory();
    _dir = Directory('${base.path}/profileforge_images');
    if (!await _dir!.exists()) {
      await _dir!.create(recursive: true);
    }
    return _dir!;
  }

  String _fileKey(String url) {
    final hash = url.hashCode.toRadixString(16);
    final safe = url
        .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_')
        .substring(0, url.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_').length.clamp(0, 48));
    return '${safe}_$hash';
  }

  /// Get a cached file or download it.
  Future<File> getFile(String url) async {
    final dir = await _cacheDir();
    final file = File('${dir.path}/${_fileKey(url)}');
    if (await file.exists()) {
      // Expire after 7 days.
      final age = DateTime.now().difference(file.lastModifiedSync());
      if (age < _maxAgeCache) return file;
      await file.delete().catchError((_) {});
    }
    // Download via Dart's HttpClient (no package needed).
    final http = HttpClient();
    try {
      final req = await http.getUrl(Uri.parse(url));
      final resp = await req.close();
      if (resp.statusCode != 200) {
        throw HttpException('GET $url -> ${resp.statusCode}');
      }
      await resp.pipe(file.openWrite());
    } finally {
      http.close();
    }
    await _prune();
    return file;
  }

  /// Check if a URL is cached (and fresh).
  Future<bool> isCached(String url) async {
    final dir = await _cacheDir();
    final file = File('${dir.path}/${_fileKey(url)}');
    if (!await file.exists()) return false;
    return DateTime.now().difference(file.lastModifiedSync()) < _maxAgeCache;
  }

  /// Pre-cache multiple URLs (best-effort, silent failures).
  Future<void> preCache(List<String> urls) async {
    for (final url in urls) {
      try {
        await getFile(url);
      } catch (_) {
        // Silently fail for pre-caching.
      }
    }
  }

  /// Total bytes currently on disk.
  Future<int> getCacheSize() async {
    final dir = await _cacheDir();
    var total = 0;
    await for (final f in dir.list()) {
      if (f is File) total += await f.length();
    }
    return total;
  }

  /// Clear the entire cache.
  Future<void> clearCache() async {
    final dir = await _cacheDir();
    if (await dir.exists()) {
      await dir.delete(recursive: true);
      _dir = null;
    }
  }

  /// Remove a specific URL from cache.
  Future<void> removeFile(String url) async {
    final dir = await _cacheDir();
    final file = File('${dir.path}/${_fileKey(url)}');
    if (await file.exists()) await file.delete().catchError((_) {});
  }

  /// Get cached file size in bytes.
  Future<int> getFileSize(String url) async {
    final dir = await _cacheDir();
    final file = File('${dir.path}/${_fileKey(url)}');
    if (!await file.exists()) return 0;
    return file.length();
  }

  /// Get cache statistics.
  Future<CacheStats> getStats() async {
    return CacheStats(size: await getCacheSize(), maxSize: _maxCacheSize);
  }

  /// Drop oldest files when over the 100MB budget.
  Future<void> _prune() async {
    final dir = await _cacheDir();
    final files = <File>[];
    await for (final f in dir.list()) {
      if (f is File) files.add(f);
    }
    if (files.length <= _maxNrOfCacheObjects) return;
    files.sort((a, b) => a.lastModifiedSync().compareTo(b.lastModifiedSync()));
    final toRemove = files.length - _maxNrOfCacheObjects;
    for (var i = 0; i < toRemove; i++) {
      await files[i].delete().catchError((_) {});
    }
  }
}

class CacheStats {
  final int size;
  final int maxSize;

  const CacheStats({required this.size, required this.maxSize});

  double get usagePercent => maxSize > 0 ? (size / maxSize) * 100 : 0;

  String get formattedSize {
    if (size < 1024) return '$size B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)} KB';
    return '${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

/// CachedImage — Widget that displays a cached image.
class CachedNetworkImage extends StatelessWidget {
  const CachedNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
  });

  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        cacheWidth: width?.toInt(),
        cacheHeight: height?.toInt(),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return placeholder ??
              Container(
                width: width,
                height: height,
                color: const Color(0xFFF1F5F9),
                child: Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                    strokeWidth: 2,
                  ),
                ),
              );
        },
        errorBuilder: (context, error, stackTrace) {
          return errorWidget ??
              Container(
                width: width,
                height: height,
                color: const Color(0xFFF1F5F9),
                child: const Icon(
                  Icons.error_outline,
                  color: Color(0xFF94A3B8),
                ),
              );
        },
      ),
    );
  }
}
