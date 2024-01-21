import 'package:dio/dio.dart';
import 'package:teslo_shop/config/constants/environment.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/infrastructure/mappers/product_mapper.dart';

class ProductsDatasourceImpl extends ProductsDataSource {
  late final Dio dio;
  final String accessToken;
  ProductsDatasourceImpl({required this.accessToken})
      : dio = Dio(BaseOptions(
          headers: {'Authorization': 'Bearer $accessToken'},
          baseUrl: Environment.apiUrl,
        ));

  @override
  Future<Product> createUpdateProduct(Map<String, dynamic> likeProduct) {
    // TODO: implement createUpdateProduct
    throw UnimplementedError();
  }

  @override
  Future<List<Product>> getProductByPage(int limit, int offset) async {
    final response =
        await dio.get<List>('/api/products?limit=$limit&offset=$offset');
    final List<Product> products = [];

    for (final product in response.data ?? []) {
      products.add(ProductMapper.jsonToEntity(product)); //pasar un mapper
    }
    return products;
  }

  @override
  Future<List<Product>> getProductsByCategory(String category) {
    // TODO: implement getProductsByCategory
    throw UnimplementedError();
  }

  @override
  Future<List<Product>> getProductsById(String id) {
    // TODO: implement getProductsById
    throw UnimplementedError();
  }

  @override
  Future<List<Product>> getProductsByTerm(String term) {
    // TODO: implement getProductsByTerm
    throw UnimplementedError();
  }
}
