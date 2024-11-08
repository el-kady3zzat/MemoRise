import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' as flutter;

class CustomNoteTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final double hintFontSize;
  final double fontSize;
  final TextInputType keyboardType;
  final bool isContent;

  const CustomNoteTextFormField({
    super.key,
    required this.controller,
    required this.hint,
    required this.hintFontSize,
    required this.fontSize,
    required this.keyboardType,
    required this.isContent, // To distinguish between title and content
  });

  @override
  State<CustomNoteTextFormField> createState() => _CustomNoteTextFormField();
}

class _CustomNoteTextFormField extends State<CustomNoteTextFormField> {
  late double fontSize;
  late int maxLength;

  @override
  void initState() {
    super.initState();
    fontSize = widget.fontSize; // Start with initial font size
    // Calculate maximum characters based on the available width and font size
    maxLength =
        36; // This is an example, you can calculate this based on the width
  }

  @override
  Widget build(BuildContext context) {
    const double minFontSize = 18.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          double availableWidth = constraints.maxWidth;

          return TextFormField(
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            onChanged: (text) {
              if (!widget.isContent) {
                // Apply resizing only for the title
                // Measure text width and adjust font size if necessary
                double textWidth = _calculateTextWidth(text, fontSize);

                if (textWidth > availableWidth && fontSize > minFontSize) {
                  setState(() {
                    fontSize -= 3; // Decrease font size if text overflows
                  });
                }
                if (textWidth < availableWidth && fontSize < 34) {
                  setState(() {
                    fontSize += 3; // increase font size if text overflows
                  });
                }
              }
            },
            maxLines: widget.isContent ? null : 1,
            textDirection:
                widget.controller.text.contains(RegExp(r'[\u0600-\u06FF]'))
                    ? flutter.TextDirection.rtl
                    : flutter.TextDirection.ltr,
            scrollPhysics:
                widget.isContent ? const AlwaysScrollableScrollPhysics() : null,
            inputFormatters: widget.isContent
                ? []
                : [LengthLimitingTextInputFormatter(maxLength)],
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: TextStyle(
                color: const Color(0xb4b4b4b4),
                fontSize: widget.hintFontSize,
                fontWeight: FontWeight.bold,
              ),
              border: InputBorder.none,
            ),
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          );
        },
      ),
    );
  }

  // Function to calculate the width of the text in the current font size
  double _calculateTextWidth(String text, double fontSize) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: TextStyle(fontSize: fontSize)),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();
    return textPainter.size.width;
  }
}
