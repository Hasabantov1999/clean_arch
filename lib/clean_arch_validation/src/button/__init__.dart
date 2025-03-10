// ignore_for_file: use_string_in_part_of_directives

part of clean_arch_validation;

class CleanArchButton extends StatelessWidget {
  const CleanArchButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.validationManager,
  });

  final Widget child;
  final VoidCallback? onPressed;
  final ValidationManager? validationManager;

  @override
  Widget build(BuildContext context) {
    if (validationManager != null) {
      return ValueListenableBuilder<bool>(
        valueListenable: validationManager!.isFormValid,
        builder: (context, isValid, ch) {
          return _Button(
            onPressed: onPressed,
            isValid: isValid,
            child: child,
          );
        },
      );
    } else {
      return _Button(
        onPressed: onPressed,
        isValid: null,
        child: child,
      );
    }
  }
}

class _Button extends StatelessWidget {
  const _Button({
    required this.onPressed,
    required this.child,
    this.isValid,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final bool? isValid;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (isValid ?? true) ? onPressed : null,
      style: ElevatedButton.styleFrom(
        foregroundColor: (isValid ?? true)
            ? CA.getTheme.buttonTheme.colorScheme?.primary
            : CA.getTheme.buttonTheme.colorScheme?.error,
      ),
      child: child,
    );
  }
}
