import 'package:get/get.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../domain/usecases/get_product_by_id_usecase.dart';
import '../../domain/usecases/create_product_usecase.dart';

class ProductController extends GetxController {
  final GetProductsUsecase getProductsUsecase;
  final GetProductByIdUsecase getProductByIdUsecase;
  final CreateProductUsecase createProductUsecase;

  ProductController({
    required this.getProductsUsecase,
    required this.getProductByIdUsecase,
    required this.createProductUsecase,
  });

  final RxList<ProductEntity> items = <ProductEntity>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAll();
  }

  Future<void> fetchAll() async {
    isLoading.value = true;
    items.value = await getProductsUsecase();
    isLoading.value = false;
  }
}
