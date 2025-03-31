import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<UserInititialEvent>(userInititialEvent);
    on<UserSignupButtonPressed>(userSignupButtonPressed);
    on<UserSinginButtonPressed>(userSinginButtonPressed);
    on<ForgotPasswordClicked>(forgotPasswordClicked);
    on<ResetPasswordclicked>(resetPasswordclicked);
    on<Signinwithgoogleclicked>(signinwithgoogleclicked);
    on<Signupwithgoogleclicked>(signupwithgoogleclicked);
  }
  FutureOr<void> userInititialEvent(
      UserInititialEvent event, Emitter<UserState> emit) {
    emit(UserSucessState());
  }

  FutureOr<void> userSignupButtonPressed(
      UserSignupButtonPressed event, Emitter<UserState> emit) {
    emit(UserSignupAuthState(
        email: event.email, pssword: event.pssword, name: event.name));
  }

  FutureOr<void> userSinginButtonPressed(
      UserSinginButtonPressed event, Emitter<UserState> emit) {
    emit(UserSigninAuthState(email: event.email, pssword: event.pssword));
  }

  FutureOr<void> forgotPasswordClicked(
      ForgotPasswordClicked event, Emitter<UserState> emit) {
    emit(ForgotPasswordNavigate());
  }

  FutureOr<void> resetPasswordclicked(
      ResetPasswordclicked event, Emitter<UserState> emit) {
    emit(ResetPasswordnavigate(email: event.email));
  }

  FutureOr<void> signinwithgoogleclicked(
      Signinwithgoogleclicked event, Emitter<UserState> emit) {
    emit(Signinwithgooglenavigate());
  }

  FutureOr<void> signupwithgoogleclicked(
      Signupwithgoogleclicked event, Emitter<UserState> emit) {
    emit(Signupwithgooglenavigate());
  }
}
