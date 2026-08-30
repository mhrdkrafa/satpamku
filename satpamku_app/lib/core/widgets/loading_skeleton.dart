import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class LoadingSkeleton extends StatelessWidget {
  final double? width;
  final double height;
  final BorderRadius borderRadius;

  const LoadingSkeleton({
    super.key,
    this.width,
    this.height = 16.0,
    this.borderRadius = AppSpacing.roundedSm,
  });

  factory LoadingSkeleton.card({double height = 120.0}) {
    return LoadingSkeleton(
      width: double.infinity,
      height: height,
      borderRadius: AppSpacing.roundedLg,
    );
  }

  factory LoadingSkeleton.circle({double size = 48.0}) {
    return LoadingSkeleton(
      width: size,
      height: size,
      borderRadius: BorderRadius.circular(size / 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.lightSurfaceVariant,
        borderRadius: borderRadius,
      ),
    );
  }
}
