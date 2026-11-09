import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:khetmti/core/theme/app_theme.dart';

/// The app's text field: a label above a white rounded box that turns green
/// when focused. Password fields get a show/hide button.
class AppTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final IconData? icon;
  final String? hint;
  final bool isPassword;
  final bool latin;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final Iterable<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;
  final bool autofocus;

  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.icon,
    this.hint,
    this.isPassword = false,
    this.latin = false,
    this.keyboardType,
    this.textInputAction,
    this.onSubmitted,
    this.autofillHints,
    this.inputFormatters,
    this.autofocus = false,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscured = widget.isPassword;
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final focused = _focus.hasFocus;
    final latin = widget.latin || widget.isPassword;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 6, bottom: 8),
          child: Text(
            widget.label,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontFamily: 'Amiri',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: focused ? AppTheme.primaryColor : AppTheme.textPrimary,
            ),
          ),
        ),
        AnimatedContainer(
          duration: AppTheme.fast,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: focused ? AppTheme.primaryColor : AppTheme.borderColor,
              width: focused ? 1.6 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: focused
                    ? AppTheme.primaryColor.withValues(alpha: 0.12)
                    : Colors.black.withValues(alpha: 0.03),
                blurRadius: focused ? 14 : 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: _focus,
            autofocus: widget.autofocus,
            obscureText: _obscured,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            onSubmitted: widget.onSubmitted,
            autofillHints: widget.autofillHints,
            inputFormatters: widget.inputFormatters,
            autocorrect: !latin,
            enableSuggestions: !latin,
            textDirection: latin ? TextDirection.ltr : TextDirection.rtl,
            textAlign: latin ? TextAlign.left : TextAlign.right,
            style: TextStyle(
              fontFamily: latin ? 'Roboto' : 'Amiri',
              fontSize: latin ? 16 : 18,
              color: AppTheme.textPrimary,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: widget.hint,
              hintTextDirection: TextDirection.rtl,
              hintStyle: const TextStyle(
                fontFamily: 'Amiri',
                fontSize: 16,
                color: AppTheme.textMuted,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              // RTL page: the field's icon sits on the right, the
              // show/hide button on the left.
              suffixIcon: widget.icon == null
                  ? null
                  : Icon(
                      widget.icon,
                      size: 22,
                      color: focused ? AppTheme.primaryColor : AppTheme.textMuted,
                    ),
              prefixIcon: widget.isPassword
                  ? IconButton(
                      tooltip: _obscured ? 'إظهار كلمة السر' : 'إخفاء كلمة السر',
                      onPressed: () => setState(() => _obscured = !_obscured),
                      icon: AnimatedSwitcher(
                        duration: AppTheme.fast,
                        child: Icon(
                          _obscured
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          key: ValueKey(_obscured),
                          size: 22,
                          color: AppTheme.textMuted,
                        ),
                      ),
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
