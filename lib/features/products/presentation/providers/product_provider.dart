import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/domain/entities/product.dart';
import 'package:teslo_shop/features/products/domain/repositories/products_repository.dart';
import 'package:teslo_shop/features/products/presentation/providers/providers.dart';

//Provider
final productProvider = StateNotifierProvider.autoDispose
    .family<ProductNotifier, ProductState, String>((ref, productId) {
  final productsRepository = ref.watch(productsRepositoryProvider);

  return ProductNotifier(
      productsRepository: productsRepository, productId: productId);
});

//State
class ProductState {
  final String id;
  final Product? product;
  final bool isLoading;
  final bool isSaving;

  ProductState(
      {required this.id,
      this.product,
      this.isLoading = true,
      this.isSaving = false});

  ProductState copyWith(
          {String? id, Product? product, bool? isLoading, bool? isSaving}) =>
      ProductState(
          id: id ?? this.id,
          product: product ?? this.product,
          isLoading: isLoading ?? this.isLoading,
          isSaving: isSaving ?? this.isSaving);
}

//StateNotifier
class ProductNotifier extends StateNotifier<ProductState> {
  final ProductsRepository productsRepository;

  ProductNotifier({required this.productsRepository, required String productId})
      : super(ProductState(id: productId)) {
    loadProduct();
  }

  Product newEmptyProduct() {
    return Product(
      id: 'new',
      title: '',
      price: 0,
      description: '',
      gender: 'men',
      slug: '',
      stock: 0,
      sizes: ['S'],
      images: [],
    );
  }

//Im not passing id because i know the id of the product.
  Future loadProduct() async {
    try {
      if (state.id == 'new') {
        state = state.copyWith(isLoading: false, product: newEmptyProduct());
        return;
      }
      final product = await productsRepository.getProductsById(state.id);

      state = state.copyWith(isLoading: false, product: product);
    } catch (e) {
      print(e);
      state = state.copyWith(isLoading: false);
    }
  }

  Future saveProduct(Product product) async {
    state = state.copyWith(isSaving: true);
    await productsRepository.createUpdateProduct(product.toJson());
    state = state.copyWith(isSaving: false);
  }
}
