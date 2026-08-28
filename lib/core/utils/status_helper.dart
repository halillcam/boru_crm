import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class StatusHelper {
  StatusHelper._();

  static Color colorFor(String status) {
    return switch (status) {
      'paid' => AppColors.statusWon, // yeşil
      'unpaid' => AppColors.statusLost, // kırmızı
      'pending' => AppColors.statusNew, // gri
      _ => AppColors.statusNew,
    };
  }

  static String labelFor(String status) {
    return switch (status) {
      'paid' => 'ÖDEDİ',
      'unpaid' => 'ÖDEMEDİ',
      'pending' => 'BEKLEMEDE',
      _ => status.toUpperCase(),
    };
  }
}
