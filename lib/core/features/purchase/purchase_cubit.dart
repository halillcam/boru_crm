import 'package:bloc/bloc.dart';
import 'repository/purchase_repository.dart';
import 'purchase_state.dart';

class PurchaseCubit extends Cubit<PurchaseState> {
  final PurchaseRepository _repository;

  PurchaseCubit(this._repository) : super(PurchaseInitial());

  Future<void> loadPurchases(String customerId) async {
    emit(PurchaseLoading());
    try {
      final purchases = await _repository.fetchPurchasesForCustomer(customerId);
      emit(PurchaseLoaded(purchases));
    } catch (e) {
      emit(PurchaseError(e.toString()));
    }
  }

  Future<void> addPurchase({
    required String customerId,
    required String productId,
    required double amount,
    bool isPaid = false,
  }) async {
    try {
      await _repository.addPurchase(
        customerId: customerId,
        productId: productId,
        amount: amount,
        isPaid: isPaid,
      );
      await loadPurchases(customerId); // aynı müşterinin listesini tazele
    } catch (e) {
      emit(PurchaseError(e.toString()));
    }
  }

  Future<void> markAsPaid(String purchaseId, String customerId) async {
    try {
      await _repository.markAsPaid(purchaseId);
      await loadPurchases(customerId);
    } catch (e) {
      emit(PurchaseError(e.toString()));
    }
  }
}
