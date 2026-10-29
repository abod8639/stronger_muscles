import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/config/api_config.dart';
import '../../../../core/error/error.dart';
import '../../../../core/services/api_service.dart';
import '../models/checkout_item_model.dart';
import '../models/checkout_params_model.dart';
import '../models/checkout_quote_model.dart';
import '../models/checkout_result_model.dart';

CheckoutResultModel parseCheckoutResultIsolate(Map<String, dynamic> data) {
  return CheckoutResultModel.fromJson(data);
}

abstract class CheckoutRemoteDataSource {
  Future<CheckoutResultModel> submitOrder(
    CheckoutParamsModel params, {
    CancelToken? cancelToken,
  });

  Future<String?> initiatePayment({
    required String orderId,
    required String gateway,
    String? customerName,
    CancelToken? cancelToken,
  });

  Future<CheckoutQuoteModel> fetchQuote(
    List<CheckoutItemModel> items, {
    CancelToken? cancelToken,
  });
}

class CheckoutRemoteDataSourceImpl implements CheckoutRemoteDataSource {
  const CheckoutRemoteDataSourceImpl(this._apiService);

  final ApiService _apiService;

  @override
  Future<CheckoutResultModel> submitOrder(
    CheckoutParamsModel params, {
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _apiService
          .post(
            ApiConfig.orders,
            data: params.toPayload(),
            cancelToken: cancelToken,
            timeout: const Duration(seconds: 30),
          );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final rawData = response.data;
        if (rawData is Map<String, dynamic>) {
          return await compute(parseCheckoutResultIsolate, rawData);
        }
        return const CheckoutResultModel(orderId: '', status: 'success');
      }

      throw ServerException(
        statusCode: response.statusCode,
        message: response.statusMessage ?? 'Failed to place order',
        data: response.data,
      );
    } on Failure catch (f) {
      if (f is TimeoutFailure) {
        throw TimeoutAppException(message: f.message);
      }
      if (f is CancelFailure) {
        throw const CancelAppException();
      }
      throw ServerException(message: f.message);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        throw const CancelAppException();
      }
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const TimeoutAppException();
      }
      throw ServerException(
        statusCode: e.response?.statusCode,
        message: e.message ?? 'Network error submitting order',
        data: e.response?.data,
      );
    } catch (e) {
      if (e is ServerException ||
          e is TimeoutAppException ||
          e is CancelAppException) {
        rethrow;
      }
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String?> initiatePayment({
    required String orderId,
    required String gateway,
    String? customerName,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _apiService
          .post(
            ApiConfig.payOrder(orderId),
            data: {
              'gateway': gateway,
              if (customerName != null && customerName.isNotEmpty)
                'first_name': customerName,
            },
            cancelToken: cancelToken,
            timeout: const Duration(seconds: 30),
          );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          final paymentData = data['data'];
          if (paymentData is Map) {
            return paymentData['payment_url']?.toString();
          }
          return data['payment_url']?.toString();
        }
        return null;
      }

      throw ServerException(
        statusCode: response.statusCode,
        message: response.statusMessage ?? 'Failed to initiate payment',
      );
    } on Failure catch (f) {
      if (f is TimeoutFailure) {
        throw TimeoutAppException(message: f.message);
      }
      if (f is CancelFailure) {
        throw const CancelAppException();
      }
      throw ServerException(message: f.message);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        throw const CancelAppException();
      }
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const TimeoutAppException();
      }
      throw ServerException(
        statusCode: e.response?.statusCode,
        message: e.message ?? 'Network error initiating payment',
      );
    } catch (e) {
      if (e is ServerException ||
          e is TimeoutAppException ||
          e is CancelAppException) {
        rethrow;
      }
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<CheckoutQuoteModel> fetchQuote(
    List<CheckoutItemModel> items, {
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConfig.orderQuote,
        data: {
          'items': items
              .map((i) => {
                    'product_id': i.productId,
                    'quantity': i.quantity,
                    if (i.selectedSize != null) 'selected_size': i.selectedSize,
                  })
              .toList(),
        },
        cancelToken: cancelToken,
        timeout: const Duration(seconds: 15),
      );

      final rawData = response.data;
      if ((response.statusCode == 200 || response.statusCode == 201) &&
          rawData is Map<String, dynamic>) {
        return CheckoutQuoteModel.fromJson(rawData);
      }

      throw ServerException(
        statusCode: response.statusCode,
        message: response.statusMessage ?? 'Failed to price the order',
        data: rawData,
      );
    } on Failure catch (f) {
      if (f is TimeoutFailure) {
        throw TimeoutAppException(message: f.message);
      }
      if (f is CancelFailure) {
        throw const CancelAppException();
      }
      throw ServerException(message: f.message);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        throw const CancelAppException();
      }
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const TimeoutAppException();
      }
      throw ServerException(
        statusCode: e.response?.statusCode,
        message: e.message ?? 'Network error pricing the order',
        data: e.response?.data,
      );
    } catch (e) {
      if (e is ServerException ||
          e is TimeoutAppException ||
          e is CancelAppException) {
        rethrow;
      }
      throw ServerException(message: e.toString());
    }
  }
}
