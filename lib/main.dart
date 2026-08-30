import 'package:boru_crm/core/features/auth/auth_cubit.dart';
import 'package:boru_crm/core/features/auth/auth_state.dart';
import 'package:boru_crm/core/features/auth/login_page.dart';
import 'package:boru_crm/core/features/customers/customers_cubit.dart';
import 'package:boru_crm/core/features/customers/customers_list_page.dart';
import 'package:boru_crm/core/features/customers/repository/customer_repository.dart';
import 'package:boru_crm/core/features/notes/notes_cubit.dart';
import 'package:boru_crm/core/features/notes/repository/notes_repository.dart';
import 'package:boru_crm/core/features/product/product_cubit.dart';
import 'package:boru_crm/core/features/product/repository/product_repository.dart';
import 'package:boru_crm/core/features/purchase/purchase_cubit.dart';
import 'package:boru_crm/core/features/purchase/repository/purchase_repository.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: dotenv.env["SUPABASE_URL"]!,
    publishableKey: dotenv.env["SUPABASE_PUBLIC_KEY"]!,
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
        BlocProvider(create: (_) => NotesCubit(NoteRepository())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
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
          AuthAuthenticated() => const CustomersListPage(),
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
