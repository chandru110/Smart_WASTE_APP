part of 'user_bloc.dart';

@immutable
sealed class UserState {}

final class UserInitial extends UserState {}

class UserActionState extends UserState {}

class UserSigninAuthState extends UserActionState {
  final String email;
  final String pssword;

  UserSigninAuthState({required this.email, required this.pssword});
}

class UserSignupAuthState extends UserActionState {
  final String email;
  final String pssword;
  final String name;

  UserSignupAuthState(
      {required this.email, required this.pssword, required this.name});
}

class UserSucessState extends UserState {}

class ForgotPasswordNavigate extends UserActionState {}

class ResetPasswordnavigate extends UserActionState {
  final String email;

  ResetPasswordnavigate({required this.email});
}

class Signinwithgooglenavigate extends UserActionState {}

class Signupwithgooglenavigate extends UserActionState {}
