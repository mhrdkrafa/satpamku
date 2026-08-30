import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class AppSearchField extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onFilterTap;
  final VoidCallback? onClear;
  final bool showFilterButton;
  final bool hasActiveFilters;

  const AppSearchField({
    super.key,
    this.hint = 'Cari lowongan satpam, lokasi, atau BUJP...',
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onFilterTap,
    this.onClear,
    this.showFilterButton = true,
    this.hasActiveFilters = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: AppSpacing.roundedMd,
        border: Border.all(color: AppColors.lightBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: AppSpacing.md, right: AppSpacing.sm),
            child: Icon(Icons.search, color: AppColors.lightTextMuted, size: 22),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.lightTextPrimary),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: theme.textTheme.bodyMedium?.copyWith(color: AppColors.lightTextMuted),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
                contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              ),
            ),
          ),
          if (controller != null && controller!.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.close, size: 18, color: AppColors.lightTextMuted),
              onPressed: () {
                controller?.clear();
                onClear?.call();
              },
            ),
          if (showFilterButton) ...[
            Container(
              height: 24,
              width: 1,
              color: AppColors.lightBorder,
              margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
            ),
            IconButton(
              icon: Stack(
                children: [
                  const Icon(Icons.tune, color: AppColors.primary, size: 22),
                  if (hasActiveFilters)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.secondary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
              onPressed: onFilterTap,
            ),
          ],
        ],
      ),
    );
  }
}
