import 'purchase_model.dart';

sealed class PurchaseState {}

class PurchaseInitial extends PurchaseState {}

class PurchaseLoading extends PurchaseState {}

class PurchaseLoaded extends PurchaseState {
  final List<PurchaseModel> purchases;
  PurchaseLoaded(this.purchases);
}

class PurchaseError extends PurchaseState {
  final String message;
  PurchaseError(this.message);
}
