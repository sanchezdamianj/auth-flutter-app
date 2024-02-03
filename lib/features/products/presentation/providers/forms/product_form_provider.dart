import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/config/constants/environment.dart';
import 'package:teslo_shop/features/products/domain/entities/product.dart';
import 'package:teslo_shop/features/products/presentation/providers/providers.dart';
import 'package:teslo_shop/features/shared/infrastructure/inputs/inputs.dart';

//Provider to deliver data to the screen, autodisposable to get the data updated when the user submits the form, and family because we need the product id to create it.

final productFormProvider = StateNotifierProvider.autoDispose
    .family<ProductFormNotifier, ProductFormState, Product>((ref, product) {
  // final createUpdateCallback =
  //     ref.watch(productsRepositoryProvider).createUpdateProduct;
  final createUpdateCallback =
      ref.watch(productsProvider.notifier).createOrUpdateProduct;

  return ProductFormNotifier(
      product: product, onSubmitCallback: createUpdateCallback);
});

//Here i receive a function to check if all data submitted are valid using a structure like a product (this productLike is the shape that the backend expects).
//Then i receive a product in the initState and pass it to the stateNotifier. Because of that, i put this in the constructor super.
class ProductFormNotifier extends StateNotifier<ProductFormState> {
  final Future<bool> Function(Map<String, dynamic> productLike)?
      onSubmitCallback;
  ProductFormNotifier({
    this.onSubmitCallback,
    required Product product,
  }) : super(ProductFormState(
          id: product.id,
          title: Title.dirty(product.title),
          price: Price.dirty(product.price),
          slug: Slug.dirty(product.slug),
          inStock: Stock.dirty(product.stock),
          sizes: product.sizes,
          description: product.description,
          images: product.images,
        ));

  Future<bool> onFormSubmit() async {
    _touchedEverything();
    if (!state.isFormValid) return false;
    if (onSubmitCallback == null) return false;

    final productLike = {
      "id": state.id,
      "title": state.title.value,
      "price": state.price.value,
      "slug": state.slug.value,
      "stock": state.inStock.value,
      "sizes": state.sizes,
      "description": state.description,
      "images": state.images
          .map((image) =>
              image.replaceAll('${Environment.apiUrl}/files/product/', ''))
          .toList(),
    };

    try {
      return await onSubmitCallback!(productLike);
    } catch (e) {
      return false;
    }
  }

  void _touchedEverything() {
    state = state.copyWith(
        isFormValid: Formz.validate([
      Title.dirty(state.title.value),
      Slug.dirty(state.slug.value),
      Price.dirty(state.price.value),
      Stock.dirty(state.inStock.value),
    ]));
  }

  void onTitleChange(String value) {
    state = state.copyWith(
        title: Title.dirty(value),
        isFormValid: Formz.validate([
          Title.dirty(value),
          Slug.dirty(state.slug.value),
          Price.dirty(state.price.value),
          Stock.dirty(state.inStock.value),
        ]));
  }

  void onSlugChanged(String value) {
    state = state.copyWith(
        slug: Slug.dirty(value),
        isFormValid: Formz.validate([
          Title.dirty(state.title.value),
          Slug.dirty(value),
          Price.dirty(state.price.value),
          Stock.dirty(state.inStock.value),
        ]));
  }

  void onPriceChanged(double value) {
    state = state.copyWith(
        price: Price.dirty(value),
        isFormValid: Formz.validate([
          Title.dirty(state.title.value),
          Slug.dirty(state.slug.value),
          Price.dirty(value),
          Stock.dirty(state.inStock.value),
        ]));
  }

  void onStockChanged(int value) {
    state = state.copyWith(
        inStock: Stock.dirty(value),
        isFormValid: Formz.validate([
          Title.dirty(state.title.value),
          Slug.dirty(state.slug.value),
          Price.dirty(state.price.value),
          Stock.dirty(value),
        ]));
  }

  void onSizeChanged(List<String> sizes) {
    state = state.copyWith(sizes: sizes);
  }

  void onDescriptionChanged(String value) {
    state = state.copyWith(description: value);
  }
}

//State
class ProductFormState {
  final bool isFormValid;
  final String? id;
  final Title title;
  final Price price;
  final Slug slug;
  final List<String> sizes;
  final String description;
  final Stock inStock;
  final List<String> images;

  ProductFormState(
      {this.isFormValid = false,
      this.id,
      this.title = const Title.dirty(''),
      this.price = const Price.dirty(0),
      this.slug = const Slug.dirty(''),
      this.inStock = const Stock.dirty(0),
      this.sizes = const [],
      this.description = '',
      this.images = const []});

  ProductFormState copyWith(
      {bool? isFormValid,
      String? id,
      Title? title,
      Price? price,
      Slug? slug,
      List<String>? sizes,
      String? description,
      Stock? inStock,
      List<String>? images}) {
    return ProductFormState(
        isFormValid: isFormValid ?? this.isFormValid,
        id: id ?? this.id,
        title: title ?? this.title,
        price: price ?? this.price,
        slug: slug ?? this.slug,
        sizes: sizes ?? this.sizes,
        description: description ?? this.description,
        inStock: inStock ?? this.inStock,
        images: images ?? this.images);
  }
}
