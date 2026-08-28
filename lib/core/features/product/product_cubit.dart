import 'package:bloc/bloc.dart';
import 'product_model.dart';
import 'repository/product_repository.dart';
import 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepository _repository;

  ProductCubit(this._repository) : super(ProductInitial());

  Future<void> loadProducts() async {
    emit(ProductLoading());
    try {
      final products = await _repository.fetchProducts();

      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> addProduct(ProductModel product) async {
    try {
      await _repository.addProduct(product);

      await loadProducts();
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      await _repository.deleteProduct(id);
      await loadProducts();
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}
