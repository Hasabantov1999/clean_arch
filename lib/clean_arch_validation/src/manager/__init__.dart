// ignore_for_file: use_string_in_part_of_directives

part of clean_arch_validation;
class ValidationManager with CleanArchDisposable {
  final Map<String, bool> _fields = {}; // Her field'in validasyon durumu
  final ValueNotifier<bool> isFormValid = ValueNotifier(false);

  /// Bir field'in validasyon durumunu günceller
  void updateField(String fieldLabel, bool isValid) {
    _fields[fieldLabel] = isValid;
    _updateFormValidity();
  }

  /// Tüm validasyonları kontrol eder
  void _updateFormValidity() {
    isFormValid.value = !_fields.containsValue(false);
  }

  /// Belirli bir field'in validasyon durumunu alır
  bool? getFieldStatus(String fieldLabel) {
    return _fields[fieldLabel];
  }

  /// Tüm validasyonları sıfırlar
  void reset() {
    _fields.clear();
    isFormValid.value = false;
  }
  
  @override
  void dispose() {
    _fields.clear();
    isFormValid.value = false;
  }
}