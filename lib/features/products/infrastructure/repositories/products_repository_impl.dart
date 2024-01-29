import 'package:teslo_shop/features/products/domain/domain.dart';

class ProductsRepositoryImpl extends ProductsRepository {
  final ProductsDataSource dataSource;
  ProductsRepositoryImpl(this.dataSource);

  @override
  Future<Product> createUpdateProduct(Map<String, dynamic> likeProduct) {
    return dataSource.createUpdateProduct(likeProduct);
  }

  @override
  @override
  Future<List<Product>> getProductByPage(int limit, int offset) {
    return dataSource.getProductByPage(limit, offset);
  }

  @override
  Future<List<Product>> getProductsByCategory(String category) {
    return dataSource.getProductsByCategory(category);
  }

  @override
  Future<Product> getProductsById(String id) {
    return dataSource.getProductsById(id);
  }

  @override
  Future<List<Product>> getProductsByTerm(String term) {
    return dataSource.getProductsByTerm(term);
  }
}
