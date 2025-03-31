part of 'user_bloc.dart';

@immutable
sealed class UserEvent {}

class UserInititialEvent extends UserEvent {}

class UserSinginButtonPressed extends UserEvent {
  final String email;
  final String pssword;

  UserSinginButtonPressed({required this.email, required this.pssword});
}

class UserSignupButtonPressed extends UserEvent {
  final String email;
  final String pssword;
  final String name;

  UserSignupButtonPressed(
      {required this.email, required this.pssword, required this.name});
}

class ForgotPasswordClicked extends UserEvent {}

class ResetPasswordclicked extends UserEvent {
  final String email;

  ResetPasswordclicked({required this.email});
}

class Signinwithgoogleclicked extends UserEvent {}

class Signupwithgoogleclicked extends UserEvent {}
