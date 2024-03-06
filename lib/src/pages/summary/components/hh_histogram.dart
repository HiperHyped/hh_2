import 'package:flutter/material.dart';
import 'package:hh_2/src/config/common/var/hh_colors.dart';

class HHHistogram extends StatelessWidget {
  final Map<String, int> data;
  final List<String> labels;
  final String selectedLabel;
  final int? labelClip;

  HHHistogram({
    required this.data,
    required this.labels,
    required this.selectedLabel,
    this.labelClip,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
      decoration: BoxDecoration(
        color: HHColors.hhColorWhite,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: CustomPaint(
        size: Size(double.infinity, 50),
        painter: HHHistPainter(
          data: data,
          labels: labels,
          selectedLabel: selectedLabel,
          labelClip: labelClip,
        ),
      ),
    );
  }
}

class HHHistPainter extends CustomPainter {
  final Map<String, int> data;
  final List<String> labels;
  final String selectedLabel;
  final int? labelClip;
  final labelFontSize = 8.0;

  HHHistPainter({
    required this.data,
    required this.labels,
    required this.selectedLabel,
    this.labelClip,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final barWidth = size.width / (data.length * 2);
    final maxCount = data.values.reduce((a, b) => a > b ? a : b).toDouble();
    final paint = Paint()..color = HHColors.hhColorDarkFirst;
    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
      maxLines: 1,
    );

    for (var i = 0; i < labels.length; i++) {
      final label = labels[i];
      final clippedLabel = (labelClip != null && labelClip! < label.length)
          ? label.substring(0, labelClip!).toUpperCase()
          : label.toUpperCase();
      final count = data[label]?.toDouble() ?? 0;
      final barHeight = count / maxCount * size.height;
      final rect = Rect.fromLTWH(i * barWidth * 2, size.height - barHeight, barWidth, barHeight);

      canvas.drawRect(rect, paint);

      // Label painting is now removed since only histogram bars are needed in the container

      // Highlight the selected label's bar
      if (selectedLabel == label) {
        final highlightPaint = Paint()..color = HHColors.hhColorBack;
        canvas.drawRect(rect, highlightPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
