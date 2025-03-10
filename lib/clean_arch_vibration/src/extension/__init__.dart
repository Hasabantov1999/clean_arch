// ignore_for_file: use_string_in_part_of_directives

part of clean_arch_vibration;

extension VibrationOnBuildContext on BuildContext {
  CleanArchVibration get getVibrator => CleanArchVibration.instance;
}
