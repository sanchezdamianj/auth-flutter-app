import 'package:teslo_shop/features/products/domain/entities/product.dart';

abstract class ProductsRepository {
  Future<List<Product>> getProductByPage(int limit, int offset);
  Future<List<Product>> getProductsById(String id);
  Future<List<Product>> getProductsByCategory(String category);
  Future<List<Product>> getProductsByTerm(String term);

  Future<Product> createUpdateProduct(Map<String, dynamic> likeProduct);
}
