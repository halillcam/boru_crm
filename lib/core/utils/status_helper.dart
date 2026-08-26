import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class StatusHelper {
  StatusHelper._();

  static Color colorFor(String status) {
    return switch (status) {
      'new' => AppColors.statusNew,
      'contacted' => AppColors.statusContacted,
      'negotiating' => AppColors.statusNegotiating,
      'won' => AppColors.statusWon,
      'lost' => AppColors.statusLost,
      _ => AppColors.statusNew,
    };
  }

  static String labelFor(String status) {
    return switch (status) {
      'new' => 'NEW',
      'contacted' => 'CONTACTED',
      'negotiating' => 'NEGOTIATING',
      'won' => 'WON',
      'lost' => 'LOST',
      _ => status.toUpperCase(),
    };
  }
}
