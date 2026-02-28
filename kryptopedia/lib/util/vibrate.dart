import 'package:haptic_feedback/haptic_feedback.dart';

void vibrate(HapticsType type) async {
  final canVibrate = await Haptics.canVibrate();
  if (canVibrate) {
    Haptics.vibrate(type);
  }
}
