import 'package:freezed_annotation/freezed_annotation.dart';
import 'order_model.dart';

part 'user_stats_model.freezed.dart';
part 'user_stats_model.g.dart';

@freezed
class UserStats with _$UserStats {
  const factory UserStats({
    required int id,
    required String name,
    @JsonKey(name: 'photo_url') String? photoUrl,
    @JsonKey(name: 'has_ordered') required bool hasOrdered,
    @JsonKey(name: 'orders_count') required int ordersCount,
    required List<OrderModel> orders,
  }) = _UserStats;

  factory UserStats.fromJson(Map<String, dynamic> json) =>
      _$UserStatsFromJson(json);
}

@freezed
class UsersStatsResponse with _$UsersStatsResponse {
  const factory UsersStatsResponse({
    @JsonKey(name: 'total_users') required int totalUsers,
    required List<UserStats> users,
  }) = _UsersStatsResponse;

  factory UsersStatsResponse.fromJson(Map<String, dynamic> json) =>
      _$UsersStatsResponseFromJson(json);
}
