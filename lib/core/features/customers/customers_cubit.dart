import 'package:bloc/bloc.dart';
import 'package:boru_crm/core/features/customers/repository/customer_repository.dart';
import 'customer_model.dart';

import 'customers_state.dart';

class CustomersCubit extends Cubit<CustomersState> {
  final CustomerRepository _repository;

  CustomersCubit(this._repository) : super(CustomersInitial());

  Future<void> loadCustomers() async {
    emit(CustomersLoading());
    try {
      final customers = await _repository.fetchCustomers();
      emit(CustomersLoaded(customers));
    } catch (e) {
      emit(CustomersError(e.toString()));
    }
  }

  Future<void> addCustomer(CustomerModel customer) async {
    try {
      await _repository.addCustomer(customer);
      await loadCustomers(); // listeyi tazele
    } catch (e) {
      emit(CustomersError(e.toString()));
    }
  }

  Future<void> updateCustomer(String id, Map<String, dynamic> updates) async {
    try {
      await _repository.updateCustomer(id, updates);
      await loadCustomers(); // listeyi tazele
    } catch (e) {
      emit(CustomersError(e.toString()));
    }
  }

  Future<void> deleteCustomer(String id) async {
    try {
      await _repository.deleteCustomer(id);
      await loadCustomers();
    } catch (e) {
      emit(CustomersError(e.toString()));
    }
  }
}
