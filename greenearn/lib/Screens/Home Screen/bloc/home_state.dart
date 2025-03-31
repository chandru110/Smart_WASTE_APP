part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

class HomeActionState extends HomeState {}

final class HomeInitial extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeSucessState extends HomeState {}

class HomeErrorState extends HomeState {}

class HomeGetStartedNavigate extends HomeActionState {}
