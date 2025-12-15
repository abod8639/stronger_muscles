import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/data/models/ReviewModel.dart';
import 'package:stronger_muscles/presentation/pages/product_details/widgets/HeaderWithIconandTitle.dart';
import 'package:stronger_muscles/presentation/pages/product_details/widgets/StarsRecord.dart';

/// A beautiful expandable description card with animations
class ExpandableDescriptionCard extends StatefulWidget {
  final String description;
  final double? stars;
  final int? reviewCount;
  final List<ReviewModel> reviews;  

  const ExpandableDescriptionCard({
    super.key,
    required this.description,
    this.stars,
    this.reviewCount,
    required this.reviews,
  });

  @override
  State<ExpandableDescriptionCard> createState() =>
      ExpandableDescriptionCardState();
}

class ExpandableDescriptionCardState extends State<ExpandableDescriptionCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _iconRotation;

  static const int _collapsedMaxLines = 4;
  static const Duration _animationDuration = Duration(milliseconds: 300);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: _animationDuration,
      vsync: this,
    );
    _iconRotation = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  theme.colorScheme.surface,
                  theme.colorScheme.surface.withOpacity(0.8),
                ]
              : [
                  theme.colorScheme.surface,
                  theme.colorScheme.primaryContainer.withOpacity(0.1),
                ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon and title
            HeaderWithIconandTitle(),

            // Description content

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedCrossFade(
                    firstChild: Text(
                      widget.description,
                      maxLines: _collapsedMaxLines,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.6,
                        letterSpacing: 0.2,
                      ),
                    ),
                    secondChild: Text(
                      widget.description,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.6,
                        letterSpacing: 0.2,
                      ),
                    ),
                    crossFadeState: _isExpanded
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: _animationDuration,
                  ),

                  // Show "Read more/less" only if text is long enough
                  if (shouldShowExpandButton())
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: InkWell(
                        onTap: _toggleExpanded,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _isExpanded ? 'Read less' : 'Read more',
                                style: theme.textTheme.bodyMedium
                                    ?.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              const SizedBox(width: 4),
                              RotationTransition(
                                turns: _iconRotation,
                                child: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                  // Stars record
                  StarsRecord(
                    reviews: widget.reviews,
                  ),
                ],
              ),
            ),
            
          ],
        ),
      ),
    );
  }
  bool shouldShowExpandButton() {
    final theme = Theme.of(context);
    final textPainter = TextPainter(
      text: TextSpan(
        text: widget.description,
        style: theme.textTheme.bodyLarge?.copyWith(
          height: 1.6,
          letterSpacing: 0.2,
        ),
      ),
      maxLines: _collapsedMaxLines,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: MediaQuery.of(context).size.width - 64);
    return textPainter.didExceedMaxLines;
  }


}
