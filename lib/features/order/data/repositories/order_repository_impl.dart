import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_remote_datasource.dart';
import '../datasources/order_local_datasource.dart';
import '../models/order_model.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDatasource remoteDatasource;
  final OrderLocalDatasource localDatasource;

  OrderRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
  });

  @override
  Future<List<OrderEntity>> getAllOrders() async {
    final models = await remoteDatasource.getAllOrders();
    await localDatasource.cacheOrders(models);
    return models;
  }

  @override
  Future<OrderEntity> getOrderById(String id) =>
      remoteDatasource.getOrderById(id);

  @override
  Future<void> createOrder(OrderEntity entity) =>
      remoteDatasource.createOrder(OrderModel(id: entity.id, name: entity.name));
}
