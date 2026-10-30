import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/core/utils/functions/cache_manager.dart';

/// Cached network image with unified rounded corners, a themed loading
/// placeholder and a fallback icon for missing or broken URLs.
class AppNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadiusGeometry? borderRadius;
  final int? memCacheWidth;
  final int? memCacheHeight;
  final IconData errorIcon;
  final double? errorIconSize;

  /// Color behind the placeholder / fallback (defaults to the theme's container color).
  final Color? backgroundColor;

  /// Show a spinner while loading; when false the placeholder is a plain color box.
  final bool showLoadingIndicator;

  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.memCacheWidth,
    this.memCacheHeight,
    this.errorIcon = Icons.image_not_supported_outlined,
    this.errorIconSize,
    this.backgroundColor,
    this.showLoadingIndicator = true,
  });

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;

    return ClipRRect(
      borderRadius: borderRadius ?? AppRadius.allMd,
      child: url == null || url.isEmpty
          ? _buildFallback(context)
          : CachedNetworkImage(
              cacheManager: CustomCacheManager.instance,
              imageUrl: url,
              width: width,
              height: height,
              fit: fit,
              memCacheWidth: memCacheWidth,
              memCacheHeight: memCacheHeight,
              placeholder: (context, _) => _buildBox(
                context,
                showLoadingIndicator
                    ? const Center(
                        child: SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                            strokeWidth: 2.0,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              errorWidget: (context, _, _) => _buildFallback(context),
            ),
    );
  }

  Widget _buildFallback(BuildContext context) => _buildBox(
        context,
        Icon(
          errorIcon,
          color: context.colorScheme.onSurfaceVariant,
          size: errorIconSize ??
              (width != null && width!.isFinite ? width! * 0.4 : 40.0),
        ),
      );

  Widget _buildBox(BuildContext context, Widget child) => Container(
        width: width,
        height: height,
        color: backgroundColor ?? context.colorScheme.surfaceContainerHighest,
        alignment: Alignment.center,
        child: child,
      );
}
