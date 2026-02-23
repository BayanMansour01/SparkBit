import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sparkbit/core/network/api_endpoints.dart';

/// Service for downloading and opening lesson attachments
class FileDownloadService {
  final Dio _dio;

  FileDownloadService(this._dio);

  /// Build the full download URL from an attachment path
  String _buildUrl(String attachmentPath) {
    if (attachmentPath.startsWith('http://') ||
        attachmentPath.startsWith('https://')) {
      return attachmentPath;
    }
    // Relative path → prepend base URL
    final base = ApiEndpoints.baseURl;
    final cleanPath = attachmentPath.startsWith('/')
        ? attachmentPath
        : '/$attachmentPath';
    return '$base$cleanPath';
  }

  /// Extract a clean file name from the path
  String getFileName(String path) {
    final name = path.split('/').last.split('?').first;
    return name.isNotEmpty ? name : 'attachment';
  }

  /// Download a file and return the local path.
  /// [onProgress] callback receives (received, total) bytes.
  Future<String> downloadFile(
    String attachmentPath, {
    void Function(int received, int total)? onProgress,
  }) async {
    final url = _buildUrl(attachmentPath);
    final fileName = getFileName(attachmentPath);

    // Get downloads directory
    final dir = await getApplicationDocumentsDirectory();
    final downloadDir = Directory('${dir.path}/SparkBit_Downloads');
    if (!await downloadDir.exists()) {
      await downloadDir.create(recursive: true);
    }

    final savePath = '${downloadDir.path}/$fileName';

    // Check if already downloaded
    final file = File(savePath);
    if (await file.exists() && (await file.length()) > 0) {
      return savePath;
    }

    // Download with progress
    await _dio.download(
      url,
      savePath,
      onReceiveProgress: (received, total) {
        onProgress?.call(received, total);
      },
      options: Options(headers: {'Accept': '*/*'}),
    );

    return savePath;
  }

  /// Open a downloaded file using the system's default handler
  Future<bool> openFile(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) return false;

    final uri = Uri.file(filePath);
    if (await canLaunchUrl(uri)) {
      return await launchUrl(uri);
    }

    // Fallback: try content:// URI on Android
    return false;
  }
}

/// Provider-friendly extension for showing download progress
class DownloadProgress {
  final double progress; // 0.0 to 1.0
  final bool isDownloading;
  final bool isComplete;
  final String? error;
  final String? filePath;

  const DownloadProgress({
    this.progress = 0.0,
    this.isDownloading = false,
    this.isComplete = false,
    this.error,
    this.filePath,
  });

  DownloadProgress copyWith({
    double? progress,
    bool? isDownloading,
    bool? isComplete,
    String? error,
    String? filePath,
  }) {
    return DownloadProgress(
      progress: progress ?? this.progress,
      isDownloading: isDownloading ?? this.isDownloading,
      isComplete: isComplete ?? this.isComplete,
      error: error ?? this.error,
      filePath: filePath ?? this.filePath,
    );
  }
}
