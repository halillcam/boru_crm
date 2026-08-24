import 'package:boru_crm/core/features/customers/customers_cubit.dart';
import 'package:boru_crm/core/features/customers/repository/customer_repository.dart';
import 'package:boru_crm/core/features/product/product_cubit.dart';
import 'package:boru_crm/core/features/product/repository/product_repository.dart';
import 'package:boru_crm/core/features/purchase/purchase_cubit.dart';
import 'package:boru_crm/core/features/purchase/repository/purchase_repository.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: "https://ewdybmwevohlythgxyql.supabase.co",
    publishableKey: "sb_publishable_EG8BpMUpaAuobNOZKa0fTw_UlgRHfrX",
  );
  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CustomersCubit(CustomerRepository())),
        BlocProvider(create: (_) => ProductCubit(ProductRepository())),
        BlocProvider(create: (_) => PurchaseCubit(PurchaseRepository())),
      ],
      child: MaterialApp(
        title: 'Boru CRM',
        theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
        home: const Placeholder(), // şimdilik boş, birazdan login_page ile değiştireceğiz
      ),
    );
  }
}
