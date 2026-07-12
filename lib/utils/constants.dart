import 'package:flutter/material.dart';

/// Curated sticker icons for events
class StickerData {
  final String label;
  final IconData icon;

  const StickerData(this.label, this.icon);
}

const List<StickerData> kStickerLibrary = [
  StickerData('Coffee', Icons.coffee_rounded),
  StickerData('Heart', Icons.favorite_rounded),
  StickerData('Star', Icons.star_rounded),
  StickerData('Gym', Icons.fitness_center_rounded),
  StickerData('Book', Icons.menu_book_rounded),
  StickerData('Music', Icons.music_note_rounded),
  StickerData('Art', Icons.palette_rounded),
  StickerData('Cake', Icons.cake_rounded),
  StickerData('Pets', Icons.pets_rounded),
  StickerData('Nature', Icons.eco_rounded),
];

/// Available cute icons for habits
const List<StickerData> kHabitIcons = [
  StickerData('Water', Icons.water_drop_rounded),
  StickerData('Run', Icons.directions_run_rounded),
  StickerData('Read', Icons.menu_book_rounded),
  StickerData('Sleep', Icons.bedtime_rounded),
  StickerData('Meditate', Icons.self_improvement_rounded),
  StickerData('Cook', Icons.restaurant_rounded),
  StickerData('Code', Icons.code_rounded),
  StickerData('Walk', Icons.directions_walk_rounded),
  StickerData('Gym', Icons.fitness_center_rounded),
  StickerData('Music', Icons.music_note_rounded),
  StickerData('Journal', Icons.edit_note_rounded),
  StickerData('Vitamins', Icons.medication_rounded),
];

/// Font families for event customization
const List<String> kFontFamilies = [
  'Outfit',
  'Inter',
  'Pacifico',
  'Caveat',
  'Dancing Script',
];

/// Light theme colors
class LightColors {
  static const Color background = Color(0xFFFDFBF7);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color primary = Color(0xFF8A9A86);
  static const Color secondary = Color(0xFFE8C5C8);
  static const Color tertiary = Color(0xFFD2C4E3);
  static const Color onBackground = Color(0xFF2D2D2D);
  static const Color onSurface = Color(0xFF3A3A3A);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color subtle = Color(0xFFB8B8B8);
  static const Color divider = Color(0xFFEEECE8);
}

/// Dark theme colors
class DarkColors {
  static const Color background = Color(0xFF1A1A1A);
  static const Color surface = Color(0xFF252525);
  static const Color primary = Color(0xFF6B7A68);
  static const Color secondary = Color(0xFFB89496);
  static const Color tertiary = Color(0xFF2A2735);
  static const Color onBackground = Color(0xFFE8E8E8);
  static const Color onSurface = Color(0xFFD0D0D0);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color subtle = Color(0xFF5A5A5A);
  static const Color divider = Color(0xFF333333);
}

/// Default calendar colors for new calendars
const List<int> kDefaultCalendarColors = [
  0xFF8A9A86, // Sage Green
  0xFFE8C5C8, // Blush Pink
  0xFFD2C4E3, // Lavender
  0xFF7FAFCF, // Soft Blue
  0xFFF2C97D, // Warm Gold
  0xFFA8D5BA, // Mint
  0xFFE6A0A0, // Salmon
  0xFF9FB8D0, // Steel Blue
];
