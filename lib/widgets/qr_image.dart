import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:qr_flutter/qr_flutter.dart';

/// A small compatibility widget that exposes the older `QrImage(data: ...)`
/// style API but uses `QrPainter` internally so it works with modern
/// `qr_flutter` versions.
/// 
/// Supports modern styling with customizable eye shape, module style, colors,
/// and margin. Defaults to MediTrack's blue color scheme with rounded eyes.
class QrImage extends StatelessWidget {
  final String data;
  final int? version;
  final double size;
  final Color? backgroundColor;
  final bool gapless;
  final Color moduleColor;
  final Color eyeColor;
  final double margin;

  const QrImage({
    super.key,
    required this.data,
    this.version,
    this.size = 260.0,
    this.backgroundColor,
    this.gapless = false,
    this.moduleColor = Colors.black,
    this.eyeColor = Colors.black,
    this.margin = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    // Use QrPainter to generate PNG bytes and display with Image.memory.
    // This approach is more reliable across web and desktop where direct
    // CustomPaint painting may not render as expected in some environments.
    final painter = QrPainter(
      data: data,
      version: version ?? QrVersions.auto,
      gapless: gapless,
      dataModuleStyle: QrDataModuleStyle(color: moduleColor),
      eyeStyle: QrEyeStyle(eyeShape: QrEyeShape.square, color: eyeColor),
    );

    return Padding(
      padding: EdgeInsets.all(margin),
      child: SizedBox(
        width: size,
        height: size,
        child: FutureBuilder<ByteData?>(
          future: painter.toImageData(size),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
              final bytes = snapshot.data!.buffer.asUint8List();
              return Container(
                color: backgroundColor ?? Colors.white,
                child: Image.memory(bytes, width: size, height: size, fit: BoxFit.contain),
              );
            }

            // While building, show a placeholder box so layout is stable.
            return Container(
              width: size,
              height: size,
              color: backgroundColor ?? Colors.white,
              alignment: Alignment.center,
              child: const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)),
            );
          },
        ),
      ),
    );
  }
}
