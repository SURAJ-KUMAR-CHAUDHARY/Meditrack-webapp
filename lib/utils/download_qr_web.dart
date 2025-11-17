import 'dart:typed_data';
import 'dart:html' as html;
import 'dart:js_util' as js_util;

/// Web implementation: create a blob URL and trigger an anchor download.
Future<String?> download(Uint8List bytes, String filename) async {
  final blob = html.Blob([bytes]);
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.document.createElement('a') as html.AnchorElement;
  anchor.href = url;
  anchor.download = filename;
  anchor.style.display = 'none';
  html.document.body!.append(anchor);
  anchor.click();
  anchor.remove();
  html.Url.revokeObjectUrl(url);
  return 'downloaded';
}

/// Try to use the Web Share API to share the file. Returns true if share
/// was attempted (and likely succeeded), false otherwise.
Future<bool> tryShare(Uint8List bytes, String filename) async {
  try {
    // Create a Blob for the bytes and then a JS File from it.
    final blob = html.Blob([bytes], 'image/png');

    // Construct a JS File from the Blob: new File([blob], filename, { type: 'image/png' })
    final jsFile = js_util.callConstructor(
        js_util.getProperty(html.window, 'File'), [js_util.jsify([blob]), filename, js_util.jsify({'type': 'image/png'})]);

    // Check navigator.canShare({ files: [file] })
    final canShare = js_util.callMethod(html.window.navigator, 'canShare', [js_util.jsify({'files': [jsFile]})]);
    if (canShare == true) {
      await js_util.promiseToFuture(js_util.callMethod(html.window.navigator, 'share', [js_util.jsify({'files': [jsFile], 'title': filename})]));
      return true;
    }
  } catch (_) {
    // ignore - fall back to download
  }
  return false;
}
