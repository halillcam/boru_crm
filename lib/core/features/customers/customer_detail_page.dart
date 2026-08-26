import 'package:boru_crm/core/widgets/purchase_cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../constants/app_text_styles.dart';
import '../../widgets/status_badge.dart';
import '../../widgets/note_card.dart';
import '../notes/notes_cubit.dart';
import '../notes/notes_state.dart';
import '../purchase/purchase_cubit.dart';
import '../purchase/purchase_state.dart';
import 'customer_model.dart';

class CustomerDetailPage extends StatefulWidget {
  final CustomerModel customer;

  const CustomerDetailPage({super.key, required this.customer});

  @override
  State<CustomerDetailPage> createState() => _CustomerDetailPageState();
}

class _CustomerDetailPageState extends State<CustomerDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<PurchaseCubit>().loadPurchases(widget.customer.id);
    context.read<NotesCubit>().loadNotes(widget.customer.id);
  }

  String get _initials {
    final parts = widget.customer.name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return widget.customer.name.isNotEmpty ? widget.customer.name[0].toUpperCase() : '?';
  }

  @override
  Widget build(BuildContext context) {
    final customer = widget.customer;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          customer.name,
          style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: AppColors.textPrimary),
            onPressed: () {
              // TODO: Edit customer ekranına yönlendir
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Avatar + isim + status
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    _initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(customer.name, style: AppTextStyles.heading),
                const SizedBox(height: 8),
                StatusBadge(status: customer.status),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // İletişim bilgisi kartı
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                if (customer.phone != null)
                  _ContactRow(icon: Icons.phone_outlined, text: customer.phone!),
                if (customer.phone != null && customer.email != null) const Divider(height: 20),
                if (customer.email != null)
                  _ContactRow(icon: Icons.email_outlined, text: customer.email!),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Purchases bölümü
          _SectionHeader(
            title: AppStrings.purchasesTitle,
            onAddPressed: () {
              // TODO: Add purchase ekranına yönlendir
            },
          ),
          const SizedBox(height: 10),
          BlocBuilder<PurchaseCubit, PurchaseState>(
            builder: (context, state) {
              return switch (state) {
                PurchaseInitial() ||
                PurchaseLoading() => const Center(child: CircularProgressIndicator()),
                PurchaseError(:final message) => Text('Hata: $message'),
                PurchaseLoaded(:final purchases) when purchases.isEmpty => const Text(
                  AppStrings.noPurchasesYet,
                  style: AppTextStyles.subtitle,
                ),
                PurchaseLoaded(:final purchases) => Column(
                  children: purchases.map((p) => PurchaseCard(purchase: p)).toList(),
                ),
              };
            },
          ),
          const SizedBox(height: 24),

          // Notes bölümü
          _SectionHeader(
            title: AppStrings.notesTitle,
            onAddPressed: () {
              // TODO: Add note dialogu göster
            },
          ),
          const SizedBox(height: 10),
          BlocBuilder<NotesCubit, NotesState>(
            builder: (context, state) {
              return switch (state) {
                NotesInitial() ||
                NotesLoading() => const Center(child: CircularProgressIndicator()),
                NotesError(:final message) => Text('Hata: $message'),
                NotesLoaded(:final notes) when notes.isEmpty => const Text(
                  AppStrings.noNotesYet,
                  style: AppTextStyles.subtitle,
                ),
                NotesLoaded(:final notes) => Column(
                  children: notes.map((n) => NoteCard(note: n)).toList(),
                ),
              };
            },
          ),
        ],
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ContactRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 10),
        Text(text, style: AppTextStyles.cardTitle),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onAddPressed;

  const _SectionHeader({required this.title, required this.onAddPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.cardTitle.copyWith(fontSize: 17)),
        TextButton(
          onPressed: onAddPressed,
          child: Text(AppStrings.addLabel, style: AppTextStyles.linkText),
        ),
      ],
    );
  }
}
