// lib/presentation/widgets/sort_options_panel.dart
import 'package:flutter/material.dart';
import '../../models/sort_option.dart';

class SortOptionsPanel extends StatelessWidget {
  final SortOption currentOption;
  final void Function(SortOption option) onOptionSelected;

  const SortOptionsPanel({
    super.key,
    required this.currentOption,
    required this.onOptionSelected,
  });

  /// Static method to show the panel from anywhere
  static void show(
    BuildContext context, {
    required SortOption currentOption,
    required void Function(SortOption option) onOptionSelected,
  }) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Sort Options',
      barrierColor: Colors.black54,
      transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Align(
          alignment: Alignment.centerRight,
          child: SortOptionsPanel(
            currentOption: currentOption,
            onOptionSelected: (option) {
              Navigator.pop(context);
              onOptionSelected(option);
            },
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.horizontal(left: Radius.circular(16)),
      child: Container(
        width: 280,
        height: double.infinity,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Sort by',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Divider(height: 1),
              Expanded(
                child: ListView(
                  children: SortOption.values
                      .map(
                        (option) => ListTile(
                          leading: Icon(
                            option == currentOption
                                ? Icons.radio_button_checked
                                : Icons.radio_button_unchecked,
                            color: option == currentOption
                                ? Colors.blue
                                : Colors.grey,
                          ),
                          title: Text(
                            option.label,
                            style: TextStyle(
                              fontWeight: option == currentOption
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                              color: option == currentOption
                                  ? Colors.blue
                                  : Colors.black87,
                            ),
                          ),
                          onTap: () => onOptionSelected(option),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
