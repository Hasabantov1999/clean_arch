// ignore_for_file: use_string_in_part_of_directives

part of clean_arch_localization;

class CleanArchText extends StatefulWidget {
  const CleanArchText(
    this.data, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.minFontSize,
    this.maxFontSize,
    this.width,
    this.textOverflow,
    this.onTap,
  });

  final String data;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final double? minFontSize;
  final double? maxFontSize;
  final double? width;
  final TextOverflow? textOverflow;
  final VoidCallback? onTap;

  @override
  State<CleanArchText> createState() => _CleanArchTextState();
}

class _CleanArchTextState extends State<CleanArchText>
    with SingleTickerProviderStateMixin {
  String _translatedText = '';
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  String? _currentLocale;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
  }

  @override
  void didUpdateWidget(covariant CleanArchText oldWidget) {
    if (oldWidget.data != widget.data) {
      _fetchTranslation(
        animate: true,
      );
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // InheritedWidget'ten mevcut locale'i al
    final locale = CleanArchLocalization.of(context).locale;

    // Eğer locale değiştiyse çeviriyi yeniden al ve animasyonu çalıştır
    if (_currentLocale != locale) {
      _currentLocale = locale;

      // İlk build'de animasyon olmadan metni göster
      if (_translatedText.isEmpty) {
        _fetchTranslation(animate: false);
      } else {
        _fetchTranslation(animate: true);
      }
    }
  }

  void _initializeAnimation() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _opacityAnimation = Tween<double>(begin: 1.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  Future<void> _fetchTranslation({bool animate = true}) async {
    if (_currentLocale == null) return;

    String translation = await CleanArchLocalizationService().asyncTranslate(
      widget.data,
      language: _currentLocale!,
    );

    if (mounted) {
      setState(() {
        _translatedText = translation;
      });

      if (animate) {
        _startAnimation();
      }
    }
  }

  void _startAnimation() {
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.reset();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox(
        width: widget.width,
        child: AnimatedBuilder(
          animation: _opacityAnimation,
          builder: (context, child) {
            return Opacity(
              opacity: _opacityAnimation.value,
              child: AutoSizeText(
                _translatedText,
                style: widget.style,
                textAlign: widget.textAlign,
                maxLines: widget.maxLines,
                maxFontSize: widget.maxFontSize ?? double.infinity,
                minFontSize: widget.minFontSize ?? 8,
                overflow: widget.textOverflow,
              ),
            );
          },
        ),
      ),
    );
  }
}
