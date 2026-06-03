import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum HiveBox {
  wardrobe('wardrobe'),
  fits('fits'),
  preferences('preferences');

  final String name;
  const HiveBox(this.name);
}

class HiveService {
  HiveService._();

  static Future<void> initialize() async {
    await Hive.initFlutter();

    await Future.wait([
      Hive.openBox(HiveBox.wardrobe.name),
      Hive.openBox(HiveBox.fits.name),
      Hive.openBox(HiveBox.preferences.name),
    ]);
  }

  static Box wardrobeBox() => Hive.box(HiveBox.wardrobe.name);
  static Box fitsBox() => Hive.box(HiveBox.fits.name);
  static Box preferencesBox() => Hive.box(HiveBox.preferences.name);

  static Future<void> clearAll() async {
    await Future.wait([
      wardrobeBox().clear(),
      fitsBox().clear(),
      preferencesBox().clear(),
    ]);
  }
}

final hiveWardrobeBoxProvider = Provider<Box>((ref) {
  return HiveService.wardrobeBox();
});

final hiveFitsBoxProvider = Provider<Box>((ref) {
  return HiveService.fitsBox();
});

final hivePreferencesBoxProvider = Provider<Box>((ref) {
  return HiveService.preferencesBox();
});
