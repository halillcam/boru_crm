import 'package:boru_crm/core/features/auth/auth_cubit.dart';
import 'package:boru_crm/core/features/auth/auth_state.dart';
import 'package:boru_crm/core/features/auth/login_page.dart';
import 'package:boru_crm/core/features/customers/customers_cubit.dart';
import 'package:boru_crm/core/features/customers/repository/customer_repository.dart';
import 'package:boru_crm/core/features/product/product_cubit.dart';
import 'package:boru_crm/core/features/product/repository/product_repository.dart';
import 'package:boru_crm/core/features/purchase/purchase_cubit.dart';
import 'package:boru_crm/core/features/purchase/repository/purchase_repository.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: "https://ewdybmwevohlythgxyql.supabase.co",
    publishableKey: "sb_publishable_EG8BpMUpaAuobNOZKa0fTw_UlgRHfrX",
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CustomersCubit(CustomerRepository())),
        BlocProvider(create: (_) => ProductCubit(ProductRepository())),
        BlocProvider(create: (_) => PurchaseCubit(PurchaseRepository())),
        BlocProvider(create: (_) => AuthCubit()),
      ],
      child: MaterialApp(
        title: 'Boru CRM',
        theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
        home: const AuthGate(),
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return switch (state) {
          AuthAuthenticated() => const _CustomerListPlaceholder(),
          AuthInitial() || AuthLoading() => const _SplashLoading(),
          AuthUnauthenticated() || AuthError() => const LoginPage(),
        };
      },
    );
  }
}

class _SplashLoading extends StatelessWidget {
  const _SplashLoading();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

/// Geçici ekran — customers_list_page.dart yazılana kadar burada duracak.
class _CustomerListPlaceholder extends StatelessWidget {
  const _CustomerListPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Giriş başarılı! Customer list yakında burada olacak.')),
    );
  }
}
