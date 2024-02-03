import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';

import 'products_repository_provider.dart';

//StateProvider

class ProductsState {
  final bool isLastPage;
  final int limit;
  final int offset;
  final bool isLoading;
  final List<Product> products;

  ProductsState({
    this.isLastPage = false,
    this.limit = 10,
    this.offset = 0,
    this.isLoading = false,
    this.products = const [],
  });

  ProductsState copyWith({
    bool? isLastPage,
    int? limit,
    int? offset,
    bool? isLoading,
    List<Product>? products,
  }) =>
      ProductsState(
        isLastPage: isLastPage ?? this.isLastPage,
        limit: limit ?? this.limit,
        offset: offset ?? this.offset,
        isLoading: isLoading ?? this.isLoading,
        products: products ?? this.products,
      );
}

// State Notifier Provider

class ProductsNotifier extends StateNotifier<ProductsState> {
  final ProductsRepository productsRepository;
  ProductsNotifier({required this.productsRepository})
      : super(ProductsState()) {
    //When the first instance is created, we call loadNextPage;
    loadNextPage();
  }

  Future<bool> createOrUpdateProduct(Map<String, dynamic> likeProduct) async {
    try {
      final product = await productsRepository.createUpdateProduct(likeProduct);
      final isProductInState =
          state.products.any((element) => element.id == product.id);
      if (!isProductInState) {
        state = state.copyWith(products: [...state.products, product]);
        return true;
      }

      state = state.copyWith(
          products: state.products
              .map((e) => e.id == product.id ? product : e)
              .toList());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future loadNextPage() async {
    //if we dont have more pages to load, we return do nothing.
    if (state.isLoading || state.isLastPage) {
      return;
    }

    state = state.copyWith(
      isLoading: true,
    );
    final products = await productsRepository.getProductByPage(
        state.limit, state.offset + state.limit);

    if (products.isEmpty) {
      state = state.copyWith(isLoading: false, isLastPage: true);
      return;
    }
    state = state.copyWith(
      isLoading: false,
      isLastPage: false,
      offset: state.offset + state.limit,
      products: [...state.products, ...products],
    );
  }
}

//Provider del State Notifier que ata a la instancia de ProductsNotifier con el State
final productsProvider =
    StateNotifierProvider<ProductsNotifier, ProductsState>((ref) {
  final productsRepository = ref.watch(productsRepositoryProvider);
  return ProductsNotifier(productsRepository: productsRepository);
});
