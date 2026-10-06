import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Câmpul de căutare, în stilul input-urilor din design.
class SearchField extends StatefulWidget {
  const SearchField({
    super.key,
    required this.onChanged,
    this.hint = 'Search programs',
    this.initialValue = '',
  });

  final ValueChanged<String> onChanged;
  final String hint;
  final String initialValue;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initialValue);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: color),
      );

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: (value) {
        setState(() {});
        widget.onChanged(value);
      },
      textInputAction: TextInputAction.search,
      style: AppTextStyles.smallMedium,
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle:
            AppTextStyles.smallRegular.copyWith(color: AppColors.greyscale400),
        prefixIcon: const Icon(Icons.search, color: AppColors.greyscale400),
        suffixIcon: _controller.text.isEmpty
            ? null
            : IconButton(
                tooltip: 'Clear',
                icon: const Icon(Icons.close, color: AppColors.greyscale400),
                onPressed: () {
                  _controller.clear();
                  setState(() {});
                  widget.onChanged('');
                },
              ),
        filled: true,
        fillColor: AppColors.greyscale25,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: _border(AppColors.greyscale100),
        enabledBorder: _border(AppColors.greyscale100),
        focusedBorder: _border(AppColors.primary500),
      ),
    );
  }
}
