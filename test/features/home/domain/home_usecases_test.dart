import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/error/error.dart';
import 'package:stronger_muscles/features/home/domain/entities/selection_entity.dart';
import 'package:stronger_muscles/features/home/domain/repositories/home_repository.dart';
import 'package:stronger_muscles/features/home/domain/usecases/get_home_products_usecase.dart';
import 'package:stronger_muscles/features/home/domain/usecases/get_home_shortcuts_usecase.dart';
import 'package:stronger_muscles/features/home/presentation/helpers/selection_ui_mapper.dart';
import 'package:stronger_muscles/features/product/domain/entities/localized_string_entity.dart';
import 'package:stronger_muscles/features/product/domain/entities/product_entity.dart';

class MockHomeRepository implements HomeRepository {
  List<SelectionEntity> mockShortcuts = [];
  List<ProductEntity> mockProducts = [];
  Failure? failureToThrow;

  @override
  Future<Either<Failure, List<SelectionEntity>>> getHomeShortcuts({
    required String langCode,
  }) async {
    if (failureToThrow != null) return Left(failureToThrow!);
    return Right(mockShortcuts);
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getHomeProducts({
    String? categoryId,
    int page = 1,
  }) async {
    if (failureToThrow != null) return Left(failureToThrow!);
    return Right(mockProducts);
  }
}

void main() {
  group('Home Clean Architecture Usecases Tests', () {
    test('GetHomeShortcutsUseCase returns shortcuts successfully on Right',
        () async {
      final mockRepo = MockHomeRepository();
      mockRepo.mockShortcuts = [
        const SelectionEntity(
          id: '',
          label: 'categoryHome',
          iconKey: 'home',
        ),
        const SelectionEntity(
          id: 'protein',
          label: 'Protein',
          iconKey: 'protein',
        ),
        const SelectionEntity(
          id: 'creatine',
          label: 'Creatine',
          iconKey: 'creatine',
        ),
      ];

      final useCase = GetHomeShortcutsUseCase(mockRepo);
      final result = await useCase(langCode: 'en');

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Should not return failure'),
        (shortcuts) {
          expect(shortcuts.length, 3);
          expect(shortcuts[0].id, '');
          expect(shortcuts[0].label, 'categoryHome');
          expect(shortcuts[1].id, 'protein');
          expect(shortcuts[1].label, 'Protein');
          expect(shortcuts[2].id, 'creatine');
          expect(shortcuts[2].label, 'Creatine');
        },
      );
    });

    test('GetHomeShortcutsUseCase returns Failure on Left', () async {
      final mockRepo = MockHomeRepository();
      mockRepo.failureToThrow = const ServerFailure(message: 'Server unavailable');

      final useCase = GetHomeShortcutsUseCase(mockRepo);
      final result = await useCase(langCode: 'en');

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect((failure as ServerFailure).message, 'Server unavailable');
        },
        (_) => fail('Should return failure'),
      );
    });

    test('GetHomeProductsUseCase returns products on Right', () async {
      final mockRepo = MockHomeRepository();
      mockRepo.mockProducts = [
        const ProductEntity(
          id: 'prod_1',
          name: LocalizedStringEntity(en: 'Whey Protein'),
          price: 150.0,
        ),
      ];

      final useCase = GetHomeProductsUseCase(mockRepo);
      final result = await useCase();

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Should not return failure'),
        (products) {
          expect(products.length, 1);
          expect(products.first.id, 'prod_1');
          expect(products.first.price, 150.0);
        },
      );
    });

    test('GetHomeProductsUseCase returns Failure on Left', () async {
      final mockRepo = MockHomeRepository();
      mockRepo.failureToThrow = const NetworkFailure(message: 'No internet connection');

      final useCase = GetHomeProductsUseCase(mockRepo);
      final result = await useCase(page: 1);

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) {
          expect(failure, isA<NetworkFailure>());
          expect((failure as NetworkFailure).message, 'No internet connection');
        },
        (_) => fail('Should return failure'),
      );
    });

    test('SelectionEntity equality and hashCode work as expected', () {
      const e1 = SelectionEntity(
        label: 'Protein',
        iconKey: 'protein',
        id: '1',
      );
      const e2 = SelectionEntity(
        label: 'Protein',
        iconKey: 'protein',
        id: '1',
      );
      const e3 = SelectionEntity(
        label: 'Creatine',
        iconKey: 'creatine',
        id: '2',
      );

      expect(e1, equals(e2));
      expect(e1.hashCode, equals(e2.hashCode));
      expect(e1 == e3, isFalse);
    });

    test('SelectionEntityUiX maps iconKey to presentation IconData correctly', () {
      const shortcutHome = SelectionEntity(id: '', label: 'Home', iconKey: 'home');
      const shortcutProtein = SelectionEntity(id: 'protein', label: 'Protein', iconKey: 'protein');

      expect(shortcutHome.icon, Icons.home);
      expect(shortcutProtein.icon, Icons.fitness_center);
    });
  });
}
