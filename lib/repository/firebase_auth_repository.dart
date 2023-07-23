import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple/providers/firebase.dart';

final authRepositoryProvider = Provider<AuthRepository>(AuthRepository.new);

class AuthRepository {
  const AuthRepository(this._ref);

  final Ref _ref;

  Stream<User?> get authStateChanges =>
      _ref.read(firebaseAuthProvider).authStateChanges();

  Stream<User?> get userChanges =>
      _ref.read(firebaseAuthProvider).userChanges();

  Future<UserCredential> signInWithEmail(String email, String password) {
    return _ref
        .read(firebaseAuthProvider)
        .signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> signInWithAnonymous() async {
    return _ref.read(firebaseAuthProvider).signInAnonymously();
  }

  Future<List<String>> fetchSignInEmail(String email) {
    return _ref.read(firebaseAuthProvider).fetchSignInMethodsForEmail(email);
  }

  Future<void> sendPasswordResetEmail(String email) {
    return _ref.read(firebaseAuthProvider).sendPasswordResetEmail(email: email);
  }

  Future<void> createUserWithEmail(String email, String password) {
    return _ref
        .read(firebaseAuthProvider)
        .createUserWithEmailAndPassword(email: email, password: password);
  }

  User? getCurrentUser() {
    return _ref.read(firebaseAuthProvider).currentUser;
  }

  Future<void> reload() async {
    return getCurrentUser()?.reload();
  }

  Future<void> signOut() async {
    await _ref.read(firebaseAuthProvider).signOut();
  }

  Future<void> delete() async {
    await getCurrentUser()?.delete();
  }
}
