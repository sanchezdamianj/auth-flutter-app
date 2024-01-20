import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';
import 'package:teslo_shop/features/shared/infrastructure/services/key_value_storage_service.dart';
import 'package:teslo_shop/features/shared/infrastructure/services/key_value_storage_service_impl.dart';

//! 3 - Provider Auth

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = AuthRespositoryImpl();
  final keyValueStorageService = KeyValueStorageServiceImpl();
  return AuthNotifier(
      authRepository: authRepository,
      keyValueStorageService: keyValueStorageService);
});

//! 2 - Auth State

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

// 1 - Auth notif

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository;
  final KeyValueStorageService keyValueStorageService;
  AuthNotifier(
      {required this.authRepository, required this.keyValueStorageService})
      : super(AuthState()) {
    checkAuthStatus();
  }

  Future<void> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));

    try {
      final user = await authRepository.login(email, password);
      _setLoggeduser(user);
    } on CustomError catch (e) {
      logout(e.message);
    } catch (e) {
      logout('Uncontrolled error');
    }
  }

  Future<void> register(String email, String password, String fullname) async {
    state = state.copyWith(authStatus: AuthStatus.checking);
  }

  Future<void> logout([String? errorMessage]) async {
    // i need to delete the token
    await keyValueStorageService.removeKey('token');
    state = state.copyWith(
        authStatus: AuthStatus.notAuthenticated,
        user: null,
        errorMessage: errorMessage);
  }

  void _setLoggeduser(User user) async {
    await keyValueStorageService.setValueValue('token', user.token);
    //i need to save the token
    state = state.copyWith(
        user: user, authStatus: AuthStatus.authenticated, errorMessage: '');
  }

  Future<void> checkAuthStatus() async {
    final token = await keyValueStorageService.getValue<String>('token');
    if (token == null) {
      return logout();
    }
    try {
      final user = await authRepository.checkAuthStatus(token);
      _setLoggeduser(user);
    } catch (e) {
      logout();
    }
    state = state.copyWith(authStatus: AuthStatus.checking);
  }
}
