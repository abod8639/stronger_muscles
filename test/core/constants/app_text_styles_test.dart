import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/constants/app_text_styles.dart';

void main() {
  group('AppTextStyles Constants Tests', () {
    test('heading styles define correct typography hierarchy', () {
      expect(AppTextStyles.h1.fontSize, 32);
      expect(AppTextStyles.h1.fontWeight, FontWeight.bold);
      expect(AppTextStyles.h1.color, AppColors.black);

      expect(AppTextStyles.h2.fontSize, 24);
      expect(AppTextStyles.h2.fontWeight, FontWeight.bold);
      expect(AppTextStyles.h2.color, AppColors.black);

      expect(AppTextStyles.h3.fontSize, 20);
      expect(AppTextStyles.h3.fontWeight, FontWeight.w600);
      expect(AppTextStyles.h3.color, AppColors.black);
    });

    test('body styles define appropriate font sizes and colors', () {
      expect(AppTextStyles.bodyLarge.fontSize, 16);
      expect(AppTextStyles.bodyLarge.fontWeight, FontWeight.normal);
      expect(AppTextStyles.bodyLarge.color, AppColors.black);

      expect(AppTextStyles.bodyMedium.fontSize, 14);
      expect(AppTextStyles.bodyMedium.fontWeight, FontWeight.normal);
      expect(AppTextStyles.bodyMedium.color, AppColors.black);

      expect(AppTextStyles.bodySmall.fontSize, 12);
      expect(AppTextStyles.bodySmall.fontWeight, FontWeight.normal);
      expect(AppTextStyles.bodySmall.color, AppColors.greyDark);
    });

    test('button and caption styles conform to design specifications', () {
      expect(AppTextStyles.button.fontSize, 16);
      expect(AppTextStyles.button.fontWeight, FontWeight.w600);
      expect(AppTextStyles.button.color, AppColors.white);

      expect(AppTextStyles.caption.fontSize, 12);
      expect(AppTextStyles.caption.fontWeight, FontWeight.w400);
      expect(AppTextStyles.caption.color, AppColors.grey);
    });
  });
}
