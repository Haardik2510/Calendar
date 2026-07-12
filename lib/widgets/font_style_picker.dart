import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';

class FontStylePicker extends StatelessWidget {
  final String selectedFamily;
  final ValueChanged<String> onSelected;

  const FontStylePicker({
    super.key,
    required this.selectedFamily,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Font Style', style: theme.textTheme.titleMedium),
        const SizedBox(height: 12),
        SizedBox(
          height: 48,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: kFontFamilies.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final family = kFontFamilies[index];
              final isSelected = family == selectedFamily;
              return GestureDetector(
                onTap: () => onSelected(family),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? theme.colorScheme.secondary.withValues(alpha: 0.2)
                        : theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? theme.colorScheme.secondary
                          : theme.dividerColor,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      family,
                      style: GoogleFonts.getFont(family,
                          fontSize: 14,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: theme.colorScheme.onSurface),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
