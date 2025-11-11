import 'package:flutter/material.dart';
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
    this.size = 200.0,
    this.backgroundColor,
    this.gapless = true,
    this.moduleColor = const Color(0xFF2B7FFF), // MediTrack blue
    this.eyeColor = const Color(0xFF2B7FFF), // MediTrack blue
    this.margin = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(margin),
      child: SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: QrPainter(
            data: data,
            version: version ?? QrVersions.auto,
            gapless: gapless,
            // Modern styling: rounded eyes with MediTrack blue color scheme
            dataModuleStyle: QrDataModuleStyle(
              color: moduleColor,
            ),
            eyeStyle: QrEyeStyle(
              eyeShape: QrEyeShape.circle, // Rounded corners
              color: eyeColor,
            ),
          ),
          child: Container(color: backgroundColor ?? Colors.white),
        ),
      ),
    );
  }
}
