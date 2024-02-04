// ignore_for_file: unnecessary_null_comparison

import 'package:dio/dio.dart';
import 'package:teslo_shop/config/constants/environment.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/infrastructure/errors/product_errors.dart';
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
  Future<Product> createUpdateProduct(Map<String, dynamic> likeProduct) async {
    try {
      final String productId = likeProduct['id'] ?? '';
      final String method = (productId == '') ? 'POST' : 'PATCH';
      final String url =
          (productId == '') ? '/products' : '/products/$productId';
      likeProduct.remove('id');

      final response = await dio.request(
        url,
        data: likeProduct,
        options: Options(method: method),
      );
      final product = ProductMapper.jsonToEntity(response.data);
      return product;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<Product>> getProductByPage(int limit, int offset) async {
    final response =
        await dio.get<List>('/products?limit=$limit&offset=$offset');
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
  Future<Product> getProductsById(String id) async {
    try {
      final response = await dio.get('/products/$id');
      final product = ProductMapper.jsonToEntity(response.data!);
      print(product);
      return product;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw ProductNoTFound();
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<List<Product>> getProductsByTerm(String term) {
    // TODO: implement getProductsByTerm
    throw UnimplementedError();
  }
}
