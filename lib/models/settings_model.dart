class SettingsModel {
  num percentage;
  String privacyPolicy;
  String termsAndConditions;
  String aboutApp;

  SettingsModel.fromMap(Map m) : percentage = m['percentage'] ?? 0.0;
}
