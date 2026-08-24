import '../customers/customer_model.dart';

sealed class CustomersState {}

class CustomersInitial extends CustomersState {}

class CustomersLoading extends CustomersState {}

class CustomersLoaded extends CustomersState {
  final List<CustomerModel> customers;
  CustomersLoaded(this.customers);
}

class CustomersError extends CustomersState {
  final String message;
  CustomersError(this.message);
}
