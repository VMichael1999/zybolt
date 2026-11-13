import '../domain/account.dart';

class FakeAccountRepository implements AccountRepository {
  Preferences _prefs = const Preferences();

  @override
  Future<Profile> loadProfile() async => const Profile(
    name: 'Michael Dev',
    email: 'michaeldev@gmail.com',
    parcels: 128,
    onTimePercent: 98,
    addresses: 3,
  );

  @override
  Future<Membership> loadMembership() async => const Membership(
    tier: 'Miembro Oro',
    nextTier: 'Platino',
    current: 72,
    target: 100,
  );

  @override
  Future<Preferences> loadPreferences() async => _prefs;

  @override
  Future<void> savePreference(PreferenceKey key, bool value) async {
    _prefs = _prefs.withValue(key, value);
  }
}
