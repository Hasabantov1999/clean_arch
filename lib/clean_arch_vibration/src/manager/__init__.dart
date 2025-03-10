// ignore_for_file: use_string_in_part_of_directives

part of clean_arch_vibration;

class CleanArchVibration {
  static final CleanArchVibration instance = CleanArchVibration._internal();

  factory CleanArchVibration() => instance;

  CleanArchVibration._internal();

  Future<bool> hasVibrator() => Vibration.hasVibrator();

  Future<void> vibrate(CleanArchVibrationPreset preset) async {
    VibrationPreset? def;
    for (var element in VibrationPreset.values) {
      if (element.name == preset.name) {
        def = element;
      }
    }
    def ??= VibrationPreset.progressiveBuzz;

    return Vibration.vibrate(
      preset: def,
    );
  }
}

enum CleanArchVibrationPreset {
  alarm,
  notification,
  heartbeat,
  singleShortBuzz,
  doubleBuzz,
  tripleBuzz,
  longAlarmBuzz,
  pulseWave,
  progressiveBuzz,
  rhythmicBuzz,
  gentleReminder,
  quickSuccessAlert,
  zigZagAlert,
  softPulse,
  emergencyAlert,
  heartbeatVibration,
  countdownTimerAlert,
  rapidTapFeedback,
  dramaticNotification,
  urgentBuzzWave,
}
