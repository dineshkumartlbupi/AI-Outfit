import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../core/theme.dart';

class SplitSlider extends StatefulWidget {
  final String beforeImageUrl;
  final String afterImageUrl;
  final double initialPosition; // 0.0 to 1.0 (default 0.5)

  const SplitSlider({
    super.key,
    required this.beforeImageUrl,
    required this.afterImageUrl,
    this.initialPosition = 0.5,
  });

  @override
  State<SplitSlider> createState() => _SplitSliderState();
}

class _SplitSliderState extends State<SplitSlider> {
  late double _dividerPosition;

  @override
  void initState() {
    super.initState();
    _dividerPosition = widget.initialPosition;
  }

  Widget _buildImage(String url) {
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        placeholder: (context, _) => Container(
          color: AppTheme.surfaceDark,
          child: const Center(
            child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.primary),
          ),
        ),
        errorWidget: (context, _, __) => Container(
          color: AppTheme.surfaceDark,
          child: const Icon(Icons.broken_image, color: Colors.white30),
        ),
      );
    } else {
      // Local file
      return Image.file(
        File(url),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, _, __) => Container(
          color: AppTheme.surfaceDark,
          child: const Icon(Icons.broken_image, color: Colors.white30),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        final splitX = width * _dividerPosition;

        return GestureDetector(
          onHorizontalDragUpdate: (details) {
            setState(() {
              _dividerPosition += details.delta.dx / width;
              _dividerPosition = _dividerPosition.clamp(0.05, 0.95);
            });
          },
          onTapDown: (details) {
            setState(() {
              _dividerPosition = (details.localPosition.dx / width).clamp(0.05, 0.95);
            });
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 1. Right Layer (AFTER: AI Transformed Outfit)
              _buildImage(widget.afterImageUrl),

              // 2. Left Layer (BEFORE: Original Photo) clipped by splitX
              ClipRect(
                clipper: _LeftSplitClipper(splitWidth: splitX),
                child: _buildImage(widget.beforeImageUrl),
              ),

              // 3. Floating Indicator Labels
              Positioned(
                top: 16,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.65),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white24, width: 0.5),
                  ),
                  child: const Text(
                    'ORIGINAL',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primary.withOpacity(0.4),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: const Text(
                    'AI OUTFIT ✨',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),

              // 4. Center Divider Line
              Positioned(
                left: splitX - 1.5,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 3,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),

              // 5. Center Draggable Handle
              Positioned(
                left: splitX - 22,
                top: height / 2 - 22,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                      BoxShadow(
                        color: AppTheme.primary.withOpacity(0.3),
                        blurRadius: 14,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.arrow_left, size: 18, color: Colors.black87),
                        Icon(Icons.arrow_right, size: 18, color: Colors.black87),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LeftSplitClipper extends CustomClipper<Rect> {
  final double splitWidth;

  _LeftSplitClipper({required this.splitWidth});

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, splitWidth, size.height);
  }

  @override
  bool shouldReclip(covariant _LeftSplitClipper oldClipper) {
    return oldClipper.splitWidth != splitWidth;
  }
}
