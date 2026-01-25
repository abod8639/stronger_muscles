// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserStatsImpl _$$UserStatsImplFromJson(Map<String, dynamic> json) =>
    _$UserStatsImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      photoUrl: json['photo_url'] as String?,
      hasOrdered: json['has_ordered'] as bool,
      ordersCount: (json['orders_count'] as num).toInt(),
      orders: (json['orders'] as List<dynamic>)
          .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$UserStatsImplToJson(_$UserStatsImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'photo_url': instance.photoUrl,
      'has_ordered': instance.hasOrdered,
      'orders_count': instance.ordersCount,
      'orders': instance.orders,
    };

_$UsersStatsResponseImpl _$$UsersStatsResponseImplFromJson(
  Map<String, dynamic> json,
) => _$UsersStatsResponseImpl(
  totalUsers: (json['total_users'] as num).toInt(),
  users: (json['users'] as List<dynamic>)
      .map((e) => UserStats.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$UsersStatsResponseImplToJson(
  _$UsersStatsResponseImpl instance,
) => <String, dynamic>{
  'total_users': instance.totalUsers,
  'users': instance.users,
};
