import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeInitialEvent>(homeInitialEvent);
    on<HomeGetStartedButtonPressed>(homeGetStartedButtonPressed);
  }

  FutureOr<void> homeInitialEvent(
      HomeInitialEvent event, Emitter<HomeState> emit) async {
    emit(HomeSucessState());
  }

  FutureOr<void> homeGetStartedButtonPressed(
      HomeGetStartedButtonPressed event, Emitter<HomeState> emit) {
    emit(HomeGetStartedNavigate());
  }
}
