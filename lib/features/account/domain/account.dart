import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  const Profile({
    required this.name,
    required this.email,
    required this.parcels,
    required this.onTimePercent,
    required this.addresses,
  });

  final String name;
  final String email;
  final int parcels;
  final int onTimePercent;
  final int addresses;

  @override
  List<Object?> get props => [name, email, parcels, onTimePercent, addresses];
}

class Membership extends Equatable {
  const Membership({
    required this.tier,
    required this.nextTier,
    required this.current,
    required this.target,
  });

  final String tier;
  final String nextTier;
  final int current;
  final int target;

  double get progress => current / target;

  @override
  List<Object?> get props => [tier, nextTier, current, target];
}

enum PreferenceKey { deliveryNotifications, darkMode }

class Preferences extends Equatable {
  const Preferences({
    this.deliveryNotifications = true,
    this.darkMode = false,
    this.language = 'Español',
  });

  final bool deliveryNotifications;
  final bool darkMode;
  final String language;

  bool valueOf(PreferenceKey key) {
    switch (key) {
      case PreferenceKey.deliveryNotifications:
        return deliveryNotifications;
      case PreferenceKey.darkMode:
        return darkMode;
    }
  }

  Preferences withValue(PreferenceKey key, bool value) {
    switch (key) {
      case PreferenceKey.deliveryNotifications:
        return Preferences(
          deliveryNotifications: value,
          darkMode: darkMode,
          language: language,
        );
      case PreferenceKey.darkMode:
        return Preferences(
          deliveryNotifications: deliveryNotifications,
          darkMode: value,
          language: language,
        );
    }
  }

  @override
  List<Object?> get props => [deliveryNotifications, darkMode, language];
}

abstract class AccountRepository {
  Future<Profile> loadProfile();
  Future<Membership> loadMembership();
  Future<Preferences> loadPreferences();

  /// Guarda una preferencia. Puede lanzar si falla.
  Future<void> savePreference(PreferenceKey key, bool value);
}
