import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';

//Provider Auth

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = AuthRespositoryImpl();

  return AuthNotifier(authRepository: authRepository);
});

//Auth State
enum AuthStatus { checking, authenticated, notAuthenticated }

class AuthState {
  final AuthStatus authStatus;
  final User? user;
  final String errorMessage;

  AuthState(
      {this.authStatus = AuthStatus.checking,
      this.user,
      this.errorMessage = ''});

  AuthState copyWith({
    AuthStatus? authStatus,
    User? user,
    String? errorMessage,
  }) =>
      AuthState(
        authStatus: authStatus ?? this.authStatus,
        user: user ?? this.user,
        errorMessage: errorMessage ?? this.errorMessage,
      );
}

// Auth notif

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository;
  AuthNotifier({required this.authRepository}) : super(AuthState());

  Future<void> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));

    try {
      final user = await authRepository.login(email, password);
      _setLoggeduser(user);
    } on WrongCredential {
      logout('Invalid Credentials');
    } catch (e) {
      logout('Uncontrolled error');
    }
  }

  Future<void> register(String email, String password, String fullname) async {
    state = state.copyWith(authStatus: AuthStatus.checking);
  }

  Future<void> logout(String? errorMessage) async {
    //Todo i need to delete the token
    state = state.copyWith(
        authStatus: AuthStatus.notAuthenticated,
        user: null,
        errorMessage: errorMessage);
  }

  void _setLoggeduser(User user) {
    //Todo i need to save the token
    state = state.copyWith(
        user: user, authStatus: AuthStatus.authenticated, errorMessage: '');
  }

  Future<void> checkAuthStatus() async {
    state = state.copyWith(authStatus: AuthStatus.checking);
  }
}
