import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';
import 'package:stronger_muscles/features/product/data/datasources/product_service.dart';

part 'search_remote_datasource.g.dart';

@riverpod
SearchRemoteDataSource searchRemoteDataSource(SearchRemoteDataSourceRef ref) {
  return SearchRemoteDataSource(ref.watch(productServiceProvider));
}

class SearchRemoteDataSource {
  final ProductService _productService;

  SearchRemoteDataSource(this._productService);

  Future<List<ProductModel>> fetchProductsFromApi(String query) async {
    return await _productService.getProducts(query: query);
  }
}
