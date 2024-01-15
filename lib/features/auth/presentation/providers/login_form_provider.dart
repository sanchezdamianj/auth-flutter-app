import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/shared/shared.dart';

// 3 - How to use it outside - StateNotifierProvider
//  We add autoDispose to avoid memory leaks, for example if the user is logged, but  did the loggout, and return to the login screen if i am not passing autoDispose, the user is able to reach their credentials, password included.

final loginFormProvider =
    StateNotifierProvider.autoDispose<LoginFormNotifier, LoginFormState>((ref) {
  return LoginFormNotifier();
});

// 1- State of Provider

//We can extend LoginFormState from Equatable to determine if the state has changed or not, to avoid re-painting.

class LoginFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Email email;
  final Password password;

  LoginFormState(
      {this.isPosting = false,
      this.isFormPosted = false,
      this.isValid = false,
      this.email = const Email.pure(),
      this.password = const Password.pure()});

  LoginFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Email? email,
    Password? password,
  }) {
    return LoginFormState(
      isPosting: isPosting ?? this.isPosting,
      isFormPosted: isFormPosted ?? this.isFormPosted,
      isValid: isValid ?? this.isValid,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  @override
  String toString() {
    return '''LoginFormState: isPosting: $isPosting, isFormPosted: $isFormPosted, isValid: $isValid, email: $email, password: $password''';
  }
}

// 2 - How to implement a state notifier

class LoginFormNotifier extends StateNotifier<LoginFormState> {
  LoginFormNotifier() : super(LoginFormState());

  onEmailChange(String value) {
    final newEmail = Email.dirty(value);
    state = state.copyWith(
        email: newEmail, isValid: Formz.validate([newEmail, state.password]));
  }

  onPasswordChange(String value) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
        password: newPassword,
        isValid: Formz.validate([state.email, newPassword]));
  }

  onFormSubmit() {
    _touchEveryField();
    if (!state.isValid) return;
    print(state);
    // state = state.copyWith(isPosting: true, isFormPosted: true);
  }

  // we need to touch every field because the init state is Pure and the form is not valid
  _touchEveryField() {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    state = state.copyWith(
        isFormPosted: true,
        email: email,
        password: password,
        isValid: Formz.validate([email, password]));
  }
}
