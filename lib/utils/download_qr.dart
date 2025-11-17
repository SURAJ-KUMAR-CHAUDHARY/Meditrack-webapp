import 'dart:typed_data';

// Conditional import - picks web or io implementation depending on platform
import 'download_qr_io.dart' if (dart.library.html) 'download_qr_web.dart';

/// Download [bytes] as [filename]. Returns a path or a short status string
/// depending on platform. Implementations are platform-specific.
Future<String?> downloadQr(Uint8List bytes, String filename) => download(bytes, filename);

/// Try to share the bytes on web using the Web Share API. Returns true if
/// sharing was attempted/succeeded, false if not supported.
Future<bool> tryShareQr(Uint8List bytes, String filename) => tryShare(bytes, filename);
