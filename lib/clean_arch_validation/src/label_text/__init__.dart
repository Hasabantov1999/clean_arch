// ignore_for_file: use_string_in_part_of_directives

part of clean_arch_validation;

class CleanArchFormLabel extends StatefulWidget {
  const CleanArchFormLabel({
    super.key,
    required this.label,
    this.validator,
    this.validationManager,
    this.controller,
    this.onChanged,
    this.onEditingComplete,
    this.textInputAction,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.obscureText = false,
    this.inputFormatters,
    this.style,
    this.maxLines = 1,
    this.minLines,
    this.decoration,
  });

  final String label;
  final String? Function(String?)? validator;
  final ValidationManager? validationManager;
  final TextEditingController? controller;

  /// TextField özellikleri

  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final bool obscureText;
  final List<TextInputFormatter>? inputFormatters;
  final TextStyle? style;
  final int maxLines;
  final int? minLines;
  final InputDecoration? decoration;

  @override
  State<CleanArchFormLabel> createState() => _CleanArchFormLabelState();
}

class _CleanArchFormLabelState extends State<CleanArchFormLabel> {
  late TextEditingController _controller;
  late InputDecoration decoration;
  String? _errorText;
  String? _currentLocale;
  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();

    // Validator ve ValidationManager kullanımı
    if (widget.validator != null && widget.validationManager != null) {
      _controller.addListener(_validate);
      final result = widget.validator!(_controller.text);
      widget.validationManager!.updateField(widget.label, result == null);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_validate);
    super.dispose();
  }

  void _validate() {
    if (_controller.text.isNotEmpty) {
      if (widget.validator != null && widget.validationManager != null) {
        final result = widget.validator!(_controller.text);
        setState(() {
          _errorText = result?.syncTranslate;
        });

        // ValidationManager'a sonucu bildir
        widget.validationManager!.updateField(widget.label, result == null);
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // InheritedWidget'ten mevcut locale'i al
    final locale = CleanArchLocalization.of(context).locale;
    // Eğer locale değiştiyse çeviriyi yeniden al ve animasyonu çalıştır
    if (_currentLocale != locale) {
      _currentLocale = locale;
      if (widget.validationManager != null && widget.validator != null) {
        if (_controller.text.isNotEmpty) {
          _validate();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: widget.onChanged,
      onEditingComplete: widget.onEditingComplete,
      textInputAction: widget.textInputAction,
      keyboardType: widget.keyboardType,
      textCapitalization: widget.textCapitalization,
      obscureText: widget.obscureText,
      inputFormatters: widget.inputFormatters,
      style: widget.style,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      decoration: InputDecoration(
        errorText: _errorText?.syncTranslate,
        border: widget.decoration?.border,
        icon: widget.decoration?.icon,
        iconColor: widget.decoration?.iconColor,
        label: widget.decoration?.label,
        labelText: widget.decoration?.labelText,
        labelStyle: widget.decoration?.labelStyle,
        floatingLabelStyle: widget.decoration?.floatingLabelStyle,
        helper: widget.decoration?.helper,
        helperText: widget.decoration?.helperText,
        helperMaxLines: widget.decoration?.helperMaxLines,
        helperStyle: widget.decoration?.helperStyle,
        hoverColor: widget.decoration?.hoverColor,
        hintFadeDuration: widget.decoration?.hintFadeDuration,
        hintMaxLines: widget.decoration?.hintMaxLines,
        hintStyle: widget.decoration?.hintStyle,
        hintText: widget.decoration?.hintText,
        hintTextDirection: widget.decoration?.hintTextDirection,
        maintainHintHeight: widget.decoration?.maintainHintHeight ?? true,
        alignLabelWithHint: widget.decoration?.alignLabelWithHint,
        error: widget.decoration?.error,
        errorStyle: widget.decoration?.errorStyle,
        enabled: widget.decoration?.enabled ?? true,
        enabledBorder: widget.decoration?.enabledBorder,
        errorBorder: widget.decoration?.errorBorder,
        errorMaxLines: widget.decoration?.errorMaxLines,
        focusedErrorBorder: widget.decoration?.focusedErrorBorder,
        fillColor: widget.decoration?.fillColor,
        filled: widget.decoration?.filled,
        floatingLabelAlignment: widget.decoration?.floatingLabelAlignment,
        floatingLabelBehavior: widget.decoration?.floatingLabelBehavior,
        focusColor: widget.decoration?.focusColor,
        focusedBorder: widget.decoration?.focusedBorder,
        disabledBorder: widget.decoration?.disabledBorder,
        constraints: widget.decoration?.constraints,
        contentPadding: widget.decoration?.contentPadding,
        counter: widget.decoration?.counter,
        counterStyle: widget.decoration?.counterStyle,
        counterText: widget.decoration?.counterText,
        isCollapsed: widget.decoration?.isCollapsed,
        semanticCounterText: widget.decoration?.semanticCounterText,
        prefix: widget.decoration?.prefix,
        prefixIcon: widget.decoration?.prefixIcon,
        prefixIconColor: widget.decoration?.prefixIconColor,
        prefixIconConstraints: widget.decoration?.prefixIconConstraints,
        prefixStyle: widget.decoration?.prefixStyle,
        prefixText: widget.decoration?.prefixText,
        suffix: widget.decoration?.suffix,
        suffixIcon: widget.decoration?.suffixIcon,
        suffixIconColor: widget.decoration?.suffixIconColor,
        suffixIconConstraints: widget.decoration?.suffixIconConstraints,
        suffixStyle: widget.decoration?.suffixStyle,
        suffixText: widget.decoration?.suffixText,
        isDense: widget.decoration?.isDense,
        
      ),
    );
  }
}
