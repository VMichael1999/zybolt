import '../../../core/theme/app_durations.dart';
import '../domain/auth.dart';

/// Repositorio falso: tarda 1700 ms y acepta cualquier credencial,
/// igual que el prototipo.
class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({this.delay = AppDurations.signingIn});

  static const User michael = User(
    name: 'Michael Dev',
    email: 'michaeldev@gmail.com',
  );

  final Duration delay;
  User? _saved;

  @override
  Future<User> signIn({
    required String email,
    required String password,
    required bool keepSignedIn,
  }) async {
    await Future<void>.delayed(delay);
    _saved = keepSignedIn ? michael : null;
    return michael;
  }

  @override
  Future<User?> savedSession() async => _saved;

  @override
  Future<void> signOut() async {
    _saved = null;
  }
}
