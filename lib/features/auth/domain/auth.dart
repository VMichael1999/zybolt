import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({required this.name, required this.email});

  final String name;
  final String email;

  @override
  List<Object?> get props => [name, email];
}

abstract class AuthRepository {
  Future<User> signIn({
    required String email,
    required String password,
    required bool keepSignedIn,
  });

  /// Sesión guardada con «Mantener sesión iniciada», si existe.
  Future<User?> savedSession();

  Future<void> signOut();
}

class SignInUseCase {
  const SignInUseCase(this._repository);

  final AuthRepository _repository;

  Future<User> call({
    required String email,
    required String password,
    required bool keepSignedIn,
  }) {
    return _repository.signIn(
      email: email,
      password: password,
      keepSignedIn: keepSignedIn,
    );
  }
}
