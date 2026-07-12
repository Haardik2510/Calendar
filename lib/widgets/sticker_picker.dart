import 'package:flutter/material.dart';
import '../utils/constants.dart';

class StickerPicker extends StatelessWidget {
  final int? selectedCodePoint;
  final ValueChanged<int?> onSelected;

  const StickerPicker({
    super.key,
    this.selectedCodePoint,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Sticker', style: theme.textTheme.titleMedium),
            const SizedBox(width: 8),
            Text('(optional)',
                style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5))),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            // "None" option
            _StickerChip(
              icon: Icons.close_rounded,
              label: 'None',
              isSelected: selectedCodePoint == null,
              onTap: () => onSelected(null),
              theme: theme,
            ),
            ...kStickerLibrary.map((sticker) {
              final isSelected =
                  selectedCodePoint == sticker.icon.codePoint;
              return _StickerChip(
                icon: sticker.icon,
                label: sticker.label,
                isSelected: isSelected,
                onTap: () => onSelected(sticker.icon.codePoint),
                theme: theme,
              );
            }),
          ],
        ),
      ],
    );
  }
}

class _StickerChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final ThemeData theme;

  const _StickerChip({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.15)
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.dividerColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 20,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface),
            const SizedBox(width: 6),
            Text(label,
                style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.w400)),
          ],
        ),
      ),
    );
  }
}
