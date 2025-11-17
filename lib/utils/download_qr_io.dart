import 'dart:typed_data';
import 'dart:io';

/// IO implementation: write bytes to system temp directory and return file path.
Future<String?> download(Uint8List bytes, String filename) async {
  final dir = Directory.systemTemp;
  final file = File('${dir.path}/$filename');
  await file.writeAsBytes(bytes);
  return file.path;
}

/// IO fallback for tryShare: not supported, return false.
Future<bool> tryShare(Uint8List bytes, String filename) async {
  return false;
}
